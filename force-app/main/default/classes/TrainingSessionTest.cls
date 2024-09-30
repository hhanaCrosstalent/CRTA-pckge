@IsTest
private class TrainingSessionTest {
    
    @IsTest
    private static void trainingSessionRepositoryTest() {
        Contact c = new Contact(
                LastName = 'Collab',
                Formateur__c = 'Test'
                );
        insert c;

        Organisme_de_formation__c org = new Organisme_de_formation__c(
                FO_Contact__c = 'Collab'
                );
        insert org;

        FO_catalogue_de_formation__c m = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 1',
                FO_Lieu__c = 'Lieu 1',
                FO_Type__c = 'Technique',
                FO_Formateur__c = c.Id,
                FO_Organisme_de_formation__c = org.Id,
            	crta__Active__c = true
                );
        insert m;
        FO_catalogue_de_formation__c m2 = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 2',
                FO_Lieu__c = 'Lieu 2',
                FO_Type__c = 'Langue',
                FO_Formateur__c = c.Id,
                FO_Organisme_de_formation__c = org.Id,
        		crta__Active__c = true        
        );
        insert m2;

        Action_de_formation__c a = new Action_de_formation__c(
                Contact__c = c.Id,
                Catalogue_de_formation__c = m.Id
                );
        insert a;
        Action_de_formation__c a2 = new Action_de_formation__c(
                Contact__c = c.Id,
                Catalogue_de_formation__c = m2.Id
                );
        insert a2;

        FO_Session_collective__c s = new FO_Session_collective__c(
                Catalogue_de_formation__c = m.Id,
                FO_Date_et_heure_de_debut__c = System.now(),
                FO_Date_et_heure_de_fin__c = System.now().addHours(7),
                Lieu__c = 'Test 1'
                );
        insert s;
        FO_Session_collective__c s2 = new FO_Session_collective__c(
                Catalogue_de_formation__c = m2.Id,
                FO_Date_et_heure_de_debut__c = System.now().addDays(1),
                FO_Date_et_heure_de_fin__c = System.now().addDays(1).addHours(1),
                Lieu__c = 'Test 2'
                );
        insert s2;

        List<String> fields = new List<String>{'Lieu__c'};
        List<FO_Session_collective__c> trainingSessions = TrainingSessionRepository.getAll();
        trainingSessions = TrainingSessionRepository.getAllForFields(fields);
        System.assertEquals(2, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllWithOffset(0, 1);
        trainingSessions = TrainingSessionRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllBeforeDate(s.FO_Date_et_heure_de_fin__c);
        trainingSessions = TrainingSessionRepository.getAllBeforeDateForFields(s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllBeforeDateStrict(s.FO_Date_et_heure_de_fin__c);
        trainingSessions = TrainingSessionRepository.getAllBeforeDateStrictForFields(s.FO_Date_et_heure_de_fin__c, 
                fields);
        System.assertEquals(0, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllAfterDate(s2.FO_Date_et_heure_de_debut__c);
        trainingSessions = TrainingSessionRepository.getAllAfterDateForFields(s2.FO_Date_et_heure_de_debut__c, fields);
        System.assertEquals(1, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllAfterDateStrict(s2.FO_Date_et_heure_de_debut__c);
        trainingSessions = TrainingSessionRepository.getAllAfterDateStrictForFields(s2.FO_Date_et_heure_de_debut__c, 
                fields);
        System.assertEquals(0, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllBetweenDates(s.FO_Date_et_heure_de_debut__c, 
                s.FO_Date_et_heure_de_fin__c);
        trainingSessions = TrainingSessionRepository.getAllBetweenDatesForFields(s.FO_Date_et_heure_de_debut__c, 
                s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllBetweenDatesStrict(s.FO_Date_et_heure_de_debut__c, 
                s.FO_Date_et_heure_de_fin__c);
        trainingSessions = TrainingSessionRepository.getAllBetweenDatesStrictForFields(s.FO_Date_et_heure_de_debut__c, 
                s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingSessions.size());

        trainingSessions = TrainingSessionRepository.getAllByModule(m.Id);
        trainingSessions = TrainingSessionRepository.getAllByModuleForFields(m.Id, fields);
        System.assertEquals(1, trainingSessions.size());
        System.assertEquals('Test 1', trainingSessions[0].Lieu__c);

        trainingSessions = TrainingSessionRepository.getAllWithOffsetByModule(m.Id, 0, 1);
        trainingSessions = TrainingSessionRepository.getAllWithOffsetByModuleForFields(m.Id, 0, 1, fields);
        System.assertEquals(1, trainingSessions.size());
        System.assertEquals('Test 1', trainingSessions[0].Lieu__c);

        FO_Session_collective__c trainingSession = TrainingSessionRepository.getById(s2.Id);
        trainingSession = TrainingSessionRepository.getByIdForFields(s2.Id, fields);
        System.assertEquals('Test 2', trainingSession.Lieu__c);
    }
}