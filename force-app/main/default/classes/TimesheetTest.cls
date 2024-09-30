@IsTest
private class TimesheetTest {

    private static Date today = System.today();

    @IsTest
    static void timesheetManagerTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        TimesheetManager.createWeeklyTimesheet(today, today, c.Id); //Real test
        TimesheetManager.createWeeklyTimesheet(today, today, '003'); //Failing test
        List<Feuille_Temps_Hebdo__c> timesheets = [SELECT Id, Date_debut_semaine__c, Date_de_fin__c 
                                                   FROM Feuille_Temps_Hebdo__c];
        System.assertEquals(1, timesheets.size());
        System.assertEquals(today.toStartOfWeek(), timesheets[0].Date_debut_semaine__c);
        System.assertEquals(today.toStartOfWeek().addDays(6), timesheets[0].Date_de_fin__c);

        TimesheetManager.editTimesheet(today, today.addDays(13), timesheets[0].Id); //Real test
        TimesheetManager.editTimesheet(today, today.addDays(13), '003'); //Failing test
        timesheets = [SELECT Id, Date_debut_semaine__c, Date_de_fin__c FROM Feuille_Temps_Hebdo__c];
        System.assertEquals(1, timesheets.size());
        System.assertEquals(today, timesheets[0].Date_debut_semaine__c);
        System.assertEquals(today.addDays(13), timesheets[0].Date_de_fin__c);

        delete timesheets;

        //Real test
        Feuille_Temps_Hebdo__c timesheet = TimesheetManager.findOrCreateTimesheet(today, today.addDays(13), c.Id);
        timesheet = TimesheetManager.findOrCreateTimesheet(today.addDays(13), today.addDays(20), c.Id); //Failing test
        timesheet = TimesheetManager.findOrCreateTimesheet(today.addDays(13), today.addDays(20), '003'); //Failing test
        timesheets = [SELECT Id, Date_debut_semaine__c, Date_de_fin__c, Statut__c, Valeur_statut__c, Texte_statut__c 
                      FROM Feuille_Temps_Hebdo__c];
        System.assertEquals(1, timesheets.size());

        TimesheetManager.validateTimesheet(timesheets[0].Date_debut_semaine__c, timesheets[0].Date_de_fin__c, c.Id); //Real test
        TimesheetManager.validateTimesheet(today, today.addDays(13), '003'); //Failing test
        TimesheetManager.validateTimesheetById(timesheets[0].Id); //Real test
        TimesheetManager.validateTimesheetById('003'); //Failing test
        timesheet = [SELECT Id, Valeur_statut__c FROM Feuille_Temps_Hebdo__c WHERE Id = :timesheets[0].Id];
        System.assertEquals(20, timesheet.Valeur_statut__c);

        TimesheetManager.acceptTimesheet(timesheets[0].Date_debut_semaine__c, timesheets[0].Date_de_fin__c, 'Test', c.Id); //Real test
        TimesheetManager.acceptTimesheet(today, today.addDays(13), 'Test', '003'); //Failing test
        TimesheetManager.acceptTimesheetById('Test', timesheets[0].Id); //Real test
        TimesheetManager.acceptTimesheetById('Test', '003'); //Failing test
        timesheet = [SELECT Id, Valeur_statut__c FROM Feuille_Temps_Hebdo__c WHERE Id = :timesheets[0].Id];
        System.assertEquals(90, timesheet.Valeur_statut__c);

        timesheets[0].Statut__c = '20 Validée par le collaborateur';
        update timesheets;
        TimesheetManager.rejectTimesheet(timesheets[0].Date_debut_semaine__c, timesheets[0].Date_de_fin__c, 'Test', c.Id); //Real test
        TimesheetManager.rejectTimesheet(today, today.addDays(13), 'Test', '003'); //Failing test
        TimesheetManager.rejectTimesheetById('Test', timesheets[0].Id); //Real test
        TimesheetManager.rejectTimesheetById('Test', '003'); //Failing test
        timesheet = [SELECT Id, Valeur_statut__c FROM Feuille_Temps_Hebdo__c WHERE Id = :timesheets[0].Id];
        System.assertEquals(15, timesheet.Valeur_statut__c);

        TimesheetManager.deleteTimesheet(timesheets[0].Id); //Real test
        TimesheetManager.deleteTimesheet(timesheets[0].Id); //Failing test
        timesheets = [SELECT Id, Date_debut_semaine__c, Date_de_fin__c FROM Feuille_Temps_Hebdo__c];
        System.assertEquals(0, timesheets.size());
    }

    @IsTest
    static void timesheetRepositoryTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Feuille_Temps_Hebdo__c f0 = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today,
                Date_de_fin__c = today.addDays(7),
                Statut__c = '10 Déposée',
                Salarie__c = c.Id
                );
        insert f0;
        Feuille_Temps_Hebdo__c f2 = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today.addDays(7),
                Date_de_fin__c = today.addDays(14),
                Statut__c = '20 Validée',
                Salarie__c = c.Id
                );
        insert f2;
        Feuille_Temps_Hebdo__c f3 = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today.addDays(14),
                Date_de_fin__c = today.addDays(21),
                Statut__c = '90 Validée par le manager',
                Salarie__c = c.Id
                );
        insert f3;

        List<String> fields = new List<String>{'Statut__c', 'Date_debut_semaine__c'};
        List<Feuille_Temps_Hebdo__c> timesheets = TimesheetRepository.getAll();
        timesheets = TimesheetRepository.getAllForFields(fields);
        System.assertEquals(3, timesheets.size());

        timesheets = TimesheetRepository.getAllByContact(c.Id);
        timesheets = TimesheetRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(3, timesheets.size());

        timesheets = TimesheetRepository.getAllByContactBetweenDates(c.Id, today, today.addDays(6));
        timesheets = TimesheetRepository.getAllByContactBetweenDatesForFields(c.Id, today, today.addDays(6), fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllPendingByContactBetweenDates(c.Id, today, today.addDays(20));
        timesheets = TimesheetRepository.getAllPendingByContactBetweenDatesForFields(c.Id, today, today.addDays(20), fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllValidatedByContactBetweenDates(c.Id, today, today.addDays(20));
        timesheets = TimesheetRepository.getAllValidatedByContactBetweenDatesForFields(c.Id, today, today.addDays(20), fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllByContactForDate(c.Id, today);
        timesheets = TimesheetRepository.getAllByContactForDateForFields(c.Id, today, fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllPendingByContactForDate(c.Id, today);
        timesheets = TimesheetRepository.getAllPendingByContactForDateForFields(c.Id, today, fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllValidatedByContactForDate(c.Id, today.addDays(7));
        timesheets = TimesheetRepository.getAllValidatedByContactForDateForFields(c.Id, today.addDays(7), fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllWithOffset(0, 1);
        timesheets = TimesheetRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, timesheets.size());

        timesheets = TimesheetRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        timesheets = TimesheetRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, timesheets.size());

        Feuille_Temps_Hebdo__c timesheet = TimesheetRepository.getById(f0.Id);
        timesheet = TimesheetRepository.getByIdForFields(f0.Id, fields);
        System.assertEquals(today, timesheet.Date_debut_semaine__c);
    }
}