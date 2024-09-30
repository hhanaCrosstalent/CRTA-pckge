@IsTest
private class VisualisationEquipeController_Test {

    @IsTest
    private static void testAll() {
        PageReference pg = Page.VisualisationEquipe;
        Test.setCurrentPage(pg);
        List<Contact> contacts = [SELECT Id FROM Contact];
        SirhTemplateController.contactId = contacts[0].Id;
        VisualisationEquipeController controller = new VisualisationEquipeController();
        
        Organigramme__c org = [SELECT Id FROM Organigramme__c WHERE SetupOwnerId =: Userinfo.getUserId()][0];
        org.Display_ex_employees__c = false;
        update org;
        System.assertEquals(false, org.Display_ex_employees__c);
        controller = new VisualisationEquipeController();
    }

    @TestSetup
    private static void testSetup() {
        Organigramme__c options = new Organigramme__c(Display_ex_employees__c = true);
        insert options;

        Contact c = new Contact(LastName='Manager');
        insert c; 

        Contact c2 = new Contact(LastName='Collaborateur');
        insert c2; 

        Organigramme__c org = new Organigramme__c(Display_ex_employees__c = true, SetupOwnerId=Userinfo.getUserId());
        insert org;
    }
}