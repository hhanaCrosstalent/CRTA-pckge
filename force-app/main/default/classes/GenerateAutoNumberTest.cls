/*
 @Author : Nouha Maddeh
 * @CreatedDate : 27/09/2021
 * 
 * */
@isTest
public class GenerateAutoNumberTest {
        
    @isTest 
    static void test() {

        Test.startTest();
        Account account = new Account(Name = 'test');
        insert account;

        Account etablissment = new Account(Name = 'testETABlissement');
        insert etablissment;

        Account socity = new Account(Name = 'testSocity');
        insert socity;

        Contact contact = new Contact(
            LastName = 'Test',
            AccountId = account.Id,
            crta__Subsidiary__c = etablissment.Id,
            crta__Legal_Account__c =  socity.Id
        );

        insert contact;
        GenerateAutoNumber.generate(
            new List<Contact>{contact},
            'AssistantName',
            'AccountId',
            'Account',
            'Name',
            false
        );
        
        //System.assertNotEquals('ABC00001',contact.AssistantName);
        
        List<Contact> contacts = new List<Contact>();
        
        Contact contact2 = new Contact(
            LastName = 'Test2',
            AccountId = account.Id,
            crta__Subsidiary__c = etablissment.Id,
            crta__Legal_Account__c =  socity.Id
        );
        contacts.add(contact2);

        Contact contact3 = new Contact(
            LastName = 'Test3',
            AccountId = account.Id,
            crta__Subsidiary__c = etablissment.Id,
            crta__Legal_Account__c =  socity.Id
        );
        contacts.add(contact3);

        Contact contact4 = new Contact(
            LastName = 'Test4',
            AccountId = account.Id,
            crta__Subsidiary__c = etablissment.Id,
            crta__Legal_Account__c =  socity.Id
        );
        contacts.add(contact4);
        insert contacts;
        GenerateAutoNumber.generate(
            contacts,
            'AssistantName',
            'AccountId',
            'Account',
            'Name',
            false
        );
        
       // System.assertNotEquals('ABC00004',contact4.AssistantName);
        Test.stopTest();
    }

    @isTest
    static void test2() {

        Test.startTest();
        
        Account account = new Account(Name = 'test');
        insert account;

        Account etablissment = new Account(Name = 'testETABlissement');
        insert etablissment;

        Account socity = new Account(Name = 'testSocity');
        insert socity;

        Account account2 = new Account(Name = 'test2');
        insert account2;

        Contact contact = new Contact(
            LastName = 'Test',
            AccountId = account.Id,
            crta__Subsidiary__c = etablissment.Id,
            crta__Legal_Account__c =  socity.Id
        );
        insert contact;

        GenerateAutoNumber.generate(
            new List<Contact>{contact},
            'AssistantName',
            'AccountId',
            'Account',
            'Name',
            false
        );
        
      //  System.assertNotEquals('ABC00001',contact.AssistantName);

        contact = [SELECT Id,name,RecordTypeId, AccountId FROM Contact LIMIT 1];
        contact.AccountId = account2.Id;
        update contact;

        GenerateAutoNumber.generate(
            new List<Contact>{contact},
            'AssistantName',
            'AccountId',
            'Account',
            'Name',
            false
        );

       // System.assertEquals('ZZZ00011',contact.AssistantName);

        Test.stopTest();
    }

    @testSetup
    static void initData()
    {
        crta__Employee_Number_Generator__c autoNumberContactInsert = 
        new crta__Employee_Number_Generator__c(
            crta__Object_API_Name__c = 'Contact',
            crta__Field_API_Name__c = 'AssistantName',
            crta__Criteria_Object_Reference__c = 'AccountId',
            crta__Criteria_Field_Name__c = 'Name',
            crta__Criteria_Field_Value__c = 'test',
            crta__Pattern__c  = 'ABC{00000}',
            crta__Last_Created_Index__c = 0,
            crta__Is_Active__c = true
        );
        insert autoNumberContactInsert;

        crta__Employee_Number_Generator__c autoNumberContactUpdate = 
        new crta__Employee_Number_Generator__c(
            crta__Object_API_Name__c = 'Contact',
            crta__Field_API_Name__c = 'AssistantName',
            crta__Criteria_Object_Reference__c = 'AccountId',
            crta__Criteria_Field_Name__c = 'Name',
            crta__Criteria_Field_Value__c = 'test2',
            crta__Pattern__c  = 'ZZZ{00000}',
            crta__Last_Created_Index__c = 10,
            crta__Is_Active__c = true,
            crta__Is_Active_For_Update__c = true
        );
        insert autoNumberContactUpdate;
    }
}