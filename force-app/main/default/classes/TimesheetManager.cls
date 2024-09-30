//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Manager class for the Feuille_Temps_Hebdo__c object
 * @author Crosstalent
 * @group SIRH-Manager
 */
global with sharing class TimesheetManager {

    /**
     * Creates a Feuille_Temps_Hebdo__c object
     * @param startDate Start date of the timesheet (ISO format)
     * @param endDate End date of the timesheet (ISO format)
     * @param contactId Id of the contact for whom the Feuille_Temps_Hebdo__c will be created
     * 
     * @return String 'success' or an error message
     */
    webService static String createTimesheet(Date startDate, Date endDate, String contactId) {
        try {
            Feuille_Temps_Hebdo__c week = new Feuille_Temps_Hebdo__c(
                    Date_debut_semaine__c = startDate,
                    Date_de_fin__c = endDate,
                    Salarie__c = contactId
                    );
            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_debut_semaine__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Salarie__c.isCreateable()
            ) {
                insert week;
            } else {
                return System.Label.Permission; 
            }

            NotificationManager.createNotification(contactId, System.Label.SI_Notif_timesheet_creation, 'Création', week.Id);
            return 'success';
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_creation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_creation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Creates a Feuille_Temps_Hebdo__c object where date are not the boundary dates of the timesheet
     * @param startDate Start date provided (ISO format)
     * @param endDate End date provided (ISO format)
     * @param contactId Id of the contact for whom the Feuille_Temps_Hebdo__c will be created
     * 
     * @return String 'success' or an error message
     */
    webService static String createWeeklyTimesheet(Date startDate, Date endDate, String contactId) {
        Date startingDate = startDate.toStartOfWeek();
        Date endingDate = endDate.toStartOfWeek().addDays(6);

        return TimesheetManager.createTimesheet(startingDate, endingDate, contactId);
    }

    /**
     * Updates a Feuille_Temps_Hebdo__c object
     * @param startDate Start date of the timesheet (ISO format)
     * @param endDate End date of the timesheet (ISO format)
     * @param timesheetId Id of the Feuille_Temps_Hebdo__c to update
     * 
     * @return String 'success' or an error message
     */
    webService static String editTimesheet(Date startDate, Date endDate, String timesheetId) {
        try {
            Feuille_Temps_Hebdo__c week = TimesheetRepository.getById(timesheetId);
            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_debut_semaine__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_de_fin__c.isUpdateable()
            ) {
                week.Date_debut_semaine__c = startDate;
                week.Date_de_fin__c = endDate;
    
                update week;
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_update.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_update.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_update.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_update.replace('{0}', e.getMessage());
        }
    }

    /**
     * Deletes a Feuille_Temps_Hebdo__c object
     * @param timesheetId Id of the Feuille_Temps_Hebdo__c to delete
     * 
     * @return String 'success' or an error message
     */
    webService static String deleteTimesheet(String timesheetId) {
        try {
            Feuille_Temps_Hebdo__c week = TimesheetRepository.getById(timesheetId);

            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isDeletable()
            ) {
                delete week;
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_delete.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_delete.replace('{0}', e.getMessage());
        }
    }

    /**
     * Retrieves a timesheet matching contact and dates
     * or creates one if none were
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * 
     * @return  Feuille_Temps_Hebdo__c Retrieved or newly created Feuille_Temps_Hebdo__c
     */
    webService static Feuille_Temps_Hebdo__c findOrCreateTimesheet(Date startDate, Date endDate, String contactId) {
        Feuille_Temps_Hebdo__c newSheet;
        List<Feuille_Temps_Hebdo__c> timesheet = TimesheetRepository.getAllByContactForDate(contactId, startDate);
        if(timesheet.size() == 0) { //Creating a timesheet if none were retrieved
            try {
                newSheet = new  Feuille_Temps_Hebdo__c(
                        Salarie__c = contactId,
                        Date_debut_semaine__c = startDate.toStartOfWeek(),
                        Date_de_fin__c = endDate.toStartOfWeek().addDays(6)
                        );
                
                if (
                    Schema.sObjectType.Feuille_Temps_Hebdo__c.isCreateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_debut_semaine__c.isCreateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_de_fin__c.isCreateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Salarie__c.isCreateable()
                ) {
                    insert newSheet;
                } else {
                    System.debug(System.Label.Permission); 
                }
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_week_creation.replace('{0}', e.getDmlMessage(0)));
                } 
                System.debug(System.Label.SI_Error_week_creation.replace('{0}', e.getMessage()));
            }
        } else { 
            newSheet = timesheet.get(0);
        }

        return newSheet;
    }

    /**
     * Validates all pending Feuille_Temps_Hebdo__c for a given contact between given dates
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * 
     * @return 'success' or an error message
     */
    webService static String validateTimesheet(Date startDate, Date endDate, String contactId) {
        try { //Retrieving the pending displayed timesheets
            List<Feuille_Temps_Hebdo__c> plannings = TimesheetRepository.getAllPendingByContactBetweenDates(contactId, startDate, endDate);
            if(plannings.size() > 0) {
                for(Feuille_Temps_Hebdo__c planning: plannings) {
                    planning.Statut__c = '20 Validée par le collaborateur';
                    planning.Date_Validation_Collaborateur__c = System.today();
                }
                if (
                    Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Collaborateur__c.isUpdateable()
                ) {
                	update plannings;

                    String s = System.Label.SI_Notif_week_validation.replace('{0}', startDate.format()).replace('{1}', endDate.format());
                    NotificationManager.createNotification(plannings[0].Salarie__c, s, 'Information', plannings[0].id);
                    s = System.Label.SI_Notif_week_validation_manager.replace('{0}', startDate.format()).replace('{1}', endDate.format()).replace('{2}', plannings[0].Salarie__r.Name);
                    NotificationManager.createNotification(plannings[0].Salarie__r.ReportsToId, s, 'Interaction', plannings[0].id);
                    return 'success';
                } else {
                    return System.Label.Permission; 
                }
            } else {
                System.debug(System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format()));
                return System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format());
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_validation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_validation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_validation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_validation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Accepts all validated Feuille_Temps_Hebdo__c for a given contact between given dates
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param comment Comment for the Feuille_Temps_Hebdo__c
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * 
     * @return 'success' or an error message
     */
    webService static String acceptTimesheet(Date startDate, Date endDate, String comment, String contactId) {
        try {
            List<Feuille_Temps_Hebdo__c> plannings = TimesheetRepository.getAllValidatedByContactBetweenDates(contactId, startDate, endDate);
            if(plannings.size() > 0) {
                for(Feuille_Temps_Hebdo__c planning: plannings) {
                    planning.Statut__c = '90 Validée par le manager';
                    planning.Commentaire__c = comment;
                    planning.Date_Validation_Manager__c = System.today();
                }
                
                if (
                    Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Commentaire__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Manager__c.isUpdateable()
                ) {
                	update plannings;

                    NotificationManager.createNotification(plannings[0].Salarie__c, System.Label.SI_Notif_week_accept.replace('{0}', startDate.format()).replace('{1}', endDate.format()), 'Information', plannings[0].id);
                    return 'success';
                } else {
                    return System.Label.Permission; 
                }
            } else {
                System.debug(System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format()));
                return System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format());
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_accept.replace('{0}', e.getMessage());
        }
    }

    /**
     * Rejects all validated Feuille_Temps_Hebdo__c for a given contact between given dates
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param comment Comment for the Feuille_Temps_Hebdo__c
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * 
     * @return 'success' or an error message
     */
    webService static String rejectTimesheet(Date startDate, Date endDate, String comment, String contactId) {
        try {
            List<Feuille_Temps_Hebdo__c> plannings = TimesheetRepository.getAllValidatedByContactBetweenDates(contactId, startDate, endDate);
            if(plannings.size() > 0) {
                for(Feuille_Temps_Hebdo__c planning: plannings) {
                    planning.Statut__c = '15 Correction demandée par le manager';
                    planning.Commentaire__c = comment;
                    planning.Date_Validation_Manager__c = System.today();
                }
                
                if (
                    Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Commentaire__c.isUpdateable()
                    && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Manager__c.isUpdateable()
                ) {
                	update plannings;

                    NotificationManager.createNotification(plannings[0].Salarie__c, System.Label.SI_Notif_week_accept.replace('{0}', startDate.format()).replace('{1}', endDate.format()), 'Information', plannings[0].id);
                	return 'success';
                } else {
                    return System.Label.Permission; 
                }
            } else {
                System.debug(System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format()));
                return System.Label.SI_Error_week_empty.replace('{0}', startDate.format()).replace('{1}', endDate.format());
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_accept.replace('{0}', e.getMessage());
        }
    }

    /**
     * Validates the given Feuille_Temps_Hebdo__c
     * @param timesheetId Id of the Feuille_Temps_Hebdo__c
     * 
     * @return 'success' or an error message
     */
    webService static String validateTimesheetById(String timesheetId) {
        try {
            Feuille_Temps_Hebdo__c planning = TimesheetRepository.getById(timesheetId);
            planning.Statut__c = '20 Validée par le collaborateur';
            planning.Date_Validation_Collaborateur__c = System.today();

            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Collaborateur__c.isUpdateable()
            ) {
                update planning;
                
                NotificationManager.createNotification(planning.Salarie__c, System.Label.SI_Notif_week_validation.replace('{0}', planning.Date_debut_semaine__c.format()).replace('{1}', planning.Date_de_fin__c.format()), 'Information', planning.id);
            	NotificationManager.createNotification(planning.Salarie__r.ReportsToId, System.Label.SI_Notif_week_validation_manager.replace('{0}', planning.Date_debut_semaine__c.format()).replace('{1}', planning.Date_de_fin__c.format()).replace('{2}', planning.Salarie__r.Name), 'Interaction', planning.id);
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_validation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_validation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_validation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_validation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Accepts the given Feuille_Temps_Hebdo__c
     * @param comment Comment for the Feuille_Temps_Hebdo__c
     * @param timesheetId Id of the Feuille_Temps_Hebdo__c
     * 
     * @return 'success' or an error message
     */
    webService static String acceptTimesheetById(String comment, String timesheetId) {
        try {
            Feuille_Temps_Hebdo__c planning = TimesheetRepository.getById(timesheetId);
            planning.Statut__c = '90 Validée par le manager';
            planning.Date_Validation_Collaborateur__c = System.today();
            
            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Collaborateur__c.isUpdateable()
            ) {
                update planning;
                
                NotificationManager.createNotification(planning.Salarie__c, System.Label.SI_Notif_week_accept.replace('{0}', planning.Date_debut_semaine__c.format()).replace('{1}', planning.Date_de_fin__c.format()), 'Information', planning.id);
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_accept.replace('{0}', e.getMessage());
        }
    }

    /**
     * Rejects the given Feuille_Temps_Hebdo__c
     * @param comment Comment for the Feuille_Temps_Hebdo__c
     * @param timesheetId Id of the Feuille_Temps_Hebdo__c
     * 
     * @return 'success' or an error message
     */
    webService static String rejectTimesheetById(String comment, String timesheetId) {
        try {
            Feuille_Temps_Hebdo__c planning = TimesheetRepository.getById(timesheetId);
            planning.Statut__c = '15 Correction demandée par le manager';
            planning.Commentaire__c = comment;
            planning.Date_Validation_Collaborateur__c = System.today();
            
            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Statut__c.isUpdateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_Validation_Collaborateur__c.isUpdateable()
            ) {
                update planning;
                
                NotificationManager.createNotification(planning.Salarie__c, System.Label.SI_Notif_week_accept.replace('{0}', planning.Date_debut_semaine__c.format()).replace('{1}', planning.Date_de_fin__c.format()), 'Information', planning.id);
            return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_week_accept.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_week_accept.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_week_accept.replace('{0}', e.getMessage());
        }
    }
}