@IsTest
private class sessionCalendarController_Test {
    
    @IsTest
    private static void sessionCalendarControllerTest() {
        SessionCalendarController controller = new SessionCalendarController();
        controller.getTypes();
        System.assert(controller.getTypes() != null);
        
        String startDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, '
            + '_d: 2015-02-23T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';
        String endDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, '
            + '_d: 2015-04-06T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';
        sessionCalendarController.getCalendarEvents(startDates, endDates);
        System.assert(sessionCalendarController.getCalendarEvents(startDates, endDates) != null);
    }
}