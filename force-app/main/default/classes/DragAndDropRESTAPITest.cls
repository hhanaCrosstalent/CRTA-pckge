@IsTest
public class DragAndDropRESTAPITest {
    
    

    @IsTest
    public static void testattachDoc(){
        // Prepare test Data
   
        
        // Initialize Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/DragAndDrop/v1';
        req.params.put('FileName','TEST_NAME');
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        try {
        DragAndDropRESTAPI.attachDoc();
        }catch(Exception e) {
            
        }
         Test.stopTest();
    }
}