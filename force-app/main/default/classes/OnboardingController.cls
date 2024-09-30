//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 10/07/2020 
*** @Modified by : MBAYE Fallou
*** @Last Modified Date : 27/10/2021
*** added the possibility to deactivate metadata
**/
public without sharing class OnboardingController {
    @AuraEnabled
    public static SObject updateContactCtrl(SObject so, Boolean isValidate) {
        if(isValidate) {
            Onboarding_Settings__c settings = Onboarding_Settings__c.getInstance();
            if(settings.Validation_Status__c != null) {
                so.put('crta__CT_Status_of_employee__c', settings.Validation_Status__c);
            } else {
                so.put('crta__CT_Status_of_employee__c', '85 To check');
            }
            so.put('crta__Onboarding_Files_Complete__c', true);
        } 
        if (
            Schema.sObjectType.Contact.isUpdateable()
            && Schema.sObjectType.Contact.fields.crta__CT_Status_of_employee__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.crta__Onboarding_Files_Complete__c.isUpdateable()
        ) {
            update (Contact)so;
            so.recalculateFormulas();
        } else {
            System.debug(System.Label.Permission);
        }
        //return so;
        return getContactInfo(so.Id);
    }

    @AuraEnabled
    public static Onboarding_Settings__c getOnboardingSettingsCtrl(){
        Onboarding_Settings__c settings = Onboarding_Settings__c.getInstance();
        return settings;
    }

    @AuraEnabled
    public static Contact recalculateFormulaCtrl(Contact contactUpdated) {
        contactUpdated.recalculateFormulas();
        //return contactUpdated;
        return getContactInfo(contactUpdated.Id);
    }

    public static Contact getContactInfo(Id conId){
         List<String> fieldString = getSObjectFieldNames('Contact');
            String fieldList = String.join(fieldString, ',');
        String soqlQuery = 'SELECT '
                + fieldList + 
                + ' FROM Contact WHERE Id=\''+conId+'\'';
         Contact con= Database.query(soqlQuery);
        return con;
    }
    
     private static List<String> getSObjectFieldNames(final String sObjectName) {
            return new List<String>(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keySet());
        }
    @AuraEnabled
    public static List<String> checkFilesCtrl(String contactId) {
        
        List<String> allRequiredFiles = new List<String>();
        String folderId;
         for(crta__Dossier_documentaire__c f : [SELECT Id, 
                Name
            FROM crta__Dossier_documentaire__c
            WHERE crta__A_afficher__c = TRUE
            AND crta__Salarie__c =: contactId
            AND crta__is_Onboarding_Folder__c = TRUE
            ORDER BY Name
            LIMIT 1
        ]) {
            folderId = f.Id;
        }
        if(folderId != null) {
            Set<String> fields = new Set<String>();
            Map<String, String> fieldsToValue = new  Map<String, String>();
            List<String> filesTypesToCheck = new List<String>();
            for(crta__Profile_File_Setting__mdt f : [
                SELECT Id,
                    crta__API_Name__c,
                    crta__Required__c,
                    Record_Types__c,
                    crta__Required_on_Field__c
                FROM crta__Profile_File_Setting__mdt  WHERE Disable__c =false
                ORDER BY MasterLabel
                LIMIT 50
            ]) {
                List<String> recordTypes = new List<String>();
                if(f.Record_Types__c != null) {
                    recordTypes = f.Record_Types__c.replaceAll( '\\s+', '').toLowerCase().split(','); 
                }
                if((f.crta__Required__c)
                    && recordTypes.contains('onboarding')) {
                    filesTypesToCheck.add(f.crta__API_Name__c);
                }
                if(f.crta__Required_on_Field__c != null) {
                    fields.add(f.crta__Required_on_Field__c);
                }
            }
            
            Set<String> filesTypesAdded = new Set<String>();
            List<String> filesTypesMissed = filesTypesToCheck;
            if(fields.size() > 0) {
                Contact myContact = Database.query(PortalUtility.getSOQLQuery(fields, 'Contact', 'Id = \'' + contactId + '\'' , '', '1', ''));
                for(crta__Profile_File_Setting__mdt f : [
                        SELECT Id,
                            crta__API_Name__c,
                            crta__Required_on_Field__c
                        FROM crta__Profile_File_Setting__mdt WHERE Disable__c =false
                        ORDER BY MasterLabel
                        LIMIT 50
                ]) {
                    if(f.crta__Required_on_Field__c != null) {
                        if(myContact.get(f.crta__Required_on_Field__c) == true) {
                            if(!filesTypesToCheck.contains(f.crta__API_Name__c)) {
                                filesTypesToCheck.add(f.crta__API_Name__c);
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

    @AuraEnabled
    public static List<String> checkRelatedListFilesCtrl(String contactId) {
        List<Profile_Related_List_Setting__mdt> profileRelatedListSettings = new List<Profile_Related_List_Setting__mdt>();
        Set<String> objectApiName = new Set<String>();
        for(Profile_Related_List_Setting__mdt r : [
            SELECT Id, 
            Allow_to_Add__c,
            Allow_to_Delete__c,
            Allow_to_Edit__c,
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
            DeveloperName,
            Attachment_Required_on_Field__c
            FROM Profile_Related_List_Setting__mdt WHERE Disable__c =false
            ORDER BY Order__c ASC NULLS LAST
        ]) {
            if(r.Attachment_Required__c || r.Attachment_Required_on_Field__c != null) {
                profileRelatedListSettings.add(r);
            }
        }
        
        Map<String, List<sObject>> recordsByRLName = new Map<String, List<sObject>> ();
        for(Profile_Related_List_Setting__mdt r : profileRelatedListSettings) {
            String requiredOnField = '';
            if(r.Attachment_Required_on_Field__c != null) {
                requiredOnField = ',' + r.Attachment_Required_on_Field__c;
            }
            String whereClause = '';
            if(r.Filter_Criteria__c != null)
            {
                whereClause = ' AND ('+r.Filter_Criteria__c+' = TRUE) ';
            }
            List<sObject> records = Database.query('SELECT Id' + requiredOnField + ', (SELECT Title FROM AttachedContentDocuments) FROM ' + r.Object_API_Name__c + ' WHERE ' +  r.Reference_Field_API_Name__c + '=: contactId' + whereClause);
            recordsByRLName.put(r.DeveloperName, records);
        }
        
        Map<String, String> results = new Map<String, String> ();
        for(Profile_Related_List_Setting__mdt r : profileRelatedListSettings) {
            List<sObject> recordsData = recordsByRLName.get(r.DeveloperName);
            for(sObject o : recordsData) {
                if(r.Attachment_Required_on_Field__c != null) {
                    if(o.get(r.Attachment_Required_on_Field__c) == true) {
                        if(o.getSObjects('AttachedContentDocuments') != null) {
                            List<AttachedContentDocument> files =  (List<AttachedContentDocument>)o.getSObjects('AttachedContentDocuments');
                            if(files.size() == 0) {
                                if(!results.containsKey(r.DeveloperName)) {
                                    results.put(r.DeveloperName, r.Label__c);
                                }
                            }
                        } else {
                            if(!results.containsKey(r.DeveloperName)) {
                                results.put(r.DeveloperName, r.Label__c);
                            }
                        }
                    }
                }
                if(r.Attachment_Required__c) {
                    if(o.getSObjects('AttachedContentDocuments') != null) {
                        List<AttachedContentDocument> files =  (List<AttachedContentDocument>)o.getSObjects('AttachedContentDocuments');
                        if(files.size() == 0) {
                            if(!results.containsKey(r.DeveloperName)) {
                                results.put(r.DeveloperName, r.Label__c);
                            }
                        }
                    } else {
                        if(!results.containsKey(r.DeveloperName)) {
                            results.put(r.DeveloperName, r.Label__c);
                        }
                    }
                }
            }
        }
        List<String> relatedListName = results.values();
        return relatedListName;

    }
}