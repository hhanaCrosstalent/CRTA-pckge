/**
 * @WsEngineTest.cls
 *
 * WsEngine class test
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
@IsTest
private class WsEngineV2Test {
    
    @IsTest
    private static void upsertHrFlowProfile() {

        RestRequest r = new RestRequest();
        RestResponse res = new RestResponse();
        r.requestURI = '/services/apexrest/v.40/HrFlowCreateProfile';  
        r.httpMethod = 'POST';
        RestContext.request = r;

        RestContext.response = res;

        String requestBody = '{"id": "666"}';
        r.requestBody = Blob.valueof(requestBody);
        WsEngine.Logger logger = new WsEngine.Logger();  
        Test.startTest();
        WsEngine.upsertHrFlowProfile();
        logger.createLog('First Comment','Second Comment');    
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(1, contacts.size(), 
            'Because the input did not provide a valid Contact, we only leave the existing Contact in peace.');
    }

    @TestSetup
    private static void testSetup() {
        Contact c = new Contact(
            FirstName = 'Abdelkader',
            LastName = 'Morjan'
        );
        insert c;
    }
   
}