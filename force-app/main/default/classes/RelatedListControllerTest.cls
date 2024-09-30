@IsTest
private with sharing class RelatedListControllerTest {
	@IsTest
    private static void testAll() {
        Account a = BrainHRDataFactory.newAccount();
        insert a;
        
        Contact c = BrainHRDataFactory.newContact(a);
        insert c;
   
        System.assert(a != null);
        System.assert(c != null);
        
        crta__Dossier_documentaire__c d = new crta__Dossier_documentaire__c(Name = c.Name, crta__Salarie__c = c.Id);
        insert d;
        Profile profileTest = BrainHRDataFactory.getAdminProfile();
        User u = new User(
            Username = 'userNameTesta1b2c3d4e5@test.fr',
            Email = 'userNameTesta1b2c3d4e5@test.fr',
            Alias = 'zyxwvu',
            CommunityNickname = 'userNameTesta1b2c3d4e5',
            ProfileId = profileTest.Id,
            LastName = 'userNameTesta1b2c3d4e5',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = c.Id
        );
        insert u;
		
        System.assert(u != null);
        ContentVersion cv = new Contentversion();
        cv.Title = d.Id + '-test';
        cv.crta__Type__c = 'CV';
        cv.PathOnClient = 'test';
        cv.Versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert cv;

        ContentVersion version1 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = d.Id;
        fileLink.ContentDocumentId = version1.ContentDocumentId;
        fileLink.sharetype = 'I';
        fileLink.Visibility = 'AllUsers';
        
        insert fileLink;
        
		
        System.assert(fileLink != null);
        System.runAs(u) {
            RelatedListController.retrievePicklistValues('Contact', 'crta__Situation_familiale__c');
            List<String> fields = new List<String>{'Name','crta__A_afficher__c','crta__Date_de_publication__c','crta__Dossier_parent__c'};
            RelatedListController.getFieldsCtrl('crta__Dossier_documentaire__c', fields, true, null,false);
            RelatedListController.getRecordsCtrl(String.join(fields, ','), 'crta__Dossier_documentaire__c', 'crta__Salarie__c', null, null, null, null);
            RelatedListController.getRecordCtrl(fields, 'crta__Dossier_documentaire__c', d.Id);
            
            crta__Dossier_documentaire__c d2 = new crta__Dossier_documentaire__c(Name = c.Name + '2', Salarie__c = c.Id);
            
            RelatedListController.insertNewRecord(d2, 'crta__Dossier_documentaire__c', 'crta__Salarie__c', null, null, null, null);
            RelatedListController.editRecordCtrl(d);
            RelatedListController.getFilesCtrl(d2.Id);
            RelatedListController.deleteFileCtrl(version1.ContentDocumentId);
            RelatedListController.deleteRecordCtrl(d.Id);
        }
    }
}