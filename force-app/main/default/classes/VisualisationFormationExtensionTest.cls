@IsTest
private class VisualisationFormationExtensionTest {

    @IsTest
    private static void testAll() {
        List<Action_de_formation__c> l = [SELECT Id, Contact__c FROM Action_de_formation__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(l[0]);
        VisualisationFormationExtension vfe = new VisualisationFormationExtension(sc);
        
        Boolean f = vfe.getIsManager();
        f = vfe.getIsCollab();
        List<Participation_session_formation__c> anotherList = vfe.getTrainingRegistrations();
        System.assert(anotherList != null);
    }

    @TestSetup
    private static void testSetup() {
        Account acc = new Account(Name = 'Hamburger Hafen');
        insert acc;
        Contact c = new Contact(
            AccountId = acc.Id,
            FirstName = 'Francois',
            LastName = 'Muller'
        );
        insert c;
        Action_de_formation__c adf = new Action_de_formation__c(Contact__c = c.Id);
        insert adf;
    }
}