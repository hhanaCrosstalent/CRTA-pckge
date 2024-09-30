/**
 * @CtEngineV2.cls
 *
 * Creates /updates all parsing records 
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
public class CtEngineV2 {
    
    MasterV2 myMasterClassObject = new MasterV2();    
    public Integer upsertProfile(MasterV2 myMaster) {
        WsEngine.Logger logger = new WsEngine.Logger(); 
        Id profileId;
        
        if(myMaster==null ) { // No traitment if the object is null
            logger.write('Parsing Json File is empty', null, null);
            logger.flush();
            return 0;
        } else {
            //No Traitement without the e-mail and last name values
            //AMO : 04/02/2022 : To address the empty email or first name
            /*if(myMaster.info.email == null || myMaster.info.last_name == null ) {
                logger.write('Method called without either email or lastname: ' 
                    + myMaster.info.email + '/' + myMaster.info.last_name, null, null);
                logger.flush();
                return 1;
            } else {*/
                try {
                    //check if the profile exist in our database
                    //string forEmptyEmail ='PRENOM.NOM'+DateTime.now().getTime()+'@crosstalent.fr';
                    string jsonEmail = (String.isBlank(myMaster.info.email) ? 'PRENOM.NOM'+DateTime.now().getTime()+'@crosstalent.fr' :myMaster.info.email);
                    Contact myCont =getProfileContexte(jsonEmail/*myMaster.info.email*/);// To retrieve all Profile contexte  
                    //Update the profile
                    if(myCont!=null ){ // the contact exists
                        
                        /********************************
                        //get custom setting to update salary?string of development name of salary record type
                        //get salary record type (myCont)
                        //get record type Id where developement name = salary
                        //test
                        //
                        //**********************/
                        profileId = myMasterClassObject.updateContact(myCont,myMaster);
                        //Upsert Education 
                        WebServiceObjectsV2.Education myeducationInstance = new WebServiceObjectsV2.Education();
                        myeducationInstance.upsertEducation(myMaster, myCont.crta__Diplomas_Contact__r, myCont.Id);
                        //Upsert Experience
                        WebServiceObjectsV2.Experience experienceToUpsert = new WebServiceObjectsV2.Experience();
                        experienceToUpsert.upsertExperience(myMaster, myCont.Experiences__r, myCont.Id);                            
                        // Upsert Language
                        WebServiceObjectsV2.Language languagesInstance = new WebServiceObjectsV2.Language();
                        List<Language__c> myExistingLanguage = [Select Id, Name, crta__Language_key__c,crta__Contact__c,crta__label__c, crta__language_name__c,crta__language_level__c,crta__Language_value__c FROM Language__c WHERE crta__Contact__c =:myCont.Id ]; 
                        //languagesInstance.upsertLanguage(myMaster, myCont.Langues__r, myCont.Id);
                        languagesInstance.upsertLanguage(myMaster,myExistingLanguage, myCont.Id);     
                        
                    } else { // The contact doesn't exist
                         Id newContactResults = myMasterClassObject.newContact(myMaster);
                        //Id newContactResults = myMasterClassObjectLWC.newContact(myMaster);
                        profileId = newContactResults;
                        //1 The consent
                        // Consent myConsentClass = new Consent();
                        // Id createdConsent = myConsentClass.newConsent(myMaster,profileId); 
                        // 2: Educations
                        WebServiceObjectsV2.Education myEducationClass = new WebServiceObjectsV2.Education();
                        myEducationClass.newEducation(myMaster,profileId);
                        //3: Experiences
                        WebServiceObjectsV2.Experience myExperienceClass = new WebServiceObjectsV2.Experience();
                        myExperienceClass.newExperience(myMaster,profileId);
                        //4: Languages
                        WebServiceObjectsV2.Language myLanguageClass = new WebServiceObjectsV2.Language();
                        myLanguageClass.newLanguage(myMaster,profileId);
                        //5: Skills
                    }

                    if(profileId != null){// We create Attachment, Interest, tags Metadata and labels if the profile creation/update is success
                        // Interest 
                        WebServiceObjectsV2.Interest myInterestClass = new WebServiceObjectsV2.Interest();
                        myInterestClass.newInterest(myMaster,profileId);                 
                        // Tags
                        WebServiceObjectsV2.Tag myTagClass = new WebServiceObjectsV2.Tag();
                        myTagClass.newTags(myMaster,profileId,true);                
                        //Labels
                        WebServiceObjectsV2.Label myLabelClass = new WebServiceObjectsV2.Label();
                        myLabelClass.newLabels(myMaster,profileId); 
                        //Metadata                 
                        WebServiceObjectsV2.Metadata myMetadataClass = new WebServiceObjectsV2.Metadata();
                        myMetadataClass.newMetadata(myMaster,profileId);
                        //Candidature + attachment
                        WebServiceObjectsV2.Attachment myAttch = new WebServiceObjectsV2.Attachment(); 
                        myAttch.newApplication(myMaster,profileId);

                        WebServiceObjectsV2.Skill mySkillClass = new WebServiceObjectsV2.Skill();
                        mySkillClass.upserSkill(myMaster, null, profileId);

                        WebServiceObjectsV2.ConsentAlgorithmic myConsentClass = new WebServiceObjectsV2.ConsentAlgorithmic();
                        myConsentClass.newConsent(myMaster,profileId); 
                    }

                    logger.write('web service succeeded, profileId: ' + profileId, null, null);

                } catch(Exception e) {
                    logger.write('web service failed: ' + e.getMessage() + '/' + e.getStackTraceString() + '/' + e.getCause() + '/' + e.getLineNumber(), null, null);
                } finally {
                    logger.flush();
                }
            //} // end of the first Else
            return 0;
        }
    }   

     
