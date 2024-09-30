@IsTest
private class VisualisationHomeController_Test {

    @IsTest
    private static void VisualisationHomeController() {
        Contact c = new Contact(Lastname = 'Collab');
        insert c;

        String startDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, '
            + '_d: 2015-02-23T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';
        String endDates = '{ _isAMomentObject: true, _isUTC: true, _offset: 0, _pf: Object, _locale: Object, '
            + '_d: 2015-04-06T00:00:00.000Z, _ambigTime: true, _ambigZone: true, _fullCalendar: true }';

        PageReference pg = Page.VisualisationHome;
        Test.setCurrentPage(pg);

        VisualisationHomeController controller = new VisualisationHomeController();
        VisualisationHomeController.getCalendarEvents(startDates, endDates, c.Id);
        System.assert( VisualisationHomeController.getCalendarEvents(startDates, endDates, c.Id) != null);
    }
}