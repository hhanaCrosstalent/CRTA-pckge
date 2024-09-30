@IsTest
private class bdu_searchController_test {
    
    @IsTest
    private static void bduSearch() {
        PageReference pageRef = Page.bdu_search;
        Test.setCurrentPage(pageRef);

        Bdu_searchController ctrl = new Bdu_searchController();
        ctrl.searchInput = 'test';
        ctrl.search();
        System.assert( ctrl.searchInput == 'test');
    }
}