//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/12/2019 
**/
trigger ContentDocumentLink on ContentDocumentLink (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
     ContentDocumentLinkHandler handler = new ContentDocumentLinkHandler(
            Trigger.isExecuting,
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isDelete,
            Trigger.isUndelete,
            Trigger.isBefore,
            Trigger.isAfter,
            Trigger.new,
            Trigger.newMap,
            Trigger.old,
            Trigger.oldMap,
            Trigger.size
        );
    
    crta__Trigger_Settings__c settings = crta__Trigger_Settings__c.getInstance();
    crta__Automation_Settings__c triggerSettings = crta__Automation_Settings__c.getInstance();
    if(settings.Activate_on_Files__c && triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger();
    }
}