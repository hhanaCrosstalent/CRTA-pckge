//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Controller for the lateral menu of the frontend
* @author Crosstalent
* @group SIRH-Frontend
* @version 1.7
*/
global with sharing class sirhMenuController {
    
    public static final String CONTACT_PIC = 'crta__contact_frontend_picture'; // name of file
    
    public String selectedLeaveType { get; set; }
    public String selectedLeavePeriod { get; set; }
    public String selectedTrainingRequestType { get; set; }
    public List<SI_Menu_Settings__mdt> menuLinks {get; set;}
    public List<SIRH_Notification__c> notifications { get; set; } //Read notifications
    
    global sirhMenuController() {
        List<PermissionSetAssignment> assignments = [SELECT Assignee.Id, PermissionSet.Name 
                                                     FROM PermissionSetAssignment 
                                                     WHERE Assignee.Id = :UserInfo.getUserId()];
        List<String> permissions = new List<String>();
        for(PermissionSetAssignment assignment: assignments) {
            permissions.add(assignment.PermissionSet.Name);
        } 
        String contactId = sirhTemplateController.contactId;
        menuLinks = [SELECT DeveloperName, MasterLabel, Icone__c, URL__c, Target__c, Ordre__c, Manager_only__c, Visibilite__c 
                     FROM SI_Menu_Settings__mdt 
                     WHERE A_afficher__c = true 
                     AND Visibilite__c IN :permissions 
                     ORDER BY Ordre__c ASC];
        sirh__c options = sirh__c.getInstance();
        if(options.showReadNotifications__c) {
            notifications = NotificationRepository.getAllByContact(contactId);
        } else {
            notifications = NotificationRepository.getAllUnreadByContact(contactId);
        }
    }
    
    
    /**
* Populates a select list with the types of leave.
* @return The types
*/
    public List<SelectOption> getLeaveTypes(){
        return LeaveManager.getLeaveTypes();
    }
    
    /**
* Populates a select list with the periods.
* @return The periods
*/
    public List<SelectOption> getLeavePeriods(){
        return LeaveManager.getLeavePeriods();
    }
    
    /**
* Populates a select list with the training request types.
* @return The types
*/
    public List<SelectOption> getTrainingRequestTypes(){
        return TrainingRequestManager.getRequestTypes();
    }
    
    /**
* Returns current page label
* @return String Page label
*/
    public String getPageLabel() {
        //Parsing current page URL to get its name
        String pageName = ApexPages.CurrentPage().getUrl();
        pageName = pageName.replaceFirst('/apex/','');
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        String[] pageNameExtra = pageName.split('%3F', 0);
        pageName = pageNameExtra[0]; 
        pageName = pageName.replaceFirst('crta__',''); // compatible with development, packaging and subscriber orgs
        
        try { //Trying to retrieve a translation
            return [SELECT Translation__c 
                    FROM Page_label_translation__mdt 
                    WHERE MasterLabel = :pageName 
                    AND language_code__c = :UserInfo.getLanguage().left(2)].Translation__c;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            try {
                return [SELECT id,name,MasterLabel FROM ApexPage WHERE name=:pageName].MasterLabel;
            } catch(Exception e) {
                System.debug(e.getMessage());
                return 'Menu';
            }
        }
    }
    
    /**
* Remote action to upload a picture for the contact
* The picture is converted from a dataURI to a blob
* And save as an attachment with a specified name
* 
* @param DataURI a base64 DataURI string of the image
* @param contactId Id of the current logged contact
* 
* @return String Status message
*/
    @remoteAction
    global Static String base64upload(String DataURI, String contactId) {
        String image = DataURI.split(';').get(1).split(',').get(1);
        
        try { //Checks if a picture exists for this contact and replace it if so
            if (
                Schema.sObjectType.Attachment.isUpdateable()
                && Schema.sObjectType.Attachment.fields.Body.isUpdateable()
            ) {
                Attachment previous = [SELECT Id, Body 
                                       FROM Attachment 
                                       WHERE ParentId = :contactId 
                                       AND Name =: CONTACT_PIC Limit 1];
                previous.Body = EncodingUtil.base64Decode(image);
                update previous;
                return 'success';
            } else {
                return System.Label.SI_Error_image_creation.replace('{0}', System.Label.Permission);
            }
        } catch(Exception ex) {
            try { //Creates an attachment with a given name
                if (
                    Schema.sObjectType.Attachment.isCreateable()
                    && Schema.sObjectType.Attachment.fields.Name.isCreateable()
                    && Schema.sObjectType.Attachment.fields.ParentId.isCreateable()
                    && Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()
                    && Schema.sObjectType.Attachment.fields.body.isCreateable()
                ) {
                    Attachment attachment = new Attachment();
                    attachment.Name = CONTACT_PIC;
                    attachment.ParentId = contactId;
                    attachment.IsPrivate = false;
                    attachment.Body = EncodingUtil.base64Decode(image);
                    insert attachment;
                    return 'success';
                } else {
                    return System.Label.SI_Error_image_creation.replace('{0}', System.Label.Permission);
                }
            } catch (DMLException e) {
                return System.Label.SI_Error_image_creation.replace('{0}', e.getDmlMessage(0));
            }
        }
    }
    
    /**
* @deprecated Replaced by TimesheetManager
*/
    @RemoteAction
    @deprecated
    global static String createWeek(String updateString) {
        try {
            if (
                Schema.sObjectType.Feuille_Temps_Hebdo__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_debut_semaine__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Feuille_Temps_Hebdo__c.fields.Salarie__c.isCreateable()
            ) {
        		Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);

                Feuille_Temps_Hebdo__c week = new Feuille_Temps_Hebdo__c();
                week.Date_debut_semaine__c = String.valueOf(updateValues.get('start')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('start'))) : Date.parse(String.valueOf(updateValues.get('start')));
                week.Date_de_fin__c = String.valueOf(updateValues.get('end')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('end'))) : Date.parse(String.valueOf(updateValues.get('end')));
                week.Salarie__c = String.valueOf(updateValues.get('contact'));
                insert week;

                NotificationManager.createNotification(String.valueOf(updateValues.get('contact')), System.Label.SI_Notif_timesheet_creation, 'Création', week.id);
                return 'success';
            } else {
                return System.Label.SI_Error_week_creation.replace('{0}', System.Label.Permission);
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_week_creation.replace('{0}', e.getDmlMessage(0));
            } 
            return System.Label.SI_Error_week_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* @deprecated Replaced by LeaveManager
