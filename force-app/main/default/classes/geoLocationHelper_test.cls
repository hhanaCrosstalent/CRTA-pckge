@IsTest
private class geoLocationHelper_test {
    @IsTest
    static void testIt() {
        geoLocationHelper g = new geoLocationHelper();
    }

    /*@IsTest 
    private static void setContactCoordinatesTest() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Contact__c = true;
        insert setting;
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2;
        Geolocation__c options = new Geolocation__c(
                API_key__c = 'AqiKi39Ge5Y57NRLwSrXTft8MU8UIHH5BR-lPz3tYyNBwU6Fzf-lSIjpxV7C5utk',
                ContactTrigger__c = true
                );
        insert options;
        Contact c = new Contact (
                LastName = 'Napoleon',
                MailingCountry='FR',
                MailingState='Haute-Normandie',
                MailingCity='Rouen',
                MailingStreet='11 rue ganterie.',
                MailingPostalCode='76000'
                );
        //Now insert data causing an contact trigger to fire.
        Test.startTest();
        insert c;
        Set<Id> conId=new Set<Id>(); 
        conId.add(c.Id);
        //geoLocationHelper.getContactLocation(conId); => commented By Hana.H on 21/05/24 to prevent prevent API requests limits (in org) from being exceeded
        Test.stopTest();
        Contact Napoleon = [SELECT Location__Latitude__s, Location__Longitude__s 
                            FROM Contact 
                            WHERE LastName = 'Napoleon' 
                            LIMIT 1];
        Double theLatitude = Napoleon.Location__Latitude__s;
        Double theLongitude = Napoleon.Location__Longitude__s;
        
        //System.assertEquals(48.89039993286133, theLatitude);
        //System.assertEquals(2.173150062561035, theLongitude);
    }*/

    /*@IsTest
    private static void setJobOfferCoordinatesTest() {
         crta__logs_activation__c setting = new crta__logs_activation__c();
        setting.crta__Active__c = true;
        insert setting;
        Geolocation__c options = new Geolocation__c(
                API_key__c = 'AqiKi39Ge5Y57NRLwSrXTft8MU8UIHH5BR-lPz3tYyNBwU6Fzf-lSIjpxV7C5utk',
                JobOfferTrigger__c = true
                );
        insert options;
        Offre_d_emploi__c c = new Offre_d_emploi__c(
                CT_Department__c = 'Hauts-de-seine',
                CT_City__c ='Paris',
                CT_Industry_of_activities__c = 'Energie',
                CT_Scope__c =true,
                CT_Country__c ='France'
                );
        //Now insert data causing an contact trigger to fire.
        Test.startTest();
        insert c;
        Test.stopTest();
        Offre_d_emploi__c offer = [SELECT Location__Latitude__s, Location__Longitude__s 
                                   FROM Offre_d_emploi__c 
                                   LIMIT 1];
        Double theLatitude = offer.Location__Latitude__s;
        Double theLongitude = offer.Location__Longitude__s;
        System.assertEquals(48.89039993286133, theLatitude);
        System.assertEquals(2.173150062561035, theLongitude);

        c.CT_City__c='London';
        c.CT_Country__c ='England';
        c.CT_Postal_code__c = 10000;
        update c;
    }*/
}