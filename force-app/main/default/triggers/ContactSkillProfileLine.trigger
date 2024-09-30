//Security isCreateable() isUpdateable() isDeletable() checked
trigger ContactSkillProfileLine on crta__Contact_Skill_Profile_Line__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
     ContactSkillProfileLineHandler handler = new ContactSkillProfileLineHandler(
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
    if(settings.crta__Activate_on_Contact_Skill_Profile_Line__c && triggerSettings.crta__Activate_Triggers__c) {
        handler.handleTrigger(); 
    }
}