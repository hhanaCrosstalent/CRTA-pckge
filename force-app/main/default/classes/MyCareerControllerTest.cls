@isTest
public with sharing class MyCareerControllerTest {

    @isTest
    static void loadCOntentTest() {
        Test.startTest();
        for (crta__application_RH__mdt app : [select Id from crta__application_RH__mdt where crta__Is_Active__c = true]) {
           MyCareerController.loadContent(app.Id, 1);
        }

        Test.stopTest();
    }

    @isTest
    static void updateDatableValuesTest() {
        List<crta__Component_table__mdt> tables= [select Id from crta__Component_table__mdt LIMIT 1];
        if (tables!=null && !tables.isEmpty()) {
            MyCareerController.updateDatableValues(tables.get(0).Id, 1, 0);
        }
    }
   
}