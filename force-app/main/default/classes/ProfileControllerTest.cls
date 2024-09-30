@IsTest
private without sharing class ProfileControllerTest {
    @IsTest
    private static void testAll() {
        Account a = new Account(Name = 'Account Name');
        insert a;
        String salarieId = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Salarie' LIMIT 1].Id;
        Contact c = new Contact(AccountId = a.Id, LastName = 'TestProfile', FirstName = 'TestProfile', Salutation = 'F', RecordTypeId = salarieId);
        insert c;
        Dossier_documentaire__c d = new Dossier_documentaire__c(Name = c.Name, Salarie__c = c.Id, Unique_Name__c ='Test');
        insert d;
		
        System.assert(c != null);
        System.assert(d != null);
        User u = new User(
            Username = 'userNameTesta1b2c3d4e5@test.fr',
            Email = 'userNameTesta1b2c3d4e5@test.fr',
            Alias = 'zyxwvu',
            CommunityNickname = 'userNameTesta1b2c3d4e5',
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%dmin%' AND Name LIKE '%sys%' LIMIT 1].Id,
            LastName = 'userNameTesta1b2c3d4e5',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            Contact__c = c.Id
        );
        insert u;

        ContentVersion photo = new Contentversion();
        photo.title= c.Id + '-profilPicture';
        photo.Type__c = 'profilPicture';
        photo.PathOnClient ='test';
        Blob b = Blob.valueOf('Unit Test File Body');
        photo.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert photo;

        ContentVersion versionPhoto = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :photo.Id];

        
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = c.Id;
        fileLink.ContentDocumentId = versionPhoto.ContentDocumentId;
        fileLink.sharetype = 'I';
        fileLink.Visibility = 'AllUsers';

        insert fileLink;

        System.runAs(u) {
            c = (Contact)JSON.deserialize(ProfileController.getContactCtrl(c.Id, 'AccountId'), Contact.class);
            ProfileController.updateContactCtrl(c);
            ProfileController.retrievePicklistValues('Contact', 'crta__Situation_familiale__c');
    
            Demande_de_modification__c editRequest = new Demande_de_modification__c();
            editRequest.Salarie__c = c.Id;
            editRequest.Champ__c = 'Firstname';
            editRequest.Champ_technique__c = 'Firstname';
            editRequest.crta__Old_Value__c = 'oldValue';
            editRequest.crta__New_Value__c = 'newValue';
            editRequest.Statut__c = '10 Demandé';
            ProfileController.createEditRequestCtrl(new List<Demande_de_modification__c>{editRequest}, new List<String>{'string'}, c.Id, null);
            ProfileController.getSectionsCtrl(c.Id,'AccountId');
            ProfileController.getConnectedContactIdCtrl();
            ProfileController.getContactPhoto(c.Id);
            ProfileController.updateFileCtrl(fileLink.ContentDocumentId, c.id);
            ProfileController.getTabsCtrl(c.Id,'AccountId');

            Demande_de_modification__c editRequest2 = new Demande_de_modification__c();
            editRequest2.Salarie__c = c.Id;
            editRequest2.Champ__c = 'MailingAddress';
            editRequest2.Champ_technique__c = 'MailingAddress';
            editRequest2.crta__Old_Value__c = 'oldValue';
            editRequest2.crta__New_Value__c = 'A - A - B - B - C';
            editRequest2.Statut__c = '10 Demandé';
            ProfileController.createEditRequestCtrl(new List<Demande_de_modification__c>{editRequest2}, new List<String>{'string'}, c.Id, null);
            
            Demande_de_modification__c editRequest3 = new Demande_de_modification__c();
            editRequest3.Salarie__c = c.Id;
            editRequest3.Champ__c = 'DoNotCall';
            editRequest3.Champ_technique__c = 'DoNotCall';
            editRequest3.crta__Old_Value__c = 'false';
            editRequest3.crta__New_Value__c = 'true';
            editRequest3.Statut__c = '10 Demandé';
            ProfileController.createEditRequestCtrl(new List<Demande_de_modification__c>{editRequest3}, new List<String>{'boolean'}, c.Id, null);
            
            ContentVersion cv = new Contentversion();
            cv.title = 'test';
            cv.Type__c = 'Attestation de sécurité sociale';
            cv.PathOnClient ='test';
            cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
            insert cv;
            ContentVersion version1 = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            
            Demande_de_modification__c editRequest4 = new Demande_de_modification__c();
            editRequest4.Salarie__c = c.Id;
            editRequest4.Champ__c = 'DoNotCall';
            editRequest4.Champ_technique__c = 'DoNotCall';
            editRequest4.crta__Old_Value__c = 'true';
            editRequest4.crta__New_Value__c = 'false';
            editRequest4.Statut__c = '10 Demandé';
            ProfileController.createEditRequestCtrl(new List<Demande_de_modification__c>{editRequest4}, new List<String>{'boolean'}, c.Id, new List<String>{version1.ContentDocumentId});
            
            Demande_de_modification__c editRequest5 = new Demande_de_modification__c();
            editRequest5.Salarie__c = c.Id;
            editRequest5.Champ__c = 'OtherAddress';
            editRequest5.Champ_technique__c = 'OtherAddress';
            editRequest5.crta__Old_Value__c = '';
            editRequest5.crta__New_Value__c = '';
            editRequest5.Statut__c = '10 Demandé';
            ProfileController.createEditRequestCtrl(new List<Demande_de_modification__c>{editRequest5}, new List<String>{'string'}, c.Id, null);
        }
    }
}