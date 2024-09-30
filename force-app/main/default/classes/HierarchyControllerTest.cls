@IsTest
private class HierarchyControllerTest {

    @IsTest
    private static void getTree() {
        String jsonTree = HierarchyController.getTree();
        List<Contact> l = (List<Contact>) JSON.deserialize(jsonTree, List<Contact>.class);
        System.assertEquals(6, l.size());
        
        delete [SELECT Id FROM crta__Organigramme__c];
        crta__Organigramme__c options = new crta__Organigramme__c();
        options.crta__Display_ex_employees__c = false;
        insert options;

        jsonTree = HierarchyController.getTree();
        l = (List<Contact>) JSON.deserialize(jsonTree, List<Contact>.class);
        System.assertEquals(6, l.size());
    }

    @IsTest
    private static void changeHierarchy() {
        List<Contact> oldBosses = [SELECT Id FROM Contact WHERE LastName = 'Luhmann'];
        String managerUntilNow = oldBosses.get(0).Id;
        List<Contact> newBosses = [SELECT Id FROM Contact WHERE LastName = 'Adorno'];
        String managerInTheFuture = newBosses.get(0).Id;
        try {
            HierarchyController.changeHierarchy(managerUntilNow, managerInTheFuture);
            System.assert(false, 'This should not have worked as this is a circular dependency.');
        } catch(AuraHandledException e) {
            // expected
        }

        oldBosses = [SELECT Id FROM Contact WHERE LastName = 'Adorno'];
        managerUntilNow = oldBosses.get(0).Id;
        newBosses = [SELECT Id FROM Contact WHERE LastName = 'Horkheimer'];
        managerInTheFuture = newBosses.get(0).Id;
        HierarchyController.changeHierarchy(managerUntilNow, managerInTheFuture);

        List<Contact> employees = [SELECT ReportsToId FROM Contact WHERE LastName = 'Searle'];
        System.assertEquals(managerInTheFuture, employees.get(0).ReportsToId);
    }

    @TestSetup
    private static void testSetup() {

        crta__Organigramme__c options = new crta__Organigramme__c();
        options.crta__Display_ex_employees__c = true;
        insert options;

        Account a = new Account(Name = 'Hamburger Hafen');
        insert a;
        Contact cCeo = new Contact(Account = a,
            FirstName = 'Niklas',
            LastName = 'Luhmann'
        );
        insert cCeo;
        Contact cMiddleManagement0 = new Contact(Account = a,
            FirstName = 'Theodor',
            LastName = 'Adorno',
            ReportsToId = cCeo.Id
        );
        insert cMiddleManagement0;
        Contact cMiddleManagement1 = new Contact(Account = a,
            FirstName = 'Max',
            LastName = 'Horkheimer',
            ReportsToId = cCeo.Id
        );
        insert cMiddleManagement1;
        Contact cNormalEmployee0 = new Contact(Account = a,
            FirstName = 'John',
            LastName = 'Searle',
            ReportsToId = cMiddleManagement0.Id
        );
        insert cNormalEmployee0;
        Contact cNormalEmployee1 = new Contact(Account = a,
            FirstName = 'Ludwig',
            LastName = 'Wittgenstein',
            ReportsToId = cMiddleManagement0.Id
        );
        insert cNormalEmployee1;
        Contact cNormalEmployee2 = new Contact(Account = a,
            FirstName = 'Juergen',
            LastName = 'Habermas',
            ReportsToId = cMiddleManagement0.Id
        );
        insert cNormalEmployee2;
        
    }
}