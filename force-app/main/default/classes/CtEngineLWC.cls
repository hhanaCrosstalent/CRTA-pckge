public class CtEngineLWC {

    private class CTEngineException extends Exception{}

    MasterLWC myMasterClassObject = new MasterLWC();

    WsEngine.Logger logger = new WsEngine.Logger();

    Boolean isContactExist = false;

    Id profileId;

    private final String MASTER_NULL                               = Label.FileLoader_EmptyParsing;
    private final String INVALID_INFOS                             = Label.FileLoader_ParsingFailure;
    private final String PROFILE_FAILURE                           = Label.FileLoader_ProfileCreationFailure;
    private final String PROFILE_PARTIAL_FAILURE                   = Label.FileLoader_ProfilePartialFailure;
    private final String MASTER_NULL_TECHNIQUE                     = Label.FileLoader_EmptyParsingTechnique;
    private final String INVALID_INFOS_TECHNIQUE                   = Label.FileLoader_ParsingFailureTechnique;
    private final String EXCLUDED_PROFILE                          = Label.FileLoader_ProfileCreationFailureExcluded;
    private final List<String> RECORD_TYPES_TO_EXCLUDE             = Label.FileLoader_RecordTypeToExclude.split(',');


    // Other errors =
    public String upsertProfile(MasterLWC master)
    {
        String message = validateMaster(master);
        if(!String.isBlank(message)) return message;
 
        try {
            message = studyContactExistance(master);
            message = String.isNotBlank(processProfile(master)) ? processProfile(master) : message;
            logMessage('Web service succeeded, profileId: ' + profileId);
        }
        catch(Exception e)
        {
            String errorMessage = String.format(
                    'Web service failed {0} / {1} / {2} / {4}',
                    new List<String>{e.getMessage(), e.getStackTraceString(), String.valueOf(e.getCause()), String.valueOf(e.getLineNumber())}
            );
            logMessage(errorMessage);
            throw new CTEngineException(errorMessage);
        }

        return message;
    }

    private String validateMaster(MasterLWC master)
    {
        if(isEmptyMaster(master)) {
            if (activateLogs()){
           logMessage('CTEngineLWC validateMaster isEmptyMaster: true');
          }
            return MASTER_NULL; }

        if(isInvalidInfos(master)) { return null /*INVALID_INFOS*/; }

        return null;
    }

    private Boolean isEmptyMaster(MasterLWC master)
    {
        if(master == null)
        {
            logMessage(MASTER_NULL_TECHNIQUE);
            return true;
        }

        return false;
    }

    private Boolean isInvalidInfos(MasterLWC master)
    {
        /*
         * AMO : 04/02/2022commented to insert the contact without email or last name
        if(master.info.email == null ||
                master.info.last_name == null)
        {
            logMessage(INVALID_INFOS_TECHNIQUE);
            return true;
        }
       */
        return false;
    }

    private void logMessage(String message)
    {
        logger.write(
                message,
                null,
                null
        );
        logger.flush();
    }

    public Contact checkContactExistance(String email, List<String> recordTypesToExclude)
    {  system.debug('email----> '+email);
        List<Contact> contacts = new List<Contact>();
        
        ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getInstance();
        if (activateLogs()){logMessage('checkContactExistance externalFields---> '+externalFields);}   
        String query = 'SELECT Id, RecordType.DeveloperName,LastName,FirstName, ' 
                       +'(SELECT crta__Title__c, Date_start__c, crta__School_Name__c FROM crta__Diplomas_Contact__r ), '
            		   +'(SELECT Company__c, StartDate__c, Title__c FROM Experiences__r ), '
            		   +'(SELECT Language_key__c FROM Langues__r), '
                       +'(SELECT Label__c FROM Certifications1__r) '
            	       +'FROM Contact ';
       if (activateLogs()){logMessage('checkContactExistance query---> '+query);}   

        if(String.isNotBlank(externalFields.External_Email_Field__c) && externalFields.External_Email_Field__c != null){
          query +=  'WHERE Email = : email OR '+externalFields.External_Email_Field__c+' =: email LIMIT 1' ;
            if (activateLogs()){logMessage('if External_Email_Field__c not null: '+ 'WHERE Email = :'+email+' OR '+externalFields.External_Email_Field__c+' =: email LIMIT 1' );}  
        }else{
           query +=  'WHERE Email = : email LIMIT 1';
           if (activateLogs()){logMessage('if External_Email_Field__c  null---> '+ 'WHERE Email = :'+email+' LIMIT 1');}  
 
        }
         //log request 
        contacts = Database.query(query);  
        //log contacts
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
        if (activateLogs()){logMessage('checkContactExistance contacts.size()---> '+contacts.size());}   
        if(contacts.size() > 0)
        { if (activateLogs()){logMessage('checkContactExistance contacts.get(0)---> '+contacts.get(0));}   
            return contacts.get(0);
        }
        return null;
    }

    private String getLoginUserProfil (){
        return userinfo.getProfileId();
    }
    
    
    
    private String studyContactExistance(MasterLWC master)
    {
        // Whether the contact exists
        string jsonEmail = (String.isBlank(master.info.email) ? 'PRENOM.NOM'+DateTime.now().getTime()+'@crosstalent.fr' :master.info.email);
        if (activateLogs()){logMessage('studyContactExistance jsonEmail---> '+jsonEmail);}
        Contact existingContact = checkContactExistance(jsonEmail/*master.info.email*/, RECORD_TYPES_TO_EXCLUDE);
        if (activateLogs()){logMessage('studyContactExistance existingContact---> '+existingContact);}

        // Update profile
        if(existingContact != null )
        {if (activateLogs()){logMessage('studyContactExistance existingContact not null '+existingContact.RecordType.DeveloperName);}
            if(!RECORD_TYPES_TO_EXCLUDE.contains(existingContact.RecordType.DeveloperName)){
               isContactExist = true;
               return processExistingContact(master, existingContact);
            }else{
                String errorMessage = EXCLUDED_PROFILE;
                logMessage(errorMessage);
                return errorMessage;
            }
        }
        else
        {
            return processNonExistingContact(master);
        }
        
    }

    public String processExistingContact(MasterLWC master, Contact contact)
    {      if (activateLogs()){logMessage('processExistingContact');}
        String message;
     system.debug('message3 '+message);
        try
        { 
            profileId = myMasterClassObject.updateContact(contact, master);
            system.debug('profileId '+profileId);
           if (activateLogs()){logMessage('processExistingContact '+profileId);}
        }
        catch(CTEngineException ex) { ex.setMessage(PROFILE_FAILURE); throw ex; }

        try
        {
            // Upsert Education
            WebServiceObjectsLWC.Education myEducationInstance = new WebServiceObjectsLWC.Education();
            myEducationInstance.upsertEducation(master, contact.crta__Diplomas_Contact__r, contact.Id);
        }
        catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
        catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

        try
        {
            // Upsert Experience
            WebServiceObjectsLWC.Experience experienceToUpsert = new WebServiceObjectsLWC.Experience();
            experienceToUpsert.upsertExperience(master, contact.Experiences__r, contact.Id);
        }
        catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }
        catch (ListException ex){ message = PROFILE_PARTIAL_FAILURE; }

        try
        {WebServiceObjectsLWC.Language languagesInstance = new WebServiceObjectsLWC.Language();
         languagesInstance.upsertLanguage(master, contact.Langues__r, contact.Id);}
        catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
        catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

        try
        {WebServiceObjectsLWC.certification certificationsInstance = new WebServiceObjectsLWC.certification();
         certificationsInstance.upsertCertification(master, contact.Certifications1__r, contact.Id);
        }
        
        catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
        catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }
     	if (message ==null ){
           return 'ProfileId'+profileId;
        }else {
            return message; 
        }
    }

    private String processNonExistingContact(MasterLWC master)
    {
        String message;

        Id newContactResults = myMasterClassObject.newContact(master);
        profileId = newContactResults;
        if (activateLogs()){
         logMessage('CtEngineLWC processNonExistingContact:'+newContactResults);
        }

        try
        {
            WebServiceObjectsLWC.Education myEducationClass = new WebServiceObjectsLWC.Education();
            myEducationClass.newEducation(master,profileId);
        }
        catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
        catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

        try
        {WebServiceObjectsLWC.Experience myExperienceClass = new WebServiceObjectsLWC.Experience();myExperienceClass.newExperience(master,profileId);}catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

        try
        {WebServiceObjectsLWC.Language myLanguageClass = new WebServiceObjectsLWC.Language();myLanguageClass.newLanguage(master,profileId);}catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }
        
        try
        {
            WebServiceObjectsLWC.certification myCertificationClass = new WebServiceObjectsLWC.certification();myCertificationClass.newCertification(master,profileId);}catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

        if (message ==null ){
           return 'ProfileId'+newContactResults;
        }else {
            return message; 
        }
    }

    private String processProfile(MasterLWC master)
    {  if (activateLogs()){logMessage('CtEngineLWC processProfile-');}
        String message;

        if(profileId != null){// We create Attachment, Interest, tags Metadata and labels if the profile creation/update is success
            try
            {
                // Interest
                WebServiceObjectsLWC.Interest myInterestClass = new WebServiceObjectsLWC.Interest();
                myInterestClass.newInterest(master, profileId);
            }
            catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

            try
            {
                // Tags
                WebServiceObjectsLWC.Tag myTagClass = new WebServiceObjectsLWC.Tag();
                myTagClass.newTags(master, profileId, isContactExist);
            }
            catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

            try
            {
                //Labels
                WebServiceObjectsLWC.Label myLabelClass = new WebServiceObjectsLWC.Label();
                myLabelClass.newLabels(master, profileId);
            }
            catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex) { message = PROFILE_PARTIAL_FAILURE; }

            try
            {
                //Metadata
                WebServiceObjectsLWC.Metadata myMetadataClass = new WebServiceObjectsLWC.Metadata();
                myMetadataClass.newMetadata(master, profileId);
            }
            catch (CTEngineException ex) { message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex){ message = PROFILE_PARTIAL_FAILURE; }

            try
            {
                //Candidature + attachment
                WebServiceObjectsLWC.Attachment myAttch = new WebServiceObjectsLWC.Attachment();
                myAttch.newApplication(master, profileId, isContactExist);
                
            }
            catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex){ message = PROFILE_PARTIAL_FAILURE; }


            try
            {
                WebServiceObjectsLWC.Skill mySkillClass = new WebServiceObjectsLWC.Skill();
                mySkillClass.upserSkill(master, null, profileId);
            }
            catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex){ message = PROFILE_PARTIAL_FAILURE; }


            try
            {
                WebServiceObjectsLWC.ConsentAlgorithmic myConsentClass = new WebServiceObjectsLWC.ConsentAlgorithmic();
                myConsentClass.newConsent(master, profileId);
            }
            catch (CTEngineException ex){ message = PROFILE_PARTIAL_FAILURE; }
            catch (DmlException ex){ message = PROFILE_PARTIAL_FAILURE; }
        }
        return message;
    }




