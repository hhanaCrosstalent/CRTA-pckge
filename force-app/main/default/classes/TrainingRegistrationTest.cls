@IsTest
private class TrainingRegistrationTest {
    
    @IsTest 
    private static void trainingRegistrationTriggerTest() {
        TrainingModule__c options = new TrainingModule__c(
                useActionTrigger__c = true
                );
        insert options;

        Contact c = new Contact(
                LastName='Collab',
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

        Action_de_formation__c a = new Action_de_formation__c(
                Contact__c = c.Id,
                Catalogue_de_formation__c = m.Id
                );
        insert a;

        FO_Session_collective__c s = new FO_Session_collective__c(
                Catalogue_de_formation__c = m.Id,
                FO_Date_et_heure_de_debut__c = System.now(),
                FO_Date_et_heure_de_fin__c = System.now().addHours(1)
                );
        insert s;
        FO_Session_collective__c s2 = new FO_Session_collective__c(
                Catalogue_de_formation__c = m.Id,
                FO_Date_et_heure_de_debut__c = System.now().addDays(1),
                FO_Date_et_heure_de_fin__c = System.now().addDays(1).addHours(1)
                );
        insert s2;

        Participation_session_formation__c p = new Participation_session_formation__c(
                Action_de_formation__c = a.Id,
                Session_de_formation__c = s.Id
                );
        insert p;
        Participation_session_formation__c p2 = new Participation_session_formation__c(
                Action_de_formation__c = a.Id,
                Session_de_formation__c = s2.Id
            /*,
                Statut__c = '90 Annulée'*/
                );
        insert p2;

        Action_de_formation__c trainingAction = TrainingActionRepository.getById(a.Id);

        System.assertEquals(trainingAction.Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_debut__c);
        System.assertEquals(trainingAction.Date_et_heure_de_fin__c, s2.FO_Date_et_heure_de_fin__c);

        update p;
        delete p2;
    }

    @IsTest 
    private static void trainingRegistrationRepositoryTest() {
        Contact c = new Contact(
                LastName='Collab',
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
                FO_Date_et_heure_de_fin__c = System.now().addHours(7)
          	
                );
        insert s;
        FO_Session_collective__c s2 = new FO_Session_collective__c(
                Catalogue_de_formation__c = m2.Id,
                FO_Date_et_heure_de_debut__c = System.now().addDays(1),
                FO_Date_et_heure_de_fin__c = System.now().addDays(1).addHours(1)
                );
        insert s2;

        Participation_session_formation__c p = new Participation_session_formation__c(
                Action_de_formation__c = a.Id,
                Session_de_formation__c = s.Id,
                Statut__c = '10 - Requested'
                );
        insert p;
        Participation_session_formation__c p2 = new Participation_session_formation__c(
                Action_de_formation__c = a2.Id,
                Session_de_formation__c = s2.Id,
                Statut__c = '90 - Rejected Manager'
                );
        insert p2;

        List<String> fields = new List<String>{'Statut__c'};
        List<Participation_session_formation__c> trainingRegistrations = TrainingRegistrationRepository.getAll();
        trainingRegistrations = TrainingRegistrationRepository.getAllForFields(fields);
        System.assertEquals(2, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffset(0, 1);
        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllBeforeDate(s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllBeforeDateForFields(s.FO_Date_et_heure_de_fin__c, 
            fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllBeforeDateStrict(s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllBeforeDateStrictForFields(
            s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(0, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllAfterDate(s2.FO_Date_et_heure_de_debut__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllAfterDateForFields(
            s2.FO_Date_et_heure_de_debut__c, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllAfterDateStrict(s2.FO_Date_et_heure_de_debut__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllAfterDateStrictForFields(
            s2.FO_Date_et_heure_de_debut__c, fields);
        System.assertEquals(0, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllBetweenDates(s.FO_Date_et_heure_de_debut__c, 
            s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllBetweenDatesForFields(
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllBetweenDatesStrict(
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllBetweenDatesStrictForFields(
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllByModule(m.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllByModuleForFields(m.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());
        System.assertEquals('10 - Requested', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByModule(m.Id, 0, 1);
        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByModuleForFields(m.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());
       // System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllByModuleBetweenDates(m.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllByModuleBetweenDatesForFields(m.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingRegistrations.size());
       // System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllByContact(c.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByContact(c.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByContactForFields(c.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllByContactBetweenDates(c.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllByContactBetweenDatesForFields(c.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingRegistrations.size());
        System.assertEquals('10 - Requested', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByContactBetweenDates(c.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c);
        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByContactBetweenDatesForFields(c.Id, 
            s.FO_Date_et_heure_de_debut__c, s.FO_Date_et_heure_de_fin__c, fields);
        System.assertEquals(1, trainingRegistrations.size());
        System.assertEquals('10 - Requested', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllBySession(s.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllBySessionForFields(s.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());
        //System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetBySession(s.Id, 0, 1);
        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetBySessionForFields(s.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());
       // System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllByAction(a.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllByActionForFields(a.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());
        //System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByAction(a2.Id);
        trainingRegistrations = TrainingRegistrationRepository.getAllActiveByActionForFields(a2.Id, fields);
        System.assertEquals(0, trainingRegistrations.size());

        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByAction(a.Id, 0, 1);
        trainingRegistrations = TrainingRegistrationRepository.getAllWithOffsetByActionForFields(a.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());
        //System.assertEquals('10 Inscrit', trainingRegistrations[0].Statut__c);

        Participation_session_formation__c trainingRegistration = TrainingRegistrationRepository.getById(p2.Id);
        trainingRegistration = TrainingRegistrationRepository.getByIdForFields(p2.Id, fields);
        //System.assertEquals('90 Annulée', trainingRegistration.Statut__c);
    }

    @IsTest
    private static void trainingRegistrationManagerTest() {
        TrainingModule__c options = new TrainingModule__c(
                useNotifications__c = true
                );
        insert options;

        Contact c = new Contact(
                LastName='Collab',
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
                FO_Date_et_heure_de_fin__c = System.now().addHours(7)
                );
        insert s;
        FO_Session_collective__c s2 = new FO_Session_collective__c(
                Catalogue_de_formation__c = m2.Id,
                FO_Date_et_heure_de_debut__c = System.now().addDays(1),
                FO_Date_et_heure_de_fin__c = System.now().addDays(1).addHours(1)
                );
        insert s2;

        TrainingRegistrationManager.createTrainingRegistration(s.Id, a.Id);
        List<Participation_session_formation__c> trainingRegistrations = TrainingRegistrationRepository.getAll();
        System.assertEquals(1, trainingRegistrations.size());
      //  System.assertEquals(10, trainingRegistrations[0].Valeur_Statut__c);

        TrainingRegistrationManager.cancelTrainingRegistration(trainingRegistrations[0].Id, false, false); //Real test
        TrainingRegistrationManager.cancelTrainingRegistration('003', false, false); //Failing test
        trainingRegistrations = TrainingRegistrationRepository.getAll();
        System.assertEquals(1, trainingRegistrations.size());
      //  System.assertEquals(90, trainingRegistrations[0].Valeur_Statut__c);

        TrainingRegistrationManager.accept(trainingRegistrations[0].Id); //Real test
        TrainingRegistrationManager.accept('003'); //Failing test

        TrainingRegistrationManager.reject(trainingRegistrations[0].Id); //Real test
        TrainingRegistrationManager.reject('003'); //Failing test

        TrainingRegistrationManager.deleteTrainingRegistration(trainingRegistrations[0].Id); //Real test
        TrainingRegistrationManager.deleteTrainingRegistration('003'); //Failing test
        trainingRegistrations = TrainingRegistrationRepository.getAll();
        System.assertEquals(0, trainingRegistrations.size());
    }
}