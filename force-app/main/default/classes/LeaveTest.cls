@IsTest
private class LeaveTest {

    @IsTest
    private static void leaveManager() {
        
        Date today = System.today();
        DateTime now = System.now();
        
        Contact c2 = new Contact(LastName = 'Manager');
        insert c2;
        Contact c = new Contact(
                LastName = 'Collab',
                ReportsToId = c2.Id
                );
        insert c;

        Timesheet__c options = new Timesheet__c(
                startHour__c = '08:00',
                endHourMorning__c = '12:00',
                startHourAfternoon__c = '13:00',
                endHour__c = '18:00'
                );
        insert options;
        LeaveManager.getLeavePeriods();
        LeaveManager.getLeaveTypes();

        LeaveManager.createWithTime(now, now.addDays(6), 'Absence', 'Absence', c.Id); //Real test
        LeaveManager.createWithTime(now, now.addDays(6), 'Absence', 'Absence', '003'); //Failing test
        List<Demande_de_conges__c> leaves = [SELECT Id, Type__c FROM Demande_de_conges__c];
        System.assertEquals(1, leaves.size());

        //Real test
        LeaveManager.editWithTime(now, now.addDays(6), 'Absence edit', 'Absence', leaves[0].Id);
        //Failing test
        LeaveManager.editWithTime(now, now.addDays(6), 'Absence edit', 'Absence', '003');
        leaves = [SELECT Id, Type__c FROM Demande_de_conges__c];
        System.assertEquals(1, leaves.size());
        System.assertEquals('Absence edit', leaves[0].Type__c);

        LeaveManager.deleteLeave(leaves[0].Id); //Real test
        LeaveManager.deleteLeave(leaves[0].Id); //Failing test
        leaves = [SELECT Id, Type__c FROM Demande_de_conges__c];
        System.assertEquals(0, leaves.size());

        // Verify we can insert, but are fault-tolerant when we get an illegal contact ID
        LeaveManager.createWithoutTime(today.addDays(6), 'Journée Complète', today.addDays(6), 
            'Journée Complète', 'Absence date', 'Absence date', c.Id); //Real test
        LeaveManager.createWithoutTime(today.addDays(7), 'Matin', today.addDays(7), 'Matin', 
            'Absence date', 'Absence date', c.Id); //Real test
        LeaveManager.createWithoutTime(today.addDays(8), 'Après-midi', today.addDays(8), 
            'Après-midi', 'Absence date', 'Absence date', c.Id); //Real test
        LeaveManager.createWithoutTime(today.addDays(9), 'Après-midi', today.addDays(9), 
            'Après-midi', 'Absence date', 'Absence date', '003'); //Failing test
        leaves = [SELECT Type__c FROM Demande_de_conges__c];
        System.assertEquals(3, leaves.size());

        // Verify we can update, but are fault-tolerant when we get an illegal contact ID
        leaves = [SELECT Id FROM Demande_de_conges__c];
        LeaveManager.editWithoutTime(today.addDays(6), 'Journée Complète', today.addDays(6), 
            'Journée Complète', 'Absence date edit', 'Absence date', leaves[0].Id); //Real test
        LeaveManager.editWithoutTime(today.addDays(7), 'Matin', today.addDays(7), 'Matin', 
            'Absence date edit', 'Absence date', leaves[1].Id); //Real test
        LeaveManager.editWithoutTime(today.addDays(8), 'Après-midi', today.addDays(8), 'Après-midi', 
            'Absence date edit', 'Absence date', leaves[2].Id); //Real test
        LeaveManager.editWithoutTime(today.addDays(9), 'Après-midi', today.addDays(9), 'Après-midi', 
            'Absence date edit', 'Absence date', '003'); //Failing test
        leaves = [SELECT Type__c FROM Demande_de_conges__c];
        System.assertEquals('Absence date edit', leaves[0].Type__c);

        LeaveManager.acceptLeave(leaves[0].Id);
        LeaveManager.rejectLeave(leaves[1].Id);
    }

    @IsTest 
    private static void leaveRepository() {
        
        Date today = System.today();
        
        Contact c = new Contact(LastName='Collab');
        insert c;
        Contact c2 = new Contact(LastName='Manager');
        insert c2;

        Demande_de_conges__c d = new Demande_de_conges__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(6),
                Type__c = 'Absence',
                Statut__c = '10 Ouvert',
                Salarie__c = c.Id
                );
        insert d;
        Demande_de_conges__c d2 = new Demande_de_conges__c(
                Date_de_debut__c = today.addDays(30),
                Date_de_fin__c = today.addDays(36),
                Type__c = 'Absence 2',
                Statut__c = '50 Fermée',
                Salarie__c = c2.Id
                );
        insert d2;

        List<String> fields = new List<String>{'Type__c', 'Date_de_debut__c'};
        List<Demande_de_conges__c> leaves = LeaveRepository.getAll();
        leaves = LeaveRepository.getAllForFields(fields);
        System.assertEquals(2, leaves.size());

        leaves = LeaveRepository.getAllActive(30);
        leaves = LeaveRepository.getAllActiveForFields(30, fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllActiveByContact(c.Id, 30);
        leaves = LeaveRepository.getAllActiveByContactForFields(c.Id, 30, fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllActiveByContactBetweenDate(c.Id, today, today.addDays(30), 30);
        leaves = LeaveRepository.getAllActiveByContactBetweenDateForFields(c.Id, today, today.addDays(30), 30, fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllByContact(c.Id);
        leaves = LeaveRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllByContactBetweenDate(c.Id, today, today.addDays(30));
        leaves = LeaveRepository.getAllByContactBetweenDateForFields(c.Id, today, today.addDays(30), fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllWithOffset(0, 1);
        leaves = LeaveRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, leaves.size());

        leaves = LeaveRepository.getAllWithOffsetByContact(c.Id, 0, 1); 
        leaves = LeaveRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields); 
        System.assertEquals(1, leaves.size());

        Demande_de_conges__c leave = LeaveRepository.getById(leaves[0].Id);
        leave = LeaveRepository.getByIdForFields(leaves[0].Id, fields);
        System.assertEquals('Absence', leave.Type__c);

        leave = LeaveRepository.getUntranslatedById(leaves[0].Id);
        System.assertEquals('Absence', leave.Type__c);
    }
}