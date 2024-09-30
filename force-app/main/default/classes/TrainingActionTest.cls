@IsTest
private class TrainingActionTest {
    
    @IsTest 
    private static void trainingActionRepositoryTest() {
        Contact c = new Contact(
                LastName='Collab',
                Formateur__c = 'Test'
                );
        insert c;
        Contact c2 = new Contact(
                LastName='Manager',
                Formateur__c = 'Test'
                );
        insert c2;

        Organisme_de_formation__c org = new Organisme_de_formation__c(
                FO_Contact__c = 'Collab'
                );
        insert org;

        FO_catalogue_de_formation__c m = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 1',
                FO_Lieu__c = 'Lieu 1',
                FO_Type__c = 'Technique',
                FO_Formateur__c = c.Id,
                FO_Organisme_de_formation__c = org.Id
                );
        insert m;
        FO_catalogue_de_formation__c m2 = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 2',
                FO_Lieu__c = 'Lieu 2',
                FO_Type__c = 'Langue',
                FO_Formateur__c = c.Id,
                FO_Organisme_de_formation__c = org.Id
                );
        insert m2;

        Action_de_formation__c a = new Action_de_formation__c(
                Contact__c = c.Id,
                Catalogue_de_formation__c = m.Id,
                Origine__c = 'Entretien Pro',
                Date_et_heure_de_debut__c = System.now(),
                Date_et_heure_de_fin__c = System.now().addDays(7)
                );
        insert a;
        Action_de_formation__c a2 = new Action_de_formation__c(
                Contact__c = c2.Id,
                Catalogue_de_formation__c = m2.Id,
                Origine__c = 'Parcours'
                );
        insert a2;

        List<String> fields = new List<String>{'Origine__c'};

        List<Action_de_formation__c> trainingActions = TrainingActionRepository.getAll();
        trainingActions = TrainingActionRepository.getAllForFields(fields);
        System.assertEquals(2, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllBeforeDate(a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllBeforeDateForFields(a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllBeforeDateStrict(a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllBeforeDateStrictForFields(a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(0, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllAfterDate(a.Date_et_heure_de_debut__c);
        trainingActions = TrainingActionRepository.getAllAfterDateForFields(a.Date_et_heure_de_debut__c, fields);
        System.assertEquals(1, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllAfterDateStrict(a.Date_et_heure_de_debut__c);
        trainingActions = TrainingActionRepository.getAllAfterDateStrictForFields(a.Date_et_heure_de_debut__c, fields);
        System.assertEquals(0, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllBetweenDates(a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllBetweenDatesForFields(a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllBetweenDatesStrict(a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllBetweenDatesStrictForFields(a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllWithOffset(0, 1);
        trainingActions = TrainingActionRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, trainingActions.size());

        trainingActions = TrainingActionRepository.getAllByModule(m.Id);
        trainingActions = TrainingActionRepository.getAllByModuleForFields(m.Id, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Entretien Pro', trainingActions[0].Origine__c);

        trainingActions = TrainingActionRepository.getAllByModuleBetweenDates(m.Id, a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllByModuleBetweenDatesForFields(m.Id, 
                a.Date_et_heure_de_debut__c, a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Entretien Pro', trainingActions[0].Origine__c);

        trainingActions = TrainingActionRepository.getAllWithOffsetByModule(m.Id, 0, 1);
        trainingActions = TrainingActionRepository.getAllWithOffsetByModuleForFields(m.Id, 0, 1, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Entretien Pro', trainingActions[0].Origine__c);

        trainingActions = TrainingActionRepository.getAllByContact(c2.Id);
        trainingActions = TrainingActionRepository.getAllByContactForFields(c2.Id, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Parcours', trainingActions[0].Origine__c);

        trainingActions = TrainingActionRepository.getAllByContactBetweenDates(c.Id, a.Date_et_heure_de_debut__c, 
                a.Date_et_heure_de_fin__c);
        trainingActions = TrainingActionRepository.getAllByContactBetweenDatesForFields(c.Id, 
                a.Date_et_heure_de_debut__c, a.Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Entretien Pro', trainingActions[0].Origine__c);

        trainingActions = TrainingActionRepository.getAllWithOffsetByContact(c2.Id, 0, 1);
        trainingActions = TrainingActionRepository.getAllWithOffsetByContactForFields(c2.Id, 0, 1, fields);
        System.assertEquals(1, trainingActions.size());
        System.assertEquals('Parcours', trainingActions[0].Origine__c);

        Action_de_formation__c trainingAction = TrainingActionRepository.getById(a2.Id);
        trainingAction = TrainingActionRepository.getByIdForFields(a2.Id, fields);
        System.assertEquals('Parcours', trainingAction.Origine__c);
    }
}