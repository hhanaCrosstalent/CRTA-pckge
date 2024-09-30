@IsTest
private class OnboardingControllerTest {
	@IsTest
    private static void testAll() {
        Account a = new Account(Name = 'Account Name');
        insert a;
        String onboardingId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND RecordType.DeveloperName = 'Onboarding' LIMIT 1].Id;
        Contact c = new Contact(AccountId = a.Id, LastName = 'TestProfile', FirstName = 'TestProfile', Salutation = 'F', RecordTypeId = onboardingId);
        insert c;
        Dossier_documentaire__c d = new Dossier_documentaire__c(Name = c.Name, Salarie__c = c.Id, Unique_Name__c ='Test', crta__is_Onboarding_Folder__c=true);
        insert d;
		
        crta__Dependent__c dep =  new crta__Dependent__c(crta__First_Name__c = 'eee', crta__Employee__c = c.Id);
        insert dep;
        crta__Dependent__c dep2 =  new crta__Dependent__c(crta__First_Name__c = 'bee', crta__Employee__c = c.Id);
        insert dep2;
        
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
        
        OnboardingController.updateContactCtrl(c, true);
        OnboardingController.checkFilesCtrl(c.Id);
        OnboardingController.checkRelatedListFilesCtrl(c.Id);
        OnboardingController.getOnboardingSettingsCtrl();
        OnboardingController.recalculateFormulaCtrl(c);
    }
}