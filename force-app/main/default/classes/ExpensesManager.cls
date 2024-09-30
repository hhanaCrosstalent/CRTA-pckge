//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Manager class for the Note_de_frais__c object
 * @author Crosstalent
 * @group SIRH-Manager
 */
global with sharing class ExpensesManager {

    /**
     * Creates a Note_de_frais__c object
     * @param startDate Start date of the expenses (ISO format)
     * @param endDate   End date of the expenses (ISO format)
     * @param name      Name of the expenses
     * @param contactId Id of the contact for whom to create the expenses
     * 
     * @return           'success' or an error message
     */
    webService static String createExpenses(Date startDate, Date endDate, String name, String contactId) {
        try {
            Note_de_frais__c expenses = new Note_de_frais__c(
                    Date_de_debut__c = startDate,
                    Date_de_fin__c = endDate,
                    Nom__c = name,
                    Salarie__c = contactId
                    );
            if (
                Schema.sObjectType.Note_de_frais__c.isCreateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Date_de_debut__c.isCreateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Nom__c.isCreateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Salarie__c.isCreateable()
            ) {
            	insert expenses;

                try {
                    NotificationManager.createNotification(contactId, System.Label.SI_Notif_expenses_creation, 'Création', 
                        expenses.Id);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_creation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_creation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Updates a Note_de_frais__c object
     * @param startDate Start date of the expenses (ISO format)
     * @param endDate   End date of the expenses (ISO format)
     * @param name      Name of the expenses
     * @param expensesId Id of the expenses to update
     * 
     * @return           'success' or an error message
     */
    webService static String editExpenses(Date startDate, Date endDate, String name, String expensesId) {
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Date_de_debut__c = startDate;
            expenses.Date_de_fin__c = endDate;
            expenses.Nom__c = name;

            if (
                Schema.sObjectType.Note_de_frais__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Date_de_debut__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Date_de_fin__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Nom__c.isUpdateable()
            ) {
            	update expenses;
            	return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_edit.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_edit.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_edit.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_edit.replace('{0}', e.getMessage());
        }
    }

    /**
     * Deletes a Note_de_frais__c object
     * @param expensesId Id of the expenses to delete
     * 
     * @return      'success' or an error message
     */
    webService static String deleteExpenses(String expensesId) {            
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            if (
                Schema.sObjectType.Note_de_frais__c.isDeletable()
            ) {
                delete expenses;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_expenses_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_delete.replace('{0}', e.getMessage());
        }
    }

    /**
     * Validates an expenses
     * @param expensesId Id of the expenses to validate
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String validateExpenses(String expensesId, String total) {            
        try {
            if(!Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()) {
                System.debug('User does not have sufficient rights.');
                return System.Label.SI_Error_expenses_validation.replace('{0}',
                        'User does not have sufficient rights.');
            }
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '20 À valider';
            
            if (
                Schema.sObjectType.Note_de_frais__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
            ) {
            	update expenses;

                try {
                    NotificationManager.createNotification(expenses.Salarie__r.reportsToId, 
                                    System.Label.SI_Notif_expenses_validation
                                        .replace('{0}', expenses.Salarie__r.Name)
                                        .replace('{1}', total), 'Interaction', expenses.Id);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
                return 'success'; 
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_validation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_validation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_validation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_validation.replace('{0}', e.getMessage());
        }


    }

    /**
     * Accepts an expense
     * @param expensesId Id of the expenses to accept
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String acceptExpenses(String expensesId, String total) {
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '30 Validée';
            update expenses;
            
            if (
                Schema.sObjectType.Note_de_frais__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
            ) {
            	update expenses;

                try {
                	NotificationManager.createNotification(expenses.Salarie__c, System.Label.SI_Notif_expenses_acceptation
                        .replace('{0}', total), 'Information', expenses.Id);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
                return 'success'; 
            } else {
                return System.Label.Permission; 
            }
            
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Accepts an expense
     * @param expensesId Id of the expenses to accept
     * @param comment Comment of the manager regarding the expenses
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String acceptExpensesWithComment(String expensesId, String comment, String total) {
        if(!Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
                || !Schema.sObjectType.Note_de_frais__c.fields.Commentaire__c.isUpdateable()) {
            System.debug('User does not have sufficient rights.');
            return System.Label.SI_Error_expenses_acceptation.replace('{0}', 'User does not have sufficient rights.');
        }
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '30 Validée';
            expenses.Commentaire__c = comment;
            update expenses;
            
            if (
                Schema.sObjectType.Note_de_frais__c.isUpdateable()
                && Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
            ) {
            	update expenses;

                try {
                    NotificationManager.createNotification(expenses.Salarie__c, System.Label.SI_Notif_expenses_acceptation
                                    .replace('{0}', total), 'Information', expenses.Id);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
                return 'success'; 
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_acceptation.replace('{0}', e.getMessage());
        }
    }

    /**
     * Returns an expense to the employee
     * @param expensesId Id of the expenses to return
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String returnExpenses(String expensesId, String total) {
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '15 Retournée';
            update expenses;
            try {
                NotificationManager.createNotification(expenses.Salarie__c, System.Label.SI_Notif_expenses_return
                            .replace('{0}', total), 'Information', expenses.Id);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            return 'success'; 
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_return.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_return.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_return.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_return.replace('{0}', e.getMessage());
        }
    }

    /**
     * Returns an expense to the employee
     * @param expensesId Id of the expenses to return
     * @param comment Comment of the manager regarding the expenses
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String returnExpensesWithComment(String expensesId, String comment, String total) {
        if(!Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
                || !Schema.sObjectType.Note_de_frais__c.fields.Commentaire__c.isUpdateable()) {
            System.debug('User does not have sufficient rights.');
            return System.Label.SI_Error_expenses_return.replace('{0}', 'User does not have sufficient rights.');
        }
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '15 Retournée';
            expenses.Commentaire__c = comment;
            update expenses;
            try {
                NotificationManager.createNotification(expenses.Salarie__c, 
                    System.Label.SI_Notif_expenses_return.replace('{0}', total), 'Information', expenses.Id);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            return 'success'; 
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_return.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_return.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_return.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_return.replace('{0}', e.getMessage());
        }
    }

    /**
     * Rejects an expense
     * @param expensesId Id of the expenses to reject
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String rejectExpenses(String expensesId, String total) {
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '55 Annulée';
            update expenses;
            try {
                NotificationManager.createNotification(expenses.Salarie__c, 
                    System.Label.SI_Notif_expenses_rejection.replace('{0}', total), 'Information', expenses.Id);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            return 'success'; 
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_rejection.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_rejection.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_rejection.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_rejection.replace('{0}', e.getMessage());
        }
    }

    /**
     * Rejects an expense
     * @param expensesId Id of the expenses to reject
     * @param comment Comment of the manager regarding the expenses
     * @param total Total amount of the expenses
     * 
     * @return      'success' or an error message
     */
    webService static String rejectExpensesWithComment(String expensesId, String comment, String total) {
        if(!Schema.sObjectType.Note_de_frais__c.fields.Statut__c.isUpdateable()
                || !Schema.sObjectType.Note_de_frais__c.fields.Commentaire__c.isUpdateable()) {
            System.debug('User does not have sufficient rights.');
            return System.Label.SI_Error_expenses_rejection.replace('{0}', 'User does not have sufficient rights.');
        }
        try {
            Note_de_frais__c expenses = ExpensesRepository.getById(expensesId);
            expenses.Statut__c = '55 Annulée';
            expenses.Commentaire__c = comment;
            update expenses;
            try {
                NotificationManager.createNotification(expenses.Salarie__c, 
                    System.Label.SI_Notif_expenses_rejection.replace('{0}', total), 'Information', expenses.Id);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            return 'success'; 
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_expenses_rejection.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_expenses_rejection.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_expenses_rejection.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_expenses_rejection.replace('{0}', e.getMessage());
        }
    }
}