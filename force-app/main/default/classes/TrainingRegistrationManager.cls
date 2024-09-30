//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Participation_session_formation__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class TrainingRegistrationManager {
    /**
* Creates a training registration
* @param  sessionId  Id of the wanted training session
* @param  actionId  Id of the linked training action
* @return 'success' or an error message
*/
    webService static String createTrainingRegistration(String sessionId, String actionId) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            
            if (
                Schema.sObjectType.Participation_session_formation__c.isCreateable()
                && Schema.sObjectType.Participation_session_formation__c.fields.Session_de_formation__c.isCreateable()
            ) {
                Participation_session_formation__c trainingRegistration = new Participation_session_formation__c(
                    Session_de_formation__c = sessionId
                );
                if(
                    actionId != null && actionId != ''
                    && Schema.sObjectType.Participation_session_formation__c.fields.Action_de_formation__c.isCreateable()
                ) {
                    trainingRegistration.Action_de_formation__c = actionId;
                }
                
                insert trainingRegistration;
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_registration_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_registration_creation.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_registration_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_registration_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a Participation_session_formation__c object
* @param registrationId Id of the Participation_session_formation__c object to delete
* @return      'success' or an error message
*/
    webService static String deleteTrainingRegistration(String registrationId) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            Participation_session_formation__c trainingRegistration = trainingRegistrationRepository.getById(registrationId);
            String module = trainingRegistration.Nom_de_la_formation__c;

            if (
                Schema.sObjectType.Participation_session_formation__c.isDeletable()
            ) {
                delete trainingRegistration;
                if(options.useNotifications__c) NotificationManager.createNotification(String.valueOf(trainingRegistration.Id_du_salarie__c), System.Label.SI_Notif_training_registration_delete.replace('{0}', module), 'Suppression', null);
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_registration_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_registration_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_registration_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_registration_delete.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Cancels a Participation_session_formation__c object
* @param registrationId Id of the Participation_session_formation__c object to cancel
* @param isManager Whether the cancellation comes from a manager
* @param isCollab Whether the cancellation comes from the owner
* @return 'success' or an error message
*/
    webService static String cancelTrainingRegistration(String registrationId, Boolean isManager, Boolean isCollab) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            
            if (
                Schema.sObjectType.Participation_session_formation__c.isUpdateable()
                && Schema.sObjectType.Participation_session_formation__c.fields.Statut__c.isUpdateable()
            ) {
                Participation_session_formation__c trainingRegistration = trainingRegistrationRepository.getById(registrationId);
                if(isCollab) {
                    trainingRegistration.Statut__c = '91 Annulée par le collaborateur';
                } else if(isManager) {
                    trainingRegistration.Statut__c = '92 Annulée par le manager';
                } else {
                    trainingRegistration.Statut__c = '90 Annulée';
                }
                String module = trainingRegistration.Nom_de_la_formation__c;
                
                update trainingRegistration;
                if(options.useNotifications__c) NotificationManager.createNotification(String.valueOf(trainingRegistration.Id_du_salarie__c), System.Label.SI_Notif_training_registration_cancel.replace('{0}', module), 'Information', trainingRegistration.Id);
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_registration_cancel.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_registration_cancel.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_registration_cancel.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_registration_cancel.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Accepts a Participation_session_formation__c object
* @param registrationId Id of the registration to accept
*
* @return 'success' or an error message
*/
    webService static String accept(String registrationId) {
        try {
            TrainingModule__c trainingOptions = TrainingModule__c.getInstance();

            if (
                Schema.sObjectType.Participation_session_formation__c.isUpdateable()
                && Schema.sObjectType.Participation_session_formation__c.fields.Statut__c.isUpdateable()
            ) {
                Participation_session_formation__c registration = TrainingRegistrationRepository.getById(registrationId);
                registration.Statut__c = trainingOptions.RegistrationAcceptedValue__c;
                
                update registration;
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception error) {
            if(error.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_registration_accepted.replace('{0}', error.getDmlMessage(0)));
                return System.Label.SI_Error_training_registration_accepted.replace('{0}', error.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_registration_accepted.replace('{0}', error.getMessage()));
            return System.Label.SI_Error_training_registration_accepted.replace('{0}', error.getMessage());
        }
    }
    
    /**
* Rejects a Participation_session_formation__c object
* @param registrationId Id of the registration to accept
*
* @return 'success' or an error message
*/
    webService static String reject(String registrationId) {
        try {
            TrainingModule__c trainingOptions = TrainingModule__c.getInstance();
            if (
                Schema.sObjectType.Participation_session_formation__c.isUpdateable()
                && Schema.sObjectType.Participation_session_formation__c.fields.Statut__c.isUpdateable()
            ) {
                Participation_session_formation__c registration = TrainingRegistrationRepository.getById(registrationId);
                registration.Statut__c = trainingOptions.RegistrationRejectedValue__c;
                
                update registration;
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception error) {
            if(error.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_registration_rejected.replace('{0}', error.getDmlMessage(0)));
                return System.Label.SI_Error_training_registration_rejected.replace('{0}', error.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_registration_rejected.replace('{0}', error.getMessage()));
            return System.Label.SI_Error_training_registration_rejected.replace('{0}', error.getMessage());
        }
    }
}