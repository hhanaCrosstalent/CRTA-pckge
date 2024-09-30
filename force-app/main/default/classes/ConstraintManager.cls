//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Astreinte__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class ConstraintManager {
    /**
* Creates an Astreinte__c object
* @param  startDate Starting date of the constraint
* @param  endDate   Ending date of the constraint
* @param  motif     Reason for the constraing
* @param  contactId Id of the contact for whom the constraint will be created
* 
* @return           'success' or an error message
*/
    webService static String createConstraint(Date startDate, Date endDate, String motif, String contactId) {
        try {
            if (
                Schema.sObjectType.Astreinte__c.isCreateable()
                && Schema.sObjectType.Astreinte__c.fields.Salarie__c.isCreateable()
                && Schema.sObjectType.Astreinte__c.fields.Date_de_debut__c.isCreateable()
                && Schema.sObjectType.Astreinte__c.fields.Date_de_fin__c.isCreateable()
                && Schema.sObjectType.Astreinte__c.fields.Motif__c.isCreateable()
            ) {
                Astreinte__c constraint = new Astreinte__c(
                    Salarie__c = contactId,
                    Date_de_debut__c = startDate, 
                    Date_de_fin__c = endDate,
                    Motif__c = motif
                );
                
                insert  constraint;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_constraint_creation.replace('{0}', e.getDmlMessage(0));
            } 
            return System.Label.SI_Error_constraint_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Updates an Astreinte__c object
* @param  startDate Starting date of the constraint
* @param  endDate   Ending date of the constraint
* @param  motif     Reason for the constraing
* @param  constraintId Id of the constraint to update
* 
* @return           'success' or an error message
*/
    webService static String editConstraint(Date startDate, Date endDate, String motif, String constraintId) {
        try {
            if (
                Schema.sObjectType.Astreinte__c.isUpdateable()
                && Schema.sObjectType.Astreinte__c.fields.Date_de_debut__c.isUpdateable()
                && Schema.sObjectType.Astreinte__c.fields.Date_de_fin__c.isUpdateable()
                && Schema.sObjectType.Astreinte__c.fields.Motif__c.isUpdateable()
            ) {
                Astreinte__c constraint = ConstraintRepository.getById(constraintId);
                constraint.Date_de_debut__c = startDate;
                constraint.Date_de_fin__c = endDate;
                constraint.Motif__c = motif;
                
                update  constraint;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_constraint_edit.replace('{0}', e.getDmlMessage(0));
            } 
            return System.Label.SI_Error_constraint_edit.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a constraint
* @param  constraintId Id of the constraint to delete
* 
* @return              'success' or an error message
*/
    webService static String deleteConstraint(String constraintId) {
        try {
            Astreinte__c constraint = ConstraintRepository.getById(constraintId);
            
            if (
                Schema.sObjectType.Astreinte__c.isDeletable()
            ) {
                delete  constraint;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_constraint_delete.replace('{0}', e.getDmlMessage(0));
            } 
            return System.Label.SI_Error_constraint_delete.replace('{0}', e.getMessage());
        }
    }
    
}