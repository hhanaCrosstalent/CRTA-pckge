@isTest
private without sharing class AlertMailArticleControllerTest {
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
		
        crta__Article__c article2 =  new crta__Article__c();
        article2.Name = 'Test bannière';
        article2.crta__Banner__c = true;
        article2.RecordTypeId = recordMedia.Id;
        insert article2;
       
    }
    
    @isTest
    private static void testMethodOne() {
        crta__Article__c article = [
            SELECT Id 
            FROM crta__Article__c 
            WHERE crta__Banner__c = FALSE 
            ORDER BY CreatedDate DESC LIMIT 1];

        EmailTemplate e = new EmailTemplate(
            DeveloperName = 'test032546',
            FolderId = [SELECT Id FROM Folder WHERE Type = 'Email' AND Name = 'Portal'].Id,
            TemplateType= 'Custom',
            HtmlValue = '{!crta__Article__c.Name}',
            Name = 'test'
        );
		insert e;
        
        AlertMailArticleController.sendMailCtrl(article.Id, e.DeveloperName, '');
        
        crta__Article__c article2 = [
            SELECT Id 
            FROM crta__Article__c 
            WHERE crta__Banner__c = TRUE 
            ORDER BY CreatedDate DESC LIMIT 1];
        AlertMailArticleController.sendMailCtrl(article2.Id, e.Name, '');

        AlertMailArticleController.getEmailTemplates();
        AlertMailArticleController.getOrgEmails();
        Map<String, String> orgmails = AlertMailArticleController.getOrgEmails();
        String mail;
        for(String s : orgmails.keySet()) {
            mail = orgmails.get(s);
        }
        System.assertEquals(mail, 'No Reply - admin@crosstalent.fr');
    }
}