// Get the profile contexte : Contact, education, language, experience...
    /*public Contact getProfileContexte (string profileEmail){

        List<Contact> contacts = [
                SELECT Id,
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
        }
    }*/

    /*public String upsertProfile(Master myMaster) {
        WsEngine.Logger logger = new WsEngine.Logger();
        Id profileId;

        if(myMaster==null ) { // No traitment if the object is null
            logger.write('Method called without myMaster', null, null);
            logger.flush();
            return 'Method called without myMaster';
        } else {
            //No Traitement without the e-mail and last name values
            if(myMaster.info.email == null || myMaster.info.last_name == null ) {
                logger.write('Method called without either email or lastname: '
                    + myMaster.info.email + '/' + myMaster.info.last_name, null, null);
                logger.flush();
                return 'Method called without either email or lastname';
            } else {
                try {
                    //check if the profile exist in our database
                    Contact myCont =getProfileContexte(myMaster.info.email);// To retrieve all Profile contexte
                    //Update the profile
                    if(myCont!=null ){ // the contact exists

                        profileId = myMasterClassObject.updateContact(myCont,myMaster);
                        //Upsert Education
                        WebServiceObjects.Education myeducationInstance = new WebServiceObjects.Education();
                        myeducationInstance.upsertEducation(myMaster, myCont.crta__Diplomas_Contact__r, myCont.Id);
                        //Upsert Experience
                        WebServiceObjects.Experience experienceToUpsert = new WebServiceObjects.Experience();
                        experienceToUpsert.upsertExperience(myMaster, myCont.Experiences__r, myCont.Id);
                        // Upsert Language
                        WebServiceObjects.Language languagesInstance = new WebServiceObjects.Language();
                        languagesInstance.upsertLanguage(myMaster, myCont.Langues__r, myCont.Id);

                    } else { // The contact doesn't exist
                        Id newContactResults = myMasterClassObject.newContact(myMaster);
                        profileId = newContactResults;
                        //1 The consent
                        // Consent myConsentClass = new Consent();
                        // Id createdConsent = myConsentClass.newConsent(myMaster,profileId);
                        // 2: Educations
                        WebServiceObjects.Education myEducationClass = new WebServiceObjects.Education();
                        myEducationClass.newEducation(myMaster,profileId);
                        //3: Experiences
                        WebServiceObjects.Experience myExperienceClass = new WebServiceObjects.Experience();
                        myExperienceClass.newExperience(myMaster,profileId);
                        //4: Languages
                        WebServiceObjects.Language myLanguageClass = new WebServiceObjects.Language();
                        myLanguageClass.newLanguage(myMaster,profileId);
                        //5: Skills
                    }

                    if(profileId != null){// We create Attachment, Interest, tags Metadata and labels if the profile creation/update is success
                        // Interest
                        WebServiceObjects.Interest myInterestClass = new WebServiceObjects.Interest();
                        myInterestClass.newInterest(myMaster,profileId);
                        // Tags
                        WebServiceObjects.Tag myTagClass = new WebServiceObjects.Tag();
                        myTagClass.newTags(myMaster,profileId);
                        //Labels
                        WebServiceObjects.Label myLabelClass = new WebServiceObjects.Label();
                        myLabelClass.newLabels(myMaster,profileId);
                        //Metadata
                        WebServiceObjects.Metadata myMetadataClass = new WebServiceObjects.Metadata();
                        myMetadataClass.newMetadata(myMaster,profileId);
                        //Candidature + attachment
                        WebServiceObjects.Attachment myAttch = new WebServiceObjects.Attachment();
                        myAttch.newApplication(myMaster,profileId);

                        WebServiceObjects.Skill mySkillClass = new WebServiceObjects.Skill();
                        mySkillClass.upserSkill(myMaster, null, profileId);

                        WebServiceObjects.ConsentAlgorithmic myConsentClass = new WebServiceObjects.ConsentAlgorithmic();
                        myConsentClass.newConsent(myMaster,profileId);
                    }

                    logger.write('web service succeeded, profileId: ' + profileId, null, null);

                } catch(Exception e) {
                    logger.write('web service failed: ' + e.getMessage() + '/' + e.getStackTraceString() + '/' + e.getCause() + '/' + e.getLineNumber(), null, null);
                } finally {
                    logger.flush();
                }
            }
            return 'Method called without myMaster';
        }
    }*/
 public  Boolean activateLogs(){
      Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
        if (logactive) {
          return true;
        }
        else {
            return false;
        }
  
    } 
}