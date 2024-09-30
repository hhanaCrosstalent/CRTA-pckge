//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Manager class for the Temps__c object
 * @author Crosstalent
 * @group SIRH-Manager
 */
global with sharing class TimeManager {
    /**
     * Creates a Temps__c object 
     * @param  startDate Date of the Temps__c
     * @param  startTime Starting hour of the Temps__c
     * @param  endTime   Ending hour of the Temps__c
     * @param  type      Type of the Temps__c
     * @param  contactId Id of the contact for whom to create the Temps__c
     * 
     * @return   String 'success' or an error message
     */
    webService static String createWithTime(Date startDate, String startTime, String endTime, String type, String contactId) {
        if (
            Schema.sObjectType.Temps__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Feuille_hebdo__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Date__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_debut__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_fin__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Type__c.isCreateable()
        ) {
            try {
                Feuille_Temps_Hebdo__c newSheet = TimesheetManager.findOrCreateTimesheet(startDate, startDate, contactId);
                Temps__c timeSlot = new Temps__c(
                    Feuille_hebdo__c = newSheet.Id,
                    Date__c = startDate,
                    Heure_de_debut__c = startTime,
                    Heure_de_fin__c = endTime,
                    Type__c = type
                );
                
                insert timeSlot;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_time_creation.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_time_creation.replace('{0}', e.getDmlMessage(0));
                } 
                System.debug(System.Label.SI_Error_time_creation.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_time_creation.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_time_creation.replace('{0}', System.Label.Permission);
        }
    }

    /**
     * Updates a Temps__c object
     * @param  startDate Date of the Temps__c
     * @param  startTime Starting hour of the Temps__c
     * @param  endTime   Ending hour of the Temps__c
     * @param  type      Type of the Temps__c
     * @param  timeId    Id of the Temps__c to update
     * 
     * @return   String   'success' or an error message
     */
    webService static String editWithTime(Date startDate, String startTime, String endTime, String type, String timeId) {
        if (
            Schema.sObjectType.Temps__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Date__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_debut__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_fin__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Type__c.isUpdateable()
        ) {
            try {
                Temps__c timeSlot = TimeRepository.getById(timeId);
                timeSlot.Date__c = startDate;
                timeSlot.Heure_de_debut__c = startTime;
                timeSlot.Heure_de_fin__c = endTime;
                timeSlot.Type__c = type;
    
                update timeSlot;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_time_update.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_time_update.replace('{0}', e.getDmlMessage(0));
                } 
                System.debug(System.Label.SI_Error_time_update.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_time_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_time_update.replace('{0}', System.Label.Permission);
        }
    }

    /**
     * Creates a Temps__c object 
     * @param  startDate Date of the Temps__c
     * @param  period Period of the Temps__c (i.e. Matin, Après-midi, Journée complète)
     * @param  type      Type of the Temps__c
     * @param  contactId Id of the contact for whom to create the Temps__c
     * 
     * @return   String 'success' or an error message
     */
    webService static String createWithoutTime(Date startDate, String period, String type, String contactId) {
        if (
            Schema.sObjectType.Temps__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Feuille_hebdo__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Date__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_debut__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_fin__c.isCreateable()
            && Schema.sObjectType.Temps__c.fields.Type__c.isCreateable()
        ) {
            timesheet__c timesheetOptions = timesheet__c.getInstance();
            try {
                Feuille_Temps_Hebdo__c newSheet = TimesheetManager.findOrCreateTimesheet(startDate, startDate, contactId);
    
                Temps__c timeSlot = new Temps__c(
                    Feuille_hebdo__c = newSheet.Id,
                    Date__c = startDate,
                    Heure_de_debut__c = TimeManager.createStartTime(period, timesheetOptions),
                    Heure_de_fin__c = TimeManager.createEndTime(period, timesheetOptions),
                    Type__c = type
                );
    
                insert timeSlot;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_time_creation.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_time_creation.replace('{0}', e.getDmlMessage(0));
                } 
                System.debug(System.Label.SI_Error_time_creation.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_time_creation.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_time_creation.replace('{0}', System.Label.Permission);
        }
    }

    /**
     * Updates a Temps__c object
     * @param  startDate Date of the Temps__c
     * @param  period Period of the Temps__c (i.e. Matin, Après-midi, Journée complète)
     * @param  type      Type of the Temps__c
     * @param  timeId    Id of the Temps__c to update
     * 
     * @return   String   'success' or an error message
     */
    webService static String editWithoutTime(Date startDate, String period, String type, String timeId) {
        if (
            Schema.sObjectType.Temps__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Date__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_debut__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Heure_de_fin__c.isUpdateable()
            && Schema.sObjectType.Temps__c.fields.Type__c.isUpdateable()
        ) {
            timesheet__c timesheetOptions = timesheet__c.getInstance();
            try {
                Temps__c timeSlot = TimeRepository.getById(timeId);
                timeSlot.Date__c = startDate;
                timeSlot.Heure_de_debut__c = TimeManager.createStartTime(period, timesheetOptions);
                timeSlot.Heure_de_fin__c = TimeManager.createEndTime(period, timesheetOptions);
                timeSlot.Type__c = type;
    
                update timeSlot;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_time_update.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_time_update.replace('{0}', e.getDmlMessage(0));
                } 
                System.debug(System.Label.SI_Error_time_update.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_time_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_time_update.replace('{0}', System.Label.Permission);
        }
    }

    /**
     * Deletes a Temps__c object
     * @param String timeId Id of the Temps__c to delete
     * 
     * @return String 'success' or an error message
     */
    webService static String deleteTime(String timeId) {
        if (Schema.sObjectType.Temps__c.isDeletable()) {
            try {
                Temps__c temps = TimeRepository.getById(timeId);
                delete temps;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    System.debug(System.Label.SI_Error_time_delete.replace('{0}', e.getDmlMessage(0)));
                    return System.Label.SI_Error_time_delete.replace('{0}', e.getDmlMessage(0));
                } 
                System.debug(System.Label.SI_Error_time_delete.replace('{0}', e.getMessage()));
                return System.Label.SI_Error_time_delete.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_time_delete.replace('{0}', System.Label.Permission);
        }
    }

    /**
     * Populates a select list with the types of time.
     * @return The types
     */
    global static List<SelectOption> getTimeTypes(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult aField = Schema.SObjectType.Temps__c.fields.Type__c;
        List<Schema.PicklistEntry> values = aField.getPickListValues();
        for(Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel())); 
        }
        return options;
    }

    /**
     * Creates a start time based on the period provided
     * @param  period    Start period of the Temps__c (i.e. Matin, Après-midi, Journée complète)
     * @param  timesheetOptions Options providing the hours needed
     * @return   String
     */
    private static String createStartTime(String period, timesheet__c timesheetOptions) {
        String startTime;
        if(period == 'Après-midi') { //Creating start and end times for the chosen period
            String startHour = String.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(0));
            String startMinute = String.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(1));

            startTime = startHour+':'+startMinute;
        } else if(period == 'Matin') {
            String startHour = String.valueOf(timesheetOptions.startHour__c.split(':').get(0));
            String startMinute = String.valueOf(timesheetOptions.startHour__c.split(':').get(1));

            startTime = startHour+':'+startMinute;
        } else {
            String startHour = String.valueOf(timesheetOptions.startHour__c.split(':').get(0));
            String startMinute = String.valueOf(timesheetOptions.startHour__c.split(':').get(1));

            startTime = startHour+':'+startMinute;
        }

        return startTime;
    }

    /**
     * Creates a end time based on the period provided
     * @param  period    End period of the Temps__c (i.e. Matin, Après-midi, Journée complète)
     * @param  timesheetOptions Options providing the hours needed
     * @return   String
     */
    private static String createEndTime(String period, timesheet__c timesheetOptions) {
        String endTime;
        if(period == 'Après-midi') { //Creating start and end times for the chosen period
            String endHour = String.valueOf(timesheetOptions.endHour__c.split(':').get(0));
            String endMinute = String.valueOf(timesheetOptions.endHour__c.split(':').get(1));

            endTime = endHour+':'+endMinute;
        } else if(period == 'Matin') {
            String endHour = String.valueOf(timesheetOptions.endHourMorning__c.split(':').get(0));
            String endMinute = String.valueOf(timesheetOptions.endHourMorning__c.split(':').get(1));

            endTime = endHour+':'+endMinute;
        } else {
            String endHour = String.valueOf(timesheetOptions.endHour__c.split(':').get(0));
            String endMinute = String.valueOf(timesheetOptions.endHour__c.split(':').get(1));

            endTime = endHour+':'+endMinute;
        }

        return endTime;
    }
}