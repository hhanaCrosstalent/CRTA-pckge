@isTest
public class AggregatedCountControllerTest {

    @isTest
    static void testGetAggregatedCountIdsByApp() {
        // Query custom metadata records to get valid IDs
        List<crta__aggregated_count__mdt> aggregatedCounts = [SELECT Id FROM crta__aggregated_count__mdt LIMIT 1];
        if (aggregatedCounts.isEmpty()) {
            System.assert(false, 'No custom metadata records found. Please create records for testing.');
            return;
        }
        Id appId = aggregatedCounts[0].Id;

        Test.startTest();
        List<Id> result = AggregatedCountController.getAggregatedCountIdsByApp(appId);
        Test.stopTest();

        // Verify the result
       // System.assertNotEquals(null, result, 'The result should not be null.');
      //  System.assertNotEquals(0, result.size(), 'The result should not be empty.');
    }

    @isTest
    static void testGetAggregatedResults() {
        // Query custom metadata records to get valid IDs
        List<crta__aggregated_count__mdt> aggregatedCounts = [SELECT Id FROM crta__aggregated_count__mdt LIMIT 1];
        if (aggregatedCounts.isEmpty()) {
            System.assert(false, 'No custom metadata records found. Please create records for testing.');
            return;
        }
        Id aggCountId = aggregatedCounts[0].Id;

        Test.startTest();
        AggregatedCountController.AggregatedCount result = AggregatedCountController.getAggregatedResults(aggCountId);
        Test.stopTest();

        // Verify the result
        System.assertNotEquals(null, result, 'The result should not be null.');
        // Add more assertions based on expected behavior
    }
}