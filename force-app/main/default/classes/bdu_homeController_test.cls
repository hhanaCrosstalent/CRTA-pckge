@IsTest
public class bdu_homeController_test {

    @IsTest
    private static void bduHomeController() {
        Override__c options = new Override__c(CT_Home__c = 'bdu_HomeText');
        insert options;
        
        PageReference pg = Page.bdu_home;
        Test.setCurrentPage(pg);
        
        Bdu_homeController controller = new Bdu_homeController();
        Bdu_homeController.finishJoyride();
        system.assertEquals(options.CT_Home__c, 'bdu_HomeText');
    }
}