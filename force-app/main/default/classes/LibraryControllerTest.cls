@isTest
private without sharing class LibraryControllerTest {
    @isTest
	private static void testMethodOne() {
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
         
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
		
        System.assert(acc != null);
        System.assert(cont != null);
        Profile testProfile = BrainHRDataFactory.getAdminProfile(); 
        User u = new User(
            Username = 'test.user.1@example.com',
            Email = 'testtest@test.fr',
            Alias = 'test03',
            ProfileId = testProfile.Id,
            LastName = 'testtest',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = cont.Id
        );
        insert u;
        
        System.assert(u != null);
        crta__Dossier_documentaire__c dossier = new crta__Dossier_documentaire__c(Name = 'Test test', 
                                                                      crta__Salarie__c = cont.Id,
                                                                      crta__Unique_Name__c = 'tt',
                                                                      crta__A_afficher__c = true);
        insert dossier;
        
        crta__Dossier_documentaire__c dossierChild = new crta__Dossier_documentaire__c(Name = 'Test test', 
                                                                           crta__Salarie__c = cont.Id,
                                                                           crta__Unique_Name__c = 'tt2',
                                                                           crta__Dossier_parent__c = dossier.Id, 
                                                                           crta__A_afficher__c = true);
        insert dossierChild;
        
       ContentVersion cv = new Contentversion();
        cv.Title = 'test';
        cv.PathOnClient ='test';
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
         
        ContentVersion version1 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
         ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.LinkedEntityId = dossier.Id;
         cdl.ContentDocumentId = version1.ContentDocumentId;
         cdl.shareType = 'I';
         insert cdl;
        
        ContentVersion cv2 = new Contentversion();
        cv2.Title = 'test 2';
        cv2.PathOnClient ='test';
        cv2.crta__Type__c = 'CV';
        cv2.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv2;
        
        ContentVersion version2 = [SELECT Id, crta__Type__c, FileExtension, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.LinkedEntityId = dossierChild.Id;
        cdl2.ContentDocumentId = version2.ContentDocumentId;
        cdl2.shareType = 'I';
        insert cdl2;
        
        Group newGroup = new Group();
		newGroup.Name = 'Group Test';
        insert newGroup;
        
        System.runAs(u) {
            GroupMember newMember = new GroupMember();
            newMember.GroupId = newGroup.Id;
            newMember.UserOrGroupId = u.Id;
            insert newMember;
            
            EmailTemplate e = new EmailTemplate(
            DeveloperName = 'test123456',
            FolderId = [SELECT Id FROM Folder WHERE Type = 'Email'].Id,
            BrandTemplateId = [SELECT Id FROM BrandTemplate LIMIT 1].Id,
            TemplateType= 'Custom',
            HtmlValue = 'TEST',
            Name = 'test');
			insert e;
            
            LibraryController.getConnectedContactIdCtrl();
            LibraryController.getFileTypes();
            LibraryController.getTagsList();
            LibraryController.getFoldersList(); 
            LibraryController.updateFilesCtrl(version2.ContentDocumentId, dossierChild.Id, 'CV', new List<String>{'RH'});
            LibraryController.sendMailCtrl('Group_Test', version2.ContentDocumentId, dossierChild.Id, e.DeveloperName);
            LibraryController.deleteFileCtrl(version2.ContentDocumentId);
           	LibraryController.getFoldersCtrl(true, NULL);
        }
    }
}