*/
    @RemoteAction
    @deprecated
    global static String createLeave(String updateString) {
        try {
            if (
                Schema.sObjectType.Demande_de_conges__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isCreateable()
                && Schema.sObjectType.Demande_de_conges__c.fields.Salarie__c.isCreateable()
            ) {
                Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
                Type_d_absence__c leaveType;
                String type;
                timesheet__c timesheetOptions = timesheet__c.getInstance();
                try {
                    leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                                 FROM Type_d_absence__c 
                                 WHERE Id = :String.valueOf(updateValues.get('type')) 
                                 LIMIT 1];
                    type = leaveType.Name;
                } catch(Exception e) {
                    System.debug(e.getMessage());
                    type = String.valueOf(updateValues.get('type'));
                }
                
                String startDatetime = String.valueOf(updateValues.get('start')).replace('T', ' ')+':00';
                String endDatetime = String.valueOf(updateValues.get('end')).replace('T', ' ')+':00';

                Demande_de_conges__c leave = new Demande_de_conges__c();
                leave.Date_de_debut__c = String.valueOf(updateValues.get('start')).contains('T') ? Datetime.valueOf(String.valueOf(updateValues.get('start')).replace('T', ' ')+':00'): Datetime.parse(String.valueOf(updateValues.get('start')));
                leave.Date_de_fin__c = String.valueOf(updateValues.get('end')).contains('T') ? Datetime.valueOf(String.valueOf(updateValues.get('end')).replace('T', ' ')+':00'): Datetime.parse(String.valueOf(updateValues.get('end')));
                leave.Type__c = type;
                leave.Salarie__c = String.valueOf(updateValues.get('contact'));
                if(
                    timesheetOptions.useMetadata__c
                    && leaveType != null
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
                String label = String.valueOf(updateValues.get('label'));
            	insert leave;
                NotificationManager.createNotification(String.valueOf(updateValues.get('contact')), System.Label.SI_Notif_leave_request_creation.replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.format()).replace('{4}', leave.Date_de_fin__c.format()), 'Création', leave.id);

                if((leaveType != null && leaveType.Notifier_manager__c) || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                    try {
                        Contact contact = [SELECT Id, Name, ReportsToId 
                                           FROM Contact 
                                           WHERE Id = :String.valueOf(updateValues.get('contact'))];
                        if((leaveType != null && leaveType.Validation_manager__c) || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                            NotificationManager.createNotification(String.valueOf(contact.ReportsToId), System.Label.SI_Notif_leave_request_creation_manager.replace('{0}', contact.Name).replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.format()).replace('{4}', leave.Date_de_fin__c.format()), 'Interaction', leave.id);
                        } else {
                            NotificationManager.createNotification(String.valueOf(contact.ReportsToId), System.Label.SI_Notif_leave_request_creation_manager.replace('{0}', contact.Name).replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.format()).replace('{4}', leave.Date_de_fin__c.format()), 'Rappel', leave.id);
                        }
                    } catch(Exception e) {
                        System.debug(e.getMessage()+' : '+e.getLineNumber());
                    }
                }
                return 'success';
            } else {
                return System.Label.SI_Error_leave_request_creation.replace('{0}', System.Label.Permission);
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getDmlMessage(0));
            } 
            return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* @deprecated Replaced by LeaveManager
