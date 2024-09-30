/**
* @Author Crosstalent
* @UpdateList :
*    Ophélie ABOA -> September, 2020 (CreatedDate)
**/

trigger RelatedList on Related_List__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	 RelatedListHandler handler = new RelatedListHandler(
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