// Get the profile contexte : Contact, education, language, experience...
    public Contact getProfileContexte (string profileEmail){

        List<Contact> contacts = new List<Contact>();
        
        ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getInstance();
        
        System.debug('externalFields.Privacy_policy_checkbox__c '+externalFields.Privacy_policy_checkbox__c); 
        System.debug('externalFields.External_Email_Field__c '+externalFields.External_Email_Field__c); 
        String query = 'SELECT Id, RecordType.DeveloperName, ' 
                       +'(SELECT crta__Title__c, Date_start__c, crta__School_Name__c FROM crta__Diplomas_Contact__r ), '
            		   +'(SELECT Company__c, StartDate__c, Title__c FROM Experiences__r ), '
            		   +'(SELECT Language_key__c FROM Langues__r), '
                       +'(SELECT Label__c FROM Certifications1__r) '
            	       +'FROM Contact ';
        if(String.isNotBlank(externalFields.External_Email_Field__c) && externalFields.External_Email_Field__c != null){
          query +=  'WHERE Email = : profileEmail OR '+externalFields.External_Email_Field__c+' =: profileEmail LIMIT 1' ;
        }else{
           query +=  'WHERE Email = : profileEmail LIMIT 1';
        }
        
        contacts = Database.query(query);    
        /*contacts = [
                SELECT
                        Id,
                        RecordType.DeveloperName,
                (
                        SELECT
                                crta__Title__c,
                                Date_start__c,
                                crta__School_Name__c
                        FROM crta__Diplomas_Contact__r
                ),
                (
                        SELECT
                                Company__c,
                                StartDate__c,
                                Title__c
                        FROM Experiences__r
                ),
                (
                        SELECT
                                Language_key__c
                        FROM Langues__r
                ),
                (
                        SELECT
                             Label__c
                        FROM Certifications1__r
                )
                FROM
                        Contact
                WHERE
                        Email = : email 
                /*AND
                        RecordType.DeveloperName NOT IN : recordTypesToExclude*/
                /*LIMIT 1
        ];*/
        if(contacts.size() > 0)
        {
            return contacts.get(0);
        }
        return null;
        /*List<Contact> contacts = [
            SELECT Id,RecordTypeId,
                (SELECT crta__Title__c, Date_start__c, crta__School_Name__c FROM crta__Diplomas_Contact__r),
                (SELECT Company__c, StartDate__c, Title__c FROM Experiences__r),
                (SELECT Language_key__c FROM Langues__r)
            FROM Contact
            WHERE Email =: profileEmail
        ];

        if(contacts.size()==0) {
            return null;
        } else {
            return contacts.get(0);
        }*/
    } 
}