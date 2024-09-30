@IsTest
private class bdu_calendarController_Test {
    
    @IsTest
    private static void testAll() {
        Bdu_calendarController controller = new Bdu_calendarController();
        List<String> types = controller.getTypes();
        System.assert(types.size()>0);
        
        String startDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, _d: '
            + '2015-02-23T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';
        String endDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, _d: '
            + '2015-04-06T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';

        Bdu_calendarController.getCalendarEvents(startDates, endDates);
    }
}