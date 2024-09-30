/**
 * Created by Saad on 03/02/2022.
 */

@IsTest
public class DownloadCVLWCTest {

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
        Id candidatureId = [SELECT Id FROM crta__Positionnement__c].Id;
        String pathOnClient = 'Adorno';
        String title = 'Adorno\'s CV';

        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        Test.startTest();
        DownloadCVLWC.downloadCV(url, candidatureId, pathOnClient, title,null,null);
        Test.stopTest();

        List<ContentVersion> cvs = [SELECT Id FROM ContentVersion];
        System.assertEquals(1, cvs.size());
        DownloadCVLWC.logMessage('message', 'body');
    }

    @TestSetup
    private static void testSetup() {
        crta__logs_activation__c setting = new crta__logs_activation__c();
        setting.crta__Active__c = true;
        insert setting;
        crta__Positionnement__c candidature = new crta__Positionnement__c();
        insert candidature;
    }
}