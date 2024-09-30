@isTest
private without sharing class ArticlesListControllerTest {
	@isTest
    private static void testMethodOne() {
        RecordType recordMedia = BrainHRDataFactory.getRecordType('crta__Article__c', 'Media');
        
        DateTime dt = System.today();
        Time myTime = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
      
        crta__Article__c article = new crta__Article__c();
        article.Name = 'Test article';
        article.crta__Texte__c = 'Test';
        article.RecordTypeId = recordMedia.Id;
        insert article;
        
        crta__Article__c article2 = new crta__Article__c();
        article2.Name = 'Test article 2';
        article2.crta__Start_Date__c = system.today();
        article2.RecordTypeId = recordMedia.Id;
        insert article2;
       
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
        
        crta__Article_Visibility__c visibility = new crta__Article_Visibility__c(Account__c = acc.Id,
                                                                                Article__c = article.Id);
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
        
        User u2 = new User(
            Username = 'ddzddeds@test.fr',
            Email = 'ddzddeds@test.fr',
            Alias = 'ddz00',
            CommunityNickname = 'ddzddeds',
            ProfileId = testProfile.Id,
            LastName = 'ddzddeds',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO'
        );
        insert u2;
        System.assertEquals(article.Name, 'Test article');
        System.assertEquals(article2.Name, 'Test article 2');
        System.runAs(u) {
             ArticlesListController.getArticlesList(5, 'Media');
        }
        
        System.runAs(u2) {
            ArticlesListController.getArticlesList(5, 'Archives');
        }
    }
}