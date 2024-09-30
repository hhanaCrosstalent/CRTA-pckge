@isTest
private class VisualisationLibraryController_Test {

    @isTest 
    private static void VisualisationLibraryController_Test() {
        Contact collab = new Contact(LastName = 'Collab');
        insert collab;

        Dossier_documentaire__c publicFolder1 = new Dossier_documentaire__c(
                Name = 'Test1',
                A_afficher__c = true
                );
        insert publicFolder1;

        Dossier_documentaire__c publicFolder2 = new Dossier_documentaire__c(
                Name = 'Test2',
                Dossier_parent__c = publicFolder1.Id,
                A_afficher__c = true
                );
        insert publicFolder2;

        Dossier_documentaire__c privateFolder1 = new Dossier_documentaire__c(
                Name = 'Test1',
                Salarie__c = collab.Id,
                A_afficher__c = true
                );
        insert privateFolder1;

        Dossier_documentaire__c privateFolder2 = new Dossier_documentaire__c(
                Name = 'Test2',
                Salarie__c = collab.Id,
                Dossier_parent__c = privateFolder1.Id,
                A_afficher__c = true
                );
        insert privateFolder2;

        PageReference pg = Page.VisualisationLibrary;
        Test.setCurrentPage(pg);

        VisualisationLibraryController controller=new VisualisationLibraryController(); 
        controller.contactId = collab.Id;
        System.assertEquals(1, controller.privateRoots.size());
        System.assertEquals(1, controller.publicRoots.size());

        List<Dossier_documentaire__c> privateChildren = VisualisationLibraryController.getPrivateChildren(privateFolder1.Id, collab.Id);
        System.assertEquals(1, privateChildren.size());

        List<Dossier_documentaire__c> publicChildren = VisualisationLibraryController.getPublicChildren(publicFolder1.Id);
        System.assertEquals(1, publicChildren.size());
    }
}