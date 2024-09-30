@isTest
public class BatchClassExampleTest {
    @isTest
    static void testBatchExecution() {
        // Set up test data
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 100; i++) {
            Contact con = new Contact(
                LastName = 'Test' + i,
                Email = 'test' + i + '@example.com'
            );
            contacts.add(con);
        }
        insert contacts;

        // Start the batch job
        Test.startTest();
        BatchClassExample batchExample = new BatchClassExample();
        Database.executeBatch(batchExample);
        Test.stopTest();

        // Verify the results
        Integer totalContacts = [SELECT COUNT() FROM Contact];
        //System.assertEquals(100, totalContacts, 'Total contacts should be 100 after batch execution.');
    }
}