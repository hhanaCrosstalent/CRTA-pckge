/**
 * Created by Saad on 20/01/2022.
 */

public with sharing class WebServiceObjectsLWC
{
    public class WebServiceException extends Exception {}

    public static String jobOfferCode=''; // used to retrieve jobe offer Id
    
    public static Boolean gdprCheckBox; 
    public static Boolean privacyPolicyCheckBox;
    public static String  geographicalMobility='';
    public static String  message='';
    public static String  availability='';
    public static String  salaryExpectation='';
    public static String  origin='';
    public static Boolean  isUpdate=false;
    
    public static String pairsToString(List<Pair> pairs) {
        String s = '';
        if(pairs==null) return s;
        for(Pair p:pairs) {
            s += p.toString();
        }
        if(s.length()>255) {
            s = s.substring(0, 255);
        }
        return s;
    }
    
     public  static Boolean activateLogs(){
      Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
        if (logactive) {
          return true;
        }
        else {
            return false;
        }
  
    } 
    
    
     private static void logMessage(String message)
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
    public virtual class Pair {
        public String name;
        public String value;
        public override String toString() {
            return '{' + name + ':' + value + '}';
        }
    }

    public class Metadata extends Pair {
        
        public void newMetadata(MasterLWC myMaster, Id ProfileId) {
            
            try{
                delete [SELECT Id FROM Metadata__c WHERE Contact__c =: ProfileId];
                List<Metadata__c> metaDataList = new List<Metadata__c>();
                
                if(myMaster.metadatas !=null) {
                    for(Metadata myMet : myMaster.metadatas) {
                        Metadata__c myMeta = new Metadata__c(
                            Contact__c = profileId,
                            Metadata_key__c = myMet.name,
                            Metadata_values__c = myMet.value
                            // Metadata_value__c = myMet.value
                        );
                        //Beg : Added by Tenhinene 2022-03-25
                        if(myMet.name=='geographical_mobility'){
                            WebServiceObjectsLWC.geographicalMobility=myMet.value;
                        }
                        if(myMet.name=='message'){
                            WebServiceObjectsLWC.message=myMet.value;
                        }
                        //End : Added by Tenhinene 2022-03-25
                        metaDataList.add(myMeta);
                    }
                }
                try{
                    insert metaDataList;
                } catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' metadatas.\n Details : \n'+message);
                    }
                }
                
            }
            Catch(Exception e){
                
                if (activateLogs()){
                     String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newMetadata method. \n Details : \n'+message);
                }
            }
        }
    }
 
    public class certification {

        public String name;
        public String value;
        
        public void newCertification(MasterLWC myMaster, Id ProfileId) {
            List<Certification__c> certificationsList = new List<Certification__c>();
            for(certification myCertif : myMaster.certifications){
                if(myCertif.name !=null){
                    Certification__c certifToAdd = new Certification__c(
                            Contact__c= ProfileId,
                            Label__c = myCertif.name
                    );
                    if(myCertif.value != null) {
                        certifToAdd.Value__c = '' + myCertif.value;
                    }
                    populateCertification(certifToAdd, myCertif);
                    certificationsList.add(certifToAdd);

                }
            }
            if(certificationsList.size() > 0) insert certificationsList;
        }
        
        public void upsertCertification(MasterLWC myMaster, List<Certification__c> certificationDB, Id myProfileId) {
            try{
                List<Certification__c> certificationList = new List<Certification__c>();
                Integer i = 0;
                for(certification myCertificat : myMaster.certifications){
                    i =0;
                    for(Certification__c certifItemDB : certificationDB){
                        if(myCertificat.name == certifItemDB.crta__Label__c){
                            populateCertification(certifItemDB, myCertificat);
                            certificationList.add(certifItemDB);
                            i=1;
                        }
                    }
                    if(i==0) {
                        Certification__c CertificationToAdd = new Certification__c(
                            Contact__c= myProfileId
                        );
                        populateCertification(CertificationToAdd, myCertificat);
                        certificationList.add(CertificationToAdd);
                    }
                }
                try{
                    upsert certificationList;
                } catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' certifications.\n Details : \n'+message);
                    }
                }
                
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in upsertCertification method. \n Details : \n'+message);
                }
            }
        }    
        private void populateCertification(Certification__c certif, certification myCertif) {
            certif.crta__Label__c = myCertif.name;
            if(myCertif.value != null) {
                certif.Value__c = '' + myCertif.value;
            }
        }

    }
    public class Language {
        
        public String name;
        public Decimal value;
        
        public void newLanguage(MasterLWC myMaster, Id ProfileId) {
            try{
                List<Language__c> languagesList = new List<Language__c>();
                for(Language myLang : myMaster.languages){
                    if(myLang.name !=null){
                        Language__c langToAdd = new Language__c(
                            Contact__c= ProfileId,
                            Language_key__c = myLang.name
                        );
                        if(myLang.value != null) {
                            langToAdd.Language_value__c = '' + myLang.value;
                        }
                        populateLanguage(langToAdd, myLang);
                        languagesList.add(langToAdd);
                        
                    }
                }
                
                try{
                    if(languagesList.size() > 0) insert languagesList;
                } catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' languages.\n Details : \n'+message);
                    }    
                }  
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newLanguage method. \n Details : \n'+message);
                }
            }  
        }

        /* Reworked
        public void upsertLanguage(MasterLWC myMaster, List<Language__c> languageDB, Id myProfileId)
        {
            List<Language__c> languagesList = new List<Language__c>();

            Map<String, Language__c> keyToLanguage = new Map<String, Language__c>();

            for(Language__c language : languageDB)
            {
                keyToLanguage.put(language.Language_key__c, language);
            }

            for(Language myLang : myMaster.languages)
            {
                if(keyToLanguage.containsKey(myLang.name))
                {
                    populateLanguage(keyToLanguage.get(myLang.name), myLang);
                    languagesList.add(keyToLanguage.get(myLang.name));
                }
                else
                {
                    Language__c langToAdd = new Language__c(
                            Contact__c= myProfileId
                    );
                    populateLanguage(langToAdd, myLang);
                    languagesList.add(langToAdd);
                }
            }
            if(languagesList.size() > 0) upsert languagesList;
        } */

        public void upsertLanguage(MasterLWC myMaster, List<Language__c> languageDB, Id myProfileId) {
            try{
            List<Language__c> languagesList = new List<Language__c>();
            Integer i = 0;
            for(Language myLang : myMaster.languages){
                i =0;
                for(Language__c langItemDB:languageDB){
                    if(myLang.name == langItemDB.Language_key__c){
                        populateLanguage(langItemDB, myLang);
                        languagesList.add(langItemDB);
                        i=1;
                    }
                }
                if(i==0) {
                    Language__c langToAdd = new Language__c(
                            Contact__c= myProfileId
                    );
                    populateLanguage(langToAdd, myLang);
                    languagesList.add(langToAdd);
                }
            }
            try{
                upsert languagesList;
            }catch (DMLException e) {
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' languages.\n Details : \n'+message);
                }   
            }
        }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in upsertLanguage method. \n Details : \n'+message);
                }
            }  
        }
        private void populateLanguage(Language__c lang, Language myLang) {
            lang.Language_key__c = myLang.name;
            if(myLang.value != null) {
                lang.Language_value__c = '' + myLang.value;
            }
        }
    }


    public class Tag extends Pair {
        private String origin;
        public void newTags(MasterLWC myMaster, Id ProfileId, Boolean isContactExist) {
            try{
                delete [SELECT Id FROM Tag__c WHERE Contact__c =: ProfileId];
                if (activateLogs()){logMessage('FileLoaderService newTags SELECT Id FROM Tag__c WHERE Contact__c =:'+ProfileId);}
                List<Tag__c> tagsList = new List<Tag__c>();
                
                if(myMaster.tags !=null){
                    for(Tag myTags : myMaster.tags) {
                        Tag__c myTagsToCreate = new Tag__c(
                            Tag_key__c = myTags.name,
                            Contact__c = profileId,
                            Tag_value__c = myTags.value
                        );
                        //Used in the job offer request
                        if(myTags.name=='application-board-job-key'){
                            WebServiceObjectsLWC.jobOfferCode=myTags.value;
                        }
                        if(myTags.origin == 'AMAJ' && isContactExist)
                        {
                            throw new WebServiceException('Il n\'est pas autorisé de mettre à jour ce profil.');
                        }
                        // On stock origin => crta__Source_name__c (Contact)
                        // 
                        if(myTags.name=='application_boardKey_jobReference'){
                            WebServiceObjectsLWC.jobOfferCode=myTags.value;
                        } 
                        //Beg : Added by Tenhinene 2022-03-25
                        if(myTags.name=='gdpr_checkbox'){
                            WebServiceObjectsLWC.gdprCheckBox=Boolean.valueOf(myTags.value);
                        }
                        if(myTags.name=='privacy_policy_checkbox'){
                            WebServiceObjectsLWC.privacyPolicyCheckBox=Boolean.valueOf(myTags.value);
                        }
                        if(myTags.name=='availability'){
                            WebServiceObjectsLWC.availability=myTags.value;
                        }
                        if(myTags.name=='salary_expectations'){
                            WebServiceObjectsLWC.salaryExpectation=myTags.value;
                        }
                        if(myTags.name=='origin'){
                            WebServiceObjectsLWC.origin=myTags.value;
                        }
                        //End : Added by Tenhinene 2022-03-25  
                        
                        tagsList.add(myTagsToCreate);
                    }
                }
                try{
                    insert tagsList;
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' tags.\n Details : \n'+message);
                    }   
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newTags method. \n Details : \n'+message);
                }
            }  
        }
    }

    public class Interest extends Pair {


        public void newInterest(MasterLWC myMaster, Id ProfileId) {
            try {
            delete [SELECT Id FROM Interest__c WHERE Contact__c =: ProfileId];
            if (activateLogs()){
             logMessage('WebServiceObjectsLWC newInterest: SELECT Id FROM Interest__c WHERE Contact__c =:'+ProfileId );
            }
            List<Interest__c> interestsList = new List<Interest__c>();

            if(myMaster.interests !=null){
                for(Interest myInter : myMaster.interests){
                    Interest__c myInterest = new Interest__c(
                            Interest_key__c = myInter.name,
                            Contact__c = profileId,
                            Interest_value__c = myInter.value
                    );
                    interestsList.add(myInterest);
                }
            }
            try{
                insert interestsList;
            }catch (DMLException e) {
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' interstes.\n Details : \n'+message);
                }   
            }
        }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newInterest method. \n Details : \n'+message);
                }
            }
        }
    }

    public class Label {

        public String job_key;
        public String stage;

        public void newLabels(MasterLWC myMaster, Id ProfileId) {
            try{
                delete [SELECT Id FROM Label__c WHERE Contact__c =: ProfileId];
                if (activateLogs()){
                    logMessage('WebServiceObjectsLWC newLabels: SELECT Id FROM Label__c WHERE Contact__c =:'+ProfileId );
                }
                List<Label__c> labelsList = new List<Label__c>();
                
                if(myMaster.labels !=null){
                    for(Label myLab : myMaster.labels) {
                        Label__c myLabel = new Label__c(
                            Job_key__c = myLab.job_key,
                            Contact__c = profileId,
                            Stage__c = Boolean.valueOf(myLab.stage)
                        );
                        labelsList.add(myLabel);
                    }
                }
                try{
                    insert labelsList;
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' labels.\n Details : \n'+message);
                    }   
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newLabels method. \n Details : \n'+message);
                }
            }
        }
    }
    public class Fields {
        public String category;
        public String city; // e.g. city
        public String city_district;
        public String country; // e.g. 'FRA'
        public String country_region;
        public String entrance;
        public String house;
        public String house_number;
        public String island;
        public String level;
        public String near;
        public String po_box;
        public String postcode; // e.g. String '75001'
        public String road;
        public String staircase;
        public String state; // e.g. 'Ile-de-France'
        public String state_district; // e.g. 'Paris'
        public String suburb;
        public String text; // e.g. 'Paris, Ile-de-France, France'
        public String unit;
        public String world_region;
    }

    public class Location {
        public String text;
        public Decimal lat;
        public Decimal lng;
        public String gmaps;
        public WebServiceObjectsLWC.Fields fields = new WebServiceObjectsLWC.Fields();
    }

    public class Url { // ok
        public String type;
        //public String[] url;  
        public String url;
    }

    public class Info { // ok
        public String email;
        public String first_name;
        public String full_name;
        public String gender; // e.g. 'male'  --> To translate to Mr, Me.  To use title standard field
        public String last_name;
        public WebServiceObjectsLWC.Location location;
        public String phone;
        public String picture; // (To clarify with HrFlow)
        public String summary;
        public List<Url> urls;
    }

    public virtual class ConsentAlorithmicType {
        public Boolean embedding;
        public Boolean parsing;
        public Boolean reasoning;
        public Boolean revealing;
        public Boolean scoring;
        public Boolean searching;
    }

    public class Controller extends ConsentAlorithmicType {}
    public class Owner extends ConsentAlorithmicType {}

    public class ConsentAlgorithmic {
        public Controller controller;
        public Owner owner;

        public void newConsent(MasterLWC myMaster, Id ProfileId) {
            try{
                delete [SELECT Id FROM PartyConsent WHERE crta__ContactV2__c =: ProfileId];
                if (activateLogs()){
                    logMessage('WebServiceObjectsLWC newConsent: SELECT Id FROM PartyConsent WHERE crta__ContactV2__c =:'+ProfileId );
                }
                List<Individual> individuals = [SELECT Id FROM Individual];
                if(individuals.size()>0) {
                    PartyConsent myCons = new PartyConsent(
                        crta__ContactV2__c = ProfileId,
                        crta__ControllerEmbeddingV2__c = myMaster.consent_algorithmic.controller.embedding,
                        crta__ControllerParsingV2__c = myMaster.consent_algorithmic.controller.parsing,
                        crta__ControllerReasoningV2__c = myMaster.consent_algorithmic.controller.reasoning,
                        crta__ControllerRevealingV2__c = myMaster.consent_algorithmic.controller.revealing,
                        crta__ControllerScoringV2__c = myMaster.consent_algorithmic.controller.scoring,
                        crta__ControllerSearchingV2__c = myMaster.consent_algorithmic.controller.searching,
                        crta__OwnerEmbeddingV2__c = myMaster.consent_algorithmic.owner.embedding,
                        crta__OwnerParsingV2__c = myMaster.consent_algorithmic.owner.parsing,
                        crta__OwnerReasoningV2__c	 = myMaster.consent_algorithmic.owner.reasoning,
                        crta__OwnerRevealingV2__c = myMaster.consent_algorithmic.owner.revealing,
                        crta__OwnerScoringV2__c = myMaster.consent_algorithmic.owner.scoring,
                        crta__OwnerSearchingV2__c = myMaster.consent_algorithmic.owner.searching,
                        Name = 'HrFlow Consent',
                        PartyId = individuals.get(0).Id
                    );
                    try{
                        insert  myCons;
                    }catch (DMLException e) {
                        if (activateLogs()){
                            String message = e.getDmlMessage(0);
                            logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' PartyConsent.\n Details : \n'+message);
                        }   
                    }
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newConsent method. \n Details : \n'+message);
                }
            }
        }
    }

    public class Source {
        public String id;
        public String name;
        public String subtype;
        public String type;
    }

    public class Education {
        public String key;
        public String title;
        public String school;
        public String description;
        public DateTime date_start; // e.g. '2016-01-01T00:00:00'
        public DateTime date_end;
        public Location location;
        public Pair[] hard_skills;
        public Pair[] soft_skills;

        public void newEducation(MasterLWC myMaster, Id ProfileId) {
            try{
                List<crta__Diploma__c> diplomaList = new List<crta__Diploma__c>();
                for(Education myDiploma : myMaster.educations){
                    if(myDiploma.title !=null && myDiploma.date_start !=null /*&& myDiploma.school !=null*/) {
                        crta__Diploma__c eduqToAdd = new crta__Diploma__c();
                        eduqToAdd.crta__Employee__c = ProfileId;
                        populateEducation(eduqToAdd, myDiploma);
                        diplomaList.add(eduqToAdd);
                    }
                }
                try{
                    insert diplomaList;
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' diplomas.\n Details : \n'+message);
                    }   
                }
                
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newEducation method. \n Details : \n'+message);
                }
            }
        }

        public void upsertEducation(MasterLWC myMaster, List<crta__Diploma__c> educationDB, Id ProfileId) {
            try{
                List<crta__Diploma__c> educationList = new List<crta__Diploma__c>();
                Integer i =0;
                
                for(Education myDiploma : myMaster.educations) {
                    
                    if(String.isBlank(myDiploma.school)) myDiploma.school = null;
                    if(String.isBlank(myDiploma.title)) myDiploma.title = null;
                    if(String.isBlank(myDiploma.description)) myDiploma.description = null;
                    
                    if(myDiploma.school==null && myDiploma.title==null
                       && (myDiploma.date_start==null || myDiploma.description==null)) {
                           continue;
                       }
                    
                    i=0;
                    for(crta__Diploma__c eduqItemDB:educationDB) {
                        // if(/*myDiploma.title !=null &&*/ myDiploma.date_start !=null /*&& myDiploma.school !=null*/){ //HrFlow data are not null
                        
                        //Diploma exists in our Database
                        if(myDiploma.title == eduqItemDB.crta__Title__c
                           && myDiploma.school == eduqItemDB.crta__School_Name__c
                           && (
                               (myDiploma.date_start != null && myDiploma.date_start.date() == eduqItemDB.Date_start__c)
                               || (myDiploma.date_start == null && eduqItemDB.Date_start__c == null)
                           )
                          ){
                              populateEducation(eduqItemDB, myDiploma);
                              educationList.add(eduqItemDB);
                              i=1;
                          }
                        // }
                    }
                    if(i==0) {
                        crta__Diploma__c eduqToAdd = new crta__Diploma__c();
                        eduqToAdd.crta__Employee__c = ProfileId;
                        populateEducation(eduqToAdd, myDiploma);
                        educationList.add(eduqToAdd);
                    }
                }
                try{
                    upsert educationList; 
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' diplomas.\n Details : \n'+message);
                    }   
                }
                
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in upsertEducation method. \n Details : \n'+message);
                }
            }
        }
        private void populateEducation(crta__Diploma__c d, Education myDiploma) {
            if(myDiploma.date_start != null) {
                d.Date_start__c = myDiploma.date_start.date(); // identical when update
            }
            if(myDiploma.date_end != null) {
                d.crta__Date_Obtained__c = myDiploma.date_end.date();
            }
            d.Description__c = myDiploma.description;
            d.crta__School_Name__c = myDiploma.school; // identical when update
            d.Hard_Skill__c = pairsToString(myDiploma.hard_skills);
            d.Soft_Skill__c = pairsToString(myDiploma.soft_skills);
            if(myDiploma.title!=null)
            {
                if(myDiploma.title.length() > 79)
                {
                    d.crta__Title__c = myDiploma.title.substring(0,79); // identical when update
                }
                else
                {
                    d.crta__Title__c = myDiploma.title; // identical when update
                }
            }

            d.Education_key__c = myDiploma.key;
            //Address school

            if(myDiploma.location!=null) {
                if(myDiploma.location.fields!=null) {
                    d.MailingCity__c = myDiploma.location.fields.city;
                    d.MailingState__c = myDiploma.location.fields.state;
                    d.MailingPostalCode__c = myDiploma.location.fields.postcode;
                    d.MailingCountry__c = myDiploma.location.fields.country;
                    d.MailingStreet__c = myDiploma.location.fields.road;
                }
                d.GMaps__c = myDiploma.location.gmaps;
                d.MailingLongitude__c = myDiploma.location.lng;
                d.MailingLatitude__c = myDiploma.location.lat;
            }
        }
    }

    public class Skill {

        public String name;
        public String type;
        public String value;

        public void upserSkill(MasterLWC myMaster, List<crta__Contact_Skill_Profile_Line__c> myProfileSkills, Id ProfileId) {
            try{
            if(myMaster.skills!=null && myMaster.skills.size()>0) {

                // build map of existing skills
                //List<crta__Skill__c> skills = [SELECT Name FROM crta__Skill__c];
                
                Map<String, Skill> MasterSkills = new Map<String, Skill>();
                for(Skill mSkill:myMaster.skills) {
                    MasterSkills.put(mSkill.Name,mSkill);
                }
                List<crta__Skill__c> skills = [SELECT Name FROM crta__Skill__c WHERE Name IN :MasterSkills.keySet()];
              if (activateLogs()){
             logMessage('WebServiceObjectsLWC upserSkill: SELECT Name FROM crta__Skill__c WHERE Name IN :'+MasterSkills.keySet() );
            }
                Map<String, crta__Skill__c> existingSkills = new Map<String, crta__Skill__c>();
                for(crta__Skill__c aSkill:skills) {
                    existingSkills.put(aSkill.Name, aSkill);
                }

                Id rtSkill = [SELECT Id FROM RecordType WHERE Name = 'Basic' AND SObjectType = 'crta__Skill__c' AND isActive=True LIMIT 1].Id;
               
                // create list of required new skills and insert them
                List<crta__Skill__c> newSkills = new List<crta__Skill__c>();
                if(skills.size() == 0){
                    //=> Debut de modif le 2022-06-22
                    // for(crta__Skill__c aSkill : skills){
                    //    crta__Skill__c newSkill = new crta__Skill__c(
                    //             crta__Active__c = true,
                    //             Name = aSkill.Name,
                    //             RecordTypeId = rtSkill,
                    //             Source__c = 'HrFlow'
                    //     );
                    //     newSkills.add(newSkill); 
                    // }
                    for(Skill aSkill : myMaster.skills){
                       crta__Skill__c newSkill = new crta__Skill__c(
                                crta__Active__c = true,
                                Name = aSkill.Name,
                                RecordTypeId = rtSkill,
                                Source__c = 'HrFlow'
                        );
                        newSkills.add(newSkill); 
                    }
                    //=> Fin de modif le 2022-06-22
                }else{
                    for(crta__Skill__c aSkill : skills){
                        if(!existingSkills.containsKey(aSkill.name)) {
                        crta__Skill__c newSkill = new crta__Skill__c(
                                crta__Active__c = true,
                                Name = aSkill.name,
                                RecordTypeId = rtSkill,
                                Source__c = 'HrFlow'
                        );
                        newSkills.add(newSkill);
                    }
                    }
                }
                /*for(Skill aSkill:myMaster.skills) {
                    if(!existingSkills.containsKey(aSkill.name)) {
                        crta__Skill__c newSkill = new crta__Skill__c(
                                crta__Active__c = true,
                                Name = aSkill.name,
                                RecordTypeId = rtSkill,
                                Source__c = 'HrFlow'
                        );
                        newSkills.add(newSkill);
                    }
                }*/
                try{
                    insert newSkills;
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' skills.\n Details : \n'+message);
                    }   
                }

                // add new skills to map of existing skills
                for(crta__Skill__c skill:newSkills) {
                    existingSkills.put(skill.Name, skill);
                }

                // build map of existing skill lines
                List<crta__Contact_Skill_Profile_Line__c> existingSkillLines = [
                        SELECT crta__Skill__c
                        FROM crta__Contact_Skill_Profile_Line__c
                        WHERE crta__Contact__c =: ProfileId];
                if (activateLogs()){
                 logMessage('WebServiceObjectsLWC Skill: SELECT crta__Skill__c FROM crta__Contact_Skill_Profile_Line__c  WHERE crta__Contact__c =:'+ProfileId );
                }
                Map<Id, crta__Contact_Skill_Profile_Line__c> existingSkillLineMap = new Map<Id, crta__Contact_Skill_Profile_Line__c>();
                for(crta__Contact_Skill_Profile_Line__c existingSkillLine:existingSkillLines) {
                    existingSkillLineMap.put(existingSkillLine.crta__Skill__c, existingSkillLine);
                }

                // create list of new skill lines and insert them
                List<crta__Contact_Skill_Profile_Line__c> newSkillLines = new List<crta__Contact_Skill_Profile_Line__c>();
                for(Skill aSkill:myMaster.skills) {
                    if(existingSkills.KeySet().contains(aSkill.name)){
                        Id skillId = existingSkills.get(aSkill.name).Id;
                        crta__Contact_Skill_Profile_Line__c sl = existingSkillLineMap.get(skillId);
                        if(sl==null) {
                            sl = new crta__Contact_Skill_Profile_Line__c();
                            sl.crta__Contact__c = ProfileId;
                            sl.crta__Skill__c = skillId;
                        }
                        populateSkillLine(sl, aSkill);
                        newSkillLines.add(sl); 
                        
                    }
                }
                try {
                    
                    upsert newSkillLines;
                } catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' new skill Lines.\n Details : \n'+message);
                    }   
                }
            } else{
                if (activateLogs()){
                    logMessage('FM WebServiceObjectsLWC Skill: la valeur de myMaster.skills :'+myMaster.skills +',  myMaster.skills.size'+ myMaster.skills.size());
                }

            }
        }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in upsertEducation method. \n Details : \n'+message);
                }
            }
        }

        private void populateSkillLine(crta__Contact_Skill_Profile_Line__c sl, Skill aSkill) {
            sl.crta__Active__c = true;
            sl.crta__Assessment_Context__c = 'External Tool';
            sl.crta__Assessment_Date_Appraisee__c = Date.today();
            sl.crta__Type__c = aSkill.type;
            sl.Evaluation__c = aSkill.value;
            sl.crta__Status__c = '30 Approved';
        }
    }

    public class Experience {
        public String key;
        public String title;
        public String company;
        public String description;
        public DateTime date_start;
        public DateTime date_end;
        public Location location;
        public Pair[] hard_skills;
        public Pair[] soft_skills;

        public void newExperience(MasterLWC myMaster, Id ProfileId) {
            try{
                List<Experience__c> experienceList = new List<Experience__c>();
                for(Experience myExp : myMaster.experiences){
                    if(myExp.company !=null && myExp.title !=null && myExp.date_start !=null) {
                        Experience__c expToAdd = new Experience__c();
                        expToAdd.Contact__c = ProfileId;
                        populateExperience(expToAdd, myExp);
                        experienceList.add(expToAdd);
                    }
                }
                try{
                    insert experienceList; 
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' experiences.\n Details : \n'+message);
                    }   
                    
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newExperience method. \n Details : \n'+message);
                }
            } 
        }

        /* Reworked
        public void upsertExperience(MasterLWC myMaster, List<Experience__c> experienceDB, Id profileId)
        {
            List<Experience__c> experienceList = new List<Experience__c>();
            Map<String, Experience__c> keyToExperience = setExperienceMap(experienceDB);

            for(Experience currentExperience : myMaster.experiences)
            {
                String company = String.isBlank(currentExperience.company) ? null : currentExperience.company;
                String title = String.isBlank(currentExperience.title) ? null : currentExperience.title;

                String key = String.format('{0}{1}{2}',
                    new List<String>
                    {
                            company,
                            title,
                            String.valueOf(currentExperience.date_start.date())
                    }
                );

                if(keyToExperience.containsKey(key))
                {
                    Experience__c experienceItem = keyToExperience.get(key);
                    populateExperience(experienceItem, currentExperience);
                    experienceList.add(experienceItem);
                }
                else
                {
                    Experience__c experienceToUpsert = new Experience__c();
                    experienceToUpsert.Contact__c = profileId;
                    populateExperience(experienceToUpsert, currentExperience);
                    experienceList.add(experienceToUpsert);
                }
            }
            upsert experienceList;
        }

         Reworked */
        public void upsertExperience(MasterLWC myMaster, List<Experience__c> experienceDB, Id ProfileId) {
            try{
                List<Experience__c> experienceList = new List<Experience__c>();
                Integer i =0;
                for(Experience myExp : myMaster.experiences){
                    i=0;
                    for(Experience__c expItemDB:experienceDB){
                        // if(/*myExp.company !=null && myExp.title !=null &&*/ myExp.date_start !=null) {
                        if(String.isBlank(myExp.company)) myExp.company = null;
                        if(String.isBlank(myExp.title)) myExp.title = null;
                        if(myExp.company== expItemDB.Company__c
                           && myExp.title == expItemDB.Title__c
                           && (
                               (myExp.date_start != null && myExp.date_start.date() == expItemDB.StartDate__c)
                               || (myExp.date_start == null && expItemDB.StartDate__c == null)
                           )
                          ) {
                              populateExperience(expItemDB, myExp);
                              experienceList.add(expItemDB);
                              i=1;
                              // Experience doesn't exist in our Database
                          }
                        // }
                    }
                    if(i==0){
                        Experience__c expToAdd = new Experience__c();
                        expToAdd.Contact__c = ProfileId;
                        populateExperience(expToAdd, myExp);
                        experienceList.add(expToAdd);
                        
                    }
                }
                try{
                    upsert experienceList;
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upsert '+e.getNumDml()+' experiences.\n Details : \n'+message);
                    } 
                }
            }Catch(Exception e){
                    
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed','Error in upsertExperience method. \n Details : \n'+message);
                    }
                } 
        }


        private Map<String, Experience__c> setExperienceMap(List<Experience__c> experiences)
        {
            Map<String, Experience__c> keyToExperience = new Map<String, Experience__c>();

            for(Experience__c experience : experiences)
            {
                String key = String.format('{0}{1}{2}',
                        new List<String>
                        {
                                experience.Company__c,
                                experience.Title__c,
                                String.valueOf(experience.StartDate__c)
                        }
                );

                keyToExperience.put(key, experience);
            }

            return keyToExperience;
        }

        private void populateExperience(Experience__c e, Experience myExp) {
            e.Title__c = myExp.title;
            if(myExp.date_start!=null) {
                e.StartDate__c = myExp.date_start.date();
            }
            e.Company__c = myExp.company;
            e.Experience_key__c = myExp.key;
            e.Description__c = myExp.description;
            if(myExp.date_end!=null) {
                e.EndDate__c = myExp.date_end.date();
            }
            e.Hard_skills__c = pairsToString(myExp.hard_skills);
            e.Soft_skills__c = pairsToString(myExp.soft_skills);
            if(myExp.location!=null) {
                e.GMaps__c = myExp.location.gmaps;
                e.MailingLatitude__c = myExp.location.lat;
                e.crta__MailingLongitude2__c = myExp.location.lng;
                if(myExp.location.fields!=null) {
                    e.MailingCountry__c = myExp.location.fields.country;
                    e.MailingStreet__c = myExp.location.fields.road;
                    e.MailingState__c = myExp.location.fields.state;
                    e.MailingCity__c = myExp.location.fields.city;
                }
            }
        }
    }

    public class Attachment {
        public String alt;
        public String extension;
        public String file_name;
        public Integer file_size;
        public String original_file_name;
        public String public_url;
        public String type;
        public void newApplication(MasterLWC myMaster, Id ProfileId, Boolean isContactExist){

            // delete [SELECT Id FROM Attachment__c WHERE Candidature__r.crta__CT_Candidate__c =: ProfileId];
            // delete [SELECT Id FROM crta__Positionnement__c WHERE crta__CT_Candidate__c =: ProfileId];
            crta__Positionnement__c myCandidature = new crta__Positionnement__c();
            if(!isContactExist && String.isBlank(WebServiceObjectsLWC.origin)){
                Id jobOfferId=null;
                Id rtApplication;
                if(!String.isBlank(WebServiceObjectsLWC.jobOfferCode)){
                    //List<String> myJobOfferParam =WebServiceObjectsLWC.jobOfferCode.split('-');
                    String myOfferId = WebServiceObjectsLWC.jobOfferCode.substringAfter('-');
                    jobOfferId = Id.valueOf(myOfferId);
                    //jobOfferId =[SELECT Id FROM crta__Offre_d_emploi__c WHERE crta__CT_Code__c =: WebServiceObjectsLWC.jobOfferCode].Id;
                    
                    
                }
                //Id jobOfferId = [Select Id,crta__CT_Code__c From crta__Offre_d_emploi__c where crta__CT_Code__c]            
                myCandidature.crta__CT_Candidate__c = ProfileId; 
                myCandidature.crta__CT_Status__c = '10 CV Received';
                myCandidature.crta__CT_Job__c = jobOfferId;
                
                List<RecordType> RtList= [SELECT Id FROM RecordType WHERE Name = 'External job application' AND SObjectType = 'crta__Positionnement__c' AND isActive=True];
                if(RtList.size()>0){
                    rtApplication = RtList[0].Id;   
                    myCandidature.put('recordTypeId', rtApplication);
                }
                
                Origin__c origine = Origin__c.getOrgDefaults();
                
                if(origine.Activate__c){
                    //String origin = 'AMAJ';
                    String origin = String.isBlank(WebServiceObjectsLWC.origin)? 'AMAJ' : WebServiceObjectsLWC.origin;
                    String soqlQuery = 'SELECT Id FROM crtarecr__Application_Source__c WHERE crtarecr__External_ID__c =\'' + origin + '\'';
                    if (activateLogs()){logMessage('WebServiceObjectsLWC newApplication soqlQuery '+soqlQuery);}
                    List<sObject> sobjList = Database.query(soqlQuery);
                    if(sobjList.size()>0){
                        if (activateLogs()){
                            logMessage('FM newApplication : crtarecr__Job_Application_Source__c '+sobjList.get(0).Id);
                        }
                        myCandidature.put('crtarecr__Job_Application_Source__c', sobjList.get(0).Id); 
                    }  
                }
                //Beg : Added by Tenhinene 2022-03-25
                ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getInstance(); 
                if(externalFields.Geographical_mobility__c == true){
                    if (activateLogs()){
                        logMessage('FM newApplication : Mobilite_geographique__c '+WebServiceObjectsLWC.geographicalMobility);
                    }
                    if(!String.isBlank(WebServiceObjectsLWC.geographicalMobility)){myCandidature.put('Mobilite_geographique__c', WebServiceObjectsLWC.geographicalMobility);}
                }
                if(externalFields.Message__c == true){
                    if (activateLogs()){
                        logMessage('FM newApplication : Message_candidat__c '+WebServiceObjectsLWC.message);
                    }
                    if(!String.isBlank(WebServiceObjectsLWC.message)){myCandidature.put('Message_candidat__c', WebServiceObjectsLWC.message);}
                }
                //End : Added by Tenhinene 2022-03-25
                try {
                    insert myCandidature;
                } catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when insert '+e.getNumDml()+' candidature.\n Details : \n'+message);
                    } 
                }
            }
            
            /*
            List<Attachment__c> attachmentList = new List<Attachment__c>();
            if(myMaster.attachments !=null) {
                for(Attachment myAttchMaster : myMaster.attachments) {

                    Attachment__c attchToCreate = new Attachment__c(
                            Candidature__c = myCandidature.Id,
                            Alt__c = (String.isBlank(myAttchMaster.alt) ? '' : myAttchMaster.alt),
                            // Attachment_key__c = (String.isBlank(myAttchMaster.attachment_key) ? '' : myAttchMaster.attachment_key),
                            Extension__c = (String.isBlank(myAttchMaster.extension) ? '' : myAttchMaster.extension),
                            Name = (String.isBlank(myAttchMaster.file_name) ? '' : myAttchMaster.file_name),
                            //Size__c = (String.isBlank(myAttchMaster.file_size) ? '' : double.valueOf(myAttchMaster.file_size)),
                            Size__c = myAttchMaster.file_size,
                            Original_file_name__c = (String.isBlank(myAttchMaster.original_file_name) ? '' : myAttchMaster.original_file_name),
                            Public_url__c = (String.isBlank(myAttchMaster.public_url) ? '' : myAttchMaster.public_url),
                            Type__c = (String.isBlank(myAttchMaster.type) ? '' : myAttchMaster.type)
                    );
                    attachmentList.add(attchToCreate);
                }
                insert attachmentList;
                for(Attachment__c a:attachmentList) {
                    String pathOnClient = a.Name;
                    String title = a.Name;
                    if(a.Extension__c!=null && a.Extension__c.length()>1) {
                        if(a.Extension__c.substring(0, 1).equals('.')) {
                            pathOnClient += a.Extension__c;
                        } else {
                            pathOnClient += '.' + a.Extension__c;
                        }
                    }
                    if(!Test.isRunningTest()) {
                        
                        DownloadCVLWC.downloadCV(a.Public_url__c, ProfileId, pathOnClient, title);
                    }
                }
                
            }
			*/
            
            
        }
        
        
    }

    // 05/08/2021 Class created to address the job offers
    public class JobOffers{
        public  List<crta__Offre_d_emploi__c> getJobOffers()
        {
            String crtiteriaValue = System.Label.JobOffer_CriteriaField;
            List<String> fieldString = getSObjectFieldNames('crta__Offre_d_emploi__c');
            String fieldList = String.join(fieldString, ',');
            String soqlQuery = 'SELECT '
                    + fieldList + ' '
                    + 'FROM crta__Offre_d_emploi__c ';
             if (activateLogs()){
                 logMessage('WebServiceObjectsLWC getJobOffers: SELECT' + fieldList + ' ' + 'FROM crta__Offre_d_emploi__c ');
                }
            //    + 'WHERE LastModifiedDate >=: fromDate AND LastModifiedDate <=: toDate';
            if(crtiteriaValue != 'None')
            {
                soqlQuery  +=  ' WHERE '+crtiteriaValue+' = TRUE ';
            }
            List<crta__Offre_d_emploi__c> jobOffersList = Database.query(soqlQuery);
            return jobOffersList;
        }

        public  List<String> getSObjectFieldNames(final String sObjectName) {
            return new List<String>(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keySet());
        }

    }
    
   
}