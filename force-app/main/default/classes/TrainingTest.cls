@IsTest
private class TrainingTest {

    @IsTest
    private static void trainingRepositoryTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Formation__c f = new Formation__c(
                CT_Start_date__c = System.today(),
                CT_Candidate__c = c.Id
                );
        insert f;
        Formation__c f2 = new Formation__c(
                CT_Start_date__c = System.today(),
                CT_Candidate__c = c.Id
                );
        insert f2;

        List<String> fields = new List<String>{'CT_Start_date__c'};
        List<Formation__c> trainings = TrainingRepository.getAll();
        trainings = TrainingRepository.getAllForFields(fields);
        System.assertEquals(2, trainings.size());

        trainings = TrainingRepository.getAllByContact(c.Id);
        trainings = TrainingRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, trainings.size());

        Date today = System.today();

        trainings = TrainingRepository.getAllByContactBetweenDate(c.Id, today, today);
        trainings = TrainingRepository.getAllByContactBetweenDateForFields(c.Id, today, today, fields);
        System.assertEquals(2, trainings.size());

        trainings = TrainingRepository.getAllWithOffset(0, 1);
        trainings = TrainingRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, trainings.size());

        trainings = TrainingRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        trainings = TrainingRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, trainings.size());

        Formation__c training = TrainingRepository.getById(f.Id);
        training = TrainingRepository.getByIdForFields(f.Id, fields);
        System.assertEquals(today, training.CT_Start_date__c);
    }
}