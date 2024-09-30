@IsTest
private class VisualisationEmploiController_test {

    @IsTest
    private static void visualisationEmploiController() {
        Contact c = new Contact(Lastname = 'test');
        insert c; 

        GS_Fiche_de_poste__c f = new GS_Fiche_de_poste__c(Name = 'Test');
        insert f;

        Offre_d_emploi__c offer1 = new Offre_d_emploi__c(
                Status__c = '30 Enregistré',
                Fiche_de_poste__c = f.Id
                );
        insert offer1;
		System.assertEquals('30 Enregistré', offer1.Status__c);
        
        PageReference pg = Page.VisualisationEmploi;
        pg.getParameters().put('id', offer1.Id);
        Test.setCurrentPage(pg);

        VisualisationEmploiController controller=new VisualisationEmploiController();
        controller.getCities();
        controller.getFilieres();
        controller.getIndustries();
        String selectedFiliere = controller.selectedFiliere;
        String selectedIndustry = controller.selectedIndustry;
        String selectedCity = controller.selectedCity;
        VisualisationEmploiController.apply(offer1.Id, 'Test', c.Id);
    }
}