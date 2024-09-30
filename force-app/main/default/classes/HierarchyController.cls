//Security isCreateable() isUpdateable() isDeletable() checked
// @author Felix van Hove
public with sharing class HierarchyController {

    @AuraEnabled
    public static String getTree() {
        List<Contact> l = null;
        crta__Organigramme__c options = crta__Organigramme__c.getInstance();
        if(options.crta__Display_ex_employees__c) {
            l = [SELECT Id, Name, ReportsToId, Account.Name
                FROM Contact
                WHERE RecordType.DeveloperName = 'Salarie' 
                ORDER BY Name];
        } else {
            l = [SELECT Id, Name, ReportsToId, Account.Name
                FROM Contact
                WHERE RecordType.DeveloperName = 'Salarie' 
                AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY)
                ORDER BY Name];
        }
        return JSON.serialize(l);
    }

    @AuraEnabled
    public static void changeHierarchy(String managerUntilNow, String managerInTheFuture) {
        List<Contact> contacts = new List<Contact>();
        for(Contact c: [SELECT Id, Name, ReportsToId FROM Contact WHERE ReportsToId = :managerUntilNow]) {
            c.ReportsToId = managerInTheFuture;
            contacts.add(c);
        }
        try {                
            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.ReportsToId.isUpdateable()
            ) {
            	update contacts;
            } else {
                System.debug(System.Label.Permission);
            }
        } catch(DmlException e) {
            if(e.getDmlType(0) == StatusCode.CIRCULAR_DEPENDENCY) {
                throw new AuraHandledException('CIRCULAR_DEPENDENCY');
            } else {
                throw new AuraHandledException(e.getMessage());
            }
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
      }
}