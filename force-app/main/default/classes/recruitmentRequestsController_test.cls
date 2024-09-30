@IsTest
private class recruitmentRequestsController_test {
    
    @IsTest
    private static void recruitmentRequestsControllerTest() {
        Offre_d_emploi__c offer = new Offre_d_emploi__c();
        List<Offre_d_emploi__c> offers = new List<Offre_d_emploi__c>();
        offers.add(offer);
        
        PageReference pg = Page.recruitmentRequests;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id', offer.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(offer);
        recruitmentRequestsController controller 
            = new recruitmentRequestsController(new ApexPages.StandardSetController(offers));
        System.assert(ApexPages.currentPage().getParameters().get('id') == offer.Id);
    }
}