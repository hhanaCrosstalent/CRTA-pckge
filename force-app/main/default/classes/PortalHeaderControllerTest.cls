@isTest
private without sharing class PortalHeaderControllerTest {
    @isTest
	private static void testMethodOne() {
        RecordType recordMedia = BrainHRDataFactory.getRecordType('crta__Article__c', 'Media');
        
        crta__Article__c coverImage =  new crta__Article__c();
        coverImage.Name = 'Test article couverture';
        coverImage.crta__Date_de_publication__c = system.Today();
        coverImage.crta__Banner__c = true;
        coverImage.RecordTypeId = recordMedia.Id;
        insert coverImage;
        
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
        
        System.assert(acc != null);
        System.assert(cont != null);
        
        crta__Article_Visibility__c visibility = new crta__Article_Visibility__c(crta__Account__c = acc.Id, crta__Article__c = coverImage.Id);
        insert visibility;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();

         User u = new User(
            Username = 'kiykiyikyk@test.fr',
            Email = 'kiykiyikyk@test.fr',
            Alias = 'joik00',
            CommunityNickname = 'kiykiyikyk',
            ProfileId = testProfile.Id,
            LastName = 'kiykiyikyk',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = cont.Id
        );
        insert u;
        
        ContentVersion articleImg = new Contentversion();
        articleImg.title= coverImage.Id + '-article';
        articleImg.PathOnClient ='test';
        articleImg.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert articleImg;

        ContentVersion versionPhoto = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :articleImg.Id];

        
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = coverImage.Id;
        fileLink.ContentDocumentId = versionPhoto.ContentDocumentId;
        fileLink.sharetype = 'I';
        fileLink.Visibility = 'AllUsers';

        insert fileLink;
        
        System.runAs(u) {
        	PortalHeaderController.getHeader();
            PortalHeaderController.getFileFromArticle(coverImage.id);
        }
    }
}