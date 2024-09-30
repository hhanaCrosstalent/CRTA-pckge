@isTest
private class VisualisationCatalogueController_test {

  @isTest static void VisualisationCatalogueController() {
    TrainingModule__c options = new TrainingModule__c(
          showUnavailableSessions__c = false
    );
    insert options;

    contact c = new contact(lastname='test') ;
    insert c; 
	System.assertEquals('test', c.lastname);
      
    FO_catalogue_de_formation__c module1 = new FO_catalogue_de_formation__c(
        FO_Nom_de_la_formation__c = 'Déploiement Salesforce',
        FO_Type__c = 'Technique',
        FO_Duree__c = '6h',
        FO_Lieu__c = 'Paris',
        FO_Diplomante__c = true
    );
    insert module1;
	System.assertEquals('Technique', module1.FO_Type__c);
    FO_catalogue_de_formation__c module2 = new FO_catalogue_de_formation__c(
        FO_Nom_de_la_formation__c = 'Apex',
        FO_Type__c = 'Langage',
        FO_Duree__c = '5j',
        FO_Lieu__c = 'Paris',
        FO_Diplomante__c = false
    );
    insert module2;
	System.assertEquals('Langage', module2.FO_Type__c);
    //instantiate a page     
    PageReference pg = Page.VisualisationCatalogue;
    pg.getParameters().put('id', module1.Id);
    Test.setCurrentPage(pg);

    // instantiate the controller
    VisualisationCatalogueController controller=new VisualisationCatalogueController();
    controller.getTypes();
    controller.getModes();
    controller.getOrganizations();
    controller.getEmployees();
    String selectedType = controller.selectedType;
    String selectedOrganization = controller.selectedOrganization;
    String selectedMode = controller.selectedMode;
    String selectedEmployee = controller.selectedEmployee;
  }

}