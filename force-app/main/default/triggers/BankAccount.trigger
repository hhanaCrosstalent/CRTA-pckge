//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/07/2020 
**/
trigger BankAccount on crta__Bank_Account__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    BankAccountHandler handler = new BankAccountHandler(
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
    if(settings.crta__Activate_on_Bank_Account__c && triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger(); 
    }
    
    
    //NMA 27/02/2024
     crta__ADP_Trigger_activation__c activation_adp=crta__ADP_Trigger_activation__c.getInstance();
    if(activation_adp.crta__ActivateTriggerADP__c){
        handler.handleADPTrigger();
    }
}