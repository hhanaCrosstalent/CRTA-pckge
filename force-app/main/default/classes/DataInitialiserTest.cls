@IsTest
private class DataInitialiserTest {

    @IsTest
    private static void getFieldsFromFile() {
        Test.startTest();
        List<List<String>> l = DataInitialiser.getFieldsFromFile();
        Test.stopTest();
        System.assert(l.size()>0);
        System.assert(l[0].size()>5);
    }

    @IsTest
    private static void initCountries() {
        Test.startTest();
        DataInitialiser.init();
        Test.stopTest();

        List<Country__c> l = [SELECT Name FROM Country__c ORDER BY Name];
        System.assert(l.size()>200, 'There are more than 200 countries on earth.');

        l = [SELECT Code__c, 
                    EEA__c,
                    EU__c, 
                    GDPR__c, 
                    Internal_Code__c
            FROM Country__c 
            WHERE Name = 'France'];

        System.assertEquals('FR', l[0].Code__c, 'The French ISO-3166-1 Alpha-2 is FR.');
        System.assertEquals('FRA', l[0].Internal_Code__c, 'The French ISO-3166-1 Alpha-3 is FRA.');
        System.assertEquals(true, l[0].EU__c, 'France remains in the EU.');
        System.assertEquals(true, l[0].EEA__c, 'France remains in the EEA.');

        l = [SELECT Code__c, 
                    EEA__c,
                    EU__c, 
                    GDPR__c, 
                    Internal_Code__c,
                    Name_French__c
            FROM Country__c 
            WHERE Name = 'Argentina'];

        System.assertEquals('AR', l[0].Code__c, 'The Argentine ISO-3166-1 Alpha-2 is AR.');
        System.assertEquals('ARG', l[0].Internal_Code__c, 'The Argentine ISO-3166-1 Alpha-3 is ARG.');
        System.assertEquals(false, l[0].EU__c, 'Argentina remains in South America.');
        System.assertEquals(false, l[0].EEA__c, 'Argentina remains in South America.');
        System.assertEquals('Argentine (l\')', l[0].Name_French__c);
        
        l = [SELECT Time_Zone__c
            FROM Country__c
            WHERE Name = 'Afghanistan'];

        System.assertEquals('Asia/Kabul', l[0].Time_Zone__c);
    }
}