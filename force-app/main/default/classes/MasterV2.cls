/**
 * @MasterV2.cls
 *
 * Contains Hr Flow objects definition
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
public class MasterV2 {
    
    //Used to create contact record
    public String id;
    public String key;
    public String reference;
    public String source_key;
    public Date archive;
    public Datetime updated_at;
    public Datetime created_at;
    public Decimal educations_duration;
    public WebServiceObjectsV2.ConsentAlgorithmic consent_algorithmic;
    public Decimal experiences_duration;
    public String text; // mapped to description
    public String text_language; // e.g. 'en' ok
    public WebServiceObjectsV2.Source source;
    public WebServiceObjectsV2.Info info;
    public List<WebServiceObjectsV2.Education> educations;
    public List<WebServiceObjectsV2.Experience> experiences;
    public List<WebServiceObjectsV2.Attachment> attachments;
    public List<WebServiceObjectsV2.Skill> skills;  
    public List<WebServiceObjectsV2.Language> languages;
    public List<WebServiceObjectsV2.Interest> interests;
    public List<WebServiceObjectsV2.Label> labels;
    public List<WebServiceObjectsV2.Tag> tags;
    public List<WebServiceObjectsV2.Metadata> metadatas;

    private static Id myRtId =[SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name='Recrutement'].Id;
    public  Boolean activateLogs(){
        Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
          if (logactive) {
            return true;
          }
          else {
              return false;
          }
    
      }
      private void logMessage(String message)
      {WsEngine.Logger logger = new WsEngine.Logger();
          logger.write(
                  message,
                  null,
                  null
          );
          logger.flush();
      }
     private static void logMessage(String message, String body)
    {WsEngine.Logger logger = new WsEngine.Logger();
        logger.write(
                message,
                body,
                null
        );
        logger.flush();
    }
    // Create a new contact
    public Id newContact (MasterV2 myNewMaster) {
        string forEmptyEmail ='PRENOM.NOM'+DateTime.now().getTime()+'@crosstalent.fr';
        Contact myContact = new Contact(
            Email = (String.isBlank(myNewMaster.info.email) ? forEmptyEmail :  myNewMaster.info.email), //Email = myNewMaster.info.email,
            profile_key__c = myNewMaster.key//myNewMaster.info.email
        );
        populateContact(myContact, myNewMaster);
        try{
            insert myContact;
        }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' contacts.\n Details : \n'+message);
                    }
                }
        
        return myContact.Id;
    }

    //Update Profile : myCont the existing profil, myMaster the new profile
    public Id updateContact (Contact myCont, MasterV2 myMaster) {
        populateContact(myCont, myMaster);
        try{
            update myCont;
        }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when updating '+e.getNumDml()+' contacts.\n Details : \n'+message);
                    }
                }
        
        return myCont.Id;
    }

    private void populateContact(Contact c, MasterV2 m) {
        if(m.info!=null) {
            c.FirstName =(String.isBlank(m.info.first_name) ? 'PRENOM' :  m.info.first_name);//c.FirstName = m.info.first_name;            
            c.LastName =(String.isBlank(m.info.last_name) ? 'NOM' :  m.info.last_name);//c.LastName = m.info.last_name;
            //c.FirstName = m.info.first_name;
            //c.LastName = m.info.last_name;
            //c.Phone = m.info.phone;
            c.MobilePhone = m.info.phone;
            c.summary__c = m.info.summary;
            c.picture__c = m.info.picture;
             system.debug('myRtId : '+myRtId);
            system.debug('c.RecordTypeId : '+c.RecordTypeId);
            if(myRtId!=null && c.RecordTypeId == null) {
                c.RecordTypeId = myRtId;
            } 
            
            //c.crta__GDPR_Date__c = Date.today();
            //c.crta__GDPR__c=True;
            // AMO : Added 2021-10-11
            c.Parsing_Creation_Date__c = m.created_at.date();
            c.Parsing_Modification_Date__c = m.updated_at.date();
            //Contact address
            if(m.info.location!=null) {
                if(m.info.location.fields!=null) {
                    c.MailingCity = m.info.location.fields.city;
                    c.MailingStreet = m.info.location.fields.house_number + ' ' + m.info.location.fields.road;
                    c.MailingPostalCode = m.info.location.fields.postcode;
                    c.MailingCountry = m.info.location.fields.country;
                    c.MailingState = m.info.location.fields.state_district;
                }
                c.MailingLatitude = m.info.location.lat;
                c.MailingLongitude= m.info.location.lng;
            }
    
            if(!String.isBlank(m.info.gender)) {
                c.crta__Sexe__c = m.info.gender.equals('male') ? 'M' : 'F';
            }
    
            //Social Media
            if(m.info.urls!=null) {
                for(WebServiceObjectsV2.Url u:m.info.urls) {
                    //if(u != null && u.url != null && u.url.size()>0) {
                    if(u != null && u.url != null) {    
                        System.debug('u.url '+u.url);
                        switch on(u.type) {
                            when 'facebook' {
                                c.Facebook_url__c = u.url;//u.url.get(0);
                            }
                            when 'twitter' {
                                c.twitter_url__c = u.url;//u.url.get(0);
                            }
                            when 'github' {
                                c.github_url__c = u.url;//u.url.get(0);
                            }
                            when 'linkedin' {
                                c.linkedin_url__c = u.url;//u.url.get(0);
                            }
                            when 'from_resume' {
                                c.SocialMedial_from_resume__c = u.url;//u.url.get(0);
                            }
                        }
                    }
                }
            }
            WebServiceObjectsV2.Tag myTagClass = new WebServiceObjectsV2.Tag();
            myTagClass.newTags(m,c.Id,false); 
            If(myTagClass.value=='1' && WebServiceObjectsV2.origin!='STOCK'){
                c.crta__GDPR_Date__c = Date.today();
                c.crta__GDPR__c=True;
            }
            if (activateLogs()){
                logMessage('FM Master populateContact  Disponible_sous__c= :'+ WebServiceObjectsV2.availability );
                logMessage('FM Master populateContact  crtarecr__Recruitment_Agreement_GDPR__c= :'+ WebServiceObjectsV2.gdprCheckBox );
                logMessage('FM Master populateContact  Politique_confidentialite_lue__c= :'+ WebServiceObjectsV2.privacyPolicyCheckBox );
                logMessage('FM Master populateContact  crtarecr__Desired_annual_gross_remuneration__c = :'+ WebServiceObjectsV2.salaryExpectation );
            }
            //==> Debut de modif par Fallou 2022-07-07
            //Beg : Added by Tenhinene 2022-03-25
            //Information from tags
            ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getOrgDefaults();
            if(externalFields.Availability__c == true){
                 if(WebServiceObjectsV2.availability !=''){c.put('Disponible_sous__c', WebServiceObjectsV2.availability);}
            }
            if(externalFields.Salary_expectations__c == true && WebServiceObjectsV2.salaryExpectation!=null){
                 if(WebServiceObjectsV2.salaryExpectation !=''){c.put('crtarecr__Desired_annual_gross_remuneration__c', WebServiceObjectsV2.salaryExpectation);}
            }
            
            if(externalFields.Gdpr_checkbox__c == true && WebServiceObjectsV2.gdprCheckBox!=null){ c.put('crtarecr__Recruitment_Agreement_GDPR__c', WebServiceObjectsV2.gdprCheckBox);}
            if(externalFields.Privacy_policy_checkbox__c == true && WebServiceObjectsV2.privacyPolicyCheckBox!=null){ c.put('Politique_confidentialite_lue__c', WebServiceObjectsV2.privacyPolicyCheckBox);}//AMO  16/06/2022 :crtarecr__confidentialite_lue__c
            //End : Added by Tenhinene 2022-03-25
            
        }

        c.educations_duration__c = m.educations_duration;
        //==> Fin de modif par Fallou 2022-07-07
        c.archive__c = m.archive;
        c.experiences_duration__c = m.experiences_duration;
        if(m.source!=null) {
            c.Type__c = m.source.type;
            c.subtype__c = m.source.subtype;
            c.Source_name__c = m.source.name;
            c.Source_key__c = m.source_key; // TODO: correctly mapped?!
            c.Source_Id__c =  m.source.id;
        }

        c.profile_reference__c = m.reference;
        c.profile_language__c = m.text_language;
        c.Description = m.text;
    }
}