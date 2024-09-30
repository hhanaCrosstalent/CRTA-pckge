@IsTest
public class ContactHandlerTest {
    @testSetup
    public static void createTestData() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Contact__c = true;
        insert setting;

        crta__Automation_Settings__c autoSetting = new crta__Automation_Settings__c();
        autoSetting.crta__Set_Contact_Owner_from_User__c = true;
        insert autoSetting;

        crta__Geolocation__c settingLoc = new crta__Geolocation__c();
        settingLoc.API_key__c = 'AqiKi39Ge5Y57NRLwSrXTft8MU8UIHH5BR-lPz3tYyNBwU6Fzf-lSIjpxV7C5utk';
        settingLoc.ContactTrigger__c = true;
        insert settingLoc;
        
        
        //NMA 27/02/2024
        crta__ADP_Trigger_activation__c adp_trigger = new crta__ADP_Trigger_activation__c();
        adp_trigger.crta__ActivateTriggerADP__c = true;
        insert adp_trigger;
    }

	@IsTest
    public static void testAll() {
        Contact c = BrainHRDataFactory.newContact();
        insert c;

        Id systAdminId = BrainHRDataFactory.getSystemAdminProfile();
        insert BrainHRDataFactory.newUser(systAdminId, c.Id);

        c.crta__Numero_de_ss__c = '8990814168025';
        c.crta__Social_Number_Key__c = '07';
        update c;

        System.assert(c.crta__Numero_de_ss__c == '8990814168025');
        
        //NMA
        Id employeeRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salarie'].Id;
        
     
        
        
        crta__Employee_Number_Generator__c autoNumberContact = 
        new crta__Employee_Number_Generator__c(
            crta__Object_API_Name__c = 'Contact',
            crta__Field_API_Name__c = 'AssistantName',
            crta__Criteria_Object_Reference__c = 'AccountId',
            crta__Criteria_Field_Name__c = 'Name',
            crta__Criteria_Field_Value__c = 'AccountTest',
            crta__Pattern__c  = 'ZZZ{00000}',
            crta__Last_Created_Index__c = 10,
            crta__Is_Active__c = true,
            crta__Is_Active_For_Update__c = true
        );
        insert autoNumberContact;
        
        crta__Employee_Number_Generator__c autoNumberContact2 = 
        new crta__Employee_Number_Generator__c(
            crta__Object_API_Name__c = 'Contact',
            crta__Field_API_Name__c = 'AssistantName',
            crta__Criteria_Object_Reference__c = 'Contact',
            crta__Criteria_Field_Name__c = 'Name',
            crta__Criteria_Field_Value__c = 'AccountTest',
            crta__Pattern__c  = 'ZZZ{00000}',
            crta__Last_Created_Index__c = 10,
            crta__Is_Active__c = true,
            crta__Is_Active_For_Update__c = true
        );
        insert autoNumberContact2;
        
        Account acc=new Account (
        Name='AccountTest'
        );
        insert acc;
        
        
        Test.startTest();
        Contact contact = new Contact(
            RecordTypeId = employeeRT,
            LastName = 'Test',
            AccountId=acc.Id,
            FirstName = 'Test1'
        );
        insert contact;
     
        contact.FirstName='Test';
        update contact;
        Test.stopTest();
    }
}