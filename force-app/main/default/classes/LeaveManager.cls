//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Demande_de_conges__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class LeaveManager {
    /**
* Creates a Demande_de_conges__c object with datetime provided
* @param startDatetime  Start datetime of the leave (ISO format)
* @param endDatetime    End datetime of the leave (ISO format)
* @param leaveType      Type of leave. Id or String
* @param leaveTypeLabel Translated label of the type of leave
* @param contactId      Id of the contact for whom to create the leave
*
* @return           'success' or an error message
*/
    webService static String createWithTime(
        Datetime startDatetime, Datetime endDatetime, String leaveTypeString, 
        String leaveTypeLabel, String contactId
    ) {
        //Getting the proper leave type
        Type_d_absence__c leaveType;
        String type;
        timesheet__c timesheetOptions = timesheet__c.getInstance();
        try {
            leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                         FROM Type_d_absence__c 
                         WHERE Id = :leaveTypeString LIMIT 1];
            type = leaveType.Name;
        } catch(Exception e) {
            System.debug(e.getMessage());
            type = leaveTypeString;
        }
        try {
            if (
                Schema.sObjectType.Demande_de_conges__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Salarie__c.isCreateable()
            ) {
                Demande_de_conges__c leave = new Demande_de_conges__c(
                    Date_de_debut__c = startDatetime,
                    Date_de_fin__c = endDatetime,
                    Type__c = type,
                    Salarie__c = contactId
                );
                if(
                    timesheetOptions.useMetadata__c
                    && leaveType != null
                    && Schema.sObjectType.Demande_de_conges__c.fields.Notifier_manager__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Validation_manager__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Afficher_dans_le_planning__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Code_metadata__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Type_d_absence_liee__c.isCreateable()
                ) { //Transfering leave type data to leave
                    leave.Notifier_manager__c = leaveType.Notifier_manager__c;
                    leave.Validation_manager__c = leaveType.Validation_manager__c;
                    leave.Afficher_dans_le_planning__c = leaveType.Afficher_dans_le_planning__c;
                    leave.Code_metadata__c = leaveType.Code__c;
                    leave.Type_d_absence_liee__c = leaveType.Id;
                }
                
                Integer duration = leave.Date_de_debut__c.date().daysBetween(leave.Date_de_fin__c.date())+1;
                insert leave;
                String s = System.Label.SI_Notif_leave_request_creation
                    .replace('{1}', leaveTypeLabel)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', leave.Date_de_debut__c.format())
                    .replace('{4}', leave.Date_de_fin__c.format());
                NotificationManager.createNotification(contactId, s, 'Création', leave.Id);
                if((leaveType != null && leaveType.Notifier_manager__c) 
                   || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                       try {
                           Contact contact = [SELECT Id, Name, ReportsToId FROM Contact WHERE Id = :contactId];
                           s = System.Label.SI_Notif_leave_request_creation_manager
                               .replace('{0}', contact.Name)
                               .replace('{1}', leaveTypeLabel)
                               .replace('{2}', String.valueOf(duration))
                               .replace('{3}', leave.Date_de_debut__c.format())
                               .replace('{4}', leave.Date_de_fin__c.format());
                           if((leaveType != null && leaveType.Validation_manager__c) 
                              || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                                  NotificationManager.createNotification(String.valueOf(contact.ReportsToId), s, 'Interaction', 
                                                                         leave.Id);
                              } else {
                                  NotificationManager.createNotification(String.valueOf(contact.ReportsToId), s, 'Rappel', 
                                                                         leave.Id);
                              }
                       } catch(Exception e) {
                           System.debug(e.getMessage()+' : '+e.getLineNumber());
                       }
                   }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Creates a Demande_de_conges__c object with date provided
* @param startDate      Start date of the leave
* @param startPeriod    Start period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param endDate        End date of the leave
* @param endPeriod      End period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param leaveType      Type of leave
* @param leaveTypeLabel Translated label of the tpe of leave
* @param contactId      Id of the contact for whom the leave to create the leave
* @return           'success' or an error message
*/
    webService static String createWithoutTime(
        Date startDate, String startPeriod, Date endDate, String endPeriod, 
        String leaveTypeString, String leaveTypeLabel, String contactId
    ) {
        //Getting the proper leave type
        Type_d_absence__c leaveType;
        String type;
        timesheet__c timesheetOptions = timesheet__c.getInstance();
        try {
            leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                         FROM Type_d_absence__c 
                         WHERE Id = :leaveTypeString 
                         LIMIT 1];
            type = leaveType.Name;
        } catch(Exception e) {
            System.debug(Logginglevel.INFO, 'No Type_d_absence__c for ' + leaveTypeString + ', exception: '
                         + e.getMessage());
            type = leaveTypeString;
        }
        try {
            if (
                Schema.sObjectType.Demande_de_conges__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Periode__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Periode_de_fin__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Salarie__c.isCreateable()
            ) {
                Demande_de_conges__c leave = new Demande_de_conges__c(
                    Date_de_debut__c = leaveManager.convertStartdate(startDate, startPeriod, timesheetOptions),
                    Date_de_fin__c = leaveManager.convertEnddate(endDate, endPeriod, timesheetOptions),
                    Periode__c = startPeriod,
                    Periode_de_fin__c = endPeriod,
                    Type__c = type,
                    Salarie__c = contactId
                );
                if(
                    timesheetOptions.useMetadata__c && leaveType != null
                    && Schema.sObjectType.Demande_de_conges__c.fields.Notifier_manager__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Validation_manager__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Afficher_dans_le_planning__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Code_metadata__c.isCreateable()
                    && Schema.sObjectType.Demande_de_conges__c.fields.Type_d_absence_liee__c.isCreateable()
                ) {
                    leave.Notifier_manager__c = leaveType.Notifier_manager__c;
                    leave.Validation_manager__c = leaveType.Validation_manager__c;
                    leave.Afficher_dans_le_planning__c = leaveType.Afficher_dans_le_planning__c;
                    leave.Code_metadata__c = leaveType.Code__c;
                    leave.Type_d_absence_liee__c = leaveType.Id;
                }
                
                Integer duration = leave.Date_de_debut__c.date().daysBetween(leave.Date_de_fin__c.date())+1;
                insert leave;
                Demande_de_conges__c trans = [SELECT toLabel(Periode__c), toLabel(Periode_de_fin__c)
                                              FROM Demande_de_conges__c
                                              WHERE Id=: leave.Id][0];
                String s = System.Label.SI_Notif_leave_request_creation
                    .replace('{1}', leaveTypeLabel)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', leave.Date_de_debut__c.date().format()+' '+trans.Periode__c)
                    .replace('{4}', leave.Date_de_fin__c.date().format()+' '+trans.Periode_de_fin__c);
                NotificationManager.createNotification(contactId, s, 'Création', leave.Id);
                if((leaveType != null && leaveType.Notifier_manager__c) 
                   || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                       try {
                           Contact contact = [SELECT Id, Name, ReportsToId FROM Contact WHERE Id = :contactId];
                           s = System.Label.SI_Notif_leave_request_creation_manager
                               .replace('{0}', contact.Name)
                               .replace('{1}', leaveTypeLabel)
                               .replace('{2}', String.valueOf(duration))
                               .replace('{3}', leave.Date_de_debut__c.date().format()+' '+trans.Periode__c)
                               .replace('{4}', leave.Date_de_fin__c.date().format()+' '+trans.Periode_de_fin__c);
                           if((leaveType != null && leaveType.Validation_manager__c) 
                              || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                                  NotificationManager.createNotification(String.valueOf(contact.ReportsToId), s, 'Interaction', 
                                                                         leave.Id);
                              } else {
                                  NotificationManager.createNotification(String.valueOf(contact.ReportsToId), s, 'Rappel', 
                                                                         leave.Id);
                              }
                       } catch(Exception e) {
                           System.debug(e.getMessage()+' : '+e.getLineNumber());
                       }
                   }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_creation
                             .replace('{0}', e.getDmlMessage(0)+' '+e.getLineNumber()));
                return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_creation
                         .replace('{0}', e.getMessage()+' '+e.getLineNumber()));
            return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Updates a Demande_de_conges__c object with datetime provided
* @param startDatetime  Start datetime of the leave (ISO format)
* @param endDatetime    End datetime of the leave (ISO format)
* @param leaveType      Type of leave. Id or String
* @param leaveTypeLabel Translated label of the type of leave
* @param leaveId      Id of the leave to update
* @return           'success' or an error message
*/
    webService static String editWithTime(
        Datetime startDatetime, Datetime endDatetime, String leaveTypeString, 
        String leaveTypeLabel, String leaveId
    ) {
        //Getting the proper leave type
        Type_d_absence__c leaveType;
        String type;
        timesheet__c timesheetOptions = timesheet__c.getInstance();
        try {
            leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                         FROM Type_d_absence__c 
                         WHERE Id = :leaveTypeString LIMIT 1];
            type = leaveType.Name;
        } catch(Exception e) {
            System.debug(e.getMessage());
            type = leaveTypeString;
        }
        
        try {
            if (
                Schema.sObjectType.Demande_de_conges__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isUpdateable()
            ) {
                Demande_de_conges__c leave = leaveRepository.getUntranslatedById(leaveId);
                leave.Date_de_debut__c = startDatetime;
                leave.Date_de_fin__c = endDatetime;
                leave.Type__c = type;
                if(
                    timesheetOptions.useMetadata__c && leaveType != null
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Notifier_manager__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Validation_manager__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Afficher_dans_le_planning__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Code_metadata__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Type_d_absence_liee__c.isUpdateable()
                ) {
                    leave.Notifier_manager__c = leaveType.Notifier_manager__c;
                    leave.Validation_manager__c = leaveType.Validation_manager__c;
                    leave.Afficher_dans_le_planning__c = leaveType.Afficher_dans_le_planning__c;
                    leave.Code_metadata__c = leaveType.Code__c;
                    leave.Type_d_absence_liee__c = leaveType.Id;
                }
                
                Integer duration = leave.Date_de_debut__c.date().daysBetween(leave.Date_de_fin__c.date())+1;
                
                update leave;
                String s = System.Label.SI_Notif_leave_request_update
                    .replace('{1}', leaveTypeLabel)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', leave.Date_de_debut__c.format())
                    .replace('{4}', leave.Date_de_fin__c.format());
                NotificationManager.createNotification(leave.Salarie__c, s, 'Création', leave.Id);
                if((leaveType != null && leaveType.Notifier_manager__c) 
                   || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                       try {
                           s = System.Label.SI_Notif_leave_request_update_manager
                               .replace('{0}', leave.Salarie__r.Name)
                               .replace('{1}', leaveTypeLabel)
                               .replace('{2}', String.valueOf(duration))
                               .replace('{3}', leave.Date_de_debut__c.format())
                               .replace('{4}', leave.Date_de_fin__c.format());
                           if((leaveType != null && leaveType.Validation_manager__c) 
                              || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                                  NotificationManager.createNotification(leave.Salarie__r.ReportsToId, s, 'Interaction', 
                                                                         leave.Id);
                              } else {
                                  NotificationManager.createNotification(leave.Salarie__r.ReportsToId, s, 'Rappel', leave.Id);
                              }
                       } catch(Exception e) {
                           System.debug(e.getMessage()+' : '+e.getLineNumber());
                       }
                   }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_update.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_update.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_update.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_update.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Updates a Demande_de_conges__c object with date provided
* @param startDate      Start date of the leave
* @param startPeriod    Start period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param endDate        End date of the leave
* @param endPeriod      End period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param leaveType      Type of leave
* @param leaveTypeLabel Translated label of the type of leave
* @param leaveId      Id of the leave to update
* @return           'success' or an error message
*/
    webService static String editWithoutTime(
        Date startDate, String startPeriod, Date endDate, String endPeriod, 
        String leaveTypeString, String leaveTypeLabel, String leaveId
    ) {
        //Getting the proper leave type
        Type_d_absence__c leaveType;
        String type;
        timesheet__c timesheetOptions = timesheet__c.getInstance();
        try {
            leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                         FROM Type_d_absence__c 
                         WHERE Id = :leaveTypeString 
                         LIMIT 1];
            type = leaveType.Name;
        } catch(Exception e) {
            System.debug(e.getMessage());
            type = leaveTypeString;
        }
        
        try {
            
            if (
                Schema.sObjectType.Demande_de_conges__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Periode__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Periode_de_fin__c.isUpdateable()
            ) {
                Demande_de_conges__c leave = leaveRepository.getUntranslatedById(leaveId);
                leave.Date_de_debut__c = leaveManager.convertStartdate(startDate, startPeriod, timesheetOptions);
                leave.Date_de_fin__c = leaveManager.convertEnddate(endDate, endPeriod, timesheetOptions);
                leave.Type__c = type;
                leave.Periode__c = startPeriod;
                leave.Periode_de_fin__c = endPeriod;
                if(
                    timesheetOptions.useMetadata__c && leaveType != null
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Notifier_manager__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Validation_manager__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Afficher_dans_le_planning__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Code_metadata__c.isUpdateable()
                	&& Schema.sObjectType.Demande_de_conges__c.fields.Type_d_absence_liee__c.isUpdateable()
                ) {
                    leave.Notifier_manager__c = leaveType.Notifier_manager__c;
                    leave.Validation_manager__c = leaveType.Validation_manager__c;
                    leave.Afficher_dans_le_planning__c = leaveType.Afficher_dans_le_planning__c;
                    leave.Code_metadata__c = leaveType.Code__c;
                    leave.Type_d_absence_liee__c = leaveType.Id;
                }
                Integer duration = leave.Date_de_debut__c.date().daysBetween(leave.Date_de_fin__c.date())+1;
                
                update leave;
                
                Demande_de_conges__c trans = [SELECT toLabel(Periode__c), toLabel(Periode_de_fin__c)
                                              FROM Demande_de_conges__c
                                              WHERE Id=: leave.Id][0];
                NotificationManager.createNotification(leave.Salarie__c, System.Label.SI_Notif_leave_request_update
                                                       .replace('{1}', leaveTypeLabel)
                                                       .replace('{2}', String.valueOf(duration))
                                                       .replace('{3}', leave.Date_de_debut__c.date().format()+' '+trans.Periode__c)
                                                       .replace('{4}', leave.Date_de_fin__c.date().format()+' '+trans.Periode_de_fin__c), 'Création', 
                                                       leave.Id);
                if((leaveType != null && leaveType.Notifier_manager__c) 
                   || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                       try {
                           String s = System.Label.SI_Notif_leave_request_update_manager
                               .replace('{0}', leave.Salarie__r.Name)
                               .replace('{1}', leaveTypeLabel)
                               .replace('{2}', String.valueOf(duration))
                               .replace('{3}', leave.Date_de_debut__c.date().format()+' '+trans.Periode__c)
                               .replace('{4}', leave.Date_de_fin__c.date().format()+' '+trans.Periode_de_fin__c);
                           if((leaveType != null && leaveType.Validation_manager__c) 
                              || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                                  NotificationManager.createNotification(leave.Salarie__r.ReportsToId, s, 'Interaction', 
                                                                         leave.Id);
                              } else {
                                  NotificationManager.createNotification(leave.Salarie__r.ReportsToId, s, 'Rappel', leave.Id);
                              }
                       } catch(Exception e) {
                           System.debug(e.getMessage()+' : '+e.getLineNumber());
                       }
                   }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_update.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_update.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_update.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_update.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a Demande_de_conges__c object
* @param Id of the Demande_de_conges__c object to delete
* @return      'success' or an error message
*/
    webService static String deleteLeave(String leaveId) {
        try {
            Demande_de_conges__c request = LeaveRepository.getById(leaveId);
            Integer duration = request.Date_de_debut__c.date().daysBetween(request.Date_de_fin__c.date())+1;
            
            if (
                Schema.sObjectType.Demande_de_conges__c.isDeletable()
            ) {
                delete request;
            } else {
                return System.Label.Permission;
            }
            try {
                Contact employee = [SELECT Id, Name, ReportsToId FROM Contact WHERE Id = :request.Salarie__c];
                String s = System.Label.SI_Notif_leave_request_delete_manager
                    .replace('{0}', employee.Name)
                    .replace('{1}', request.Type__c)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', request.Date_de_debut__c.format())
                    .replace('{4}', request.Date_de_fin__c.format());
                NotificationManager.createNotification(String.valueOf(employee.ReportsToId), s, 'Suppression', null);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            String s = System.Label.SI_Notif_leave_request_delete
                .replace('{1}', request.Type__c)
                .replace('{2}', String.valueOf(duration))
                .replace('{3}', request.Date_de_debut__c.format())
                .replace('{4}', request.Date_de_fin__c.format());
            NotificationManager.createNotification(String.valueOf(request.Salarie__c), s, 'Suppression', null);
            
            return 'success';
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_delete.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Accepts a Demande_de_conges__c object
* @param leaveId Id of the leave to accept
*
* @return 'success' or an error message
*/
    webService static String acceptLeave(String leaveId) {
        try {
            timesheet__c timesheetOptions = timesheet__c.getInstance();
            if (
                Schema.sObjectType.Demande_de_conges__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Statut__c.isUpdateable()
            ) {
                Demande_de_conges__c request = LeaveRepository.getById(leaveId);
                request.Statut__c = timesheetOptions.acceptedValue__c;
                
                update request;
                Integer duration = request.Date_de_debut__c.date().daysBetween(request.Date_de_fin__c.date())+1;
                String s = System.Label.SI_Notif_leave_request_accepted
                    .replace('{1}', request.Type__c)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', request.Date_de_debut__c.format())
                    .replace('{4}', request.Date_de_fin__c.format());
                NotificationManager.createNotification(request.Salarie__c, s, 'Information', request.Id);
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_accepted.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_accepted.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_accepted.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_accepted.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Rejects a Demande_de_conges__c object
* @param leaveId Id of the leave to accept
*
* @return 'success' or an error message
*/
    webService static String rejectLeave(String leaveId) {
        try {
            timesheet__c timesheetOptions = timesheet__c.getInstance();
            
            if (
                Schema.sObjectType.Demande_de_conges__c.isUpdateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Statut__c.isUpdateable()
            ) {
                Demande_de_conges__c request = LeaveRepository.getById(leaveId);
                request.Statut__c = timesheetOptions.rejectedValue__c;
                
                update request;
                Integer duration = request.Date_de_debut__c.date().daysBetween(request.Date_de_fin__c.date())+1;
                String s = System.Label.SI_Notif_leave_request_rejected
                    .replace('{1}', request.Type__c)
                    .replace('{2}', String.valueOf(duration))
                    .replace('{3}', request.Date_de_debut__c.format())
                    .replace('{4}', request.Date_de_fin__c.format());
                NotificationManager.createNotification(String.valueOf(request.Salarie__c), s, 'Information', request.Id);
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_leave_request_rejected.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_leave_request_rejected.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_leave_request_rejected.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_leave_request_rejected.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Populates a select list with the types of leave.
*
* @return List<SelectOption>
*/
    global static List<SelectOption> getLeaveTypes(){
        timesheet__c timesheetOptions = timesheet__c.getInstance();
        List<SelectOption> options = new List<SelectOption>();
        if(timesheetOptions.useMetadata__c) {
            for(Type_d_absence__c a : [SELECT Id, Name FROM Type_d_absence__c Order By Name ASC]) {
                try {
                    String leaveLabel = [SELECT Translation__c 
                                         FROM Leave_type_translation__mdt 
                                         WHERE MasterLabel = :a.Name 
                                         AND language_code__c = :UserInfo.getLanguage().left(2)].Translation__c;
                    options.add(new SelectOption(a.Id, leaveLabel));
                } catch(Exception e) {
                    options.add(new SelectOption(a.Id, a.Name));
                }
            }
        } else {
            Schema.DescribeFieldResult aField = Schema.SObjectType.Demande_de_conges__c.fields.Type__c;
            List<Schema.PicklistEntry> values = aField.getPickListValues();
            for(Schema.PicklistEntry a : values) {
                options.add(new SelectOption(a.getValue(), a.getLabel()));
            }
        }
        
        return options;
    }
    
    /**
* Populates a select list with the periods.
*
* @return List<SelectOption>
*/
    global static List<SelectOption> getLeavePeriods(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult aField = Schema.SObjectType.Demande_de_conges__c.fields.Periode__c;
        List<Schema.PicklistEntry> values = aField.getPickListValues();
        for(Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel()));
        }
        
        return options;
    }
    
    
    /**
* Converts a start date to a start datetime based on the period provided
* @param      Start date of the leave
* @param    Start period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param Options providing the hours needed
* @return   Datetime
*/
    private static Datetime convertStartDate(Date startDate, String startPeriod, timesheet__c timesheetOptions) {
        if(startPeriod == 'Après-midi') {
            Integer startHour = Integer.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(0));
            Integer startMinute = Integer.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(1));
            
            Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
            return Datetime.newInstance(startDate, startTime);
        } else if(startPeriod == 'Matin') {
            Integer startHour = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(0));
            Integer startMinute = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(1));
            
            Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
            return Datetime.newInstance(startDate, startTime);
        } else {
            Integer startHour = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(0));
            Integer startMinute = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(1));
            
            Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
            return Datetime.newInstance(startDate, startTime);
        }
    }
    
    /**
* Converts a end date to a end datetime based on the period provided
* @param      End date of the leave
* @param    End period of the leave (i.e. Matin, Après-midi, Journée complète)
* @param Options providing the hours needed
* @return   Datetime
*/
    private static Datetime convertEndDate(Date endDate, String endPeriod, timesheet__c timesheetOptions) {
        if(endPeriod == 'Après-midi') {
            Integer endHour = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(0));
            Integer endMinute = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(1));
            
            Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
            return Datetime.newInstance(endDate, endTime);
        } else if(endPeriod == 'Matin') {
            Integer endHour = Integer.valueOf(timesheetOptions.endHourMorning__c.split(':').get(0));
            Integer endMinute = Integer.valueOf(timesheetOptions.endHourMorning__c.split(':').get(1));
            
            Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
            return Datetime.newInstance(endDate, endTime);
        } else {
            Integer endHour = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(0));
            Integer endMinute = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(1));
            
            Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
            return Datetime.newInstance(endDate, endTime);
        }
    }
}