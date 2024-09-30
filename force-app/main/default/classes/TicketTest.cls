@IsTest
private class TicketTest {
    
    @IsTest 
    private static void ticketManagerTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;
		
        TicketManager.saveTicket('Test', 'Gestion des temps', 'Anomalie', 'Test', c.Id); //Real test
        TicketManager.saveTicket('Test', 'Gestion des temps', 'Anomalie', 'Test', '003'); //Failing test
        List<Demande__c> tickets = [SELECT Id, Intitule__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals('Test', tickets[0].Intitule__c);

        TicketManager.editTicket('Test 2', 'Gestion des temps', 'Anomalie', 'Test description', null, null, null, 
        null, tickets[0].Id); //Real test
        TicketManager.editTicket('Test 2', 'Gestion des temps', 'Anomalie', 'Test description', null, null, null, 
        null, '003'); //Failing test
        tickets = [SELECT Id, Intitule__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals('Test 2', tickets[0].Intitule__c);

        TicketManager.editTicket('Test réponse', 'Gestion des temps', 'Anomalie', 'Test description', '15 Retournée', 
            'Réponse test', 'Critique', null, tickets[0].Id); //Real test
        TicketManager.editTicket('Test réponse', 'Gestion des temps', 'Anomalie', 'Test description', null, 
            'Réponse test', null, null, '003'); //Failing test
        tickets = [SELECT Id, Intitule__c, Reponse__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals('Test réponse', tickets[0].Intitule__c);
        System.assertEquals('Réponse test', tickets[0].Reponse__c);

        TicketManager.returnTicket('Test de retour', tickets[0].Id); //Real test
        TicketManager.returnTicket('Test de retour', '003'); //Failing test
        tickets = [SELECT Id, Reponse__c, Valeur_statut__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals(15, tickets[0].Valeur_statut__c);
        System.assertEquals('Test de retour', tickets[0].Reponse__c);

        TicketManager.closeTicket('Test de cloture', tickets[0].Id); //Real test
        TicketManager.closeTicket('Test de cloture', '003'); //Failing test
        tickets = [SELECT Id, Reponse__c, Valeur_statut__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals(50, tickets[0].Valeur_statut__c);
        System.assertEquals('Test de cloture', tickets[0].Reponse__c);

        TicketManager.rejectTicket('Test de rejet', tickets[0].Id); //Real test
        TicketManager.rejectTicket('Test de rejet', '003'); //Failing test
        tickets = [SELECT Id, Reponse__c, Valeur_statut__c FROM Demande__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals(60, tickets[0].Valeur_statut__c);
        System.assertEquals('Test de rejet', tickets[0].Reponse__c);

        TicketManager.deleteTicket(tickets[0].Id); //Real test
        TicketManager.deleteTicket('003'); //Failing test
        tickets = [SELECT Id, Reponse__c, Valeur_statut__c FROM Demande__c];
        System.assertEquals(0, tickets.size());
    }

    @IsTest 
    private static void ticketRepositoryTest() {
        List<Profile> ps = [SELECT Id, Name FROM Profile WHERE UserLicense.Name = 'Salesforce'];

        User standard = new User(
                alias = 'Hmid', 
                email='dev01@testorg.com', 
                emailencodingkey='UTF-8', 
                lastname='Testing01', 
                languagelocalekey='en_US', 
                localesidkey='en_US', 
                profileid = ps[0].Id, 
                timezonesidkey='Europe/Paris', 
                username='dev12@testorg.com'
                );
        insert standard;

        Contact c = new Contact(LastName='Collab');
        insert c;

        Demande__c t = new Demande__c(
                Intitule__c = 'Test 1',
                Type__c = 'Anomalie',
                Salarie__c = c.Id,
                Attribution__c = standard.Id
                );
        insert t;
        Demande__c t2 = new Demande__c(
                Intitule__c = 'Test 2',
                Type__c = 'Assistance',
                Salarie__c = c.Id
                );
        insert t2;

        List<String> fields = new List<String>{'Intitule__c', 'Type__c', 'Reponse__c'};
        List<String> filterFields = new List<String>{'Intitule__c', 'Type__c', 'Statut__c'};
        List<String> filterOperations = new List<String>{'=', '=', '='};
        List<String> filterValues = new List<String>{'test', 'test', 'test'};

        List<Demande__c> tickets = TicketRepository.getAll();
        tickets = TicketRepository.getAllForFields(fields);
        System.assertEquals(2, tickets.size());

        tickets = TicketRepository.getAllFiltered(filterFields, filterOperations, filterValues);
        System.assertEquals(0, tickets.size());

        tickets = TicketRepository.getAllFilteredForFields(filterFields, filterOperations, filterValues, fields);
        System.assertEquals(0, tickets.size());


        tickets = TicketRepository.getAllByContact(c.Id);
        tickets = TicketRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, tickets.size());

        tickets = TicketRepository.getAllFilteredByContact(filterFields, filterOperations, filterValues, c.Id);
        System.assertEquals(0, tickets.size());

        tickets = TicketRepository.getAllByUser(standard.Id);
        tickets = TicketRepository.getAllByUserForFields(standard.Id, fields);
        System.assertEquals(1, tickets.size());

        tickets = TicketRepository.getAllWithOffset(0, 1);
        tickets = TicketRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, tickets.size());

        tickets = TicketRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        tickets = TicketRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, tickets.size());

        tickets = TicketRepository.getAllFilteredWithOffsetByContact(c.Id, 0, 1, filterFields, filterOperations, 
            filterValues);
        System.assertEquals(0, tickets.size());

        tickets = TicketRepository.getAllWithOffsetByUser(standard.Id, 0, 1);
        tickets = TicketRepository.getAllWithOffsetByUserForFields(standard.Id, 0, 1, fields);
        System.assertEquals(1, tickets.size());

        Demande__c ticket = TicketRepository.getById(t.Id);
        ticket = TicketRepository.getUntranslatedById(t.Id);
        ticket = TicketRepository.getByIdForFields(t.Id, fields);
        System.assertEquals('Anomalie', ticket.Type__c);
    }

    @IsTest
    private static void visualisationTicketControllerTest() {
        List<Profile> ps = [SELECT Id, Name FROM Profile WHERE UserLicense.Name = 'Salesforce'];
        User standard = new User(
                alias = 'standt', 
                email='dev@testorg.com', 
                emailencodingkey='UTF-8', 
                lastname='Testing', 
                languagelocalekey='en_US', 
                localesidkey='en_US', 
                profileid = ps[0].Id, 
                timezonesidkey='Europe/Paris', 
                username='dev2@testorg.com'
                ); 
        insert standard;

        Contact c = new Contact(LastName='Collab');
        insert c;
		System.assert(c != null);
        
        Demande__c t = new Demande__c(
                Intitule__c = 'Test 1',
                Type__c = 'Anomalie',
                Salarie__c = c.Id,
                Attribution__c = standard.Id
                );
        insert t;
        System.assertEquals('Anomalie', t.Type__c);
        Demande__c t2 = new Demande__c(
                Intitule__c = 'Test 2',
                Type__c = 'Assistance',
                Salarie__c = c.Id
                );
        insert t2;
		System.assertEquals('Assistance', t2.Type__c);
        PageReference pg = Page.VisualisationTicket;
        pg.getParameters().put('id', t.Id);
        Test.setCurrentPage(pg);

        VisualisationTicketController controller=new VisualisationTicketController();
        String selectedType = controller.selectedType;
        String selectedModule = controller.selectedModule;
        String selectedPriority = controller.selectedPriority;
    }
}