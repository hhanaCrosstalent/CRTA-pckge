//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author: Ophélie ABOA
 * @Date: 05/11/2019
**/
public without sharing class ModificationRequestHandler {
    private class ModificationRequestHandlerException extends Exception {}
    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<crta__Demande_de_modification__c> triggerNew;
    private Map<Id, crta__Demande_de_modification__c> triggerNewMap;
    private List<crta__Demande_de_modification__c> triggerOld;
    private Map<Id, crta__Demande_de_modification__c> triggerOldMap;
    private Integer size;
    
    public ModificationRequestHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<crta__Demande_de_modification__c> triggerNew,
        Map<Id, crta__Demande_de_modification__c> triggerNewMap,
        List<crta__Demande_de_modification__c> triggerOld,
        Map<Id, crta__Demande_de_modification__c> triggerOldMap,
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
    
    public void handleTrigger() {
        if(this.isAfter) {
            if(this.isUpdate) {
                changeRequest();
            }
        }
    }
    
    private void changeRequest() {
        ModificationRequestHandler.manageRequest(this.triggerNew, this.triggerOldMap);
    }
    
    public static void manageRequest(List<crta__Demande_de_modification__c> newChangeRequest, Map<Id, crta__Demande_de_modification__c> oldChangeRequestMap) {
        List<sObject> contactList = new List<sObject>();
        Map<Id, List<crta__Demande_de_modification__c>> changeRequestByContactId = new Map<Id, List<crta__Demande_de_modification__c>>();
        for (crta__Demande_de_modification__c newRequest: newChangeRequest) {
            if(!changeRequestByContactId.containsKey(newRequest.crta__Salarie__c)) {
                changeRequestByContactId.put(newRequest.crta__Salarie__c, new List<crta__Demande_de_modification__c>{newRequest});
            } else {
                changeRequestByContactId.get(newRequest.crta__Salarie__c).add(newRequest);
            }
        }
        Map<Id, crta__Demande_de_modification__c> changeRequestWithFiles = new Map<Id, crta__Demande_de_modification__c>();
        for(Id i : changeRequestByContactId.keySet()) {
            List<crta__Demande_de_modification__c> currentChangeRequest = changeRequestByContactId.get(i);
            sObject contact = Schema.getGlobalDescribe().get('Contact').newSObject();
            contact.put('Id', i);
            String requestId;
            for (crta__Demande_de_modification__c newRequest: currentChangeRequest) {
                crta__Demande_de_modification__c oldRequest = oldChangeRequestMap.get(newRequest.Id);
                requestId = newRequest.Id;
                if ((newRequest.crta__Statut__c != oldRequest.crta__Statut__c) && newRequest.crta__Statut__c == '30 Validée') {
                    contact = ModificationRequestHandler.setFields(newRequest, contact);
                    changeRequestWithFiles.put(newRequest.Id, newRequest);
                    system.debug(contact);
                } else if((newRequest.crta__Statut__c != oldRequest.crta__Statut__c) && newRequest.crta__Statut__c == '70 Rétablie') {
                    contact = ModificationRequestHandler.restoreFields(newRequest, contact);
                }
            }
            if (contact != null) {
                contactList.add(contact);
            } else {
                system.debug('No contact related to this modification request, Id request : ' + requestId);
            }
        }
        ModificationRequestHandler.getFiles(changeRequestWithFiles);
        if(contactList.size() > 0) {
            if (
                Schema.sObjectType.Contact.isUpdateable()
            ) {
        		update contactList;
            } else {
                throw new ModificationRequestHandlerException(System.Label.Permission);
            }
        }
    }

    public static sObject setFields(crta__Demande_de_modification__c newRequest, sObject contact) {
        Schema.DisplayType fieldType = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get(newRequest.crta__Champ_technique__c).getDescribe().getType();
        
        if (newRequest.crta__Champ_technique__c == 'MailingAddress') {
            List<String> adressFields = newRequest.crta__New_Value__c.split('-');
            contact.put('Id', newRequest.crta__Salarie__c);
            if(
                adressFields.size() > 0
                && Schema.sObjectType.Contact.fields.MailingStreet.isUpdateable()
            ) {
                contact.put('MailingStreet', adressFields[0] != '' ? adressFields[0] : '');
            }
            if(
                adressFields.size() > 1
                && Schema.sObjectType.Contact.fields.MailingPostalCode.isUpdateable()
            ) {
                contact.put('MailingPostalCode', adressFields[1] != '' ? adressFields[1] : '');
            }
            if(
                adressFields.size() > 2
                && Schema.sObjectType.Contact.fields.MailingCity.isUpdateable()
            ) {
                contact.put('MailingCity', adressFields[2] != '' ? adressFields[2] : '');
            }
            if(
                adressFields.size() > 3
                && Schema.sObjectType.Contact.fields.MailingState.isUpdateable()
            ) {
                contact.put('MailingState', adressFields[3] != '' ? adressFields[3] : '');
            }
            if(
                adressFields.size() > 4
                && Schema.sObjectType.Contact.fields.MailingCountry.isUpdateable()
            ) {
                contact.put('MailingCountry', adressFields[4] != '' ? adressFields[4] : '');
            }
        } else {
            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.getMap().get(newRequest.crta__Champ_technique__c) != null
                && Schema.sObjectType.Contact.fields.getMap().get(newRequest.crta__Champ_technique__c).getDescribe().isUpdateable()
            ) {
                String newValueTmp = newRequest.crta__New_Value__c;
                if(String.valueOf(fieldType).toLowerCase() == 'reference') {
                    newValueTmp = newRequest.crta__New_Value__c.substringBetween('(', ')');
                }
                Object newValue = setFieldValue(newValueTmp, String.valueOf(fieldType).toLowerCase());
                contact.put('Id', newRequest.crta__Salarie__c);
                contact.put(newRequest.crta__Champ_technique__c, newValue);
            } else {
                throw new ModificationRequestHandlerException(System.Label.Permission.removeEnd('.')
                                                              + ' on ' + newRequest.crta__Champ_technique__c + ' field');
            }
        }
        System.debug('contact : ' + contact);
        return contact;
    }

    public static sObject restoreFields(crta__Demande_de_modification__c newRequest, sObject contact) {
        Schema.DisplayType fieldType = Schema.getGlobalDescribe().get('Contact')
                                                                .getDescribe().fields
                                                                .getMap().get(newRequest.crta__Champ_technique__c)
                                                                .getDescribe().getType();
        
        if (newRequest.crta__Champ_technique__c == 'MailingAddress') {
            List<String> adressFields = newRequest.crta__Old_Value__c.split('-');
            contact.put('Id', newRequest.crta__Salarie__c);
            system.debug(adressFields);
            if(
                adressFields.size() > 0
                && Schema.sObjectType.Contact.fields.MailingStreet.isUpdateable()
            ) {
                contact.put('MailingStreet', adressFields[0] != '' ? adressFields[0] : '');
            }
            if(
                adressFields.size() > 1
                && Schema.sObjectType.Contact.fields.MailingPostalCode.isUpdateable()
            ) {
                contact.put('MailingPostalCode', adressFields[1] != '' ? adressFields[1] : '');
            }
            if(
                adressFields.size() > 2
                && Schema.sObjectType.Contact.fields.MailingCity.isUpdateable()
            ) {
                contact.put('MailingCity', adressFields[2] != '' ? adressFields[2] : '');
            }
            if(
                adressFields.size() > 3
                && Schema.sObjectType.Contact.fields.MailingState.isUpdateable()
            ) {
                contact.put('MailingState', adressFields[3] != '' ? adressFields[3] : '');
            }
            if(
                adressFields.size() > 4
                && Schema.sObjectType.Contact.fields.MailingCountry.isUpdateable()
            ) {
                contact.put('MailingCountry', adressFields[4] != '' ? adressFields[4] : '');
            }
        } else {
            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.getMap().get(newRequest.crta__Champ_technique__c) != null
                && Schema.sObjectType.Contact.fields.getMap().get(newRequest.crta__Champ_technique__c).getDescribe().isUpdateable()
            ) {
                String oldValueTmp = newRequest.crta__Old_Value__c;
                if(String.valueOf(fieldType).toLowerCase() == 'reference') {
                    oldValueTmp = newRequest.crta__Old_Value__c.substringBetween('(', ')');
                }
                Object newValue = setFieldValue(oldValueTmp, String.valueOf(fieldType).toLowerCase());
                contact.put('Id', newRequest.crta__Salarie__c);
                contact.put(newRequest.crta__Champ_technique__c, newValue);
            } else {
                throw new ModificationRequestHandlerException(System.Label.Permission.removeEnd('.')
                                                              + ' on ' + newRequest.crta__Champ_technique__c + ' field');
            }
        }
        System.debug('contact : ' + contact);
        return contact;
    }
    
    private static void getFiles(Map<Id, crta__Demande_de_modification__c> records) {
        Set<String> contentDocumentIds = new Set<String>();
        Map<Id, Id> recordByContentDocumentId = new Map<Id, Id>();
        if(records != null && !records.isEmpty()) {
            for(ContentDocumentLink c : [SELECT Id,
                                            LinkedEntityId,
                                            ContentDocumentId 
                                            FROM ContentDocumentLink 
                                        WHERE LinkedEntityId IN: records.keySet()
            ]) {
                contentDocumentIds.add(c.ContentDocumentId);
                recordByContentDocumentId.put(c.ContentDocumentId, c.LinkedEntityId);
            }
            Map<Id, Id> folderByContactId = new Map<Id, Id>();
            Map<Id, Id> contactIdByRecord = new Map<Id, Id>();
            Set<Id> employeeId = new Set<Id>();
            for(Id record : records.keySet()) {
                employeeId.add(records.get(record).crta__Salarie__c);
                contactIdByRecord.put(record,records.get(record).crta__Salarie__c);
            }
            
            if(contentDocumentIds != null) {
                //String folderId;
                for(crta__Dossier_documentaire__c f :[
                    SELECT Id, 
                        crta__Salarie__r.Name,
                        crta__Salarie__r.Id 
                    FROM crta__Dossier_documentaire__c 
                    WHERE crta__Salarie__c IN: employeeId
                    AND is_Onboarding_Folder__c = TRUE
                    LIMIT 1]) {
                        //folderId = f.Id;
                        if(!folderByContactId.containsKey(f.crta__Salarie__r.Id)) {
                            folderByContactId.put(f.crta__Salarie__r.Id, f.Id);
                        }
                }
                
                if(folderByContactId != null && !folderByContactId.isEmpty()) {
                    List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                    for(String docId : recordByContentDocumentId.keySet()) {
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.LinkedEntityId = folderByContactId.get(
                            contactIdByRecord.get(
                                recordByContentDocumentId.get(docId)));
                        cdl.ContentDocumentId = docId;
                        cdl.ShareType = 'I';
                        cdlList.add(cdl);
                    }
                    if(cdlList.size() > 0) {
                        if (
                            Schema.sObjectType.ContentDocumentLink.isCreateable()
                            && Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()
                            && Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()
                            && Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()
                        ) {
                        	insert cdlList;
                        } else {
                            throw new ModificationRequestHandlerException(System.Label.Permission.removeEnd('.') + ' on ContentDocumentLink Object');
                        }
                    }
                }
            }
        }
    }

    private static Object setFieldValue(String fieldValue, String fieldType) {
        Object newValue = null;
        system.debug('fieldType ' + fieldType);
        if(fieldValue != null) {
            switch on fieldType {
                when 'currency', 'double', 'integer', 'long', 'percent' {
                    fieldValue = fieldValue.replace(',','.');
                    newValue = Decimal.valueOf(fieldValue);
                }
                when 'date' {
                    if (fieldValue.contains('/'))
                    {
					List<String> dateParts = fieldValue.split('/');
					Integer day = Integer.valueOf(dateParts[0]);
					Integer month = Integer.valueOf(dateParts[1]);
					Integer year = Integer.valueOf(dateParts[2]);
 					newValue = Date.newInstance(year, month, day);}
                    else 
                        newValue = Date.valueOf(fieldValue);
                }
                when 'datetime' {
                    newValue = Datetime.valueOf(fieldValue);
                }
                when 'picklist', 'multipicklist' {
                    newValue = fieldValue;
                }
                when 'string', 'email', 'phone', 'encryptedstring', 'textarea', 'url', 'reference' {
                    newValue = fieldValue;
                }
                when 'boolean' {
                    if(fieldValue == Label.crta.Yes) {
                        newValue = true;
                    } else {
                        newValue = false;
                    }
                }
                when else {
                    newValue = null;
                }
            }
        }
        return newValue;
    }
}