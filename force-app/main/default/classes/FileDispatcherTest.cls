@IsTest
public class FileDispatcherTest {

    // TODO
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }


    @IsTest
    private static void dispatch() {
        Test.startTest();
        Test.stopTest();
    }

    @TestSetup
    private static void testSetup() {
        
    }
}