@IsTest
private class TrainingRequestTest {

    @IsTest
    private static void trainingRequestRepositoryTest() {
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

        Demande_de_formation__c r = new Demande_de_formation__c(
                Catalogue_de_formation__c = m.Id,
                Session_de_formation__c = s.Id,
                Salarie__c = c.Id
                );
        insert r;
        Demande_de_formation__c r2 = new Demande_de_formation__c(
                Catalogue_de_formation__c = m2.Id,
                Session_de_formation__c = s2.Id,
                Salarie__c = c.Id/*,
                Statut__c = '50 - Rejected by Manager'*/
                );
        insert r2;

        List<String> fields = new List<String>{'Statut__c'};
        List<Demande_de_formation__c> trainingRegistrations = TrainingRequestRepository.getAll();
        trainingRegistrations = TrainingRequestRepository.getAllForFields(fields);
        System.assertEquals(2, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllPending();
        trainingRegistrations = TrainingRequestRepository.getAllPendingForFields(fields);
        //System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllWithOffset(0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllPendingWithOffset(0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllPendingWithOffsetForFields(0, 1, fields);
        //System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllByModule(m.Id);
        trainingRegistrations = TrainingRequestRepository.getAllByModuleForFields(m.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());
       // System.assertEquals('10 Demandée', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetByModule(m.Id, 0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetByModuleForFields(m.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());
       //System.assertEquals('10 Demandée', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRequestRepository.getAllByContact(c.Id);
        trainingRegistrations = TrainingRequestRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllPendingByContact(c.Id);
        trainingRegistrations = TrainingRequestRepository.getAllPendingByContactForFields(c.Id, fields);
       // System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllPendingWithOffsetByContact(c.Id, 0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllPendingWithOffsetByContactForFields(c.Id, 0, 1, 
            fields);
        System.assertEquals(1, trainingRegistrations.size());

        trainingRegistrations = TrainingRequestRepository.getAllBySession(s.Id);
        trainingRegistrations = TrainingRequestRepository.getAllBySessionForFields(s.Id, fields);
        System.assertEquals(1, trainingRegistrations.size());
        //System.assertEquals('10 Demandée', trainingRegistrations[0].Statut__c);

        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetBySession(s.Id, 0, 1);
        trainingRegistrations = TrainingRequestRepository.getAllWithOffsetBySessionForFields(s.Id, 0, 1, fields);
        System.assertEquals(1, trainingRegistrations.size());
      //  System.assertEquals('10 Demandée', trainingRegistrations[0].Statut__c);

        Integer count = TrainingRequestRepository.countPendingRequestByContactAndModule(c.Id, m.Id);
        System.assertEquals(1, count);

        Demande_de_formation__c trainingRegistration = TrainingRequestRepository.getById(r2.Id);
        trainingRegistration = TrainingRequestRepository.getByIdForFields(r2.Id, fields);
      // System.assertEquals('50 Refusée', trainingRegistration.Statut__c);
    }

    @IsTest
    private static void trainingRegistrationManagerTest() {
        Contact c = new Contact(
                LastName='Manager',
                Formateur__c = 'Test'
                );
        insert c;
        Contact c2 = new Contact(
                LastName='Collab',
                ReportsToId = c.Id
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

        Demande_de_formation__c r = new Demande_de_formation__c(
                Catalogue_de_formation__c = m.Id,
                Session_de_formation__c = s.Id,
                Salarie__c = c.Id
                );
        insert r;
        Demande_de_formation__c r2 = new Demande_de_formation__c(
                Catalogue_de_formation__c = m2.Id,
                Salarie__c = c.Id
                );
        insert r2;
        Demande_de_formation__c r3 = new Demande_de_formation__c(
                Salarie__c = c.Id
                );
        insert r3;

        TrainingRequestManager.createTrainingRequest(m.Id, s.Id, 'Langues', '6 mois', 'test', 'Inscription', c2.Id);
        List<Demande_de_formation__c> trainingRequests = [SELECT Id, Description__c 
                                                    FROM Demande_de_formation__c 
                                                    WHERE Type_de_formation__c = 'Langues'];
        //System.assertEquals(1, trainingRequests.size());

       /* TrainingRequestManager.deleteTrainingRequest(trainingRequests[0].Id); //Real test
        TrainingRequestManager.deleteTrainingRequest(trainingRequests[0].Id); //Fail test
        trainingRequests = TrainingRequestRepository.getAll();
       /* System.assertEquals(3, trainingRequests.size());*/

        TrainingRequestManager.acceptRequest(r.Id);
        Demande_de_formation__c trainingRequest = TrainingRequestRepository.getById(r.Id);
        List<Participation_session_formation__c> trainingRegistrations = TrainingRegistrationRepository.getAll();
        Action_de_formation__c trainingAction = TrainingActionRepository.getById(a.Id);
       // System.assertEquals('30 Acceptée', trainingRequest.Statut__c);
        System.assertEquals(1, trainingRegistrations.size());
        //System.assertEquals('20 Prévue', trainingAction.Statut__c);

        TrainingRequestManager.acceptRequest(r2.Id);
        trainingRequest = TrainingRequestRepository.getById(r2.Id);
        List<Action_de_formation__c> trainingActions = TrainingActionRepository.getAllByModule(m2.Id);
        //System.assertEquals('30 Acceptée', trainingRequest.Statut__c);
        System.assertEquals(1, trainingActions.size());

        TrainingRequestManager.acceptRequest(r3.Id);
        trainingRequest = TrainingRequestRepository.getById(r3.Id);
      //  System.assertEquals('10 Demandée', trainingRequest.Statut__c);

        TrainingRequestManager.rejectRequest(r3.Id);
        trainingRequest = TrainingRequestRepository.getById(r3.Id);
        //System.assertEquals('Denied', trainingRequest.Statut__c); 

        List<SelectOption> options = TrainingRequestManager.getRequestTypes();
    }
}