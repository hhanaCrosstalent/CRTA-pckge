//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 08/01/2019 
*** @Modified by : MBAYE Fallou
*** @Last Modified Date : 27/10/2021
*** added the possibility to deactivate metadata
**/
public without sharing class ProfileController {
    public class FieldWrapper implements Comparable {
        @AuraEnabled 
        public String apiName {get; set;}
        @AuraEnabled
        public String fieldType {get; set;}
        @AuraEnabled
        public Object fieldValue {get; set;}
        @AuraEnabled
        public Boolean required {get; set;}
        @AuraEnabled
        public String idValue {get; set;}
        @AuraEnabled
        public String fieldHelpText {get; set;}
        @AuraEnabled
        public Object newValue {get; set;}
        @AuraEnabled
        public String fieldLabel {get; set;}
        @AuraEnabled
        public Boolean isPrivate {get; set;}
        @AuraEnabled
        public Boolean isManager {get; set;}
        @AuraEnabled
        public Boolean allowAttachment {get; set;}
        @AuraEnabled
        public Boolean attachmentRequired {get; set;}
        @AuraEnabled
        public String picklistLabel {get; set;}
        @AuraEnabled
        public Map<String, String> pickListValues {get; set;}
        @AuraEnabled
        public String columnSize {get;set;}
        @AuraEnabled
        public Integer order {get;set;}
        
        public FieldWrapper(
            String apiName, String fieldType, Object fieldValue, Boolean required, String idValue, String fieldHelpText, String picklistLabel, String fieldLabel,
            Boolean isPrivate, Boolean isManager, Boolean allowAttachment, Boolean attachmentRequired, Map<String, String> pickListValues, String columnSize,
            Decimal order
        ) {
            this.apiName = apiName;
            this.fieldType = fieldType;
            this.fieldValue = fieldValue;
            this.required = required;
            this.idValue = idValue;
            this.fieldHelpText = fieldHelpText;
            this.picklistLabel = picklistLabel;
            this.newValue = null;
            this.fieldLabel = fieldLabel;
            this.isPrivate = isPrivate;
            this.isManager = isManager;
            this.allowAttachment = allowAttachment;
            this.attachmentRequired = attachmentRequired;
            this.pickListValues = pickListValues;
            this.columnSize = columnSize;
            this.order = Integer.valueOf(order);
        }
        
        public Integer compareTo(Object o) {
            FieldWrapper to = (FieldWrapper)o;
            
            if (order == null || order > to.order) {
                return 1;
            } else if (order < to.order) {
                return -1;
            }
            return 0;
        }
    }
    
    public class FieldGroupWrapper {
        @AuraEnabled
        public String uniqueName {get; set;}
        @AuraEnabled
        public String fieldPermission {get; set;}
        @AuraEnabled
        public String fieldPermissionLabel {get; set;}
        @AuraEnabled
        public String modificationFieldPermission {get; set;}
        @AuraEnabled
        public String modificationFieldPermissionLabel {get; set;}
        @AuraEnabled
        public String managerModificationFieldPermission {get; set;}
        @AuraEnabled
        public String managerModificationFieldPermissionLabel {get; set;}
        @AuraEnabled
        public String fieldFormat {get; set;}
        @AuraEnabled
        public List<FieldWrapper> fieldsList {get; set;}
        
        public FieldGroupWrapper(String uniqueName, String fieldPermission, String fieldPermissionLabel, String modificationFieldPermission, String modificationFieldPermissionLabel, String managerModificationFieldPermission, String managerModificationFieldPermissionLabel, String fieldFormat, List<FieldWrapper> fieldsList ) {
                        this.uniqueName = uniqueName;
                        this.fieldPermission = fieldPermission;
                        this.fieldPermissionLabel = fieldPermissionLabel;
                        this.modificationFieldPermission = modificationFieldPermission;
                        this.modificationFieldPermissionLabel = modificationFieldPermissionLabel;
                        this.managerModificationFieldPermission = managerModificationFieldPermission;
                        this.managerModificationFieldPermissionLabel = managerModificationFieldPermissionLabel;
                        this.fieldFormat = fieldFormat;
                        this.fieldsList = fieldsList;
                        this.fieldsList.sort();
                    }
    }
    
    public class RelatedFieldWrapper implements Comparable {
        @AuraEnabled 
        public String apiName {get; set;}
        @AuraEnabled
        public Boolean isPrivate {get; set;}
        @AuraEnabled
        public Boolean isManager {get; set;}
        @AuraEnabled
        public Boolean isRequired {get; set;}
        @AuraEnabled
        public Boolean isToShowMobile {get; set;}
        @AuraEnabled
        public Boolean hasHelpText {get; set;}
        @AuraEnabled
        public String fieldPermission {get; set;}
        @AuraEnabled
        public Integer order {get; set;}
        
        public RelatedFieldWrapper(
            String apiName, Boolean isPrivate, Boolean isManager, Boolean isRequired,Boolean isToShowMobile, Boolean hasHelpText, String fieldPermission, Decimal order
        ) {
            this.apiName = apiName;
            this.isPrivate = isPrivate;
            this.isManager = isManager;
            this.isRequired = isRequired; 
            this.isToShowMobile=isToShowMobile;
            this.hasHelpText = hasHelpText;
            this.fieldPermission = fieldPermission;
            this.order = Integer.valueOf(order);
        }
        
        public Integer compareTo(Object o) {
            RelatedFieldWrapper to = (RelatedFieldWrapper)o;
            
            if (order == null || order > to.order) {
                return 1;
            } else if (order < to.order) {
                return -1;
            }
            return 0;
        }
    }
    
    public class RelatedListWrapper  {
        @AuraEnabled 
        public String objectApiName {get; set;}
        @AuraEnabled
        public String referenceField {get; set;}
        @AuraEnabled
        public List<RelatedFieldWrapper> fields {get; set;}
        @AuraEnabled
        public Boolean isPrivate {get; set;}
        @AuraEnabled
        public Boolean isManager {get; set;}
        @AuraEnabled
        public String title {get; set;}
        @AuraEnabled
        public String icon {get; set;}
        @AuraEnabled
        public Boolean allowEdit {get; set;}
        @AuraEnabled
        public Boolean allowAdd {get; set;}
        @AuraEnabled
        public Boolean allowDelete {get; set;}
        @AuraEnabled
        public Boolean allowEditManager {get; set;}
        @AuraEnabled
        public Boolean allowAddManager {get; set;}
        @AuraEnabled
        public Boolean allowDeleteManager {get; set;}
        @AuraEnabled
        public Boolean allowFiles {get; set;}
        @AuraEnabled
        public Boolean attachmentRequired {get; set;}
        @AuraEnabled
        public String attachmentRequiredField {get; set;}
        @AuraEnabled
        public String conditionalField {get; set;}
        @AuraEnabled
        public Boolean isDisplayed {get; set;}
        @AuraEnabled
        public Boolean required {get; set;}
        @AuraEnabled
        public String sortingClause {get; set;}
        @AuraEnabled
        public String filteringCriteria {get; set;}
        @AuraEnabled
        public String recordType {get; set;}
        
        public RelatedListWrapper(
            String objectApiName, String referenceField, List<RelatedFieldWrapper> fields, Boolean isPrivate, 
            Boolean isManager, String title, String icon, Boolean allowAdd, Boolean allowEdit, Boolean allowDelete,
            Boolean allowAddManager, Boolean allowEditManager, Boolean allowDeleteManager, Boolean allowFiles, Boolean attachmentRequired, String attachmentRequiredField, String conditionalField, Boolean isDisplayed, Boolean required, String sortingClause, String filteringCriteria, String recordType) {
                
                this.objectApiName = objectApiName;
                this.referenceField = referenceField;
                this.fields = fields;
                this.fields.sort();
                this.isPrivate = isPrivate;
                this.isManager = isManager;
                this.title = title;
                this.icon = icon;
                this.allowAdd = allowAdd;
                this.allowEdit = allowEdit;
                this.allowDelete = allowDelete;
                this.allowAddManager = allowAddManager;
                this.allowEditManager = allowEditManager;
                this.allowDeleteManager = allowDeleteManager;
                this.allowFiles = allowFiles;
                this.attachmentRequired = attachmentRequired;
                this.attachmentRequiredField = attachmentRequiredField;
                this.conditionalField = conditionalField;
                this.isDisplayed = isDisplayed;
                this.required = required;
                this.sortingClause = sortingClause;
                this.filteringCriteria = filteringCriteria;
                this.recordType = recordType;
            }
    }
    
    public class SectionWrapper {
        @AuraEnabled 
        public String title {get; set;}
        @AuraEnabled 
        public String tabId {get; set;}
        @AuraEnabled
        public List<FieldGroupWrapper> fieldGroupsList {get; set;}
        @AuraEnabled 
        public String icon {get; set;}
        @AuraEnabled 
        public String customIcon {get; set;}
        @AuraEnabled
        public Boolean isPrivate {get; set;}
        @AuraEnabled
        public Boolean isManager {get; set;}
        @AuraEnabled
        public String conditionalField {get; set;}
        @AuraEnabled
        public String color {get; set;}
        @AuraEnabled
        public Boolean isDisplayed {get; set;}
        
        public SectionWrapper(String title, String tabId, String icon, String customIcon, Boolean isPrivate, Boolean isManager, String conditionalField, String color, Boolean isDisplayed, List<FieldGroupWrapper> fieldGroupsList) {
            this.title = title;
            this.tabId = tabId;
            this.icon = icon;
            this.customIcon = customIcon;
            this.isPrivate = isPrivate;
            this.isManager = isManager;
            this.color = color;
            this.isDisplayed = isDisplayed;
            this.conditionalField = conditionalField;
            this.fieldGroupsList = fieldGroupsList;
        }
    }
    
    public class TabWrapper {
        @AuraEnabled 
        public String id {get; set;}
        @AuraEnabled 
        public String title {get; set;}
        @AuraEnabled
        public List<RelatedListWrapper> relatedLists {get; set;}
        @AuraEnabled 
        public String icon {get; set;}
        @AuraEnabled 
        public String customIcon {get; set;}
        @AuraEnabled
        public Boolean isPrivate {get; set;}
        @AuraEnabled
        public Boolean isManager {get; set;}
        @AuraEnabled
        public String conditionalField {get; set;}
        @AuraEnabled
        public Boolean isDisplayed {get; set;}
        
        public TabWrapper(String id, String title, String icon, String customIcon, Boolean isPrivate, Boolean isManager,
         String conditionalField, Boolean isDisplayed, List<RelatedListWrapper> relatedLists) {
                this.id = id;
                this.title = title;
                this.icon = icon;
                this.customIcon = customIcon;
                this.isPrivate = isPrivate;
                this.isManager = isManager;
                this.conditionalField = conditionalField;
                this.isDisplayed = isDisplayed;
                this.relatedLists = relatedLists;
            }
    }
    
    private static Map<String, Map<String, String>> getTranslationsCrtl() {
        Map<String, Map<String, String>> labelsMap = new Map<String, Map<String, String>>();
        labelsMap.put('Contact', PortalUtility.getTranslationMap(Contact.SObjectType));
        return labelsMap;
    }
    
    @AuraEnabled
    public static String createEditRequestCtrl(List<SObject> soList, List<String> fieldType, String contactId, List<String> contentDocumentIds) {
        if (
            Schema.sObjectType.Demande_de_modification__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.crta__New_Value__c.isCreateable()
            && Schema.sObjectType.ContentDocumentLink.isCreateable()
            && Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()
            && Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()
            && Schema.sObjectType.ContentDocumentLink.fields.Sharetype.isCreateable()
            && Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()
        ) {
            System.debug('tttttttttttttt 1 ');
            List<Demande_de_modification__c> editRequest = (List<Demande_de_modification__c>)soList;
            String currentContactId;
            for(Demande_de_modification__c o : editRequest) {
                currentContactId = o.Salarie__c;
            }
            String whereClause = 'Id = \'' + contactId + '\'';
            String query =  getSelectStarRequest('Contact', whereClause , '', '1', '');
            Contact currentContact = (Contact)Database.query(query);
            System.debug('tttttttttttttt currentContact ');
            Contact fakeContact = currentContact.clone(false, true, false, false);
            System.debug('tttttttttttttt fakeContact ');
            try {
                Integer i = 0;
                for(Demande_de_modification__c o : editRequest) {
                    System.debug('tttttttttttttt O ');
                    if(o.Champ_technique__c == 'MailingAddress') {
                        List<String> address = o.crta__New_Value__c.split('-');
                        if(address[0] != '') {
                            fakeContact.put('MailingStreet', address[0]);
                        }
                        if(address[1] != '') {
                            fakeContact.put('MailingPostalCode', address[1]);
                        }
                        if(address[2] != '') {
                            fakeContact.put('MailingCity', address[2]);
                        }
                        if(address[3] != '') {
                            fakeContact.put('MailingState', address[3]);
                        }
                        if(address[4] != '') {
                            fakeContact.put('MailingCountry', address[4]);
                        }
                    } else {
                        String newValueInit = o.crta__New_Value__c;
                        String newValueTmp = o.crta__New_Value__c;
                        if(fieldType[i] == 'reference') {
                            List<String> valueSplit = newValueTmp.split(';');
                            newValueTmp = valueSplit[0];
                            newValueInit = valueSplit[1];
                            o.crta__New_Value__c = newValueInit + ' (' + newValueTmp + ')';
                        }
                        Object newValue = PortalUtility.setFieldValue(newValueTmp, fieldType[i]);
                        fakeContact.put(o.Champ_technique__c, newValue);
                        
                        if(fakeContact.get(o.Champ_technique__c) == NULL) {
                            fakeContact.put(o.Champ_technique__c, NULL);
                        }
                        
                        if(fieldType[i] == 'date') {
                                String originalDate = o.crta__New_Value__c ;
                                if( UserInfo.getLanguage() == 'fr'){
                                    if (originalDate != null && originalDate.length() == 10 && originalDate.contains('-')) {
                                        String year = originalDate.substring(0, 4);
                                        String month = originalDate.substring(5, 7);
                                        String day = originalDate.substring(8, 10);
                                        o.crta__New_Value__c = day + '/' + month + '/' + year;
                                    }
                                }
                        }
                        
                        if(fieldType[i] == 'boolean') {
                            if(o.crta__New_Value__c == 'true') {
                                o.crta__New_Value__c = Label.crta.Yes;
                            } else {
                                o.crta__New_Value__c = Label.crta.No;
                            }
                            if(o.crta__Old_Value__c == 'true') {
                                o.crta__Old_Value__c = Label.crta.Yes;
                            } else {
                                o.crta__Old_Value__c = Label.crta.No;
                            }
                        }
                        i++;
                    }
                }
                //We update a currentContact in order to trigger all validation rules before we insert the editRequest
                //Update currentContact with old value (fakeContact) if success
                
                if (
                    Schema.sObjectType.Contact.isCreateable()
                    && Schema.sObjectType.Contact.fields.FirstName.isCreateable()
                    && Schema.sObjectType.Contact.fields.LastName.isCreateable()
                    && Schema.sObjectType.Contact.fields.Birthdate.isCreateable()
                    && Schema.sObjectType.Contact.fields.Email.isCreateable()
                    && Schema.sObjectType.Contact.fields.ReportsToId.isCreateable()
                    && Schema.sObjectType.Contact.fields.Is_Modification_Request__c.isCreateable()
                    && Schema.sObjectType.Contact.isDeletable()
                ) {
                    String fakeFName = ProfileController.generateRandomString(12) + 'zzz';
                    String fakeLName = ProfileController.generateRandomString(20) + 'zzz';
                    fakeContact.FirstName = fakeFName;
                    fakeContact.LastName = fakeLName;
                    //Begin ==> 16/09/2021 By tenhinene CT-202109#003562 Comment the line "fakeContact.Birthdate = Date.newInstance(1950, 1, 1);"
                    //fakeContact.Birthdate = Date.newInstance(1950, 1, 1);
                    //End ==> 16/09/2021 By tenhinene CT-202109#003562
                    fakeContact.Email = fakeFName + '.' + fakeLName + '@testCt.com';
                    fakeContact.ReportsToId = null;
                    fakeContact.Is_Modification_Request__c = true;
                    insert fakeContact;
                    delete fakeContact;
                }
                
                insert editRequest;
                
                List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
                for(Demande_de_modification__c e : editRequest) {
                    for(String s : contentDocumentIds) {
                        ContentDocumentLink fileLink = new ContentDocumentLink();
                        fileLink.LinkedEntityId = e.Id;
                        fileLink.ContentDocumentId = s;
                        fileLink.Sharetype = 'I';
                        fileLink.Visibility = 'AllUsers';
                        fileLinks.add(fileLink);
                    }
                }
                if(fileLinks.size() > 0) {
                    insert fileLinks;
                }
                return 'SUCCESS';
            }
            catch (Exception e) {
                system.debug('Error ' + e.getMessage());
                return e.getMessage();
            }
        } else {
            if (
                Schema.sObjectType.Demande_de_modification__c.isCreateable()
                && Schema.sObjectType.Demande_de_modification__c.fields.crta__New_Value__c.isCreateable()
            ) {
                return System.Label.SI_Error_modif_request_creation.replace('{0}', System.Label.Permission);
            } else {
                return System.Label.SI_Error_modif_request_creation.replace('{0}', System.Label.Permission);
            }
        }
    }
    
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    @AuraEnabled
    public static void updateContactCtrl(SObject so) {
        if (Schema.sObjectType.Contact.isUpdateable()) {
            Contact c = (Contact)so;
            update c;
        }
    }
    
    @AuraEnabled
    public static String getContactCtrl(String receivedId, String accountFieldName) {
        String contactId = (String.isBlank(receivedId))
            ? [SELECT Contact__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].Contact__c
            : receivedId;
        if(contactId != null) {
            String whereClause = 'Id = \'' + contactId + '\'';
            
            List<String> l = new List<String>(Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet());
            Set<String> contactFields = new Set<String>();
            for(String s : l) {
                if(!s.endsWith('__c')) {
                    contactFields.add(s.toLowerCase());
                }
            }
            String accountField = (accountFieldName.endsWith('Id') ? accountFieldName.replace('Id', '') : (accountFieldName.endsWith('__c') ? accountFieldName.replace('__c', '__r') : accountFieldName));
            if(accountField == null) {
                accountField = 'Account';
            }
            
            contactFields.add('crta__Status_Value__c');
            contactFields.add('crta__CT_Status_of_employee__c');
            contactFields.add('crta__GDPR__c');
            contactFields.add('crta__GDPR_Date__c');
            contactFields.add('crta__Onboarding_Errors__c');
            contactFields.add(accountField + '.crta__Onboarding_GPDR_Text__c');
            contactFields.add(accountField + '.crta__Onboarding_Welcome_Message__c'); 
            contactFields.add('RecordType.DeveloperName');
            contactFields.add('ReportsTo.ReportsToId');
            contactFields.add('ReportsTo.ReportsTo.ReportsToId');
            
            for(Profile_Field_Setting__mdt p : [
                SELECT Id, 
                API_Name__c,
                Type__c
                FROM Profile_Field_Setting__mdt
                WHERE Type__c = 'Field' AND Disable__c=false
                ORDER BY Order__c ASC NULLS LAST
            ]) {
                List<String> fields = p.API_Name__c.split(',');
                for(String s : fields) {
                    contactFields.add(s.toLowerCase());
                }
            }
            
            for(Profile_Section_Setting__mdt s : [
                SELECT Id, 
                crta__Conditional_Display__c
                FROM Profile_Section_Setting__mdt
                WHERE crta__Conditional_Display__c != NULL AND Disable__c=false
            ]) {
                contactFields.add(s.crta__Conditional_Display__c.toLowerCase());
            }

            for(crta__Profile_Related_List_Setting__mdt r : [
                SELECT Id, 
                crta__Conditional_Display__c
                FROM crta__Profile_Related_List_Setting__mdt
                WHERE crta__Conditional_Display__c != NULL AND Disable__c=false
            ]) {
                contactFields.add(r.crta__Conditional_Display__c.toLowerCase());
            }

            for(crta__Profile_Tab_Setting__mdt t : [
                SELECT Id, 
                crta__Conditional_Display__c
                FROM crta__Profile_Tab_Setting__mdt
                WHERE crta__Conditional_Display__c != NULL AND Disable__c=false
            ]) {
                contactFields.add(t.crta__Conditional_Display__c.toLowerCase());
            }
              
            String query = PortalUtility.getSOQLQuery(contactFields, 'Contact', whereClause , '', '1', '');
            System.debug('query OB');
                        System.debug(query);
            try {
                return JSON.serialize((Contact)Database.query(query));
            } catch(Exception e) {
                system.debug(e.getMessage());
                return e.getMessage();
            }
        } else {
            return '';
        }
    }
    
    @AuraEnabled
    public static String getConnectedContactIdCtrl() {
        String contactId = [SELECT crta__Contact__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].crta__Contact__c;
        return contactId;
    }
    
    @AuraEnabled
    public static List<SectionWrapper> getSectionsCtrl(String receivedId, String accountFieldName) {
        Map<String, Schema.SObjectField> mapTypes = Schema.SObjectType.Contact.fields.getMap();
        Map<String, Map<String,String>> fieldsTranslations = getTranslationsCrtl();
        List<SectionWrapper> sectionFieldsList = new List<SectionWrapper>();
        
        // List<Profile_Field_Setting__mdt> profileSettings = new List<Profile_Field_Setting__mdt>();
        List<Profile_Field_Setting__mdt> profileSettings = [SELECT Id, 
                                                                API_Name__c,
                                                                Field_Permission__c,
                                                                Section__c,
                                                                Type__c,
                                                                Employee_Only__c,
                                                                Manager_Only__c,
                                                                Display_Help_Text__c,
                                                                Allow_Attachment__c,
                                                                Attachment_Required__c,
                                                                Column_Size__c,
                                                                Record_Types__c,
                                                                Order__c,
                                                                Required__c
                                                            FROM Profile_Field_Setting__mdt
                                                            WHERE Type__c != 'Related list field' AND Disable__c=false
                                                            ORDER BY Order__c ASC NULLS LAST];

        Contact currentContact = (Contact)JSON.deserialize(ProfileController.getContactCtrl(receivedId, accountFieldName), Contact.class);
        /*for(Profile_Field_Setting__mdt p : [
            SELECT Id, 
            API_Name__c,
            Field_Permission__c,
            Section__c,
            Type__c,
            Employee_Only__c,
            Manager_Only__c,
            Display_Help_Text__c,
            Allow_Attachment__c,
            Attachment_Required__c,
            Column_Size__c,
            Record_Types__c,
            Order__c,
            Required__c
            FROM Profile_Field_Setting__mdt
            WHERE Type__c != 'Related list field' AND Disable__c=false
            ORDER BY Order__c ASC NULLS LAST
        ]) {
            profileSettings.add(p);
        }
        
        for(Profile_Section_Setting__mdt section : [
            SELECT Id,
            MasterLabel,
            Icon__c,
            Custom_Icon__c,
            Employee_Only__c,
            Manager_Only__c,
            Dutch_Label__c,
            English_Label__c, 
            German_Label__c,
            Portuguese_Label__c,
            Spanish_Label__c,
            Record_Types__c,
            Tab__c,
            crta__Conditional_Display__c,
            Order__c,
            Color__c
            FROM Profile_Section_Setting__mdt  WHERE Disable__c=false
            ORDER BY Order__c ASC NULLS LAST
        ]) 
        
        */
        List<Profile_Section_Setting__mdt> sectionList = [
                                                            SELECT Id,
                                                                MasterLabel,
                                                                Icon__c,
                                                                Custom_Icon__c,
                                                                Employee_Only__c,
                                                                Manager_Only__c,
                                                                Dutch_Label__c,
                                                                English_Label__c, 
                                                                German_Label__c,
                                                                Portuguese_Label__c,
                                                                Spanish_Label__c,
            													Italian_Label__c ,
                                                                Record_Types__c,
                                                                Tab__c,
                                                                crta__Conditional_Display__c,
                                                                Order__c,
                                                                Color__c
                                                            FROM Profile_Section_Setting__mdt  WHERE Disable__c=false
                                                            ORDER BY Order__c ASC NULLS LAST
                                                        ];
        for(Profile_Section_Setting__mdt section : sectionList) {
            List<FieldGroupWrapper> fieldList = new List<FieldGroupWrapper>();
            Set<String> setSectionRecordIds = new Set<String>();
            if(section.Record_Types__c == null) {
                setSectionRecordIds.add(
                    Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                    .get('Salarie')
                    .getRecordTypeId()
                );
            } else {
                List<String> recordList = section.Record_Types__c.replaceAll( '\\s+', '').split(',');
                for(String r : recordList) {
                    setSectionRecordIds.add(
                        Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                        .get(r)
                        .getRecordTypeId()
                    );
                }
            }
            if(setSectionRecordIds.contains(String.valueOf(currentContact.get('RecordTypeId')))) {
                for(Profile_Field_Setting__mdt p : profileSettings) {
                    Set<String> setRecordIds = new Set<String>();
                    if(p.Record_Types__c == null) {
                        setRecordIds.add(
                            Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                            .get('Salarie')
                            .getRecordTypeId()
                        );
                    } else {
                        List<String> recordList = p.Record_Types__c.replaceAll( '\\s+', '').split(',');
                        for(String r : recordList) {
                            setRecordIds.add(
                                Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                .get(r)
                                .getRecordTypeId()
                            );
                        }
                    }
                    if(setRecordIds.contains(String.valueOf(currentContact.get('RecordTypeId')))) {
                        if(section.Id == p.Section__c) {
                            List<FieldWrapper> fields = new List<FieldWrapper>();
                            if(p.Type__c != 'Blank') {
                                List<String> fieldsApiName = p.API_Name__c.split(',');
                                
                                for(String s : fieldsApiName) {
                                    List<String> l = s.split('\\.');
                                    Object fieldValue;
                                    try {
                                        fieldValue = (s == 'MailingAddress')
                                            ? (
                                                (currentContact.get('MailingStreet') == null ? ' ' : 
                                                 currentContact.get('MailingStreet'))
                                                + ' ' + (currentContact.get('MailingPostalCode') == null ? ' ' : 
                                                         currentContact.get('MailingPostalCode'))
                                                + ' ' + (currentContact.get('MailingCity') == null ? ' ' : 
                                                         currentContact.get('MailingCity'))
                                                + ' ' + (currentContact.get('MailingState') == null ? ' ' : 
                                                         currentContact.get('MailingState'))
                                                + ' ' + (currentContact.get('MailingCountry') == null ? ' ' : 
                                                         currentContact.get('MailingCountry'))
                                            ) : PortalUtility.get(currentContact, s);
                                    } catch(Exception e) {
                                        fieldValue = '';
                                    }
                                    
                                    Schema.SObjectField field = mapTypes.get(s);
                                    String fieldType = PortalUtility.getFieldType(mapTypes, s);
                                    
                                   if(fieldType == 'TEXTAREA') {
                                        if(field.getDescribe().isHtmlFormatted()) {
                                            fieldType = 'RICHTEXT';
                                        }
                                    }
                                    
                                    Map<String, String> m;
                                    try {
                                        m = ProfileController.retrievePicklistValues('Contact', s);
                                    } catch (Exception e) {
                                        m = new Map<String, String>();
                                    }
                                    String fieldName = (l.size() > 1)
                                        ? (l.get(0).contains('__r') ? l.get(0).replace('__r','__c') : l.get(0) + 'Id')
                                        : l.get(0);
                                    String fieldTrans = fieldsTranslations.get('Contact').get(fieldName.toLowerCase());
                                    
                                    String fieldLabel = (fieldTrans.startsWith('ID du')) 
                                        ? fieldTrans.replace('ID du ', '').capitalize() : fieldTrans;
                                    
                                    String helptext = '';
                                    if(p.Display_Help_Text__c) {
                                        if(fieldType == 'REFERENCE') {
                                            Schema.SObjectField fieldRef = mapTypes.get(fieldName);
                                            helptext = fieldRef.getDescribe().getInlineHelpText();
                                        } else {
                                            helptext = field.getDescribe().getInlineHelpText();
                                        }
                                    }

                                    String picklistLabelTmp = m.get((String)fieldValue);
                                    if(fieldType == 'MULTIPICKLIST') {
                                        if(fieldValue != null) {
                                            List<String> fieldValueArray = String.valueof(fieldValue).split(';');
                                            List<String> fieldValueFinal = new List<String>();
                                            for(String v : fieldValueArray) {
                                                fieldValueFinal.add(m.get((String)v));
                                            }
                                            picklistLabelTmp = fieldValueFinal.toString().substringBetween('(', ')');

                                        }
                                    }
                                    fields.add(
                                        new FieldWrapper(
                                            s,
                                            fieldType.toLowerCase(),
                                            fieldValue,
                                            p.Required__c,
                                            (fieldName.toLowerCase().endsWith('id') || fieldType == 'REFERENCE' ? PortalUtility.get(currentContact, fieldName) : ''),
                                            helptext,
                                            picklistLabelTmp,
                                            fieldLabel,
                                            p.Employee_Only__c,
                                            p.Manager_Only__c,
                                            p.Allow_Attachment__c,
                                            p.Attachment_Required__c,
                                            m,
                                            (p.Column_Size__c == null ? '3' : p.Column_Size__c),
                                            p.Order__c
                                        )
                                    );
                                }
                            } else {
                                fields.add(
                                    new FieldWrapper(
                                        'blank',
                                        '',
                                        null,
                                        false,
                                        '',
                                        '',
                                        null,
                                        '',
                                        p.Employee_Only__c,
                                        p.Manager_Only__c,
                                        false,
                                        false,
                                        null,
                                        p.Column_Size__c,
                                        p.Order__c
                                    )
                                );
                            }
                            fieldList.add(new FieldGroupWrapper(
                                p.API_Name__c,
                                p.Field_Permission__c,
                                retrievePicklistLabel('crta__Profile_Field_Setting__mdt', 'crta__Field_Permission__c', p.Field_Permission__c),
                                null,
                                null,
                                null,
                                null,
                                p.Type__c,
                                fields
                            ));
                        }
                    }
                }
                
                String userLocale = UserInfo.getLanguage();
                String sectionLabel = section.MasterLabel;
                if(userLocale == 'nl_NL') {
                    sectionLabel = (section.Dutch_Label__c != null ? section.Dutch_Label__c : section.MasterLabel);
                }
                if(userLocale == 'en_US') {
                    sectionLabel = (section.English_Label__c != null ? section.English_Label__c : section.MasterLabel);
                }
                if(userLocale == 'de') {
                    sectionLabel = (section.German_Label__c != null ? section.German_Label__c : section.MasterLabel);
                }
                if(userLocale == 'pt_BR') {
                    sectionLabel = (section.Portuguese_Label__c != null ? section.Portuguese_Label__c : section.MasterLabel);
                }
                if(userLocale == 'es') {
                    sectionLabel = (section.Spanish_Label__c != null ? section.Spanish_Label__c : section.MasterLabel);
                }
                Boolean isDisplayed = true;
                if(section.crta__Conditional_Display__c != null) {
                    if(currentContact.get(section.crta__Conditional_Display__c.toLowerCase()) != null) {
                        isDisplayed = Boolean.valueOf(currentContact.get(section.Conditional_Display__c.toLowerCase()));
                    }
                }

                String color = '#080707';
                if(section.Color__c != null) {
                    color = section.Color__c;
                }
                
                if(fieldList.size() > 0) {
                    SectionWrapper sw = new SectionWrapper(
                        sectionLabel,
                        section.Tab__c,
                        section.Icon__c,
                        section.Custom_Icon__c,
                        section.Employee_Only__c,
                        section.Manager_Only__c,
                        section.crta__Conditional_Display__c,
                        color,
                        isDisplayed,
                        fieldList);
                    sectionFieldsList.add(sw);
                }
            }
        }
        System.debug(sectionFieldsList);
        return sectionFieldsList;
    }
    @AuraEnabled
    public static List<TabWrapper> getTabsCtrl(String receivedId, String accountFieldName) {
        Contact currentContact = (Contact)JSON.deserialize(ProfileController.getContactCtrl(receivedId, accountFieldName), Contact.class);
        
        List<TabWrapper> tabsList = new List<TabWrapper>();
        List<Profile_Related_List_Setting__mdt> profileRelatedListSettings =  [
                                                                                SELECT Id, 
                                                                                Allow_to_Add__c,
                                                                                Allow_to_Delete__c,
                                                                                Allow_to_Edit__c,
                                                                                Allow_Manager_to_Add__c,
                                                                                Allow_Manager_to_Delete__c,
                                                                                Allow_Manager_to_Edit__c,
                                                                                Filter_Criteria__c,
                                                                                Icon__c,
                                                                                Label__c,
                                                                                Manage_Files__c,
                                                                                Object_API_Name__c,
                                                                                Reference_Field_API_Name__c,
                                                                                Section__c,
                                                                                Sorting_Field__c,
                                                                                Sorting_Order__c,
                                                                                Employee_Only__c,
                                                                                Manager_Only__c,
                                                                                Record_Types__c,
                                                                                Tab__c,
                                                                                Record_Type_for_Save__c,
                                                                                Attachment_Required__c,
                                                                                Order__c,
                                                                                Attachment_Required_on_Field__c,
                                                                                Conditional_Display__c,
                                                                                crta__Required__c,
                                                                                (
                                                                                    SELECT Id, 
                                                                                    API_Name__c,
                                                                                    Field_Permission__c,
                                                                                    Section__c,
                                                                                    Type__c,
                                                                                    Employee_Only__c,
                                                                                    Manager_Only__c,
                                                                                    Display_Help_Text__c,
                                                                                    Allow_Attachment__c,
                                                                                    Attachment_Required__c,
                                                                                    Column_Size__c,
                                                                                    Record_Types__c,
                                                                                    Order__c,
                                                                                    crta__Show_in_mobile__c,
                                                                                    Required__c
                                                                                    FROM Profile_Fields_Settings__r WHERE Disable__c=false
                                                                                )
                                                                                FROM Profile_Related_List_Setting__mdt WHERE Disable__c=false
                                                                                ORDER BY Order__c ASC NULLS LAST
                                                                            ];
       /* for(Profile_Related_List_Setting__mdt r : [
            SELECT Id, 
            Allow_to_Add__c,
            Allow_to_Delete__c,
            Allow_to_Edit__c,
            Allow_Manager_to_Add__c,
            Allow_Manager_to_Delete__c,
            Allow_Manager_to_Edit__c,
            Filter_Criteria__c,
            Icon__c,
            Label__c,
            Manage_Files__c,
            Object_API_Name__c,
            Reference_Field_API_Name__c,
            Section__c,
            Sorting_Field__c,
            Sorting_Order__c,
            Employee_Only__c,
            Manager_Only__c,
            Record_Types__c,
            Tab__c,
            Record_Type_for_Save__c,
            Attachment_Required__c,
            Order__c,
            Attachment_Required_on_Field__c,
            Conditional_Display__c,
            crta__Required__c,
            (
                SELECT Id, 
                API_Name__c,
                Field_Permission__c,
                Section__c,
                Type__c,
                Employee_Only__c,
                Manager_Only__c,
                Display_Help_Text__c,
                Allow_Attachment__c,
                Attachment_Required__c,
                Column_Size__c,
                Record_Types__c,
                Order__c,
                Required__c
                FROM Profile_Fields_Settings__r WHERE Disable__c=false
            )
            FROM Profile_Related_List_Setting__mdt WHERE Disable__c=false
            ORDER BY Order__c ASC NULLS LAST
        ]) {
            profileRelatedListSettings.add(r);
        }
         SELECT Id,
            MasterLabel,
            Custom_Icon__c,
            Dutch_Label__c,
            Employee_Only__c,
            English_Label__c,
            German_Label__c,
            Icon__c,
            Manager_Only__c,
            Portuguese_Label__c,
            Record_Types__c,
            Spanish_Label__c,
            Order__c,
            Conditional_Display__c
            FROM Profile_Tab_Setting__mdt WHERE Disable__c=false
            ORDER BY Order__c ASC NULLS LAST
        
        */
        List<Profile_Tab_Setting__mdt> tabList = [
                            SELECT Id,
                            MasterLabel,
                            Custom_Icon__c,
                            Dutch_Label__c,
                            Employee_Only__c,
                            English_Label__c,
                            German_Label__c,
                            Icon__c,
                            Manager_Only__c,
                            Portuguese_Label__c,
                            Record_Types__c,
                            Spanish_Label__c,
                            Order__c,
                            Conditional_Display__c
                            FROM Profile_Tab_Setting__mdt WHERE Disable__c=false
                            ORDER BY Order__c ASC NULLS LAST
                        ];
        for(Profile_Tab_Setting__mdt tab : tabList) {
            List<RelatedListWrapper> relatedList = new List<RelatedListWrapper>();
            Set<String> setTabRecordIds = new Set<String>();
            if(tab.Record_Types__c == null) {
                setTabRecordIds.add(
                    Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                    .get('Salarie')
                    .getRecordTypeId()
                );
            } else {
                List<String> recordList = tab.Record_Types__c.replaceAll( '\\s+', '').split(',');
                for(String recordType : recordList) {
                    setTabRecordIds.add(
                        Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                        .get(recordType)
                        .getRecordTypeId()
                    );
                }
            }
           
            if(setTabRecordIds.contains(String.valueOf(currentContact.get('RecordTypeId')))) {
                for(Profile_Related_List_Setting__mdt r : profileRelatedListSettings) {
                    if(tab.Id == r.Tab__c) {
                        Set<String> setRecordIds = new Set<String>();
                        if(r.Record_Types__c == null) {
                            setRecordIds.add(
                                Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                .get('Salarie')
                                .getRecordTypeId()
                            );
                        } else {
                            List<String> recordList = r.Record_Types__c.replaceAll( '\\s+', '').split(',');
                            for(String recordType : recordList) {
                                setRecordIds.add(
                                    Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                    .get(recordType)
                                    .getRecordTypeId()
                                );
                            }
                        }
                       
                        if(setRecordIds.contains(String.valueOf(currentContact.get('RecordTypeId')))) {
                            List<RelatedFieldWrapper> rFields = new List<RelatedFieldWrapper>();
                            if(r.Profile_Fields_Settings__r.size() > 0) {
                                for(Profile_Field_Setting__mdt f : r.Profile_Fields_Settings__r) {
                                    Set<String> setFieldsRecordIds = new Set<String>();
                                    if(f.Record_Types__c == null) {
                                        setFieldsRecordIds.add(
                                            Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                            .get('Salarie')
                                            .getRecordTypeId()
                                        );
                                    } else {
                                        List<String> recordList = f.Record_Types__c.replaceAll( '\\s+', '').split(',');
                                        for(String recordType : recordList) {
                                            setFieldsRecordIds.add(
                                                Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                                .get(recordType)
                                                .getRecordTypeId()
                                            );
                                        }
                                    }
                                    if(setFieldsRecordIds.contains(String.valueOf(currentContact.get('RecordTypeId')))) {
                                        rFields.add(
                                            new RelatedFieldWrapper(
                                                f.API_Name__c,
                                                f.Employee_Only__c,
                                                f.Manager_Only__c,
                                                f.Required__c,
                                                f.Show_in_mobile__c,
                                                f.Display_Help_Text__c,
                                                f.Field_Permission__c,
                                                f.Order__c
                                            )
                                        );
                                    }
                                }
                            }
                            Boolean listToDisplay = true;
                            if(r.Conditional_Display__c != null) {
                                if(currentContact.get(r.Conditional_Display__c.toLowerCase()) != null) {
                                    listToDisplay = Boolean.valueOf(currentContact.get(r.Conditional_Display__c.toLowerCase()));
                                }
                            }
                            relatedList.add(
                                new RelatedListWrapper(
                                    r.Object_API_Name__c,
                                    r.Reference_Field_API_Name__c,
                                    rFields,
                                    r.Employee_Only__c,
                                    r.Manager_Only__c,
                                    r.Label__c,
                                    r.Icon__c,
                                    r.Allow_to_Add__c,
                                    r.Allow_to_Edit__c,
                                    r.Allow_to_Delete__c,
                                    r.Allow_Manager_to_Add__c,
                                    r.Allow_Manager_to_Edit__c,
                                    r.Allow_Manager_to_Delete__c,
                                    r.Manage_Files__c,
                                    r.Attachment_Required__c,
                                    r.Attachment_Required_on_Field__c,
                                    r.Conditional_Display__c,
                                    listToDisplay,
                                    r.crta__Required__c,
                                    (r.Sorting_Field__c != null ? 'ORDER BY ' + r.Sorting_Field__c + ' ' 
                                     + r.Sorting_Order__c : null),
                                    r.Filter_Criteria__c,
                                    r.Record_Type_for_Save__c
                                )
                            );
                        }
                    }
                }
                String userLocale = UserInfo.getLanguage();
                String tabLabel = tab.MasterLabel;
                if(userLocale == 'nl_NL') {
                    tabLabel = (tab.Dutch_Label__c != null ? tab.Dutch_Label__c : tab.MasterLabel);
                }
                if(userLocale == 'en_US') {
                    tabLabel = (tab.English_Label__c != null ? tab.English_Label__c : tab.MasterLabel);
                }
                if(userLocale == 'de') {
                    tabLabel = (tab.German_Label__c != null ? tab.German_Label__c : tab.MasterLabel);
                }
                if(userLocale == 'pt_BR') {
                    tabLabel = (tab.Portuguese_Label__c != null ? tab.Portuguese_Label__c : tab.MasterLabel);
                }
                if(userLocale == 'es') {
                    tabLabel = (tab.Spanish_Label__c != null ? tab.Spanish_Label__c : tab.MasterLabel);
                }
                 if(userLocale == 'it') {
                    tabLabel = (tab.Italian_Label__c != null ? tab.Italian_Label__c : tab.MasterLabel);
                }

                Boolean tabToDisplay = true;
                if(tab.Conditional_Display__c != null) {
                    if(currentContact.get(tab.Conditional_Display__c.toLowerCase()) != null) {
                        tabToDisplay = Boolean.valueOf(currentContact.get(tab.Conditional_Display__c.toLowerCase()));
                    }
                }

                TabWrapper tw = new TabWrapper(
                    tab.Id,
                    tabLabel,
                    tab.Icon__c,
                    tab.Custom_Icon__c,
                    tab.Employee_Only__c,
                    tab.Manager_Only__c,
                    tab.Conditional_Display__c,
                    tabToDisplay,
                    relatedList);
                tabsList.add(tw);
            }
        }
        return tabsList;
    }
    
    @AuraEnabled
    public static String getSelectStarRequest(
        String sObjectName, String whereClause,
        String orderByClause, String limitClause, String offsetClause
    ) {
        return PortalUtility.getSOQLQuery(
            Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keySet(),
            sObjectName,
            whereClause,
            orderByClause,
            limitClause,
            offsetClause
        );
    }
    
    
    @AuraEnabled
    public static ContentDistribution getContactPhoto(String contactId) {
        Set<Id> contentIds = new Set<Id>();
        List<Id> ids = new List<Id>();
        
        /*for (ContentDocumentLink cLink :[
            SELECT Id, 
            LinkedEntityId,
            ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =:contactId
        ]) {
            contentIds.add(cLink.ContentDocumentId);
        }*/
        ContentVersion c = null;
        /*for(ContentVersion cver : [
            SELECT Id,
            CreatedDate
            FROM ContentVersion 
            WHERE ContentDocumentId 
            IN :contentIds 
            AND Type__c = 'profilPicture' 
            ORDER BY CreatedDate DESC LIMIT 1
        ]) {
            c = cver;
        }*/
        for (ContentVersion cver :[SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId=:contactId 
                                                //AND Description = 'Profile_Picture'
                                                AND crta__Type__c = 'profilPicture'
                                                ORDER BY LastModifiedDate DESC LIMIT 1])
                                                {
            c = cver;
        }
        System.debug(c);
        
        ContentDistribution contentDistrib = null;
        if (c != null) {
            for(ContentDistribution cdl : [
                SELECT ContentDownloadUrl,
                ContentDocumentId , ContentVersionId
                FROM ContentDistribution 
                WHERE ContentVersionId = :c.Id 
                LIMIT 1
            ]) {
                contentDistrib = cdl;
            }
            return contentDistrib;
        }
        
        return null;
    }
    
    @AuraEnabled  
    public static List<ContentDocument> updateFileCtrl(String documentId, String recordId){  
        String cdId = [SELECT Id FROM ContentDocument where Id=:documentId].Id; // Getting files from Parent record 
        
        ContentVersion file = [SELECT Id, Type__c  FROM ContentVersion WHERE ContentDocumentId =:cdId];
        file.Type__c = 'profilPicture';
        
        try{  
            if (
                Schema.sObjectType.ContentVersion.isUpdateable()
                && Schema.sObjectType.ContentVersion.fields.Type__c.isUpdateable()
            ) {
                update file;
            } else {
                System.debug(System.Label.SI_Error_image_creation.replace('{0}', System.Label.Permission));
            }
        } catch(DMLException e){  
            System.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:recordId];
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [SELECT Id, Title, FileType, ContentSize, Description FROM ContentDocument WHERE Id IN: documentIds];
        return DocumentList;  // Return list of files on parent record
    }
    
    @AuraEnabled
    public static List<String> checkFilesCtrl(String contactId, String currentRecordType) {

        // Contact currentContact = (Contact)JSON.deserialize(contact, Contact.class);
       // String contactRecordTypeId = currentRecordType;
        List<String> allRequiredFiles = new List<String>();
        String folderId;
         for(crta__Dossier_documentaire__c f : [SELECT Id, 
                Name
            FROM crta__Dossier_documentaire__c
            WHERE crta__A_afficher__c = TRUE
            AND crta__Salarie__c =: contactId
            AND crta__is_Onboarding_Folder__c = FALSE
            AND crta__is_Doc_Gen_Folder__c = FALSE
            ORDER BY Name
            LIMIT 1
        ]) {
            folderId = f.Id;
        }
        if(folderId != null) {
            Set<String> fields = new Set<String>();
            Map<String, String> fieldsToValue = new  Map<String, String>();
            List<String> filesTypesToCheck = new List<String>();
            //Set<String> setFilesRecordIds = new Set<String>();
            for(crta__Profile_File_Setting__mdt f : [
                SELECT Id,
                    crta__API_Name__c,
                    crta__Required__c,
                    Record_Types__c,
                    crta__Required_on_Field__c
                FROM crta__Profile_File_Setting__mdt WHERE Disable__c=false
                ORDER BY MasterLabel
                LIMIT 50
            ]) {
                List<String> recordTypes = new List<String>();
                //if(f.Record_Types__c != null) {
                    Set<String> setFilesRecordIds = new Set<String>();
                    if(f.Record_Types__c == null) {
                        setFilesRecordIds.add(
                            Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                            .get('Salarie')
                            .getRecordTypeId()
                        );
                    } else {
                        List<String> recordList = f.Record_Types__c.replaceAll( '\\s+', '').split(',');
                        system.debug(f.crta__API_Name__c);
                        system.debug(f.Record_Types__c);
                        system.debug(recordList);
                        for(String r : recordList) {
                            system.debug(r);
                            setFilesRecordIds.add(
                                Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                .get(r)
                                .getRecordTypeId()
                            );
                        }
                    }
                    //recordTypes = f.Record_Types__c.replaceAll( '\\s+', '').toLowerCase().split(','); 
                //}
                if(setFilesRecordIds.contains(currentRecordType)) {
                    if(f.crta__Required__c) {
                        filesTypesToCheck.add(f.crta__API_Name__c);
                    }
                    if(f.crta__Required_on_Field__c != null) {
                        fields.add(f.crta__Required_on_Field__c);
                    }
                }
            }
            
           Set<String> filesTypesAdded = new Set<String>();
            List<String> filesTypesMissed = filesTypesToCheck;
            if(fields.size() > 0) {
                Contact currentContact = Database.query(PortalUtility.getSOQLQuery(fields, 'Contact', 'Id = \'' + contactId + '\'' , '', '1', ''));
                for(crta__Profile_File_Setting__mdt f : [
                        SELECT Id,
                            crta__API_Name__c,
                            Record_Types__c,
                            crta__Required_on_Field__c
                        FROM crta__Profile_File_Setting__mdt WHERE Disable__c=false
                        ORDER BY MasterLabel
                        LIMIT 50
                ]) {
                    Set<String> setFilesRecordIds = new Set<String>();
                    if(f.Record_Types__c == null) {
                        setFilesRecordIds.add(
                            Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                            .get('Salarie')
                            .getRecordTypeId()
                        );
                    } else {
                        List<String> recordList = f.Record_Types__c.replaceAll( '\\s+', '').split(',');
                        for(String r : recordList) {
                            setFilesRecordIds.add(
                                Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                .get(r)
                                .getRecordTypeId()
                            );
                        }
                    }
                    if(setFilesRecordIds.contains(currentRecordType)) {
                        if(f.crta__Required_on_Field__c != null) {
                            if(currentContact.get(f.crta__Required_on_Field__c) == true) {
                                if(!filesTypesToCheck.contains(f.crta__API_Name__c)) {
                                    filesTypesToCheck.add(f.crta__API_Name__c);
                                }
                            }
                        }
                    }
                }
            }
            
            if(filesTypesToCheck.size() > 0) {
                Set<String> cdIds = new Set<String>();
                for(ContentDocumentLink c : [SELECT Id,
                    LinkedEntityId,
                    ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId =: folderId]) {
                    cdIds.add(c.ContentDocumentId);
                }
                for(ContentVersion cver : [
                        SELECT Id,
                            toLabel(Type__c)
                        FROM ContentVersion 
                        WHERE ContentDocumentId IN :cdIds 
                        AND Type__c IN: filesTypesToCheck
                        ORDER BY CreatedDate DESC
                    ]) {
                        if(!filesTypesAdded.contains(cver.Type__c)) {
                            filesTypesAdded.add(cver.Type__c);
                            filesTypesMissed.remove(filesTypesMissed.indexOf(cver.Type__c));
                        }
                }
                allRequiredFiles.addAll(filesTypesMissed);
            }
        }
        return allRequiredFiles;
    }
    
    public static Map<String, String> retrievePicklistValues(String objectApiName, String fieldName) {
        Map<String, String> pickListValues = new Map <String, String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectApiName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map <String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List <Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: pick_list_values) {
            pickListValues.put(a.getValue(), a.getLabel());
        }
        system.debug('pickListValues '+pickListValues);
        return pickListValues;
    }
    
    public static String retrievePicklistLabel(String objectApiName, String fieldName, String fieldValue) {
        String label;
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectApiName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map <String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List <Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: pick_list_values) {
            if(a.getValue() == fieldValue) {
                label = a.getLabel();
            }
        }
        return label;
    }
    
}