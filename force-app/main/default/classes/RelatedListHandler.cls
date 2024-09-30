/**
* @Author Crosstalent
* @UpdateList :
*    Ophélie ABOA -> September, 2020 (CreatedDate)
**/

public without sharing class RelatedListHandler {
    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<Related_List__c> triggerNew;
    private Map<Id, Related_List__c> triggerNewMap;
    private List<Related_List__c> triggerOld;
    private Map<Id, Related_List__c> triggerOldMap;
    private Integer size;

    public RelatedListHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<Related_List__c> triggerNew,
        Map<Id, Related_List__c> triggerNewMap,
        List<Related_List__c> triggerOld,
        Map<Id, Related_List__c> triggerOldMap,
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
            if(this.isInsert || this.isUpdate) {
                checkObjectExist(this.triggerNew);
            }
        }
    }

    private void checkObjectExist(List<Related_List__c> relatedList) {
        String errorMessage = '';
        for(Related_List__c r : relatedList) {
            SObjectType objectType = Schema.getGlobalDescribe().get(r.Object_API_Name__c);
                if(objectType == null) {
                    errorMessage = String.format(
                        Label.Object_API_Name_Error,
                        new List<String>{
                            r.Object_API_Name__c
                        }
                    );
                }
            if (!String.isBlank(errorMessage)) {
                r.addError(errorMessage);
            }
        }
    }
}