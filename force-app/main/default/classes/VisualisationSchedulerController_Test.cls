@IsTest
private class VisualisationSchedulerController_Test {

    @IsTest
    private static void VisualisationSchedulerController_Test() {
        Timesheet__c timesheetOptions = new Timesheet__c(
                useConstraint__c=true,
                startHour__c = '07:00',
                endHour__c = '19:00',
                endHourMorning__c = '12:00',
                startHourAfternoon__c = '13:00'
                );
        insert timesheetOptions;

        DateTime now = System.now();
        DateTime startTimeM = DateTime.newInstance(now.date(), Time.newInstance(8, 0, 0, 0));
        DateTime endTimeM = DateTime.newInstance(now.date(), Time.newInstance(12, 0, 0, 0));
        DateTime startTimeA = DateTime.newInstance(now.date(), Time.newInstance(14, 0, 0, 0));
        DateTime endTimeA = DateTime.newInstance(now.date(), Time.newInstance(18, 0, 0, 0));

        Contact c = new Contact(Lastname='Manager');
        insert c; 
		System.assertEquals('Manager', c.Lastname);
        
        Contact c2 = new Contact(
                Lastname='Collab',
                ReportsToId = c.Id,
                Responsable_RH__c = c.Id
                );
        insert c2;
		System.assertEquals('Collab', c2.Lastname);
        
        Feuille_Temps_Hebdo__c week = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = startTimeM.date().toStartOfWeek().addDays(-7),
                Date_de_fin__c = startTimeM.date().toStartOfWeek().addDays(-1),
                Statut__c = '10 Déclaration en cours',
                Salarie__c = c2.Id
                );
        insert week;
		System.assertEquals('10 Déclaration en cours', week.Statut__c);
        
        PageReference pg = Page.VisualisationScheduler;
        Test.setCurrentPage(pg);

        VisualisationSchedulerController controller = new VisualisationSchedulerController();
        controller.getManagers();
        controller.getTeams();
        controller.getTimePeriods();
        controller.getTimeTypes();
        String selectedTimeType = controller.selectedTimeType;
        String selectedTimePeriod = controller.selectedTimePeriod;
        String selectedTeam = controller.selectedTeam;
        String selectedManager = controller.selectedManager;

        String jsonStart = '{_isAMomentObject=true, _isUTC=true, _offset=0, _pf={empty=false, unusedTokens=[], '
                + 'unusedInput=[], overflow=-2, charsLeftOver=0, nullInput=false, invalidMonth=null, '
                + 'invalidFormat=false, userInvalidated=false, iso=false}, _locale={_fullCalendar_weekCalc=local}, _d='
                + String.valueOf(week.Date_debut_semaine__c)
                + ', _ambigTime=true, _ambigZone=true, _fullCalendar=true}';
        String jsonEnd = '{_isAMomentObject=true, _isUTC=true, _offset=0, _pf={empty=false, unusedTokens=[], '
                + 'unusedInput=[], overflow=-2, charsLeftOver=0, nullInput=false, invalidMonth=null, '
                + 'invalidFormat=false, userInvalidated=false, iso=false}, _locale={_fullCalendar_weekCalc=local}, _d='
                + String.valueOf(week.Date_de_fin__c)
                + ', _ambigTime=true, _ambigZone=true, _fullCalendar=true}';
        VisualisationSchedulerController.getCalendarResources(c.Id, 'Test');
        VisualisationSchedulerController.getCalendarEvents(jsonStart, jsonEnd, c.Id, 'Test');
    }
}