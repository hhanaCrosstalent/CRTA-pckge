@IsTest 
private class candidateSearchController_Test {
    
    @IsTest
    private static void testcandidateSearchController() {
        PageReference pg = Page.CandidateSearch;
        Test.setCurrentPage(pg);
        CandidateSearchController controller = new CandidateSearchController();
        controller.searchtext='a';
        controller.Search();
        controller.toggleSort();
        controller.searchtext= null;
        controller.mockContact.CT_Brut_fixe_recherche__c = 0;
        controller.Search();
        system.assert(controller.searchtext == null);
    }
}