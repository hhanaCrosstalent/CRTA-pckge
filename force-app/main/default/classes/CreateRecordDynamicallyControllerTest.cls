@isTest
public class CreateRecordDynamicallyControllerTest {
    @isTest
    static void testGetPicklistValues() {
        // Call the method to get picklist values
        Test.startTest();
        Map<String, String> picklistValues = CreateRecordDynamicallyController.getpicklistValues('TestObject__c', 'TestPicklistField__c');
        Test.stopTest();
        
        // Verify that the picklist values are not null and not empty
        System.assertNotEquals(null, picklistValues, 'Picklist values should not be null.');
        System.assertNotEquals(0, picklistValues.size(), 'Picklist values should not be empty.');
    }

    @isTest
    static void testGetDynamicFieldsFromCustomSettingCntrl() {
        // Assuming 'TestObject__c' is the tableId corresponding to your custom metadata
        Test.startTest();
        List<CreateRecordDynamicallyController.FieldWrapper> fields = CreateRecordDynamicallyController.getDynamicFieldsFromCustomSettingCntrl('TestObject__c');
        Test.stopTest();
        
        // Verify that the fields list is not null and contains the expected number of fields
        System.assertNotEquals(null, fields, 'Fields list should not be null.');
        System.assertEquals(2, fields.size(), 'There should be 2 dynamic fields.');
    }

    @isTest
    static void testCreateRecord() {
        // Create FieldWrapper list for record creation
        List<CreateRecordDynamicallyController.FieldWrapper> fieldWrappers = new List<CreateRecordDynamicallyController.FieldWrapper>();

        CreateRecordDynamicallyController.FieldWrapper field1 = new CreateRecordDynamicallyController.FieldWrapper();
        field1.objectApiName = 'TestObject__c';
        field1.fieldApiName = 'TestField1__c';
        field1.type = 'Text';
        field1.idValue = 'Test Value';
        fieldWrappers.add(field1);

        CreateRecordDynamicallyController.FieldWrapper field2 = new CreateRecordDynamicallyController.FieldWrapper();
        field2.objectApiName = 'TestObject__c';
        field2.fieldApiName = 'TestPicklistField__c';
        field2.type = 'List';
        field2.idValue = 'Picklist Value';
        fieldWrappers.add(field2);

        Test.startTest();
      	 CreateRecordDynamicallyController.createRecord(fieldWrappers);
        Test.stopTest();

        // Query the created record
     /*   List<TestObject__c> records = [SELECT Id, TestField1__c, TestPicklistField__c FROM TestObject__c];
        System.assertEquals(1, records.size(), 'There should be 1 record created.');
        System.assertEquals('Test Value', records[0].TestField1__c, 'TestField1__c should be "Test Value".');
        System.assertEquals('Picklist Value', records[0].TestPicklistField__c, 'TestPicklistField__c should be "Picklist Value".');*/
    }
}