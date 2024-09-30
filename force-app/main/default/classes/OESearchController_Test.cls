@IsTest
private class OESearchController_Test {
    
    @IsTest
    private static void testOESearch() {

        PageReference pg = Page.Recherche_offre_d_emploi;
        Test.setCurrentPage(pg);
        pg.getParameters().put('date1', '01/01/2013');
        pg.getParameters().put('intitule_mission', 'a');
        pg.getParameters().put('departement', '75');
        pg.getParameters().put('secteur_d_activite', 'aa');
        
        OESearchController controller = new OESearchController();

        System.assert(controller.runSearch() == null);
        controller.toggleSort();
     
        List<SelectOption> testsecteur_d_activite = new List<SelectOption>();
        testsecteur_d_activite = controller.secteur_d_activite;
    
        String s1 = controller.OEcount;
        String s2 = controller.debugSoql;
    
        controller.first();
        controller.last();
        controller.next();
        controller.previous();
        Boolean b1 = controller.getdisablenext();
        Boolean b2 = controller.getdisableprevious();
        Integer i1 = controller.gettotalpages();
        Integer i2 = controller.getpagenumber();
    }
}