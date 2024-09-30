//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Pause__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class PauseManager {
    /**
* Creates a Pause__c object
* @param startDate Date of the pause
* @param duration  Duration of the pause
* @param contactId Id of the contact for whom to create the pause
* 
* @return 'success' or an error message
*/
    webService static String createPause(Date startDate, Integer duration, String contactId) {
        try {
            Feuille_Temps_Hebdo__c newSheet = TimesheetManager.findOrCreateTimesheet(startDate, startDate, contactId);
            
            if (
                Schema.sObjectType.Pause__c.isCreateable()
                && Schema.sObjectType.Pause__c.fields.Feuille_hebdo__c.isCreateable()
                && Schema.sObjectType.Pause__c.fields.Date__c.isCreateable()
                && Schema.sObjectType.Pause__c.fields.Duree__c.isCreateable()
            ) {
                Pause__c pause = new Pause__c(
                    Feuille_hebdo__c = newSheet.Id,
                    Date__c = startDate,
                    Duree__c = duration
                );
            	insert pause;
            	return 'success';
            } else {
                return System.Label.SI_Error_pause_creation.replace('{0}', System.Label.Permission);
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_pause_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_pause_creation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_pause_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_pause_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Updates a Pause__c object
* @param startDate Date of the pause
* @param duration  Duration of the pause
* @param pauseId Id of the pause to update
* 
* @return 'success' or an error message
*/
    webService static String editPause(Date startDate, Integer duration, String pauseId) {
        try {
            if (
                Schema.sObjectType.Pause__c.isUpdateable()
                && Schema.sObjectType.Pause__c.fields.Date__c.isUpdateable()
                && Schema.sObjectType.Pause__c.fields.Duree__c.isUpdateable()
            ) {
                Pause__c pause = PauseRepository.getById(pauseId);
                pause.Date__c = startDate;
                pause.Duree__c = duration;
                
                update pause;
                return 'success';
            } else {
                return System.Label.SI_Error_pause_edit.replace('{0}', System.Label.Permission);
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_pause_edit.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_pause_edit.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_pause_edit.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_pause_edit.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a Pause__c object
* @param pauseId Id of the pause to delete
* 
* @return 'success' or an error message
*/
    webService static String deletePause(String pauseId) {
        try {
            if (
                Schema.sObjectType.Pause__c.isDeletable()
            ) {
                Pause__c pause = PauseRepository.getById(pauseId);

                delete pause;
                return 'success';
            } else {
                return System.Label.SI_Error_pause_delete.replace('{0}', System.Label.Permission);
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_pause_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_pause_delete.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_pause_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_pause_delete.replace('{0}', e.getMessage());
        }
    }
}