*/
    @RemoteAction
    @deprecated
    global static String createLeaveDate(String updateString) {
        if (
            Schema.sObjectType.Demande_de_conges__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_debut__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Date_de_fin__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Periode__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Periode_de_fin__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Type__c.isCreateable()
            && Schema.sObjectType.Demande_de_conges__c.fields.Salarie__c.isCreateable()
        ) {
            Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
            Type_d_absence__c leaveType;
            String type;
            timesheet__c timesheetOptions = timesheet__c.getInstance();
            try {
                leaveType = [SELECT Name, Code__c, Notifier_manager__c, Validation_manager__c, Afficher_dans_le_planning__c 
                             FROM Type_d_absence__c 
                             WHERE Id = :String.valueOf(updateValues.get('type')) 
                             LIMIT 1];
                type = leaveType.Name;
            } catch(Exception e) {
                System.debug(e.getMessage());
                type = String.valueOf(updateValues.get('type'));
            }
            
            Date startDate = String.valueOf(updateValues.get('start')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('start'))) : Date.parse(String.valueOf(updateValues.get('start')));
            Date endDate = String.valueOf(updateValues.get('end')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('end'))) : Date.parse(String.valueOf(updateValues.get('end')));
            Datetime startDatetime;
            Datetime endDatetime;
            String startPeriod = String.valueOf(updateValues.get('startPeriod'));
            String endPeriod = String.valueOf(updateValues.get('endPeriod'));
            
            //Creating a datetime from a date and a specified period      
            if(startPeriod == 'Après-midi') {
                Integer startHour = Integer.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(0));
                Integer startMinute = Integer.valueOf(timesheetOptions.startHourAfternoon__c.split(':').get(1));
                
                Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
                startDatetime = Datetime.newInstance(startDate, startTime);
            } else if(startPeriod == 'Matin') {
                Integer startHour = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(0));
                Integer startMinute = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(1));
                
                Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
                startDatetime = Datetime.newInstance(startDate, startTime);
            } else {
                Integer startHour = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(0));
                Integer startMinute = Integer.valueOf(timesheetOptions.startHour__c.split(':').get(1));
                
                Time startTime = Time.newInstance(startHour, startMinute, 0, 0);
                startDatetime = Datetime.newInstance(startDate, startTime);
            }
            if(endPeriod == 'Après-midi') {
                Integer endHour = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(0));
                Integer endMinute = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(1));
                
                Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
                endDatetime = Datetime.newInstance(endDate, endTime);
            } else if(endPeriod == 'Matin') {
                Integer endHour = Integer.valueOf(timesheetOptions.endHourMorning__c.split(':').get(0));
                Integer endMinute = Integer.valueOf(timesheetOptions.endHourMorning__c.split(':').get(1));
                
                Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
                endDatetime = Datetime.newInstance(endDate, endTime);
            } else {
                Integer endHour = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(0));
                Integer endMinute = Integer.valueOf(timesheetOptions.endHour__c.split(':').get(1));
                
                Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
                endDatetime = Datetime.newInstance(endDate, endTime);
            }
            
            Demande_de_conges__c leave = new Demande_de_conges__c();
            leave.Date_de_debut__c = startDatetime;
            leave.Date_de_fin__c = endDatetime;
            leave.Periode__c = String.valueOf(updateValues.get('startPeriod'));
            leave.Periode_de_fin__c = String.valueOf(updateValues.get('endPeriod'));
            leave.Type__c = type;
            leave.Salarie__c = String.valueOf(updateValues.get('contact'));
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
            String label = String.valueOf(updateValues.get('label'));
    
            try {
                insert leave;
                NotificationManager.createNotification(String.valueOf(updateValues.get('contact')), System.Label.SI_Notif_leave_request_creation.replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.date().format()+' '+leave.Periode__c).replace('{4}', leave.Date_de_fin__c.date().format()+' '+leave.Periode_de_fin__c), 'Création', leave.id);
                if((leaveType != null && leaveType.Notifier_manager__c) || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                    try {
                        Contact contact = [SELECT Id, Name, ReportsToId 
                                           FROM Contact 
                                           WHERE Id = :String.valueOf(updateValues.get('contact'))];
                        if((leaveType != null && leaveType.Validation_manager__c) || (timesheetOptions != null && !timesheetOptions.useMetadata__c)) {
                            NotificationManager.createNotification(String.valueOf(contact.ReportsToId), System.Label.SI_Notif_leave_request_creation_manager.replace('{0}', contact.Name).replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.date().format()+' '+leave.Periode__c).replace('{4}', leave.Date_de_fin__c.date().format()+' '+leave.Periode_de_fin__c), 'Interaction', leave.id);
                        } else {
                            NotificationManager.createNotification(String.valueOf(contact.ReportsToId), System.Label.SI_Notif_leave_request_creation_manager.replace('{0}', contact.Name).replace('{1}', label).replace('{2}', String.valueOf(duration)).replace('{3}', leave.Date_de_debut__c.date().format()+' '+leave.Periode__c).replace('{4}', leave.Date_de_fin__c.date().format()+' '+leave.Periode_de_fin__c), 'Rappel', leave.id);
                        }
                    } catch(Exception e) {
                        System.debug(e.getMessage()+' : '+e.getLineNumber());
                    }
                }
                return 'success';
            } catch(Exception e) {
                System.debug(e.getMessage());
                if(e.getTypeName() == 'System.DmlException') {
                    return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getDmlMessage(0));
                } 
                return System.Label.SI_Error_leave_request_creation.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_leave_request_creation.replace('{0}', System.Label.Permission);
        }
    }
    
    /**
* @deprecated Replaced by ExpensesManager
*/
    @RemoteAction
    @deprecated
    global static String createExpenses(String updateString) {
        if (
            Schema.sObjectType.Note_de_frais__c.isCreateable()
            && Schema.sObjectType.Note_de_frais__c.fields.Date_de_debut__c.isCreateable()
            && Schema.sObjectType.Note_de_frais__c.fields.Date_de_fin__c.isCreateable()
            && Schema.sObjectType.Note_de_frais__c.fields.Nom__c.isCreateable()
            && Schema.sObjectType.Note_de_frais__c.fields.Salarie__c.isCreateable()
        ) {
            Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
            
            Note_de_frais__c expenses = new Note_de_frais__c();
            expenses.Date_de_debut__c = String.valueOf(updateValues.get('start')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('start'))) : Date.parse(String.valueOf(updateValues.get('start')));
            expenses.Date_de_fin__c = String.valueOf(updateValues.get('end')).contains('-') ? Date.valueOf(String.valueOf(updateValues.get('end'))) : Date.parse(String.valueOf(updateValues.get('end')));
            expenses.Nom__c = String.valueOf(updateValues.get('name'));
            expenses.Salarie__c = String.valueOf(updateValues.get('contact'));
            
            try {
                insert expenses;
                NotificationManager.createNotification(String.valueOf(updateValues.get('contact')), System.Label.SI_Notif_leave_expenses, 'Création', expenses.id);
                return 'success';
            } catch(Exception e) {
                System.debug(e.getMessage());
                if(e.getTypeName() == 'System.DmlException') {
                    return System.Label.SI_Error_expenses_creation.replace('{0}', e.getDmlMessage(0));
                } 
                return System.Label.SI_Error_expenses_creation.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.SI_Error_expenses_creation.replace('{0}', System.Label.Permission);
        }
    }
}