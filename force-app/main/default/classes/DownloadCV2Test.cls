@IsTest
public class DownloadCV2Test {

    public class HttpCalloutMockImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            String b = 'Name: Theodor Adorno Born: Frankfurt Year: 1968';
            res.setBody(b);
            return res;
        }
    }
    
    @IsTest
    private static void testAll() {
       
        
        String url = 'https://riminder-documents-eu-2019-12.s3-eu-west-1.amazonaws.com/resume.pdf';
        String url2 = 'exception.pdf';
        Id candidatureId = [SELECT Id FROM crta__Positionnement__c].Id;
        String pathOnClient = 'Adorno';
        String title = 'Adorno\'s CV';

        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        Test.startTest();
        DownloadCV2.downloadCV(url, candidatureId, pathOnClient, title);
        
        Test.stopTest();

        List<ContentVersion> cvs = [SELECT Id FROM ContentVersion];
        System.assertEquals(1, cvs.size());
        DownloadCV2.downloadCV(url2, candidatureId, pathOnClient, title);
        DownloadCV2.logMessage('message', 'body');
        DownloadCV2.activateLogs();
        
        
    }

    @TestSetup
    private static void testSetup() {
        crta__Positionnement__c candidature = new crta__Positionnement__c();
        insert candidature;
        
         Contact c=new Contact();
        c.LastName='Dupont';
        c.FirstName='Flore';
        insert c;
        
        crta__logs_activation__c logActivate = new crta__logs_activation__c();
        logActivate.crta__Active__c = true;
        insert logActivate;
    }
}