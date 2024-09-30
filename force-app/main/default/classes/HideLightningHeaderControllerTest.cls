@isTest
private class HideLightningHeaderControllerTest {
	@isTest
    private static void itShould() {
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
        
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
        system.assert(u != null);
        System.runAs(u) {
        	HideLightningHeaderController.getContactId();
            
        }
    }
}