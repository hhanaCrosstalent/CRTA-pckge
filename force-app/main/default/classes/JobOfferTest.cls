@IsTest
private class JobOfferTest {

    @IsTest
    private static void jobOfferRepositoryTest() {
        Contact c = new Contact(
                LastName = 'Collab',
                Formateur__c = 'Test'
                );
        insert c;
        Contact c2 = new Contact(LastName = 'Manager');
        insert c2;

        Offre_d_emploi__c j = new Offre_d_emploi__c(
                Name = 'test',
                CT_Annee_budget__c = 2016,
                CT_Code__c = 'Code 1'
                );
        insert j;
        Offre_d_emploi__c j2 = new Offre_d_emploi__c(
                Name = 'test 2',
                CT_Annee_budget__c = 2013,
                CT_Code__c = 'Code 2'
                );
        insert j2;

        List<String> fields = new List<String>{'CT_Code__c'};
        List<String> fieldOperations = new List<String>{'='};
        List<String> fieldValues = new List<String>{'Code 1'};

        List<Offre_d_emploi__c> jobs = JobOfferRepository.getAll();
        jobs = JobOfferRepository.getAllForFields(fields);
        System.assertEquals(2, jobs.size());

        jobs = JobOfferRepository.getAllFiltered(fields, new List<String>(), fieldValues);
        jobs = JobOfferRepository.getAllFilteredForFields(fields, new List<String>(), fieldValues, fields);
        System.assertEquals(1, jobs.size());

        jobs = JobOfferRepository.getAllWithOffset(0, 1);
        jobs = JobOfferRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, jobs.size());

        jobs = JobOfferRepository.getAllFilteredWithOffset(fields, new List<String>(), fieldValues, 0, 1);
        jobs = JobOfferRepository.getAllFilteredWithOffsetForFields(fields, new List<String>(), fieldValues, 0, 1, fields);
        System.assertEquals(1, jobs.size());

        Offre_d_emploi__c job = JobOfferRepository.getById(j.Id);
        job = JobOfferRepository.getByIdForFields(j.Id, fields);
        System.assertEquals('test', job.Name);
    }
}