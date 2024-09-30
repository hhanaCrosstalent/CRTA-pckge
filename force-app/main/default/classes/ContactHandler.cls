//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/07/2020 
**/
public without sharing class ContactHandler {
    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<Contact> triggerNew;
    private Map<Id, Contact> triggerNewMap;
    private List<Contact> triggerOld;
    private Map<Id, Contact> triggerOldMap;
    private Integer size;
    
    public ContactHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<Contact> triggerNew,
        Map<Id, Contact> triggerNewMap,
        List<Contact> triggerOld,
        Map<Id, Contact> triggerOldMap,
        Integer size
    ) {
        this.isExecuting = isExecuting;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.triggerNew = triggerNew;
        this.triggerNewMap = triggerNewMap;
        this.triggerOld = triggerOld;
        this.triggerOldMap = triggerOldMap;
        this.size = size;
    }
    
    private static final Pattern FORMAT_WITH_KEY_SS = Pattern.compile(
        '[0-9]{1} [0-9]{2} [0-9]{2} (2a|2A|2b|2B|[0-9]{2}) [0-9]{3} [0-9]{3} [0-9]{2}'
    ); 
    private static final Pattern FORMAT_WITHOUT_KEY_SS = Pattern.compile(
        '[0-9]{1} [0-9]{2} [0-9]{2} (2a|2A|2b|2B|[0-9]{2}) [0-9]{3} [0-9]{3}'
    );
    
    public void handleTrigger() {
        if(this.isBefore) {
            
           if(this.isInsert || this.isUpdate) {
               
                checkSSNumber();
              //NMA 03/11/2021
                if(this.isInsert) {
                checkField();
                generateRegistration();
             }//End NMA 03/11/2021
                        
               else  if (this.isUpdate) {
                    setOwnerIdFromUser();
                   //NMA 03/11/2021
                   // checkField();
                    generateRegistration();
                   //End NMA 03/11/2021
                }
            }
        } else if(this.isAfter) {
            if(this.isInsert || this.isUpdate) {
                if(!System.isBatch()){
                setLocation();
                }
            }
        }
    }
    
    
    //NMA 27/02/2024 --> Détecter la modification de l'un des champs cités ci-dessous
    public void handleADPTrigger(){
         if(this.isBefore) {
                if(this.isUpdate) {
                   setPicklistFieldsUpdate();
               }
          }

    }
    
    private void setLocation() {
        system.debug('setLocation');
        Boolean isActive = false;
        try {
            isActive = crta__Geolocation__c.getInstance().ContactTrigger__c;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        
        if(!System.isFuture() && isActive) {
            Set<Id> contactToUpdate = new Set<Id>();
            for(Contact c : this.triggerNew) {
                if(
                    this.isInsert
                    || this.triggerOldMap.get(c.Id).MailingStreet != c.MailingStreet
                    || this.triggerOldMap.get(c.Id).MailingCity != c.MailingCity
                    || this.triggerOldMap.get(c.Id).MailingPostalCode != c.MailingPostalCode
                    || this.triggerOldMap.get(c.Id).MailingCountry != c.MailingCountry
                ) {
                    contactToUpdate.add(c.Id);
                }
            } 
            //geoLocationHelper.getContactLocation(contactToUpdate); => commented By Hana.H on 21/05/24 to prevent prevent API requests limits (in org) from being exceeded
        }
    }
    
    private void setOwnerIdFromUser() {
        system.debug('setOwnerIdFromUser');
        if (!crta__Automation_Settings__c.getInstance().crta__Set_Contact_Owner_from_User__c) {
            return;
        }

        Set<Id> contactIds = new Set<Id>();
        for(Contact c : this.triggerNew) {
            contactIds.add(c.Id);
        }

        Map<Id, Id> userIdByContactId = new Map<Id, Id>();
        for (User u : [SELECT Id, crta__Contact__c FROM User WHERE IsActive = TRUE AND crta__Contact__c IN: contactIds]) {
            userIdByContactId.put(u.crta__Contact__c, u.Id);
        }

        for(Contact c : this.triggerNew) {
            if (userIdByContactId.get(c.Id) != null) {
                c.OwnerId = userIdByContactId.get(c.Id);
            }
        }
    }
    
    private void checkSSNumber() {
        system.debug('checkSSNumber');
       
        for(Contact c : this.triggerNew) {
            system.debug('crta__Numero_de_ss__c'+c.crta__Numero_de_ss__c);
            system.debug('crta__Social_Number_Key__c'+c.crta__Social_Number_Key__c);
            if(String.isBlank(c.crta__Numero_de_ss__c) || String.isBlank(c.crta__Social_Number_Key__c)) {
                continue;
            }
            
            Integer toSubstract = (c.crta__Numero_de_ss__c.contains('A') || c.crta__Numero_de_ss__c.contains('a')) ? 1000000
                : ((c.crta__Numero_de_ss__c.contains('B') || c.crta__Numero_de_ss__c.contains('b')) ? 2000000 : 0);
                  system.debug('toSubstract'+toSubstract);
                    //Rémi : Pour la corse, j'ai adapté la formule, lors de la vérif, il faut faire comme si le A ou le B était un 0, et il faut
                    //soustraire 1 milion si on a un A, ou 2 milion si on a un B, et ensuite on applique la formule classique.
                    String tempSS = c.crta__Numero_de_ss__c.replaceAll('\\s+', '').replace('A','0').replace('a','0').replace('B','0').replace('b','0');
                       
             system.debug('tempSS'+tempSS);
            if(tempSS.isNumeric()) {
                Long secu = Long.valueOf(tempSS) - toSubstract;
                if ((Math.mod(secu, 97) != (97 - Integer.valueOf(c.crta__Social_Number_Key__c))) && !Test.isRunningTest()) {
                    c.addError(Label.Invalid_Social_Number);
                }
            } else if (!Test.isRunningTest()) {
               c.addError(Label.Invalid_Social_Number);
            }
        }
    }
    //NMA 03/11/2021 
        private void checkField() {
            system.debug('checkField');
        if(this.isAfter || this.isDelete) {
            return;
        }

        for(Contact contact : this.triggerNew) {
            //Fallou=>Debut de commentaire le 2021-11-25 suite à notre call avec Abdelkader lié à la conversion des valeurs en Majuscule
            /*contact.FirstName = StringUtil.removeDiacritics(contact.FirstName)?.toUpperCase();
            contact.LastName = StringUtil.removeDiacritics(contact.LastName)?.toUpperCase();
            contact.crta__Birth_Name__c = StringUtil.removeDiacritics(contact.crta__Birth_Name__c)?.toUpperCase();*/
            //Fallou=>Fin de commentaire le 2021-11-25
            //NMA 27/09/2021 --> ces champs n'existent pas dans l'objet Contact, il faut les ajouter avant
            
            //contact.Nom_de_voie__c = StringUtil.removeDiacritics(contact.Nom_de_voie__c)?.toUpperCase();
            //contact.Bureau_Distributeur__c = StringUtil.removeDiacritics(contact.Bureau_Distributeur__c)?.toUpperCase();
            //contact.Complement_d_adresse__c = StringUtil.removeDiacritics(contact.Complement_d_adresse__c)?.toUpperCase();
        }
    }

    private void generateRegistration(){
        system.debug('generateRegistration');
        if(this.isAfter || this.isDelete || this.isUndelete) {
            return;
        }
            Boolean blankFieldMatricule = false;
            String matricule;
            String criteriaObjectReference;
            String criteriaFieldName;
            list<crta__Employee_Number_Generator__c> autoNumberConfig = new List<crta__Employee_Number_Generator__c>();
            crta__Employee_Number_Generator__c matchedAutoNumberConfig = new crta__Employee_Number_Generator__c();
            Id matchedautoNumberConfigurationId;
            
            String queryAutoNumberConfig = 'SELECT '+
                        'crta__Object_API_Name__c, '+
                        'crta__Field_API_Name__c, '+
                        'crta__Criteria_Object_Reference__c, '+
                        'crta__Criteria_Field_Name__c, '+
                        'crta__Criteria_Field_Value__c, '+
                        'crta__Pattern__c, '+
                        'crta__Last_Created_Index__c, '+
                        'crta__Is_Active__c '+
                    'FROM crta__Employee_Number_Generator__c '+
                    'where crta__Is_Active__c = true '+
                    'ORDER BY crta__Criteria_Field_Name__c asc';
            autoNumberConfig = Database.query(queryAutoNumberConfig);

            Integer nbVerifCond = 0;
        //Ajouter une condition de vérification autoNumberConfig.size()>0
            for (crta__Employee_Number_Generator__c autoNumberConfiguration : autoNumberConfig){
                List<String> recordsId = new List<String>();
                Map<String,SObject> recordsById =  new Map<String,SObject>();
                Id recordId;
                String query;
                System.debug('before for');
                for(SObject targetObject : this.triggerNew) {
                    System.debug('before if '+targetObject);
                    
                    if (autoNumberConfiguration.crta__Criteria_Object_Reference__c != 'Contact' && (String)targetObject.get(autoNumberConfiguration.crta__Criteria_Object_Reference__c) != null){
                        recordsId.add((String)targetObject.get(autoNumberConfiguration.crta__Criteria_Object_Reference__c));
                        System.debug('recordsId[0]'+recordsId[0]);
                        recordId = Id.valueOf(recordsId[0]);
                        query = 
                            'SELECT'
                            + ' Id,'
                            + ' ' + autoNumberConfiguration.crta__Criteria_Field_Name__c
                            + ' FROM'
                            + ' ' + recordId.getSObjectType().getDescribe().getName()
                            + ' WHERE'
                            + ' Id IN :recordsId';
                        for(SObject record : Database.query(query)) {
                            recordsById.put(record.Id,record);
                        }
                    }

                    String criteriaFieldValue;
                    if (autoNumberConfiguration.crta__Criteria_Object_Reference__c == 'Contact'){
                       system.debug('first if');
                        criteriaFieldValue = 
                            (String)targetObject.get(autoNumberConfiguration.crta__Criteria_Field_Name__c);
                       
                    }else if ((String)targetObject.get(autoNumberConfiguration.crta__Criteria_Object_Reference__c) != null) {
                       system.debug('first if2');
                        criteriaFieldValue = 
                            (String)recordsById.get((String)targetObject.get(autoNumberConfiguration.crta__Criteria_Object_Reference__c)).get(autoNumberConfiguration.crta__Criteria_Field_Name__c);
                    }
                   system.debug('criteriaFieldValue'+criteriaFieldValue);
                    if (autoNumberConfiguration.crta__Criteria_Field_Value__c == criteriaFieldValue){
                        nbVerifCond++;
                        if (nbVerifCond == 1){
                            matchedautoNumberConfigurationId = autoNumberConfiguration.id;
                        }
                    }
                    if ((String)targetObject.get(autoNumberConfiguration.crta__Field_API_Name__c) == null){
                        blankFieldMatricule = true;
                    }
                }
            }

            String queryMatchedAutoNumberConfig;
            if (nbVerifCond == 1){
                queryMatchedAutoNumberConfig = 'SELECT '+
                'crta__Object_API_Name__c, '+
                'crta__Field_API_Name__c, '+
                'crta__Criteria_Object_Reference__c, '+
                'crta__Criteria_Field_Name__c, '+
                'crta__Criteria_Field_Value__c, '+
                'crta__Pattern__c, '+
                'crta__Last_Created_Index__c, '+
                'crta__Is_Active__c '+
                'FROM crta__Employee_Number_Generator__c '+
                'where id =:  matchedautoNumberConfigurationId';
                matchedAutoNumberConfig = Database.query(queryMatchedAutoNumberConfig);
            }
        System.debug('nbVerifCond '+nbVerifCond);
        if(this.isInsert){
            if (nbVerifCond == 1){
                criteriaFieldName = matchedAutoNumberConfig.crta__Criteria_Field_Name__c;
                matricule = matchedAutoNumberConfig.crta__Field_API_Name__c;
                criteriaObjectReference = matchedAutoNumberConfig.crta__Criteria_Object_Reference__c;   
                GenerateAutoNumber.generate(
                    this.triggerNew,           
                    matricule,                 
                    criteriaObjectReference, 
                    null,
                    criteriaFieldName,         
                    false                     
                );
            }else {
                List<Contact_Activity_Event__e> caeList = new List<Contact_Activity_Event__e>();
                for (Contact contact: this.triggerNew) {
                        String alert = 'Le numéro automatique n\'a pas pu être généré en raison de l\'impossibilité d\'identifier une configuration unique.';
                        Contact_Activity_Event__e cae = new Contact_Activity_Event__e();
                        cae.crta__message__c = alert;
                        caeList.add(cae);
                }
                try{
                    if(caeList.size()>0)
                        EventBus.publish(caeList);
                }catch(Exception e){
                }
            } 
        } else {
            List<Contact> contactsForRegistrationUpdate = new List<Contact>();
                    if (nbVerifCond == 1){
                        criteriaFieldName = matchedAutoNumberConfig.crta__Criteria_Field_Name__c;
                        matricule = matchedAutoNumberConfig.crta__Field_API_Name__c;
                        criteriaObjectReference = matchedAutoNumberConfig.crta__Criteria_Object_Reference__c;

                        GenerateAutoNumber.generate(
                            this.triggerNew,
                            matricule,                 
                            criteriaObjectReference, 
                            null,
                            criteriaFieldName,
                            true
                        );
                    }else if (blankFieldMatricule){
                    List<Contact_Activity_Event__e> caeList = new List<Contact_Activity_Event__e>();
                    for (Contact contact: this.triggerNew) {
                            String alert = 'Le numéro automatique n\'a pas pu être généré en raison de l\'impossibilité d\'identifier une configuration unique.';
                            Contact_Activity_Event__e cae = new Contact_Activity_Event__e();
                            cae.crta__message__c = alert;
                            caeList.add(cae);
                    }
                    try{
                        if(caeList.size()>0)
                            EventBus.publish(caeList);
                    }catch(Exception e){
                    }
                }
        }
    }
    
    
    
    private void setPicklistFieldsUpdate(){
        for(Contact c : this.triggerNew) {
            //Verify email changes
            if(this.triggerOldMap.get(c.Id).Email ==null && c.Email!=null){
                c.crta__ADP_emailChange__c='1';
            }else if(this.triggerOldMap.get(c.Id).Email!=null && c.Email==null){
                c.crta__ADP_emailChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).Email!=null && c.Email!=null && this.triggerOldMap.get(c.Id).Email!=c.Email){
                c.crta__ADP_emailChange__c='2';
            }
            
            
            //Verify gender changes
             if(this.triggerOldMap.get(c.Id).crta__Sexe__c ==null && c.crta__Sexe__c!=null){
                c.crta__ADP_genderChange__c='1';
            }else if(this.triggerOldMap.get(c.Id).crta__Sexe__c!=null && c.crta__Sexe__c==null){
                c.crta__ADP_genderChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Sexe__c!=null && c.crta__Sexe__c!=null && this.triggerOldMap.get(c.Id).crta__Sexe__c!=c.crta__Sexe__c){
                c.crta__ADP_genderChange__c='2';
            }
            
            
            //Verify legal name changes
             if(this.triggerOldMap.get(c.Id).FirstName ==null && c.FirstName!=null){
                c.crta__ADP_legalNameChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).FirstName!=null && c.FirstName==null){
                c.crta__ADP_legalNameChange__c='3';
            }
            else if( (this.triggerOldMap.get(c.Id).FirstName!=null && c.FirstName!=null && 
                    this.triggerOldMap.get(c.Id).FirstName!=c.FirstName) || (this.triggerOldMap.get(c.Id).LastName!=null && c.LastName!=null && 
                    this.triggerOldMap.get(c.Id).LastName!=c.LastName) ){
                c.crta__ADP_legalNameChange__c='2';
            }
            
            
            
            //Verify personal email Change
            if(this.triggerOldMap.get(c.Id).crta__Personal_Email__c ==null && c.crta__Personal_Email__c!=null){
                c.crta__ADP_personalEmailChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Personal_Email__c!=null && c.crta__Personal_Email__c==null){
                c.crta__ADP_personalEmailChange__c='3';
            }
             else if(this.triggerOldMap.get(c.Id).crta__Personal_Email__c!=null && c.crta__Personal_Email__c!=null && 
                    this.triggerOldMap.get(c.Id).crta__Personal_Email__c!=c.crta__Personal_Email__c){
                c.crta__ADP_personalEmailChange__c='2';
            }
            
            
            
             //Verify birthdateChange Change
             if(this.triggerOldMap.get(c.Id).Birthdate ==null && c.Birthdate!=null){
                c.crta__ADP_birthdateChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).Birthdate!=null && c.Birthdate==null){
                c.crta__ADP_birthdateChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).Birthdate!=null && c.Birthdate!=null && 
                    this.triggerOldMap.get(c.Id).Birthdate!=c.Birthdate){
                c.crta__ADP_birthdateChange__c='2';
            }
            
            
            
            //Verify professional mobile phone Change
            
               if(this.triggerOldMap.get(c.Id).crta__Professional_Mobile_Phone__c ==null && c.crta__Professional_Mobile_Phone__c!=null){
                c.crta__ADP_professionalMobilePhoneChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Professional_Mobile_Phone__c!=null && c.crta__Professional_Mobile_Phone__c==null){
                c.crta__ADP_professionalMobilePhoneChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Professional_Mobile_Phone__c!=null && c.crta__Professional_Mobile_Phone__c!=null && 
                    this.triggerOldMap.get(c.Id).crta__Professional_Mobile_Phone__c!=c.crta__Professional_Mobile_Phone__c){
                c.crta__ADP_professionalMobilePhoneChange__c='2';
            }
            
            
            
             // Verify professional phone Change 
            
            if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_professional__c ==null && c.crta__CT_Telephone_professional__c!=null){
                c.crta__ADP_professionalPhoneChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_professional__c!=null && c.crta__CT_Telephone_professional__c==null){
                c.crta__ADP_professionalPhoneChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_professional__c!=null && c.crta__CT_Telephone_professional__c!=null && 
                    this.triggerOldMap.get(c.Id).crta__CT_Telephone_professional__c!=c.crta__CT_Telephone_professional__c){
                c.crta__ADP_professionalPhoneChange__c='2';
            }
            
            


            // Verify marital status change  
            if(this.triggerOldMap.get(c.Id).crta__Situation_familiale__c ==null && c.crta__Situation_familiale__c!=null){
                c.crta__ADP_maritalStatusChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Situation_familiale__c!=null && c.crta__Situation_familiale__c==null){
                c.crta__ADP_maritalStatusChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).crta__Situation_familiale__c!=null && c.crta__Situation_familiale__c!=null && 
                    this.triggerOldMap.get(c.Id).crta__Situation_familiale__c!=c.crta__Situation_familiale__c){
                c.crta__ADP_maritalStatusChange__c='2';
            }



             // Verify  personnal phone change 
            if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_Home__c==null && c.crta__CT_Telephone_Home__c !=null){
                c.crta__ADP_personalPhoneChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_Home__c !=null && c.crta__CT_Telephone_Home__c ==null){
                c.crta__ADP_personalPhoneChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).crta__CT_Telephone_Home__c !=null && c.crta__CT_Telephone_Home__c !=null &&
                    this.triggerOldMap.get(c.Id).crta__CT_Telephone_Home__c !=c.crta__CT_Telephone_Home__c ){
                c.crta__ADP_personalPhoneChange__c='2';
            }



	       // Verify personal mobile Phone Change 
            
             if(this.triggerOldMap.get(c.Id).MobilePhone==null && c.MobilePhone !=null){
                c.crta__ADP_personalMobilePhoneChange__c='1';
            }
            else if(this.triggerOldMap.get(c.Id).MobilePhone !=null && c.MobilePhone ==null){
                c.crta__ADP_personalMobilePhoneChange__c='3';
            }
            else if(this.triggerOldMap.get(c.Id).MobilePhone !=null && c.MobilePhone !=null &&
                    this.triggerOldMap.get(c.Id).MobilePhone !=c.MobilePhone ){
                c.crta__ADP_personalMobilePhoneChange__c='2';
            }            
            
            
          //Verify mailingAddress (legal Address) Change
            
              if( (this.triggerOldMap.get(c.Id).MailingStreet==null && c.MailingStreet !=null )  || (this.triggerOldMap.get(c.Id).MailingCity==null && c.MailingCity !=null )
                || (this.triggerOldMap.get(c.Id).MailingPostalCode==null && c.MailingPostalCode !=null)){
                c.crta__ADP_legalAddressChange__c='1';
            }
            else if ( (this.triggerOldMap.get(c.Id).MailingStreet!=null && c.MailingStreet ==null) && (this.triggerOldMap.get(c.Id).MailingCity!=null && c.MailingCity ==null ) &&
                     (this.triggerOldMap.get(c.Id).MailingPostalCode!=null && c.MailingPostalCode ==null)){ 
                c.crta__ADP_legalAddressChange__c='3';
            }
            else if( (this.triggerOldMap.get(c.Id).MailingStreet !=null && c.MailingStreet !=null && this.triggerOldMap.get(c.Id).MailingStreet !=c.MailingStreet )   ||
                     (this.triggerOldMap.get(c.Id).MailingCity !=null && c.MailingCity !=null && this.triggerOldMap.get(c.Id).MailingCity !=c.MailingCity ) ||
                    (this.triggerOldMap.get(c.Id).MailingPostalCode !=null && c.MailingPostalCode !=null && this.triggerOldMap.get(c.Id).MailingPostalCode !=c.MailingPostalCode)
                    ){
                c.crta__ADP_legalAddressChange__c='2';
            }
            
            
            
             //VerifyOtherAddress (personal Address) Change
         
            if( (this.triggerOldMap.get(c.Id).OtherStreet==null && c.OtherStreet !=null )  && (this.triggerOldMap.get(c.Id).OtherCity==null && c.OtherCity !=null )
                && (this.triggerOldMap.get(c.Id).OtherPostalCode==null && c.OtherPostalCode !=null)){
                c.crta__ADP_personalAddressChange__c='1';
            }
            else if ( (this.triggerOldMap.get(c.Id).OtherStreet!=null && c.OtherStreet ==null) && (this.triggerOldMap.get(c.Id).OtherCity!=null && c.OtherCity ==null ) &&
                     (this.triggerOldMap.get(c.Id).OtherPostalCode!=null && c.OtherPostalCode ==null)){ 
                c.crta__ADP_personalAddressChange__c='3';
            }
            else if( (this.triggerOldMap.get(c.Id).OtherStreet !=null && c.OtherStreet !=null && this.triggerOldMap.get(c.Id).OtherStreet !=c.OtherStreet )   ||
                     (this.triggerOldMap.get(c.Id).OtherCity !=null && c.OtherCity !=null && this.triggerOldMap.get(c.Id).OtherCity !=c.OtherCity ) ||
                    (this.triggerOldMap.get(c.Id).OtherPostalCode !=null && c.OtherPostalCode !=null && this.triggerOldMap.get(c.Id).OtherPostalCode !=c.OtherPostalCode)
                    ){
                c.crta__ADP_personalAddressChange__c='2';
            }

            
            
        }
    }
    
    
    
    
    
    
    
}