//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller to toggle the publication state of a value
 * @author Crosstalent
 * @group BDU-Backend
 * @version 1.0
 */
global with sharing class bduPublishValues {
    /**
     * Publishes the selected values
     * @param Id[] arg           List of values Id
     * @return      Status
     */
    webService static String publish(Id[] arg) { 
        try {
            List<BDU_Valeur__c> aei = [SELECT Id, CT_A_publier__c FROM BDU_Valeur__c WHERE Id IN :arg]; 
            for(BDU_Valeur__c i:aei) {
                i.CT_A_publier__c = true;
            }
            if (
                Schema.sObjectType.BDU_Valeur__c.isUpdateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_A_publier__c.isUpdateable()
            ) {
                update aei;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch (exception e) {
            return e.getMessage();
        }
    }
    /**
     * Unpublishes the selected values
     * @param Id[] arg           List of values Id
     * @return      Status
     */
    webService static String unpublish(Id[] arg) { 
        try {
            List<BDU_Valeur__c> aei = [SELECT Id, CT_A_publier__c FROM BDU_Valeur__c WHERE Id IN :arg]; 
            for(BDU_Valeur__c i:aei) {
                i.CT_A_publier__c = false;
            }
            if (
                Schema.sObjectType.BDU_Valeur__c.isUpdateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_A_publier__c.isUpdateable()
            ) {
                update aei;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch (exception e) {
            return e.getMessage();
        }
    }
}