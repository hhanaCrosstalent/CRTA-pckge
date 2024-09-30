/**
* @Author Crosstalent
* @UpdateList :
*    Ophélie ABOA -> September, 2020 (CreatedDate)
**/
//Security isCreateable() isUpdateable() isDeletable() checked
public without sharing class FieldHandler {
    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<Field__c> triggerNew;
    private Map<Id, Field__c> triggerNewMap;
    private List<Field__c> triggerOld;
    private Map<Id, Field__c> triggerOldMap;
    private Integer size;

    private Map<String,Id> recordTypeByDeveloperName = new Map<String,Id>();
    private Map<Id,Related_List__c> pdrRelatedListById = new Map<Id,Related_List__c>();

    public FieldHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<Field__c> triggerNew,
        Map<Id, Field__c> triggerNewMap,
        List<Field__c> triggerOld,
        Map<Id, Field__c> triggerOldMap,
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
        if(this.isBefore) {
            if(this.isInsert) {
                getRecordType();
                getPdrRelatedList();
                checkApiName();
                checkDependentPicklist();
            } else if(this.isUpdate) {
                getRecordType();
                getPdrRelatedList();
                checkApiName();
                checkDependentPicklist();
            }
        }
    }

    /** Getter **/
    private void getRecordType() {
        for(RecordType currentRecordType : 
            [
                SELECT
                    Id,
                    DeveloperName
                FROM RecordType
                WHERE sObjectType = 'crta__Field__c'
            ]
        ) {
            this.recordTypeByDeveloperName.put(currentRecordType.DeveloperName,currentRecordType.Id);
        }
    }

    private void getPdrRelatedList() {
        
        Set<Id> relatedListsIds = new Set<Id>();
        for(Field__c currentField : this.triggerNew) {
            if(currentField.RecordTypeId == this.recordTypeByDeveloperName.get('Related_List_Field')) {
                relatedListsIds.add(currentField.Related_List__c);
            }
        }

        this.pdrRelatedListById.putAll(
            [
                SELECT
                    Id,
                    Object_API_Name__c
                FROM Related_List__c
                WHERE Id IN: relatedListsIds
            ]
        );
    }

    /** Setter **/

    /** Checker **/
    private void checkApiName() {
        if(this.isAfter || this.isDelete) {
            return;
        }

        Set<String> pdrFields;

        for(Field__c currentField : this.triggerNew) {
            if(
                currentField.RecordTypeId == this.recordTypeByDeveloperName.get('Section_Field')
                || currentField.RecordTypeId == this.recordTypeByDeveloperName.get('Related_List_Field')
            ) {
                if(currentField.RecordTypeId == this.recordTypeByDeveloperName.get('Related_List_Field')) {
                    Related_List__c currentRL = this.pdrRelatedListById.get(currentField.Related_List__c);
                    pdrFields = 
                        Schema.getGlobalDescribe()
                            .get(currentRL.Object_API_Name__c)
                            .getDescribe().fields.getMap().keySet();
                } else {
                    pdrFields = 
                         Schema.getGlobalDescribe().get('crta__EI_Entretien__c').getDescribe().fields.getMap().keySet();
                }
                if(!currentField.Api_Name__c.contains('.')) {
                    if(!pdrFields.contains(currentField.Api_Name__c.toLowerCase())){
                        currentField.Api_Name__c.addError(Label.Field_API_Name_Error);
                    }
                } else {
                    if(currentField.Api_Name__c == '.') {
                        currentField.Api_Name__c.addError(Label.Field_API_Name_Error);
                    } else if(currentField.Api_Name__c.contains('__r.')) {
                        String tmpApiName = currentField.Api_Name__c.split('\\.')[0].replace('__r','__c');
                        if(!pdrFields.contains(tmpApiName.toLowerCase())){
                            currentField.Api_Name__c.addError(Label.Field_API_Name_Error);
                        }
                    } else {
                        String tmpApiName = currentField.Api_Name__c.split('\\.')[0] + 'Id';
                        if(!pdrFields.contains(tmpApiName.toLowerCase())){
                            currentField.Api_Name__c.addError(Label.Field_API_Name_Error);
                        }
                    }
                }
            }
        }
    }

    private void checkDependentPicklist() {
        if(this.isAfter || this.isDelete) {
            return;
        }

        Map<String, Schema.SObjectField> pdrFields = 
            Schema.getGlobalDescribe().get('crta__EI_Entretien__c').getDescribe().fields.getMap();
        Map<String, String> picklistByController = new Map<String, String>();
        for(Field__c currentField : this.triggerNew) {
            if(currentField.RecordTypeId == this.recordTypeByDeveloperName.get('Section_Field')) {
                Schema.SObjectField field = pdrFields.get(currentField.Api_Name__c);
                if(
                    field != null
                    && field.getDescribe().isDependentPicklist()
                    && String.isBlank(currentField.Picklist_Controller__c)
                ) {
                    currentField.Picklist_Controller__c.addError(Label.Dependent_Picklist_Error);
                }
            }
        }
    }
}