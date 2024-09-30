@IsTest
private class offerGeolocationController_test {
    
    @IsTest
    private static void testAll() {
        
        OfferGeolocationController con = new OfferGeolocationController();
        con.searchText = 'Tes';
        con.search();
        List<SelectOption> options = con.getOfferIndustries();
        System.assert(options.size()>0);
        con.getContactTypes();
        con.toggleSort();

        con.searchText = '';
        con.selectedType = 'test';
        con.selectedIndustry = 'test';
        con.search();
    }

    @TestSetup
    private static void testSetup() {
        Geolocation__c options = new Geolocation__c(
            API_key__c = 'AqiKi39Ge5Y57NRLwSrXTft8MU8UIHH5BR-lPz3tYyNBwU6Fzf-lSIjpxV7C5utk',
            ContactTrigger__c = false
        );
        insert options;

        Contact c = new Contact(LastName='Test', Location__Latitude__s = 48.8078, Location__Longitude__s = 2.3747);
        insert c;
    }
}