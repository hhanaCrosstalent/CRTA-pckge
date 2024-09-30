@IsTest
private class BankAccountTest {
     @testSetup static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Bank_Account__c = true;
        insert setting;
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
    }
    
	@IsTest
    private static void testAll() {
        Contact c = BrainHRDataFactory.newContact();
        insert c;
        
        crta__Bank_Account__c d = new crta__Bank_Account__c(crta__IBAN__c = 'GB33BUKB20201555555555', crta__Contact__c = c.Id);
        insert d;
        
        System.assert(d != null);
    }
}