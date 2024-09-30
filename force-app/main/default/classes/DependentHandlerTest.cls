@IsTest
private class DependentHandlerTest {
	 @testSetup
    private static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Dependent__c = true;
        insert setting;
       	crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
    }
    
    @IsTest
    private static void testAll() {
        Contact c = BrainHRDataFactory.newContact();
        insert c;
        
        Dependent__c d = new Dependent__c(
        crta__Employee__c = c.Id,
        crta__Last_Name__c = 'tt',
        crta__First_Name__c = 'aa'
        );
        insert d;

        d.crta__Social_Security_Number__c = '8990814168025';
        d.crta__Social_Number_Key__c = '07';
        update d;

        System.assert(d.crta__Social_Security_Number__c == '8990814168025');
    }
}