/**
 * Created by Saad on 20/01/2022.
 */

public with sharing class MasterLWC
{
    //Used to create contact record
    public String id;
    public String key;
    public String reference;
    public String source_key;
    public Date archive;
    public Decimal educations_duration;
    public WebServiceObjectsLWC.ConsentAlgorithmic consent_algorithmic;
    public Decimal experiences_duration;
    public String text; // mapped to description
    public String text_language; // e.g. 'en' ok
    public WebServiceObjectsLWC.Source source;
    public WebServiceObjectsLWC.Info info;
    public List<WebServiceObjectsLWC.Education> educations;
    public List<WebServiceObjectsLWC.Experience> experiences;
    public List<WebServiceObjectsLWC.Attachment> attachments;
    public List<WebServiceObjectsLWC.Skill> skills; // TODO: unmapped fields
    public List<WebServiceObjectsLWC.Language> languages;
    public List<WebServiceObjectsLWC.certification> certifications;
    public List<WebServiceObjectsLWC.Interest> interests;
    public List<WebServiceObjectsLWC.Label> labels;
    public List<WebServiceObjectsLWC.Tag> tags;
    public List<WebServiceObjectsLWC.Metadata> metadatas;
	public Datetime updated_at;
    public Datetime created_at;
    private static Id myRtId = null;



    static {
        List<RecordType> rts = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'Recrutement'];
        if(rts.size()==1) myRtId = rts[0].Id;
    }

    // Create a new contact
    public Id newContact (MasterLWC myNewMaster) {
        string forEmptyEmail ='PRENOM.NOM'+DateTime.now().getTime()+'@crosstalent.fr';
        /*if (activateLogs()){
         logMessage('MasterLWC newContact:forEmptyEmail '+forEmptyEmail);
        }*/
        Contact myContact = new Contact(
                Email = (String.isBlank(myNewMaster.info.email) ? forEmptyEmail :  myNewMaster.info.email) ,
                profile_key__c = myNewMaster.key
        );
        populateContact(myContact, myNewMaster);
        insert myContact;
        if(!Test.isRunningTest()){
            for(WebServiceObjectsLWC.Attachment myAttchMaster : myNewMaster.attachments) {
                String extension = (String.isBlank(myAttchMaster.extension) ? '' : myAttchMaster.extension);
                String pathOnClient = (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name);
             
                if(extension !=null && extension.length()>1) {
                    if(extension.substring(0, 1).equals('.')) {
                        pathOnClient += extension;
                    } else {
                        pathOnClient += '.' + extension;
                    }
                }
                DownloadCVLWC.downloadCV((String.isBlank(myAttchMaster.public_url) ? '' : myAttchMaster.public_url), myContact.Id, 
                                         pathOnClient, 
                                         (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name),myContact.LastName,myContact.FirstName); 
            }
        }
        return myContact.Id;
    }

    //Update Profile : myCont the existing profil, myMaster the new profile
    public Id updateContact (Contact myCont, MasterLWC myMaster) {
         /*if (activateLogs()){
         logMessage('MasterLWC call updateContact Method');
        }*/
        populateContact(myCont, myMaster);
        update myCont;
        //Get Existing Files attached to contact
        if(!Test.isRunningTest()){
            Set<Id> ContentDocumentIds = new Set<Id>();
            For(ContentDocumentLink item : [SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: myCont.Id]){
                ContentDocumentIds.add(item.ContentDocumentId);
            }
            /*if (activateLogs()){
             logMessage('MasterLWC updateContact  ContentDocumentIds'+ContentDocumentIds);
            }*/
            List<String> filesNames = new List<String>();
            for(ContentVersion content : [SELECT Id, title FROM ContentVersion WHERE ContentDocumentId IN:ContentDocumentIds ]){
                filesNames.add(content.title);
            }
            /*if (activateLogs()){
             logMessage('MasterLWC updateContact  filesNames'+filesNames);
            }*/
          
            for(WebServiceObjectsLWC.Attachment myAttchMaster : myMaster.attachments) {
            
                String extension = (String.isBlank(myAttchMaster.extension) ? '' : myAttchMaster.extension);
                String pathOnClient = (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name);
                if(extension !=null && extension.length()>1) {
                    if(extension.substring(0, 1).equals('.')) {
                        pathOnClient += extension;
                    } else {
                        pathOnClient += '.' + extension;
                    }
                }
                if(!filesNames.contains((String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name)) ){
                    DownloadCVLWC.downloadCV((String.isBlank(myAttchMaster.public_url) ? '' : myAttchMaster.public_url), myCont.Id, 
                                             pathOnClient, 
                                             (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name),myCont.LastName,myCont.FirstName);      
                }
            }
        }
        
        /*for(WebServiceObjectsLWC.Attachment myAttchMaster : myMaster.attachments) {
           DownloadCVLWC.downloadCV((String.isBlank(myAttchMaster.public_url) ? '' : myAttchMaster.public_url), myCont.Id, 
                                    (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name), 
                                    (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name)); 
        }*/
        return myCont.Id;
    }

    private void populateContact(Contact c, MasterLWC m) {
        /*if (activateLogs()){
         logMessage('populateContact Method');
        }*/
        if(m.info!=null) {
            c.FirstName =(String.isBlank(m.info.first_name) ? 'PRENOM' :  m.info.first_name);//c.FirstName = m.info.first_name;            
            c.LastName =(String.isBlank(m.info.last_name) ? 'NOM' :  m.info.last_name);//c.LastName = m.info.last_name;
            //c.Phone = m.info.phone;
            c.MobilePhone = m.info.phone;
            c.summary__c = m.info.summary;
            c.picture__c = m.info.picture;
            //AMO : 04/02/2022
            //c.crta__GDPR_Date__c = Date.today();
            c.crta__GDPR__c=False;
            c.crta__Parsing_Creation_Date__c = m.created_at.date();
            c.crta__Parsing_Modification_Date__c = m.updated_at.date();
            //End : 04/02/2022 
            if(myRtId!=null && c.RecordTypeId == null) {
                c.RecordTypeId = myRtId;
            }
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
                for(WebServiceObjectsLWC.Url u:m.info.urls) {
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
        }

        /*if (activateLogs()){
            logMessage('FM MasterLWC populateContact  Disponible_sous__c= :'+ WebServiceObjectsLWC.availability );
            logMessage('FM MasterLWC populateContact  crtarecr__Desired_annual_gross_remuneration__c= :'+ WebServiceObjectsLWC.gdprCheckBox );
            logMessage('FM MasterLWC populateContact  crtarecr__confidentialite_lue__c= :'+ WebServiceObjectsLWC.privacyPolicyCheckBox );
        }*/
        //Beg : Added by Tenhinene 2022-03-25
            //Information from tags
            //==> Debut de modif par Fallou 2022-07-07
            ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getOrgDefaults();
            if(externalFields.Availability__c == true){
                 if(WebServiceObjectsLWC.availability!=''){c.put('Disponible_sous__c', WebServiceObjectsLWC.availability);}
            }
            if(externalFields.Salary_expectations__c == true && WebServiceObjectsLWC.salaryExpectation !=null){
                 if(WebServiceObjectsLWC.salaryExpectation!=''){c.put('crtarecr__Desired_annual_gross_remuneration__c', WebServiceObjectsLWC.salaryExpectation);}
            }
            if(externalFields.Gdpr_checkbox__c == true && WebServiceObjectsLWC.gdprCheckBox !=null){ c.put('crtarecr__Recruitment_Agreement_GDPR__c', WebServiceObjectsLWC.gdprCheckBox);}
            if(externalFields.Privacy_policy_checkbox__c == true && WebServiceObjectsLWC.privacyPolicyCheckBox!=null){ c.put('crtarecr__confidentialite_lue__c', WebServiceObjectsLWC.privacyPolicyCheckBox);}
        
        //End : Added by Tenhinene 2022-03-25
         
        c.educations_duration__c = m.educations_duration;
        c.archive__c = m.archive;
        c.experiences_duration__c = m.experiences_duration;
        //==> Fin de modif par Fallou 2022-07-07
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
}