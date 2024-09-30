//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Manager class for the Frais__c object
 * @author Crosstalent
 * @group SIRH-Manager
 */
global with sharing class ExpenseLineManager {
    /**
     * Creates a Frais__c object
     * @param  category     Category of the Frais__c
     * @param  other          Name of the category of the Frais__c if it's set to 'Other'
     * @param  lineDate      Date of the Frais__c
     * @param  centre         Financial centre of the Frais__c
     * @param  type            Type of the Frais__c
     * @param  amount     Amount of the Frais__c
     * @param  isJustified Whether the Frais__c has a receipt
     * @param  contactId     Id of the contact for whom to create the Frais__c
     * @param  noteId         Id of the parent Note_de_frais__c
     * @param  receiptFile               Receipt file in Base64/DataURI format
     * @param  receiptFilename      Receipt filename
     *
     * @return      'success' or an error message
     */
    webService static String createExpenseLine(String category, String other, Date lineDate, String centre, String type, Double amount, Boolean isJustified, String contactId, String noteId, String receiptFile, String receiptFilename) {
        try {
            Frais__c expenseLine = new Frais__c(
                Date__c = lineDate,
                Centre_de_frais__c = centre,
                Type__c = type,
                Montant__c = amount,
                Justificatif_present__c = isJustified,
                Note_de_frais__c = noteId,
                Salarie__c = contactId
            );
            
            if (
                Schema.sObjectType.Frais__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Date__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Centre_de_frais__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Type__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Montant__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Justificatif_present__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Note_de_frais__c.isCreateable()
                && Schema.sObjectType.Frais__c.fields.Salarie__c.isCreateable()
            ) {
                if(category == 'other' && Schema.sObjectType.Frais__c.fields.Autre_depense__c.isCreateable()) {
                    expenseLine.Autre_depense__c = other;
                }
            	insert expenseLine;

                try { //Creates an attachment with a given name
                    if(
                        receiptFile != null && receiptFile != ''
                        && Schema.sObjectType.Attachment.isCreateable()
                        && Schema.sObjectType.Attachment.fields.Name.isCreateable()
                        && Schema.sObjectType.Attachment.fields.ParentId.isCreateable()
                        && Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()
                        && Schema.sObjectType.Attachment.fields.Body.isCreateable()
                    ) {
                        String image = receiptFile.split(';').get(1).split(',').get(1);
                        String fileExt = receiptFilename.split('\\.').get(1);
                        Attachment attachment = new Attachment();
                        attachment.Name = 'justificatif.'+fileExt;
                        attachment.ParentId = expenseLine.Id;
                        attachment.IsPrivate = false;
                        attachment.Body = EncodingUtil.base64Decode(image);
                        insert attachment;
                    } else {
                        return System.Label.SI_Error_image_creation.replace('{0}', System.Label.Permission);
                    }
                } catch (Exception e) {
                    System.debug(e.getMessage()+ ' :'+e.getLineNumber());
                    return System.Label.Expense_error_image.replace('{0}', e.getMessage());
                }
                NotificationManager.createNotification(contactId, System.Label.Expense_notification_creation, 'Création', 'Frais__c', expenseLine.Id);
                return 'success';
            } else {
                return System.Label.Permission; 
            }

            
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenseLine_create.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenseLine_create.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_expenseLine_create.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenseLine_create.replace('{0}', e.getMessage());
        }
    }

    /**
     * Updates a Frais__c object
     * @param  category     Category of the Frais__c
     * @param  other          Name of the category of the Frais__c if it's set to 'Other'
     * @param  lineDate      Date of the Frais__c
     * @param  centre         Financial centre of the Frais__c
     * @param  type            Type of the Frais__c
     * @param  amount     Amount of the Frais__c
     * @param  isJustified Whether the Frais__c has a receipt
     * @param  expenseLineId     Id of the Frais__c to update
     * @param  receiptFile               Receipt file in Base64/DataURI format
     * @param  receiptFilename      Receipt filename
     *
     * @return      'success' or an error message
     */
    webService static String editExpenseLine(String category, String other, Date lineDate, String centre, String type, Double amount, Boolean isJustified, String expenseLineId, String receiptFile, String receiptFilename) {
        try {
            Frais__c expenseLine = ExpenseLineRepository.getById(expenseLineId);
            expenseLine.Date__c = lineDate;
            expenseLine.Centre_de_frais__c = centre;
            expenseLine.Type__c = type;
            expenseLine.Montant__c = amount;
            expenseLine.Justificatif_present__c = isJustified;

            if (
                Schema.sObjectType.Frais__c.isUpdateable()
                && Schema.sObjectType.Frais__c.fields.Date__c.isUpdateable()
                && Schema.sObjectType.Frais__c.fields.Centre_de_frais__c.isUpdateable()
                && Schema.sObjectType.Frais__c.fields.Type__c.isUpdateable()
                && Schema.sObjectType.Frais__c.fields.Montant__c.isUpdateable()
                && Schema.sObjectType.Frais__c.fields.Justificatif_present__c.isUpdateable()
            ) {
                if(category == 'other' && Schema.sObjectType.Frais__c.fields.Autre_depense__c.isUpdateable()) {
                    expenseLine.Autre_depense__c = other;
                }
            	update expenseLine;

                try { //Creates an attachment with a given name
                    if(
                        receiptFile != null && receiptFile != ''
                        && Schema.sObjectType.Attachment.isCreateable()
                        && Schema.sObjectType.Attachment.fields.Name.isCreateable()
                        && Schema.sObjectType.Attachment.fields.ParentId.isCreateable()
                        && Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()
                        && Schema.sObjectType.Attachment.fields.Body.isCreateable()
                    ) {
                        String image = receiptFile.split(';').get(1).split(',').get(1);
                        String fileExt = receiptFilename.split('\\.').get(1);
                        Attachment attachment = new Attachment();
                        attachment.Name = 'justificatif.'+fileExt;
                        attachment.ParentId = expenseLine.Id;
                        attachment.IsPrivate = false;
                        attachment.Body = EncodingUtil.base64Decode(image);
                        insert attachment;
                    } else {
                        return System.Label.SI_Error_image_creation.replace('{0}', System.Label.Permission);
                    }
                } catch (Exception e) {
                    System.debug(e.getMessage()+ ' :'+e.getLineNumber());
                    return System.Label.Expense_error_image.replace('{0}', e.getMessage());
                }
            	NotificationManager.createNotification(expenseLine.Salarie__c, System.Label.Expense_notification_creation, 'Création', 'Frais__c', expenseLine.id);
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenseLine_edit.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenseLine_edit.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_expenseLine_edit.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenseLine_edit.replace('{0}', e.getMessage());
        }
    }

    /**
     * Deletes a Frais__c object
     * @param expenseLineId Id of the Frais__c to delete
     * 
     * @return 'success' or an error message
     */
    webService static String deleteExpenseLine(String expenseLineId) {
        try {
            Frais__c expenseLine = ExpenseLineRepository.getById(expenseLineId);
            if (
                Schema.sObjectType.Frais__c.isDeletable()
            ) {
                delete expenseLine;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenseLine_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenseLine_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_expenseLine_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenseLine_delete.replace('{0}', e.getMessage());
        }
    }

    /**
     * Clones a Frais__c object
     * @param expenseLineId Id of the Frais__c to clone
     * 
     * @return 'success' or an error message
     */
    webService static String cloneExpenseLine(String expenseLineId) {
        try {
            Frais__c expenseLine = ExpenseLineRepository.getById(expenseLineId);
            Frais__c expenseClone = expenseLine.clone();
            if (
                Schema.sObjectType.Frais__c.isCreateable()
            ) {
            	insert expenseClone;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenseLine_clone.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenseLine_clone.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_expenseLine_clone.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenseLine_clone.replace('{0}', e.getMessage());
        }
    }
}