@IsTest
private class ContactTest {
     @testSetup static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Contact__c = true;
        insert setting;
    }
    
	@IsTest
    private static void testAll() {
        Contact c = BrainHRDataFactory.newContact();
        insert c;
        
        c.crta__Numero_de_ss__c = '8990814168025';
        c.crta__Social_Number_Key__c = '07';
        
        update c;
        
        System.assert(c.crta__Numero_de_ss__c == '8990814168025');
    }
}