//Security isCreateable() isUpdateable() isDeletable() checked
trigger Field on Field__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    FieldHandler handler = new FieldHandler(
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
    crta__Automation_Settings__c triggerSettings = crta__Automation_Settings__c.getInstance();
    if(triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger();
    }
}