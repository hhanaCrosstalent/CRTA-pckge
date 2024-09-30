//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author: Ophélie ABOA
 * @Date: 29/07/2019
**/
trigger ModificationRequest on Demande_de_modification__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
     ModificationRequestHandler handler = new ModificationRequestHandler(
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
    if(settings.Activate_on_Modification_Request__c && triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger();
    }
}