@isTest
private without sharing class BrainHRDataFactoryTest {
    @IsTest
    private static void testMethodOne() {
        BrainHRDataFactory.getAdminProfile();
        RecordType employeeRt = BrainHRDataFactory.getRecordType('Contact', 'Salarie');

        Account account = BrainHRDataFactory.newAccount();
        insert account;

        Contact contact = BrainHRDataFactory.newContact();
        contact = BrainHRDataFactory.newContact(account);
        contact = BrainHRDataFactory.newContact(employeeRt);
        contact = BrainHRDataFactory.newContact(account, employeeRt);
        insert contact;
        BrainHRDataFactory.newContacts(account, 5);

        
        Id systAdminId = BrainHRDataFactory.getSystemAdminProfile();
        User u = BrainHRDataFactory.newUser(systAdminId, contact.Id);

        Account legal = BrainHRDataFactory.newAccount('Legal');
        insert legal;
        crta__Labor_contract__c contract = BrainHRDataFactory.newContract(legal, contact);
        insert contract;
        system.assert(legal != null);
        system.assert(contract != null);

        crta__GS_Fiche_de_poste__c job = BrainHRDataFactory.newJob();
        insert job;

        crta__GS_Affectation_poste__c hrAssignment = BrainHRDataFactory.newHrAssignment(contact, job);
        insert hrAssignment;
        
        system.assert(hrAssignment != null);
        system.assert(job != null);
    }
}