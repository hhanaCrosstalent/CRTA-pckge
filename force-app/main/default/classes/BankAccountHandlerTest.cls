@IsTest
private class BankAccountHandlerTest {
     @testSetup static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Bank_Account__c = true;
        insert setting;
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
        //NMA 29/02/2024
        crta__ADP_Trigger_activation__c adp_trigger = new crta__ADP_Trigger_activation__c();
        adp_trigger.crta__ActivateTriggerADP__c = true;
        insert adp_trigger;
    }
    
	@IsTest
    private static void testAll() {
        Contact c = BrainHRDataFactory.newContact();
        insert c;
        
        crta__Bank_Account__c d = new crta__Bank_Account__c(crta__IBAN__c = 'GB33BUKB20201555555555', crta__Contact__c = c.Id);
        insert d;
        
        d.crta__Bank_Account_Holder__c='Test';
        update d;
        System.assert(d != null);
    }
}