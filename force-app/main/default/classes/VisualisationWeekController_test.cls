@IsTest
private class VisualisationWeekController_test {

    @IsTest
    private static void generalTest() {
        DateTime now = System.now();
        DateTime startTimeM = DateTime.newInstance(now.date(), Time.newInstance(8, 0, 0, 0));
        DateTime endTimeM = DateTime.newInstance(now.date(), Time.newInstance(12, 0, 0, 0));
        DateTime startTimeA = DateTime.newInstance(now.date(), Time.newInstance(14, 0, 0, 0));
        DateTime endTimeA = DateTime.newInstance(now.date(), Time.newInstance(18, 0, 0, 0));
        VisualisationWeekController_Test.insertBaseObjects();

        Contact c2 = [SELECT Id, LastName FROM Contact WHERE LastName = 'Collab' LIMIT 1];
        Feuille_Temps_Hebdo__c week = [SELECT Id, Date_debut_semaine__c, Date_de_fin__c, Statut__c 
                                       FROM Feuille_Temps_Hebdo__c 
                                       WHERE Salarie__c = :c2.Id 
                                       LIMIT 1];
		//System.assertEquals('Collab', c2.LastName);
       // System.assertEquals('10 Déclaration en cours', week.Statut__c);
        PageReference pg = Page.VisualisationWeek;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', week.Id);

        // instantiate the controller
        VisualisationWeekController controller = new VisualisationWeekController();
        controller.getTimePeriods();
        controller.getTimeTypes();
        String selectedTimeType = controller.selectedTimeType;
        String selectedTimePeriod = controller.selectedTimePeriod;
    }

    @IsTest 
    private static void insertBaseObjects() {
        DateTime now = System.now();
        DateTime startTimeM = DateTime.newInstance(now.date(), Time.newInstance(8, 0, 0, 0));
        DateTime endTimeM = DateTime.newInstance(now.date(), Time.newInstance(12, 0, 0, 0));
        DateTime startTimeA = DateTime.newInstance(now.date(), Time.newInstance(14, 0, 0, 0));
        DateTime endTimeA = DateTime.newInstance(now.date(), Time.newInstance(18, 0, 0, 0));

        Contact c = new Contact(Lastname='Manager');
        insert c; 

        Contact c2 = new Contact(
                Lastname='Collab',
                ReportsToId = c.Id,
                Responsable_RH__c = c.Id
                );
        insert c2; 

        Timesheet__c timesheetOptions = new Timesheet__c(
                UseMetadata__c = true,
                StartHour__c = '07:00',
                EndHour__c = '19:00',
                EndHourMorning__c = '12:00',
                StartHourAfternoon__c = '13:00'
                );
        insert timesheetOptions;

        Type_d_absence__c leaveType = new Type_d_absence__c(
                Name = 'Congés payés', 
                Notifier_manager__c = true,
                Validation_manager__c = true
                );
        insert leaveType;

        Feuille_Temps_Hebdo__c week = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = startTimeM.date().toStartOfWeek().addDays(-7),
                Date_de_fin__c = startTimeM.date().toStartOfWeek().addDays(-1),
                Statut__c = '10 Déclaration en cours',
                Salarie__c = c2.Id
                );
        insert week;
    }
}