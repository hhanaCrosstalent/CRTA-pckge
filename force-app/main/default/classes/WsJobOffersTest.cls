/**
 * @WsJobOffersTest.cls
 *
 *WsJobOffer Test class
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
@IsTest
private class WsJobOffersTest {
     
    @IsTest
    private static void getJobOffersWS() {

        RestRequest r = new RestRequest();
        RestResponse res = new RestResponse();
        r.requestURI = '/services/apexrest/v.40/HrFlowGetJobOffers';  
        r.httpMethod = 'POST';
        RestContext.request = r;
        RestContext.response = res;
        String requestBody = '{"Name": "Morjana Offer"}';
        r.requestBody = Blob.valueof(requestBody);
        Test.startTest();
        List<crta__Offre_d_emploi__c> l = WsJobOffers.getJobOffersWS();
        WsEngine.Logger logger = new WsEngine.Logger();  
        logger.createLog('First Comment','Second Comment');    
        Test.stopTest();

        List<crta__Offre_d_emploi__c> offers = [SELECT Id FROM crta__Offre_d_emploi__c];
        System.assertEquals(1, offers.size(), 
            'Because the input did not provide a valid Offer, we only leave the existing Offer in peace.');
            System.debug('Size : '+offers.size());
        
    }

    @TestSetup
    private static void testSetup() {
        crta__Offre_d_emploi__c offer = new crta__Offre_d_emploi__c(
            Name = 'Morjana Offer',
            crta__CT_Description__c = 'Crosstalent offer test'
        );
        insert offer;
    } 
}