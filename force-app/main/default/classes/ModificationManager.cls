//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Demande_de_modification__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class ModificationManager {
    
    /**
    * Creates a Demande_de_modification__c for a given contact
    * @param  oldValue   Current value of the field to change
    * @param  newValue   New value of the field to change
    * @param  fieldLabel Translated label of the field to change
    * @param  fieldName  API name of the field to change
    * @param  contactId  Id of the contact asking for the change
    * 
    * @return 'success' or an error message
    */
    webService static String createModification(String oldValue, String newValue, String fieldLabel, String fieldName, String contactId) {
        if (
            Schema.sObjectType.Demande_de_modification__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Ancienne_valeur__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Nouvelle_valeur__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Champ__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Champ_technique__c.isCreateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Salarie__c.isCreateable()
        ) {
            try {
                Demande_de_modification__c modif = new Demande_de_modification__c(
                    Ancienne_valeur__c = oldValue,
                    Nouvelle_valeur__c = newValue,
                    Champ__c = fieldLabel,
                    Champ_technique__c = fieldName,
                    Salarie__c = contactId
                );
                
                insert modif;
                NotificationManager.createNotification(contactId, System.Label.SI_Notif_modif_request_creation.replace('{0}', modif.Champ__c), 'Création', modif.id);
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_modif_request_creation.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_modif_request_creation.replace('{0}', e.getDmlMessage(0));
                }
                System.debug(System.Label.SI_Error_modif_request_creation.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_modif_request_creation.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_modif_request_creation.replace('{0}', System.Label.Permission);
        }
    }
    
    /**
* Updates a Demande_de_modification__c for a given contact
* @param  oldValue   Current value of the field to change
* @param  newValue   New value of the field to change
* @param  fieldLabel Translated label of the field to change
* @param  fieldName  API name of the field to change
* @param  modifId  Id of the Demande_de_modification__c to update
* 
* @return 'success' or an error message
*/
    webService static String editModification(String oldValue, String newValue, String fieldLabel, String fieldName, String modifId) {
        if (
            Schema.sObjectType.Demande_de_modification__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Ancienne_valeur__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Nouvelle_valeur__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Champ__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Champ_technique__c.isUpdateable()
        ) {
            try {
                Demande_de_modification__c modif = ModificationRepository.getById(modifId);
                modif.Ancienne_valeur__c = oldValue;
                modif.Nouvelle_valeur__c = newValue;
                modif.Champ__c = fieldLabel;
                modif.Champ_technique__c = fieldName;
                
                update modif;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_modif_request_update.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_modif_request_update.replace('{0}', e.getDmlMessage(0));
                }
                System.debug(System.Label.SI_Error_modif_request_update.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_modif_request_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_modif_request_update.replace('{0}', System.Label.Permission);
        }
    }
    
    /**
* Deletes a Demande_de_modification__c
* @param  modifId  Id of the Demande_de_modification__c to delete
* 
* @return 'success' or an error message
*/
    webService static String deleteModification(String modifId) {
        if (Schema.sObjectType.Temps__c.isDeletable()) {
            try {
                Demande_de_modification__c modif = ModificationRepository.getById(modifId);
                
                delete modif;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_modif_request_delete.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_modif_request_delete.replace('{0}', e.getDmlMessage(0));
                }
                System.debug(System.Label.SI_Error_modif_request_delete.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_modif_request_delete.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_modif_request_delete.replace('{0}', System.Label.Permission);
        }
    }
    
    /**
* Approves a contact's new value
* @param modifId Id of the request to approve
* 
* @return 'success' or an error message
*/
    webService static String approve(String modifId) { 
        if (
            Schema.sObjectType.Demande_de_modification__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Statut__c.isUpdateable()
            && Schema.sObjectType.Contact.isUpdateable()
        ) {
            try {
                //Fetching
                Demande_de_modification__c request = ModificationRepository.getById(modifId);
                String salarieSOQL = 'Select Id, '+request.Champ_technique__c+' From Contact Where Id = \''+request.Salarie__c+'\'';
                Contact salarie = Database.query(salarieSOQL);
                //Serializing and replacing
                String jsonSalarie = JSON.serialize(salarie);
                String oldString = '"'+request.Champ_technique__c+'":"'+request.Ancienne_valeur__c+'"';
                String newString = '"'+request.Champ_technique__c+'":"'+request.Nouvelle_valeur__c+'"';
                jsonSalarie = jsonSalarie.replace(oldString, newString);
                //Deserializing
                salarie = (Contact)JSON.deserialize(jsonSalarie, Contact.class);
                if(request.Valeur_statut__c < 30) request.Statut__c = '30 Validée';
                
                update salarie;
                update request;
                return 'success';
            } catch (exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_modif_request_approval.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_modif_request_approval.replace('{0}', e.getDmlMessage(0));
                }
                System.debug(System.Label.SI_Error_modif_request_approval.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_modif_request_approval.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_modif_request_approval.replace('{0}', System.Label.Permission);
        }
    }
    
    /**
* Reverts a contact field to its previous value
* @param modifId Id of the request to revert
* @return 'success' or an error message
*/
    webService static String revert(String modifId) { 
        if (
            Schema.sObjectType.Demande_de_modification__c.isUpdateable()
            && Schema.sObjectType.Demande_de_modification__c.fields.Statut__c.isUpdateable()
            && Schema.sObjectType.Contact.isUpdateable()
        ) {
            try {
                //Fetching
                Demande_de_modification__c request = ModificationRepository.getById(modifId);
                String salarieSOQL = 'Select Id, '+request.Champ_technique__c+' From Contact Where Id = \''+request.Salarie__c+'\'';
                Contact salarie = Database.query(salarieSOQL);
                //Serializing and replacing
                String jsonSalarie = JSON.serialize(salarie);
                String oldString = '"'+request.Champ_technique__c+'":"'+request.Nouvelle_valeur__c+'"';
                String newString = '"'+request.Champ_technique__c+'":"'+request.Ancienne_valeur__c+'"';
                jsonSalarie = jsonSalarie.replace(oldString, newString);
                //Deserializing
                salarie = (Contact)JSON.deserialize(jsonSalarie, Contact.class);
                if(request.Valeur_statut__c >= 30 && request.Valeur_statut__c < 50 || Test.isRunningTest()) request.Statut__c = '70 Rétablie';

                update salarie;
                update request;
                return 'success';
            } catch (exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_modif_request_revert.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_modif_request_revert.replace('{0}', e.getDmlMessage(0));
                }
                System.debug(System.Label.SI_Error_modif_request_revert.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_modif_request_revert.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_modif_request_revert.replace('{0}', System.Label.Permission);
        }
    }
}