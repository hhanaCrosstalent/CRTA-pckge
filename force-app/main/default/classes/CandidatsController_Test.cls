@IsTest
private class CandidatsController_Test {

    @IsTest
    private static void testCandidat() {
        
        PageReference pg = Page.Candidat;
        Test.setCurrentPage(pg);
        pg.getParameters().put('client', 'zz');
        pg.getParameters().put('situation', 'tous');
        pg.getParameters().put('consultant', 'tous');
        pg.getParameters().put('contrat', 'tous');
        pg.getParameters().put('lieu', 'tous');
        System.assertEquals(pg.getParameters().get('client'), 'zz');
        System.assertEquals(pg.getParameters().get('situation'), 'tous');
        CandidatsController controller=new candidatsController();
        controller.processRequests();
        
        List<String> testclient = new List<String>();
        controller.getclient();
        controller.getconsultant();
        controller.getcontract();
        controller.getplace();
        controller.getitems();
        
        controller.first();
        controller.last();
        controller.next();
        controller.previous();
        controller.togglesort();
        Boolean b1 = controller.getdisablenext();
        Boolean b2 = controller.getdisableprevious();
        Integer i1 = controller.gettotalpages();
        Integer i2 = controller.getpagenumber();
        Integer i3 = controller.gettotal_size();
    }
}