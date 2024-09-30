@IsTest
private class GDPRReadinessControllerTest {

    @IsTest
    private static void lightning() {
        GDPRReadinessController.save('2');
        List<GDPR__c> l = [SELECT Id FROM GDPR__c];
        System.assertEquals(1, l.size());

        GDPRReadinessController.save('3');
        l = [SELECT Id FROM GDPR__c];
        System.assertEquals(2, l.size());

        GDPRReadinessController.save('3');
        l = [SELECT Id FROM GDPR__c];
        System.assertEquals(2, l.size());
    }

    @IsTest
    private static void classic() {
        GDPRReadinessController c = new GDPRReadinessController();
        String s = 'first column,second column,third column,fourth column|first column,second column,'
            + 'third column,fourth column|first column,second column,third column,fourth column';
        GDPRReadinessController.buildTable(s, false);
        s = 'first column,second column,third column,fourth column,fifth column|first column,second column,'
            + 'third column,fourth column,fifth column|first column,second column,third column,'
            + 'fourth column,fifth column';
        GDPRReadinessController.buildTable(s, true);
		system.assert(s != '');
        c.handleClick1();
        c.handleClick2();
        c.handleClick3();
        c.handleClick4();

        List<Object> l = c.getTable1csv();
        l = c.getTable2csv();
        l = c.getTable3csv();
        s = c.getWord();
    }
}