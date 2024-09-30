@isTest
private without sharing class ArticleDetailsControllerTest {
	@isTest
	private static void testMethodOne() {
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();
        
        Contact contact = BrainHRDataFactory.newContact(acc);
        insert contact;
        
        User testUser = new User(LastName = 'test user 1', 
                                Username = 'test.user.1@example.com', 
                                Email = 'test.1@example.com', 
                                Alias = 'testu1', 
                                TimeZoneSidKey = 'GMT', 
                                LocaleSidKey = 'en_GB', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                ProfileId = testProfile.Id,
                                crta__Contact__c = contact.Id,
                                LanguageLocaleKey = 'en_US');  
        
        insert testUser;
        
        RecordType recordMedia = BrainHRDataFactory.getRecordType('crta__Article__c', 'Media');
        
        DateTime dt = System.today();
		Time myTime = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
    
        
        crta__Article__c article =  new crta__Article__c();
        article.Name = 'Test article';
        article.crta__Texte__c = 'Test';
        article.RecordTypeId = recordMedia.Id;
        insert article;
        
        ContentVersion articleImg = new Contentversion();
        articleImg.title = article.Id + '-article';
        articleImg.PathOnClient ='test';
        Blob b = Blob.valueOf('Unit Test File Body');
        articleImg.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert articleImg;

        ContentVersion versionPhoto = [
            SELECT Id,
                ContentDocumentId
            FROM ContentVersion WHERE Id = :articleImg.Id];

        
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = article.Id;
        fileLink.ContentDocumentId = versionPhoto.ContentDocumentId;
        fileLink.Sharetype = 'I';
        fileLink.Visibility = 'AllUsers';

        insert fileLink;
        
        System.runAs(testUser) {
            System.assertEquals(fileLink.LinkedEntityId, article.id);
        	ArticleDetailsController.getArticleDetails(article.id);
            ArticleDetailsController.getFileFromArticle(article.id);
        }
    }
}