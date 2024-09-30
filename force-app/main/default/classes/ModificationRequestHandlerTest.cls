@isTest
private without sharing class ModificationRequestHandlerTest {
	@isTest
    static void updateField() {
        Account a = BrainHRDataFactory.newAccount();
        insert a;
        
        Contact c = BrainHRDataFactory.newContact(a);
        insert c;
        
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
            crta__Contact__c = c.Id
        );
        insert u;
        System.assert(u != null);
        System.runAs(u) {
            crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        	setting.crta__Activate_on_Modification_Request__c = true;
            setting.crta__Activate_on_Files__c = true;
        	insert setting;
            crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
            setting2.crta__Activate_Triggers__c = true;
            insert setting2; 
            
            crta__Demande_de_modification__c editRequest = new crta__Demande_de_modification__c();
            editRequest.crta__Salarie__c = c.Id;
            editRequest.crta__Champ__c = 'Firstname';
            editRequest.crta__Champ_technique__c = 'Firstname';
            editRequest.crta__Old_Value__c = 'oldValue';
            editRequest.crta__New_Value__c = 'newValue';
            editRequest.crta__Statut__c = '10 Demandée';
            insert editRequest;
            
            editRequest.crta__Statut__c = '30 Validée';
            update editRequest;
           
            crta__Demande_de_modification__c editRequestAddress = new crta__Demande_de_modification__c();
            editRequestAddress.crta__Champ_technique__c = 'MailingAddress';
            editRequestAddress.crta__Salarie__c = c.Id; 
            editRequestAddress.crta__Statut__c = '10 Demandée';
            editRequestAddress.crta__New_Value__c = '117 rue St lazare - 75007 - Paris - Ile de France - France';
            editRequestAddress.crta__Old_Value__c = '117 rue St Lazare - 75008 - Paris - - France';
            insert editRequestAddress;
    
            editRequestAddress.crta__Statut__c = '30 Validée';
            update editRequestAddress;
            editRequestAddress.crta__Statut__c = '70 Rétablie';
            update editRequestAddress;
            
            crta__Demande_de_modification__c editRequestNumeric = new crta__Demande_de_modification__c();
            editRequestNumeric.crta__Champ_technique__c = 'crta__CT_Brut_fixe_recherche__c';
            editRequestNumeric.crta__Salarie__c = c.Id; 
            editRequestNumeric.crta__Statut__c = '10 Demandée';
            editRequestNumeric.crta__New_Value__c = '5000';
            editRequestNumeric.crta__Old_Value__c = '2000';
            insert editRequestNumeric;
    
            editRequestNumeric.crta__Statut__c = '30 Validée';
            update editRequestNumeric;
            editRequestNumeric.crta__Statut__c = '70 Rétablie';
            update editRequestNumeric;
        }
    }
}