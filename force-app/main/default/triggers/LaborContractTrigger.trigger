/*
 * @Author: Nouha Maddeh	
 * @CreatedDate: 27/02/2024
 * 
 * */
trigger LaborContractTrigger on crta__Labor_Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

 
    LaborContractHandler handler = new LaborContractHandler(
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
    
    
    
     crta__ADP_Trigger_activation__c activation_adp=crta__ADP_Trigger_activation__c.getInstance();
    if(activation_adp.crta__ActivateTriggerADP__c){
        handler.handleTrigger();
    }
}