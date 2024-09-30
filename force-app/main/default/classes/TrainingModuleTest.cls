@IsTest
private class TrainingModuleTest {
    
    @IsTest
    private static void trainingModuleRepositoryTest() {
        
        Contact c = new Contact(
                LastName='Collab',
                Formateur__c = 'Test'
                );
        insert c;
        Contact c2 = new Contact(LastName='Manager');
        insert c2;

        Organisme_de_formation__c org = new Organisme_de_formation__c(
                FO_Contact__c = 'Collab'
                );
        insert org;

        FO_catalogue_de_formation__c m = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 1',
                FO_Lieu__c = 'Lieu 1',
                FO_Type__c = 'Technique',
                A_publier__c = true,
                FO_Formateur__c = c.Id,
                FO_Organisme_de_formation__c = org.Id
                );
        insert m;

        FO_catalogue_de_formation__c m2 = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 2',
                FO_Lieu__c = 'Lieu 2',
                FO_Type__c = 'Technique',
                A_publier__c = true,
                FO_Formateur__c = c2.Id,
                FO_Organisme_de_formation__c = org.Id
                );
        insert m2;

        List<String> fields = new List<String>{'FO_Nom_de_la_formation__c', 'FO_Type__c'};
        List<String> fieldOperations = new List<String>{'=', '!='};
        List<String> fieldValues = new List<String>{'Test 1', 'Technique'};

        List<FO_catalogue_de_formation__c> modules = TrainingModuleRepository.getAll();
        modules = TrainingModuleRepository.getAllForFields(fields);
        modules = TrainingModuleRepository.getAllActiveForFields(fields);
        System.assertEquals(2, modules.size());

        modules = TrainingModuleRepository.getAllFiltered(fields, new List<String>(), fieldValues);
        modules = TrainingModuleRepository.getAllActiveFiltered(fields, new List<String>(), fieldValues);
        modules = TrainingModuleRepository.getAllFilteredForFields(fields, new List<String>(), fieldValues, fields);
        modules = TrainingModuleRepository.getAllActiveFilteredForFields(fields, new List<String>(), fieldValues, fields);
        System.assertEquals(1, modules.size());

        modules = TrainingModuleRepository.getAllFiltered(fields, fieldOperations, fieldValues);
        System.assertEquals(0, modules.size());

        modules = TrainingModuleRepository.getAllWithOffset(0, 1);
        modules = TrainingModuleRepository.getAllActiveWithOffset(0, 1);
        modules = TrainingModuleRepository.getAllWithOffsetForFields(0, 1, fields);
        modules = TrainingModuleRepository.getAllActiveWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, modules.size());

        modules = TrainingModuleRepository.getAllActiveFilteredWithOffset(fields, new List<String>(), fieldValues, 0, 1);
        modules = TrainingModuleRepository.getAllFilteredWithOffset(fields, new List<String>(), fieldValues, 0, 1);
        modules = TrainingModuleRepository.getAllFilteredWithOffsetForFields(fields, new List<String>(), fieldValues, 0, 1, fields);
        modules = TrainingModuleRepository.getAllActiveFilteredWithOffsetForFields(fields, new List<String>(), fieldValues, 0, 1, fields);
        System.assertEquals(1, modules.size());

        modules = TrainingModuleRepository.getAllByTrainer(c.Id);
        modules = TrainingModuleRepository.getAllActiveByTrainer(c.Id);
        modules = TrainingModuleRepository.getAllByTrainerForFields(c.Id, fields);
        modules = TrainingModuleRepository.getAllActiveByTrainerForFields(c.Id, fields);
        System.assertEquals(1, modules.size());

        modules = TrainingModuleRepository.getAllWithOffsetByTrainer(c.Id, 0, 1);
        modules = TrainingModuleRepository.getAllActiveWithOffsetByTrainer(c.Id, 0, 1);
        modules = TrainingModuleRepository.getAllWithOffsetByTrainerForFields(c.Id, 0, 1, fields);
        modules = TrainingModuleRepository.getAllActiveWithOffsetByTrainerForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, modules.size());

        modules = TrainingModuleRepository.getAllByOrg(org.Id);
        modules = TrainingModuleRepository.getAllActiveByOrg(org.Id);
        modules = TrainingModuleRepository.getAllByOrgForFields(org.Id, fields);
        modules = TrainingModuleRepository.getAllActiveByOrgForFields(org.Id, fields);
        System.assertEquals(2, modules.size());

        modules = TrainingModuleRepository.getAllActiveWithOffsetByOrg(org.Id, 0, 1);
        modules = TrainingModuleRepository.getAllWithOffsetByOrg(org.Id, 0, 1);
        modules = TrainingModuleRepository.getAllWithOffsetByOrgForFields(org.Id, 0, 1, fields);
        modules = TrainingModuleRepository.getAllActiveWithOffsetByOrgForFields(org.Id, 0, 1, fields);
        System.assertEquals(1, modules.size());

        FO_catalogue_de_formation__c module = TrainingModuleRepository.getById(m.Id);
        module = TrainingModuleRepository.getByIdForFields(m.Id, fields);
        System.assertEquals('Test 1', module.FO_Nom_de_la_formation__c);

        module = TrainingModuleRepository.getWithRequestsById(m2.Id, c.Id);
        module = TrainingModuleRepository.getWithRequestsByIdForFields(m2.Id, c.Id, fields);
        System.assertEquals('Test 2', module.FO_Nom_de_la_formation__c);
    }
}