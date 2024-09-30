//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the SIRH_Notification__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class NotificationManager {
    
    public static String createNotification(String contact, String text, String type, String objectId) {
        System.debug('I hit the new createNotification.');
        String objectName = null;
        if(!String.isBlank(objectId) && objectId.length()>2) {
            objectName = BaseRepository.findObjectNameFromRecordIdPrefix(objectId);
        }
        return createNotification(contact, text, type, objectName, objectId);
    }
    
    public static String editNotification(String text, String type, String objectId, String notifId) {
        System.debug('I hit the new editNotification.');
        String objectName = null;
        if(!String.isBlank(objectId) && objectId.length()>2) {
            objectName = BaseRepository.findObjectNameFromRecordIdPrefix(objectId);
        }
        return editNotification(text, type, objectName, objectId, notifId);
    }
    
    /**
* Felix, 20/4/2017: DO NOT USE FROM INSIDE OF THE PACKAGE! This is a legacy. Use the method with the same
* name taking no objectName instead. This is safer, not redundant and, more importantly, works in an environment 
* with and without namespace.
*
* Creates a SIRH_Notification__c object to be displayed on the frontend
* @param contact       Id of the contact
* @param text          Text of the notification
* @param type          Type of the notification (e.g. Création, Suppression...)
* @param objectName    Optional. API name of the object related to the notification
* @param objectId      Optional. Id of the object related to the notification
*
* @return 'success' or an error message
*/
    webService static String createNotification(String contact, String text, String type, String objectName, String objectId) {
        try {
            if(!Schema.sObjectType.SIRH_Notification__c.fields.Salarie__c.isCreateable()
               || !Schema.sObjectType.SIRH_Notification__c.fields.Texte__c.isCreateable()
               || !Schema.sObjectType.SIRH_Notification__c.fields.Type__c.isCreateable()
               || !Schema.sObjectType.SIRH_Notification__c.fields.Objet__c.isCreateable()
               || !Schema.sObjectType.SIRH_Notification__c.fields.Id_de_l_objet__c.isCreateable()
              ) {
                  // TODO: label instead of English literal
                  System.debug(System.Label.SI_Error_notif_creation.replace('{0}', 'User does not have sufficient rights.'));
                  return System.Label.SI_Error_notif_creation.replace('{0}', 'User does not have sufficient rights.');
              }
            SIRH_Notification__c notif = new SIRH_Notification__c(
                Salarie__c = contact,
                Texte__c = text,
                Type__c = type
            );
            if(objectName != null && objectId != null) {
                notif.Objet__c = objectName;
                notif.Id_de_l_objet__c = objectId;
            }
            insert notif;
            return 'success';
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_notif_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_notif_creation.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_notif_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_notif_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Felix, 20/4/2017: DO NOT USE FROM INSIDE OF THE PACKAGE! This is a legacy. Use the method with the same
* name taking no objectName instead. This is safer, not redundant and, more importantly, works in an environment 
* with and without namespace.
*
* Updates a SIRH_Notification__c object
* @param text          Text of the notification
* @param type          Type of the notification (e.g. Création, Suppression...)
* @param objectName    Optional. API name of the object related to the notification
* @param objectId      Optional. Id of the object related to the notification
* @param notifId      Id of the notification to update
*
* @return 'success' or an error message
*/
    webService static String editNotification(String text, String type, String objectName, String objectId, String notifId) {
        if(!Schema.sObjectType.SIRH_Notification__c.fields.Texte__c.isUpdateable()
           || !Schema.sObjectType.SIRH_Notification__c.fields.Type__c.isUpdateable()
           || !Schema.sObjectType.SIRH_Notification__c.fields.Objet__c.isUpdateable()
           || !Schema.sObjectType.SIRH_Notification__c.fields.Id_de_l_objet__c.isUpdateable()) {
               System.debug('User does not have sufficient rights.');
               return System.Label.SI_Error_notif_update.replace('{0}', 'User does not have sufficient rights.');
           }
        try {
            SIRH_Notification__c notif = NotificationRepository.getById(notifId);
            notif.Texte__c = text;
            notif.Type__c = type;
            if(objectName != null && objectId != null) {
                notif.Objet__c = objectName;
                notif.Id_de_l_objet__c = objectId;
            }
            update notif;
            return 'success';
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_notif_update.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_notif_update.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_notif_update.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_notif_update.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a SIRH_Notification__c object
* @param notifId Id of the notification
* 
* @return 'success' or an error message
*/
    webService static String deleteNotification(String notifId) {
        try {
            SIRH_Notification__c notification = NotificationRepository.getById(notifId);
            if (
                Schema.sObjectType.SIRH_Notification__c.isDeletable()
            ) {
                delete notification;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_notif_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_notif_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_notif_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_notif_delete.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Marks a SIRH_Notification__c object as read
* @param notifId Id of the notification
* 
* @return 'success' or an error message
*/
    webService static String markAsRead(String notifId) {
        try {
            SIRH_Notification__c notification = NotificationRepository.getById(notifId);
            if (
                Schema.sObjectType.SIRH_Notification__c.isUpdateable()
                && Schema.sObjectType.SIRH_Notification__c.fields.Lu__c.isUpdateable()
            ) {
                notification.Lu__c = true;
                update notification;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_notif_read.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_notif_read.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_notif_read.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_notif_read.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Marks a SIRH_Notification__c object as unread
* @param notifId Id of the notification
* 
* @return 'success' or an error message
*/
    webService static String markAsUnread(String notifId) {
        try {
            SIRH_Notification__c notification = NotificationRepository.getById(notifId);
            if (
                Schema.sObjectType.SIRH_Notification__c.isUpdateable()
                && Schema.sObjectType.SIRH_Notification__c.fields.Lu__c.isUpdateable()
            ) {
                notification.Lu__c = false;
                update notification;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_notif_unread.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_notif_unread.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_notif_unread.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_notif_unread.replace('{0}', e.getMessage());
        }
    }
}