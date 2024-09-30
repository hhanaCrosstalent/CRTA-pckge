@IsTest
public class TeamControllerTest {
 	@IsTest
    private static void testAll() {
        Test.startTest();
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
        
        System.assert(acc != null);
        System.assert(cont != null);
        
        Contact cont1 = BrainHRDataFactory.newContact(acc);
        cont1.ReportsToId = cont.Id;
        insert cont1;
        
        crta__Team_Settings__c setting = new crta__Team_Settings__c();
        setting.crta__Field_1__c = 'Title';
        setting.crta__Field_2__c = 'crta__CT_Service__c';
        setting.crta__Field_3__c = 'crta__CT_Matricule__c';
        setting.crta__Field_4__c = 'crta__CT_Date_of_entry_to_the_society__c';
        insert setting;
        
        System.assert(setting.crta__Field_1__c == 'Title');
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
        System.assert(u != null);
        System.runAs(u) {
            TeamController.getTranslations();
            TeamController.getSettings();
            TeamController.getEmployee(3, null);
            TeamController.getEmployee(3, 'Salarie');
            TeamController.getEmployee(3, 'Salarie');
            TeamController.getEmployee(3, 'Salarie, Recrutement');
            TeamController.getEmployee(3, 'Salarie, Recrutement');
            System.assert(TeamController.getEmployee(3, 'Salarie') != null);
            System.assert(TeamController.getEmployee(3, 'Salarie') != null);
            System.assert(TeamController.getEmployee(3, 'Salarie, Recrutement') != null);
        }
        
    }
}