/**
 * Created by Saad on 13/01/2022.
 */

@IsTest
private class FileLoaderTest
{
    @IsTest
    static void testBehavior()
    {   crta__logs_activation__c setting = new crta__logs_activation__c();
        setting.crta__Active__c = true;
        insert setting;
        Test.setMock(HttpCalloutMock.class, new FileLoaderMock());

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'ABC';
        contentVersion.PathOnClient = 'test';
        contentVersion.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert contentVersion;

        ContentVersion contentVers = [SELECT Id, Title, ContentDocumentId
        FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];

        Test.startTest();
        FileLoaderController.sendToParser(contentVers.ContentDocumentId);

        Test.stopTest();
    }
}