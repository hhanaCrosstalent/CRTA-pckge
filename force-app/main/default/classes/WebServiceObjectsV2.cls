/**
 * @WebServiceObjectsV2.cls
 *
 * Contains all web services objects classes
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
public inherited sharing class WebServiceObjectsV2 {
    public static String  jobOfferCode=''; // used to retrieve jobe offer Id 
    public static Boolean gdprCheckBox; 
    public static Boolean privacyPolicyCheckBox;
    public static String  geographicalMobility='';
    public static String  message='';
    public static String  availability='';
    public static String  salaryExpectation='';
    public static String  origin='';
    
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

    public static Boolean activateLogs(){
        Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
          if (logactive) {
            return true;
          }
          else {
              return false;
          }
    
      }
      public static void logMessage(String message, String body)
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
        

        public void newMetadata(MasterV2 myMaster, Id ProfileId) {
 
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
                        WebServiceObjectsV2.geographicalMobility=myMet.value;
                    }
                    if(myMet.name=='message'){
                        WebServiceObjectsV2.message=myMet.value;
                    }
                    //End : Added by Tenhinene 2022-03-25
                    metaDataList.add(myMeta);
                }
            }
            try{
                insert metaDataList;
            }
            catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' metadatas.\n Details : \n'+message);
                    }
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                     String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newMetadata method. \n Details : \n'+message);
                }
            }
        }
        
    }

    public class Language {

        public String name;
        public Decimal value;
        Map<String, crta__LanguagesFilter_Setting__mdt> mapLangaueKey = new Map<String, crta__LanguagesFilter_Setting__mdt>();
 
        public void newLanguage(MasterV2 myMaster, Id ProfileId) {
            try{
                List<Language__c> languagesList = new List<Language__c>();
                //Map<string,string> myPickList = new Map<string,string>{'CHI'=>'Chinese','CHI'=>'Chinois','CHI'=>'Mandarin','POR'=>'Portuguese','POR'=>'Portugais',
                //'FRA'=>'French','FRA'=>'Français','ENG'=>'English','ENG'=>'Anglais',
                //'ARA'=>'Arabic','ARA'=>'Arabe','SPA'=>'Spanish','SPA'=>'Espagnol','DEU'=>'German','DEU'=>'Alellmand','ITA'=>'Italian','ITA'=>'Italien','JPN'=>'Japonais','JPN'=>'Japanese'}; 
                //Map<String, crta__LanguagesFilter_Setting__mdt> mapLangaueKey = crta__LanguagesFilter_Setting__mdt.getAll();
                //Map<String, crta__LanguagesFilter_Setting__mdt> mapLangaueKey = new Map<String, crta__LanguagesFilter_Setting__mdt>(); // Ligne déplacée au niveau de la classe
                for(LanguagesFilter_Setting__mdt current : [SELECT MasterLabel, crta__Language_key__c FROM crta__LanguagesFilter_Setting__mdt]){
                    mapLangaueKey.put(current.MasterLabel.toUpperCase(), current) ; 
                }
                if(myMaster.languages !=null){
                    for(Language myLang : myMaster.languages){
                        if(myLang.name !=null){
                            Language__c langToAdd = new Language__c(
                                Contact__c= ProfileId,
                                //Language_key__c = myLang.name
                                label__c = myLang.name.toUppercase(),
                                //language_name__c = myLang.name,//myPickList.get(mapLangaueKey.get(myLang.name).crta__Language_key__c), 
                                Language_key__c = (mapLangaueKey.containsKey(myLang.name.toUppercase()))? mapLangaueKey.get(myLang.name.toUppercase()).crta__Language_key__c.toUppercase() : 'UNK' // To change to retrieve Code and Label
                                
                            );
                            if(myLang.value != null) {
                                langToAdd.Language_value__c = '' + myLang.value;
                                //langToAdd.crta__language_level__c = myLang.value; // We have to create the mapping between Hr Flow Value and CT Pick List
                            }
                            populateLanguage(langToAdd, myLang);
                            languagesList.add(langToAdd);
                            
                        }
                        //System.debug('Map : '+mapLangaueKey.get(myLang.name).crta__Language_key__c);
                    }
                }
                try{
                    insert languagesList;
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' languages.\n Details : \n'+message);
                    }
                }
                
                system.debug(languagesList.size());
            }
            Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newLanguage method. \n Details : \n'+message);
                }
            }
        }

        public void upsertLanguage(MasterV2 myMaster, List<Language__c> languageDB, Id myProfileId) {
            try{
                List<Language__c> languagesList = new List<Language__c>();
                Integer i = 0;
                System.debug('All --->'+ languageDB);
                if(myMaster.languages !=null){
                    for(Language myLang : myMaster.languages){
                        i =0;
                        for(Language__c langItemDB:languageDB){
                            //if(myLang.name == langItemDB.Language_key__c){
                            System.debug('Database Language : --->'+ langItemDB.crta__label__c + 'And Name: -->'+myLang.name.toUpperCase());
                            
                            if(!String.isBlank(langItemDB.crta__label__c) && !String.isBlank(myLang.name)
                               && myLang.name.toUpperCase() == langItemDB.crta__label__c.toUpperCase()){    
                                   
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
                }
                try{
                    upsert languagesList;
                }
                catch (DMLException e) {
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
            //lang.Language_key__c = myLang.name;
            if(myLang.value != null) {
                lang.Language_value__c = '' + myLang.value;
            }
         if(myLang.name !=null){  
             lang.label__c = myLang.name.toUppercase();
             //lang.language_name__c = myLang.name;
             lang.Language_key__c = (mapLangaueKey.containsKey(myLang.name.toUppercase()))? mapLangaueKey.get(myLang.name.toUppercase()).crta__Language_key__c.toUppercase() : 'UNK';
         }
        }
         
    }
    
    public class Tag extends Pair {
        
          private void logMessage(String message)
          {WsEngine.Logger logger = new WsEngine.Logger();
              logger.write(
                      message,
                      null,
                      null
              );
              logger.flush();
          }
        
        public void newTags(MasterV2 myMaster, Id ProfileId, Boolean isCreated) {
            try{
                if(isCreated) delete [SELECT Id FROM Tag__c WHERE Contact__c =: ProfileId];
                List<Tag__c> tagsList = new List<Tag__c>();
                
                if(myMaster.tags !=null){
                    for(Tag myTags : myMaster.tags) { 
                        Tag__c myTagsToCreate = new Tag__c(
                            Tag_key__c = myTags.name,
                            Contact__c = profileId,
                            Tag_value__c = myTags.value                        
                        );
                        
                        //Used in the job offer request //application-board-job-key 
                        if(myTags.name=='application_boardKey_jobReference'){
                            WebServiceObjectsV2.jobOfferCode=myTags.value;
                        }
                        //Beg : Added by Tenhinene 2022-03-25
                        if(myTags.name=='gdpr_checkbox'){
                            //Start AMO : 01/05/2022
                            If(myTags.value=='1' && WebServiceObjectsV2.origin!='STOCK'){ //AMO : 29062022 Ne pas cocher la case dans le cas de la reprise du stock 
                                //WebServiceObjectsV2.gdprCheckBox=Boolean.valueOf(myTags.value);
                                WebServiceObjectsV2.gdprCheckBox=True;
                                
                            }else
                            {
                                WebServiceObjectsV2.gdprCheckBox=False;
                            }
                            //End AMO
                        }
                        if(myTags.name=='privacy_policy_checkbox'){
                            //Start AMO : 01/05/2022
                            If(myTags.value=='1'){
                                //WebServiceObjectsV2.privacyPolicyCheckBox=Boolean.valueOf(myTags.value);
                                WebServiceObjectsV2.privacyPolicyCheckBox= True;
                            }
                            //End AMO
                        }
                        if(myTags.name=='availability'){
                            WebServiceObjectsV2.availability=myTags.value;
                        }
                        if(myTags.name=='salary_expectations'){
                            WebServiceObjectsV2.salaryExpectation=myTags.value;
                        }
                        if(myTags.name=='origin'){
                            WebServiceObjectsV2.origin=myTags.value;
                        }
                        // if (activateLogs()){
                        //     logMessage('FM WebServiceObjectsV2 newTags  myTags.name  :'+ myTags.name );
                        //     logMessage('FM WebServiceObjectsV2 newTags  WebServiceObjectsV2.availability  :'+ WebServiceObjectsV2.availability );
                        //     logMessage('FM WebServiceObjectsV2 newTags  WebServiceObjectsV2.gdprCheckBox :'+ WebServiceObjectsV2.gdprCheckBox );
                        //     logMessage('FM WebServiceObjectsV2 newTags  WebServiceObjectsV2.privacyPolicyCheckBox :'+ WebServiceObjectsV2.privacyPolicyCheckBox );
                        // }
                        //End : Added by Tenhinene 2022-03-25                    
                        tagsList.add(myTagsToCreate);
                    } 
                }
                try{
                    if(isCreated) insert tagsList;
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' tags.\n Details : \n'+message);
                    }
                }
            }
            Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newTags method. \n Details : \n'+message);
                }
            }
        }
         
    }

    public class Interest extends Pair {
 
        public void newInterest(MasterV2 myMaster, Id ProfileId) {
            try{
            delete [SELECT Id FROM Interest__c WHERE Contact__c =: ProfileId];
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
            }
            catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' interests.\n Details : \n'+message);
                    }
                }
            }
            Catch(Exception e){
                
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
 
        public void newLabels(MasterV2 myMaster, Id ProfileId) {
            try{                
                delete [SELECT Id FROM Label__c WHERE Contact__c =: ProfileId];
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
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' labels.\n Details : \n'+message);
                    }
                }
            }
        Catch(Exception e){
            
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
        public WebServiceObjectsV2.Fields fields = new WebServiceObjectsV2.Fields();
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
        public WebServiceObjectsV2.Location location;
        public String phone;
        public String picture; // (To clarify with HrFlow)
        public String summary; 
        //public Date updated_at;
        //public Date created_at;
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
// Uncomment when we create field in PartyConsent object
   
        public void newConsent(MasterV2 myMaster, Id ProfileId) {
            try{
                delete [SELECT Id FROM PartyConsent WHERE ContactV2__c =: ProfileId]; 
                
                List<Individual> individuals = [SELECT Id FROM Individual];
                if(individuals.size()>0) {
                    PartyConsent myCons = new PartyConsent(
                        ContactV2__c = ProfileId, 
                        ControllerEmbeddingV2__c = myMaster.consent_algorithmic.controller.embedding,
                        ControllerParsingV2__c = myMaster.consent_algorithmic.controller.parsing,
                        ControllerReasoningV2__c = myMaster.consent_algorithmic.controller.reasoning,
                        ControllerRevealingV2__c = myMaster.consent_algorithmic.controller.revealing,
                        ControllerScoringV2__c = myMaster.consent_algorithmic.controller.scoring,
                        ControllerSearchingV2__c = myMaster.consent_algorithmic.controller.searching,
                        OwnerEmbeddingV2__c = myMaster.consent_algorithmic.owner.embedding,
                        OwnerParsingV2__c = myMaster.consent_algorithmic.owner.parsing,
                        OwnerReasoningV2__c = myMaster.consent_algorithmic.owner.reasoning, 
                        OwnerRevealingV2__c = myMaster.consent_algorithmic.owner.revealing,
                        OwnerScoringV2__c = myMaster.consent_algorithmic.owner.scoring,
                        OwnerSearchingV2__c = myMaster.consent_algorithmic.owner.searching,
                        Name = 'HrFlow Consent',
                        PartyId = individuals.get(0).Id
                    );
                    try{
                        insert  myCons;   
                    } catch (DMLException e) {
                        if (activateLogs()){
                            String message = e.getDmlMessage(0);
                            logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' consents.\n Details : \n'+message);
                        }
                    }
                    
                } 
            }
            Catch(Exception e){
                
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

        public void newEducation(MasterV2 myMaster, Id ProfileId) { 
            try{
                List<crta__Diploma__c> diplomaList = new List<crta__Diploma__c>();
                for(Education myDiploma : myMaster.educations){
                    if(myDiploma.title !=null && myDiploma.date_start !=null ) {
                        crta__Diploma__c eduqToAdd = new crta__Diploma__c();
                        eduqToAdd.crta__Employee__c = ProfileId;
                        populateEducation(eduqToAdd, myDiploma);
                        diplomaList.add(eduqToAdd);
                    }
                }  
                try{
                    insert diplomaList;  
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' diplomas.\n Details : \n'+message);
                    }
                }
            }
            Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in newEducation method. \n Details : \n'+message);
                }
            }
        }
    
        public void upsertEducation(MasterV2 myMaster, List<crta__Diploma__c> educationDB, Id ProfileId) { 
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
                        // if( myDiploma.date_start !=null ){ //HrFlow data are not null
                        
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
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' educations.\n Details : \n'+message);
                    }
                }
            }
            Catch(Exception e){
                
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
                d.crta__Years__c = String.valueOf(myDiploma.date_end.date().year());
            }
            d.Description__c = myDiploma.description;
            d.crta__School_Name__c = myDiploma.school; // identical when update
            d.Hard_Skill__c = pairsToString(myDiploma.hard_skills);
            d.Soft_Skill__c = pairsToString(myDiploma.soft_skills);
            d.crta__Title__c = myDiploma.title; // identical when update
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

        /*public void upserSkill(MasterV2 myMaster, List<crta__Contact_Skill_Profile_Line__c> myProfileSkills, Id ProfileId) { 
            if(myMaster.skills!=null && myMaster.skills.size()>0) {
                
                // build map of existing skills
                List<crta__Skill__c> skills = [SELECT Name FROM crta__Skill__c];
                Map<String, crta__Skill__c> existingSkills = new Map<String, crta__Skill__c>();
                for(crta__Skill__c aSkill:skills) {
                    existingSkills.put(aSkill.Name, aSkill);
                }

                Id rtSkill = [SELECT Id FROM RecordType WHERE Name = 'Basic' AND SObjectType = 'crta__Skill__c' AND isActive=True LIMIT 1].Id;

                // create list of required new skills and insert them
                List<crta__Skill__c> newSkills = new List<crta__Skill__c>();
                for(Skill aSkill:myMaster.skills) {
                    if(!existingSkills.containsKey(aSkill.name)) {
                        crta__Skill__c newSkill = new crta__Skill__c(
                            crta__Active__c = true,
                            Name = aSkill.name,
                            RecordTypeId = rtSkill,
                            crta__Source__c = 'HrFlow'
                        );
                        newSkills.add(newSkill);
                    }
                }
                insert newSkills;

                // add new skills to map of existing skills
                for(crta__Skill__c skill:newSkills) {
                    existingSkills.put(skill.Name, skill);
                }

                // build map of existing skill lines
                List<crta__Contact_Skill_Profile_Line__c> existingSkillLines = [
                    SELECT crta__Skill__c 
                    FROM crta__Contact_Skill_Profile_Line__c 
                    WHERE crta__Contact__c =: ProfileId];
                Map<Id, crta__Contact_Skill_Profile_Line__c> existingSkillLineMap = new Map<Id, crta__Contact_Skill_Profile_Line__c>();
                for(crta__Contact_Skill_Profile_Line__c existingSkillLine:existingSkillLines) {
                    existingSkillLineMap.put(existingSkillLine.crta__Skill__c, existingSkillLine);
                }

                // create list of new skill lines and insert them
                List<crta__Contact_Skill_Profile_Line__c> newSkillLines = new List<crta__Contact_Skill_Profile_Line__c>();
                for(Skill aSkill:myMaster.skills) {
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
                upsert newSkillLines;
            } 
        }*/

        
        public void upserSkill(MasterV2 myMaster, List<crta__Contact_Skill_Profile_Line__c> myProfileSkills, Id ProfileId) {
            if(myMaster.skills!=null && myMaster.skills.size()>0) {

                // build map of existing skills
                //List<crta__Skill__c> skills = [SELECT Name FROM crta__Skill__c];
                
                Map<String, Skill> MasterSkills = new Map<String, Skill>();
                for(Skill mSkill:myMaster.skills) {
                    MasterSkills.put(mSkill.Name,mSkill);
                }
                List<crta__Skill__c> skills = [SELECT Name FROM crta__Skill__c WHERE Name IN :MasterSkills.keySet()];
                
                Map<String, crta__Skill__c> existingSkills = new Map<String, crta__Skill__c>();
                for(crta__Skill__c aSkill:skills) {
                    existingSkills.put(aSkill.Name, aSkill);
                }

                Id rtSkill = [SELECT Id FROM RecordType WHERE Name = 'Basic' AND SObjectType = 'crta__Skill__c' AND isActive=True LIMIT 1].Id;

                // create list of required new skills and insert them
                List<crta__Skill__c> newSkills = new List<crta__Skill__c>();
                if(skills.size() == 0){
                    for(Skill aSkill : myMaster.skills){
                       crta__Skill__c newSkill = new crta__Skill__c(
                                crta__Active__c = true,
                                Name = aSkill.Name,
                                RecordTypeId = rtSkill,
                                Source__c = 'HrFlow'
                        );
                        newSkills.add(newSkill); 
                    }
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
                }
                catch (DMLException e) {
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
                try{
                   upsert newSkillLines; 
                }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' skills.\n Details : \n'+message);
                    }
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

        public void newExperience(MasterV2 myMaster, Id ProfileId) { 
            try{
            List<Experience__c> experienceList = new List<Experience__c>();
            if(myMaster.experiences !=null){
            for(Experience myExp : myMaster.experiences){
                if(myExp.company !=null && myExp.title !=null && myExp.date_start !=null) {
                    Experience__c expToAdd = new Experience__c();
                    expToAdd.Contact__c = ProfileId;
                    populateExperience(expToAdd, myExp);
                    experienceList.add(expToAdd);
                }
            }
            }
            try{
               insert experienceList; 
            }
            catch (DMLException e) {
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

        public void upsertExperience(MasterV2 myMaster, List<Experience__c> experienceDB, Id ProfileId) { 
            try{
                List<Experience__c> experienceList = new List<Experience__c>();
                Integer i =0;
                if(myMaster.experiences !=null){
                    for(Experience myExp : myMaster.experiences){
                        i=0;
                        for(Experience__c expItemDB:experienceDB){
                            // if( myExp.date_start !=null) {
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
                }
                try{
                    upsert experienceList;
                }
                catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' experiences.\n Details : \n'+message);
                    }
                }
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in upsertExperience method. \n Details : \n'+message);
                }
            }
             
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
                //e.MailingLongitude__c = myExp.location.lng; // To create
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

        public void newApplication(MasterV2 myMaster, Id ProfileId){
            // delete [SELECT Id FROM Attachment__c WHERE Candidature__r.crta__CT_Candidate__c =: ProfileId];
            // delete [SELECT Id FROM crta__Positionnement__c WHERE crta__CT_Candidate__c =: ProfileId]; 
            Id jobOfferId=null;            
            if(!String.isBlank(WebServiceObjectsV2.jobOfferCode)){
                //List<String> myJobOfferParam =WebServiceObjects.jobOfferCode.split('-'); 
                String myOfferId = WebServiceObjectsV2.jobOfferCode.substringAfter('_');
                jobOfferId = Id.valueOf(myOfferId);
            //jobOfferId =[SELECT Id FROM crta__Offre_d_emploi__c WHERE crta__CT_Code__c =: WebServiceObjects.jobOfferCode].Id;
            

             }
            System.debug('Job Offer Id'+jobOfferId);
            Id rtApplication = null;
           /*List<RecordType> RtList;
            if(RtList.size() >0)
            {
			rtApplication= RtList[0].Id;                
            }*/
            List<crta__Positionnement__c> existingPositionnement = [SELECT Id FROM crta__Positionnement__c WHERE  crta__CT_Candidate__c =:ProfileId AND crta__CT_Job__c =:jobOfferId];
            // New positionnement : I create the positionnement only if it doesn't exist for the same Offer and for the same contact
            System.debug('Candidature size '+existingPositionnement.size());
            if(existingPositionnement.size() == 0){
            //Id jobOfferId = [Select Id,crta__CT_Code__c From crta__Offre_d_emploi__c where crta__CT_Code__c]
            crta__Positionnement__c myCandidature = new crta__Positionnement__c(
                crta__CT_Candidate__c = ProfileId,
                crta__CT_Status__c = '10 CV Received',
                crta__CT_Job__c =jobOfferId//,
                
            );
            List<RecordType> RtList= [SELECT Id FROM RecordType WHERE Name = 'External job application' AND SObjectType = 'crta__Positionnement__c' AND isActive=True];
            if(RtList.size()>0){
             rtApplication = RtList[0].Id;   
              myCandidature.put('recordTypeId', rtApplication);
                }
                
            Origin__c origine = Origin__c.getOrgDefaults();
            
            if(origine.Activate__c){
                //String origin = 'AMAJ';
                String origin = WebServiceObjectsV2.origin;
                String soqlQuery = 'SELECT Id FROM crtarecr__Application_Source__c WHERE crtarecr__External_ID__c =\'' + origin + '\'';
                List<sObject> sobjList = Database.query(soqlQuery);
                if(sobjList.size()>0){
                    myCandidature.put('crtarecr__Job_Application_Source__c', sobjList.get(0).Id); 
                }  
            }
            //Beg : Added by Tenhinene 2022-03-25
             ExpernalFieldsParsing__c externalFields = ExpernalFieldsParsing__c.getOrgDefaults();
              
             if(externalFields.Geographical_mobility__c == true){
                 if(!String.isBlank(WebServiceObjectsV2.geographicalMobility)){myCandidature.put('Mobilite_geographique__c', WebServiceObjectsV2.geographicalMobility);}
             }
             if(externalFields.Message__c == true){
                 if(!String.isBlank(WebServiceObjectsV2.message)){myCandidature.put('Message_candidat__c', WebServiceObjectsV2.message);}
             }
            //End : Added by Tenhinene 2022-03-25
                try{
                    insert myCandidature;
                }  catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' candidature.\n Details : \n'+message);
                    }
                }
            
            
            
            
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
                  try{
                      insert attachmentList;
                  }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' attachements.\n Details : \n'+message);
                    }
                }
                  
                  
                  String LastName;
                  String FirstName;
                  Contact con= [select id, LastName,FirstName from Contact where Id=: myCandidature.crta__CT_Candidate__c LIMIT 1 ];
                  LastName=con.LastName;
                  FirstName=con.FirstName;
                  Datetime UTC = System.now(); 
                  Organization orgDetails = [SELECT Id, TimeZoneSidKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()]; 
                  String orgTime = UTC.format('yyyy-MM-dd HH:mm:ss', orgDetails.TimeZoneSidKey); 
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
                        //DownloadCV2.downloadCV(a.Public_url__c, a.Candidature__c, pathOnClient, title);
                        //Start : AMO 21/04/2022 : Added to manage CV migration
                          If(WebServiceObjectsV2.origin=='STOCK'){ //=> STOCK ça veut dire pour si on doit faire une reprise de données. 
                              DownloadCV2.downloadCV(a.Public_url__c, ProfileId, pathOnClient, title);
                              /*system.debug(' ONE');
                              delete attachmentList;
                              system.debug(' TWO');
                              delete myCandidature; 
                              system.debug(' THREE');*/
                          }else{
                              DownloadCV2.downloadCV(a.Public_url__c, a.Candidature__c, pathOnClient, title);
                          }
                          //End : AMO 21/04/2022
                        
                    }
                    a.Name='CV'+LastName+FirstName+orgTime;
                }
                  try{
                      update attachmentList; 
                  }catch (DMLException e) {
                    if (activateLogs()){
                        String message = e.getDmlMessage(0);
                        logMessage('Web service failed', 'Error when upserting '+e.getNumDml()+' attachements.\n Details : \n'+message);
                    }
                }
                 
                  If(WebServiceObjectsV2.origin=='STOCK'){
                      try{
                          delete attachmentList;
                          delete myCandidature; 
                      }catch (DMLException e) {
                          if (activateLogs()){
                              String message = e.getDmlMessage(0);
                              logMessage('Web service failed', 'Error when deleting '+e.getNumDml()+' attachements & candidatures.\n Details : \n'+message);
                          }
                      }
                      
                  }
                  
                  
            } //end attachment not null
         } //end : existingPositionnement == null 
        }
    }

    //Abdelkader Morjan,  05/08/2021 :Class created to retrieve the job offers
    public class JobOffers{
        public  List<crta__Offre_d_emploi__c> getJobOffers()
        {
            List<crta__Offre_d_emploi__c> jobOffersList;
            try{
                
            
             crta__HrFlow_JobOffers__c crtiteriaConf = crta__HrFlow_JobOffers__c.getOrgDefaults(); // A Modifier lors de la répércuption dans CRTA
             String crtiteriaValue = crtiteriaConf.crta__Offer_Criteria__c;
            List<String> fieldString = getSObjectFieldNames('crta__Offre_d_emploi__c');
            String fieldList = String.join(fieldString, ',');
            String soqlQuery = 'SELECT '
                + fieldList + ' '
                + 'FROM crta__Offre_d_emploi__c ';
                //+ 'WHERE LastModifiedDate >=: fromDate AND LastModifiedDate <=: toDate';   
              if(crtiteriaValue != null)
            {
                soqlQuery  +=  ' WHERE '+crtiteriaValue+' = TRUE ';
            }   
                system.debug('query Job Offer ::'+crtiteriaValue);
            jobOffersList = Database.query(soqlQuery);
            }Catch(Exception e){
                
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed','Error in getJobOffers method. \n Details : \n'+message);
                }
            }
            return jobOffersList;
        }

        private List<String> getSObjectFieldNames(final String sObjectName) {
            return new List<String>(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keySet());
        }

    }


}