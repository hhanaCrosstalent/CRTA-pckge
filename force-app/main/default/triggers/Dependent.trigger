//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 30/09/2020 
**/
trigger Dependent on crta__Dependent__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	DependentHandler handler = new DependentHandler(
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

    Trigger_Settings__c settings = Trigger_Settings__c.getInstance();
    crta__Automation_Settings__c triggerSettings = crta__Automation_Settings__c.getInstance();
    if(settings.crta__Activate_on_Dependent__c  && triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger(); 
    }    
}