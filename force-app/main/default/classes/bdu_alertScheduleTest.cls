@IsTest
public class bdu_alertScheduleTest {
    
    
    @IsTest
    static void testMethd() {
        Test.startTest();    
        String CRON_EXP = '0 0 0 3 9 ? 2022';
       // Schedule the test job
       String jobId = System.schedule('bdu_alertScheduleTest', CRON_EXP, new bdu_alertSchedule());
       Test.stopTest();
    }

}