@IsTest
private without sharing class ContentDocumentLinkTest {
    
    @testSetup static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Modification_Request__c = true;
        setting.crta__Activate_on_Files__c = true;
        insert setting;
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
    }
    
	@IsTest
    private static void testAll() {
        Account a = BrainHRDataFactory.newAccount();
        insert a;
        
        Contact c = BrainHRDataFactory.newContact(a);
        insert c;
        
        crta__Dossier_documentaire__c d = new crta__Dossier_documentaire__c(Name = c.Name, crta__Salarie__c = c.Id);
        insert d;

        ContentVersion cv = new Contentversion();
        cv.Title = c.Id + '-CV';
        cv.crta__Type__c = 'CV';
        cv.PathOnClient ='test';
        cv.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert cv;

        ContentVersion version1 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = d.Id;
        fileLink.ContentDocumentId = version1.ContentDocumentId;
        fileLink.Sharetype = 'I';
        fileLink.Visibility = 'AllUsers';
        insert fileLink;
        
        System.assert(cv != null);
        System.assert(fileLink != null);
    }
}