//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Demande_de_formation__c object
*/
global with sharing class TrainingRequestManager {
    /**
* Creates a training request
* @param  moduleId    Optional. Id of the wanted training module
* @param  sessionId   Optional. Id of the wanted training session
* @param  type        Optional. Type of training request
* @param  schedule    Optional. Schedule wanted for the training request
* @param  description Optional. Description of the training request
* @param  origin Optional. Origin of the training request
* @param  contactId   Id of the contact
* @return 'success' or an error message
*/
    webService static String createTrainingRequest(
        String moduleId, String sessionId, String type, String schedule, 
        String description, String origin, String contactId
    ) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        
        try {
            if (
                Schema.sObjectType.Demande_de_formation__c.isCreateable()
                && Schema.sObjectType.Demande_de_formation__c.fields.Salarie__c.isCreateable()
            ) {
                Demande_de_formation__c trainingRequest = new Demande_de_formation__c(
                    Salarie__c = contactId
                );
                if(
                    moduleId != null && moduleId != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Catalogue_de_formation__c.isCreateable()
                ) {
                    trainingRequest.Catalogue_de_formation__c = moduleId;
                }
                if(
                    sessionId != null && sessionId != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Session_de_formation__c.isCreateable()
                ) {
                    trainingRequest.Session_de_formation__c = sessionId;
                }
                if(
                    type != null && type != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Type_de_formation__c.isCreateable()
                ) {
                    trainingRequest.Type_de_formation__c = type;
                }
                if(
                    schedule != null && schedule != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Echeance_souhaitee__c.isCreateable()
                ) {
                    trainingRequest.Echeance_souhaitee__c = schedule;
                }
                if(
                    origin != null && origin != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Origine__c.isCreateable()
                ) {
                    trainingRequest.Origine__c = origin;
                }
                if(
                    description != null && description != ''
                    && Schema.sObjectType.Demande_de_formation__c.fields.Description__c.isCreateable()
                ) {
                    trainingRequest.Description__c = description;
                }
                
                insert trainingRequest;
                if(options.useNotifications__c) NotificationManager.createNotification(String.valueOf(trainingRequest.Salarie__c), 
                                                           System.Label.SI_Notif_training_request_creation.replace('{0}', ''), 'Création', trainingRequest.Id);
                
                try {
                    Contact employee = [SELECT Id, Name, ReportsToId FROM Contact WHERE Id = :trainingRequest.Salarie__c];
                    if(options.useNotifications__c) {
                        NotificationManager.createNotification(String.valueOf(employee.ReportsToId), 
                                                               System.Label.SI_Notif_training_request_creation_manager.replace('{0}', employee.Name), 
                                                               'Interaction', trainingRequest.Id);
                    }
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_request_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_request_creation.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_request_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_request_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a Demande_de_formation__c object
* @param Id of the Demande_de_formation__c object to delete
* @return      'success' or an error message
*/
    webService static String deleteTrainingRequest(String requestId) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            Demande_de_formation__c trainingRequest = TrainingRequestRepository.getById(requestId);
            String module = (trainingRequest.Catalogue_de_formation__c != null) ? trainingRequest.Nom_du_catalogue__c : '';
            
            if (
                Schema.sObjectType.Demande_de_formation__c.isDeletable()
            ) {
                delete trainingRequest;
                if(options.useNotifications__c) {
                    NotificationManager.createNotification(String.valueOf(trainingRequest.Salarie__c), 
                                                           System.Label.SI_Notif_training_request_delete.replace('{0}', module), 'Suppression', null);
                }
                
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_request_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_request_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_training_request_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_request_delete.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Accepts a training request
* @param  requestId Id of the request to accept
* @return 'success' or an error message
*/
    webService static String acceptRequest(String requestId) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            Demande_de_formation__c trainingRequest = TrainingRequestRepository.getById(requestId);
            trainingRequest.Statut__c = '30 Acceptée';
            if(options.NoCheckOnCatalogOrSession__c) {
                if (
                    Schema.sObjectType.Demande_de_formation__c.isUpdateable()
                    && Schema.sObjectType.Demande_de_formation__c.fields.Statut__c.isUpdateable()
                ) {
                	update trainingRequest;
                
                    //Possibly create a notification if allowed "if(options.useNotifications__c)
                    
                    return 'success';
                } else {
                    return System.Label.Permission;
                }
            } else if(trainingRequest.Session_de_formation__c != null) { //If we have a training session
                Participation_session_formation__c trainingRegistration = new Participation_session_formation__c(
                    Session_de_formation__c = trainingRequest.Session_de_formation__c
                );
                
                //If we have a corresponding training action
                List<Action_de_formation__c> trainingActions = new List<Action_de_formation__c>();
                trainingActions = TrainingActionRepository.getAllPendingByContactAndModule(trainingRequest.Salarie__c, 
                                                                                           trainingRequest.Catalogue_de_formation__c);
                if(trainingActions.size() > 0) {
                    trainingRegistration.Action_de_formation__c = trainingActions[0].Id;
                    trainingActions[0].Statut__c = '20 Prévue';
                }

                if (
                    Schema.sObjectType.Participation_session_formation__c.isCreateable()
                    && Schema.sObjectType.Participation_session_formation__c.fields.Session_de_formation__c.isCreateable()
                    && Schema.sObjectType.Participation_session_formation__c.fields.Action_de_formation__c.isCreateable()

                    && Schema.sObjectType.Action_de_formation__c.isUpdateable()
                    && Schema.sObjectType.Action_de_formation__c.fields.Statut__c.isUpdateable()

                    && Schema.sObjectType.Demande_de_formation__c.isUpdateable()
                    && Schema.sObjectType.Demande_de_formation__c.fields.Statut__c.isUpdateable()
                ) {
                    insert trainingRegistration;
                    update trainingRequest;
                    update trainingActions;
                    
                    if(options.useNotifications__c) {
                        NotificationManager.createNotification(String.valueOf(trainingRequest.Salarie__c), 
                                                               System.Label.SI_Notif_training_request_accept.replace('{0}', 
                                                                                                                     trainingRequest.Nom_du_catalogue__c), 'Information', trainingRequest.Id);
                    }
                    return 'success';
                } else {
                    return System.Label.Permission;
                }
            } else if(trainingRequest.Catalogue_de_formation__c != null) {
                List<Action_de_formation__c> trainingActions = new List<Action_de_formation__c>();
                trainingActions = TrainingActionRepository.getAllPendingByContactAndModule(trainingRequest.Salarie__c, 
                                                                                           trainingRequest.Catalogue_de_formation__c);
                if(options.DoNotCreateAction__c) {
                    if (
                        Schema.sObjectType.Demande_de_formation__c.isUpdateable()
                        && Schema.sObjectType.Demande_de_formation__c.fields.Statut__c.isUpdateable()
                    ) {
                        update trainingRequest;
                        
                        if(options.useNotifications__c) {
                            NotificationManager.createNotification(
                                String.valueOf(trainingRequest.Salarie__c), 
                                System.Label.SI_Notif_training_request_accept.replace('{0}', trainingRequest.Nom_du_catalogue__c), 
                                'Information', 
                                trainingRequest.Id
                            );
                        }
                        return 'success';
                    } else {
                        return System.Label.Permission;
                    }
                } else if(trainingActions.size() == 0) {
                    Action_de_formation__c trainingAction = new Action_de_formation__c(
                        Contact__c = trainingRequest.Salarie__c,
                        Catalogue_de_formation__c = trainingRequest.Catalogue_de_formation__c
                    );
                    
                    if (
                        Schema.sObjectType.Action_de_formation__c.isCreateable()
                        && Schema.sObjectType.Action_de_formation__c.fields.Contact__c.isCreateable()
                        && Schema.sObjectType.Action_de_formation__c.fields.Catalogue_de_formation__c.isCreateable()

                        && Schema.sObjectType.Demande_de_formation__c.isUpdateable()
                        && Schema.sObjectType.Demande_de_formation__c.fields.Statut__c.isUpdateable()
                    ) {
                        insert trainingAction;
                        update trainingRequest;
                        
                        if(options.useNotifications__c) {
                            NotificationManager.createNotification(String.valueOf(trainingRequest.Salarie__c), 
                                                                   System.Label.SI_Notif_training_request_accept.replace('{0}', 
                                                                                                                         trainingRequest.Nom_du_catalogue__c), 'Information', trainingRequest.Id);
                        }
                        return 'success';
                    } else {
                        return System.Label.Permission;
                    }
                } else {
                    System.debug(System.Label.SI_Error_training_request_accept_existing_action);
                    return System.Label.SI_Error_training_request_accept_existing_action;
                }
            } else {
                System.debug(System.Label.SI_Error_training_request_accept_missing_module);
                return System.Label.SI_Error_training_request_accept_missing_module;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_request_accept.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_request_accept.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_training_request_accept.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_request_accept.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Rejects a training request
* @param  requestId Id of the request to reject
* @return 'success' or an error message
*/
    webService static String rejectRequest(String requestId) {
        TrainingModule__c options = TrainingModule__c.getInstance();
        try {
            Demande_de_formation__c trainingRequest = TrainingRequestRepository.getById(requestId);
            trainingRequest.Statut__c = '50 Refusée';
            
            if (
                Schema.sObjectType.Demande_de_formation__c.isUpdateable()
                && Schema.sObjectType.Demande_de_formation__c.fields.Statut__c.isUpdateable()
            ) {
                update trainingRequest;
                
                String module = (trainingRequest.Catalogue_de_formation__c != null) ? 
                    trainingRequest.Nom_du_catalogue__c : '';
                if(options.useNotifications__c) 
                    NotificationManager.createNotification(String.valueOf(trainingRequest.Salarie__c), 
                                                           System.Label.SI_Notif_training_request_reject.replace('{0}', module), 
                                                           'Information', 
                                                           trainingRequest.Id);
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_training_request_reject.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_training_request_reject.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_training_request_reject.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_training_request_reject.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Populates a select list with the types of training request.
* 
* @return List<SelectOption>
*/
    global static List<SelectOption> getRequestTypes(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult aField = Schema.SObjectType.Demande_de_formation__c.fields.Type_de_formation__c;
        List<Schema.PicklistEntry> values = aField.getPickListValues();
        for(Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel())); 
        }
        return options;
    }
}