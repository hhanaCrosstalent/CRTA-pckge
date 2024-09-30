//Security isCreateable() isUpdateable() isDeletable() checked
trigger TrainingRegistrationTrigger on Participation_session_formation__c (
    after delete, after insert, after undelete,
	after update, before delete, before insert, before update
) {
      TrainingRegistrationHandler handler = new TrainingRegistrationHandler(Trigger.isExecuting, Trigger.size);
      TrainingModule__c options = TrainingModule__c.getInstance();

      if(options.useActionTrigger__c && Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
      }
      else if(options.useActionTrigger__c && Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new);
            //TrainingRegistrationHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
      }

      else if(options.useActionTrigger__c && Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
      }
      else if(options.useActionTrigger__c && Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
            //TrainingRegistrationHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
      }

      else if(options.useActionTrigger__c && Trigger.isDelete && Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
      }
      else if(options.useActionTrigger__c && Trigger.isDelete && Trigger.isAfter){
            handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
            //TrainingRegistrationHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
      }

      else if(options.useActionTrigger__c && Trigger.isUnDelete){
            handler.OnUndelete(Trigger.new);
      }
}