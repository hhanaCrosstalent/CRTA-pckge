@isTest
private without sharing class AlertMailArticleBatchTest {
	@TestSetup 
    static void setup() {
        Account account = BrainHRDataFactory.newAccount();
        insert account;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();

        Contact contact = BrainHRDataFactory.newContact(account);
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
                                LanguageLocaleKey = 'en_US',
                                isActive = true);  
        
        insert testUser;
        
        RecordType recordMedia = BrainHRDataFactory.getRecordType('crta__Article__c', 'Media');
        
        DateTime dt = System.today();
        Time myTime = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
    
        
        crta__Article__c article =  new crta__Article__c();
        article.Name = 'Test article';
        article.crta__Texte__c = 'Test';
        article.RecordTypeId = recordMedia.Id;
        insert article;
        
        crta__Article_Visibility__c droitArticle = new crta__Article_Visibility__c(crta__Account__c = account.Id,
                                                                    crta__Article__c = article.Id);
        insert droitArticle;
       
    }
    
    @isTest
    private static void testMethodOne() {
        crta__Article__c article = [
            SELECT Id, 
                Name,
                crta__Texte__c,
                crta__Email_Sent__c,
                crta__Banner__c 
            FROM crta__Article__c 
            WHERE crta__Banner__c = FALSE 
            ORDER BY CreatedDate DESC LIMIT 1];

        EmailTemplate e = new EmailTemplate(
            DeveloperName = 'test123456',
            FolderId = [SELECT Id FROM Folder WHERE Type = 'Email' AND Name = 'Portal'].Id,
            TemplateType= 'Custom',
            HtmlValue = '{!crta__Article__c.Name}',
            Name = 'test');
		insert e;
        
       	AlertMailArticleBatch myBatch = new AlertMailArticleBatch(article, e.DeveloperName, null);
        Database.executeBatch(myBatch);
        AlertMailArticleBatch.getScopeSize();
        System.assertEquals(AlertMailArticleBatch.getScopeSize(), 20);
    }
}