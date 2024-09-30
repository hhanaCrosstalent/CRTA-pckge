@isTest
private class CreateRepositoryByContactBatchTest {
	static final RecordType rtContactEmployee = BrainHRDataFactory.getRecordType('Contact', 'Salarie');
	static final RecordType rtContactRecruitement = BrainHRDataFactory.getRecordType('Contact', 'Recrutement');
	static final RecordType rtContactOnboarding = BrainHRDataFactory.getRecordType('Contact', 'Onboarding');

	@isTest
	static void test() {
		Test.startTest();
		Id contactId = [SELECT Id FROM Contact WHERE RecordTypeId =: rtContactEmployee.Id LIMIT 1].Id;
		List<Id> contactIds = new List<Id>{contactId};
		Database.executeBatch(new CreateRepositoryByContactBatch(), CreateRepositoryByContactBatch.getScopeSize());
		Database.executeBatch(new CreateRepositoryByContactBatch(contactId), CreateRepositoryByContactBatch.getScopeSize());
		Database.executeBatch(new CreateRepositoryByContactBatch(contactIds), CreateRepositoryByContactBatch.getScopeSize());
		Test.stopTest();
	}

	@TestSetup
	static void initData() {
		Contact contact1 = BrainHRDataFactory.newContact();
		Contact contact2 = BrainHRDataFactory.newContact(rtContactRecruitement);
		Contact contact3 = BrainHRDataFactory.newContact(rtContactOnboarding);
        insert new List<Contact>{contact1, contact2, contact3};
	}
}