@isTest
private without sharing class ChangeFolderOwnerTest {
	@IsTest
    private static void testAll() {
        Account acc = BrainHRDataFactory.newAccount();
        insert acc;
         
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
		
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
        System.assertEquals(u.LastName, 'testtest');
        System.assert(u != null);
        
        Trigger_Settings__c setting = new Trigger_Settings__c();
        setting.Activate_on_Folder__c = true;
        insert setting;
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
        
        crta__Dossier_documentaire__c dossier = new crta__Dossier_documentaire__c(Name = 'Test test', 
                                                                          crta__Salarie__c = cont.Id,
                                                                          crta__Unique_Name__c = 'tt',
                                                                          crta__A_afficher__c = true);
        insert dossier;
        System.runAs(u) {
            crta__Dossier_documentaire__c dossierChild = new crta__Dossier_documentaire__c(Name = 'Test test', 
                                                                               crta__Salarie__c = cont.Id,
                                                                               crta__Unique_Name__c = 'tt2',
                                                                               crta__Dossier_parent__c = dossier.Id, 
                                                                               crta__A_afficher__c = true);
            insert dossierChild;
        }
    }
}