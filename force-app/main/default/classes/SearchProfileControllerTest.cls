@isTest
private without sharing class SearchProfileControllerTest {
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
            Username = 'userNameTesta1b2c3d4e5@test.fr',
            Email = 'userNameTesta1b2c3d4e5@test.fr',
            Alias = 'zyxwvu',
            CommunityNickname = 'userNameTesta1b2c3d4e5',
            ProfileId = testProfile.Id,
            LastName = 'userNameTesta1b2c3d4e5',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = cont.Id
        );
        insert u;
        System.assert(u != null);
        
        Contact contact = new Contact();
        System.runAs(u) {
            SearchProfileController.getContactsFilter('Name;Title', 'Salarié');
            SearchProfileController.getSchema('Contact', 'Salutation');
            SearchProfileController.getselectOptions(contact, 'Salutation');
         }
        
     }
}