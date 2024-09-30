/*
* @Author Fallou MBAYE
* Cretead Date 2022-01-06
* List modified
*  ==> Modified by XXXX
*  ==> Modified Date yyyy-mm-dd
*/
@isTest
private class orgChartLWCControllerTest {
    @isTest
    private static void testMethodOne() {
    	Account acc = BrainHRDataFactory.newAccount();
        insert acc;
        
        Contact cont = BrainHRDataFactory.newContact(acc);
        insert cont;
		
        System.assert(acc != null);
        System.assert(cont != null);
        string randomChar = 
        DateTime.now().getTime() + 'srhnfyjfrj.tjssnxest@jytjteffsxfnffnssdnfgt.com.' + DateTime.now().getTime();
		
        Profile testProfile = BrainHRDataFactory.getAdminProfile();
        
    	User u = new User(
            Username = randomChar,
            Email = 'testtestazerty@test.fr',
            Alias = 'test03',
            ProfileId = testProfile.Id,
            LastName = 'testtestazerty',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = cont.Id
        );
        insert u;
        
        Contact cont2 = BrainHRDataFactory.newContact(acc);
        cont2.ReportsToId = cont.Id;
        insert cont2;

        string randomChar2 = 
        DateTime.now().getTime() + 'srhnfyjfrj.tjssnxest@jytjteffsxfnffnssdnfgt.com.' + DateTime.now().getTime();

    	User u2 = new User(
            Username = randomChar2,
            Email = 'testtestazerty2@test.fr',
            Alias = 'test06',
            ProfileId = testProfile.Id,
            LastName = 'testtestazerty2',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = cont2.Id
        );
        insert u2;
        
        orgChartLWCController.getParentContacts();
        orgChartLWCController.getCurrentContact();
        orgChartLWCController controller = new orgChartLWCController();
    }

}