/** Test of trigger CreateContact */
@IsTest
private class createContact_test {

    @IsTest
    private static void createContactTest() {
        SIRH__c options = new SIRH__c(NewContactFromUser__c = true);
        insert options;

        Profile p = [SELECT Id 
                        FROM Profile 
                        WHERE Name = 'Administrateur Système' 
                        OR Name = 'System Administrator' 
                        LIMIT 1];

        User u0 = new User(
                LastName = 'Test',
                FirstName = 'Toto',
                Username = 'test-dev-app-exchange@test.com',
                Email = 'test-dev-app-exchange@test.com',
                Alias = 'ttest',
                TimeZoneSidKey = 'Europe/Paris',
                LocaleSidKey = 'fr',
                EmailEncodingKey = 'ISO-8859-1',
                ProfileId = p.Id,
                LanguageLocaleKey = 'fr'
                );
        insert u0;

        List<Contact> contacts = [SELECT FirstName, LastName FROM Contact];
        System.assertEquals(contacts.size(), 1);
        Contact toto = contacts.get(0);
        //System.assertEquals(toto.LastName, u0.LastName);
        //System.assertEquals(toto.FirstName, u0.FirstName);

        User u1 = new User(
                LastName = 'Iesti',
                FirstName = 'Ioto',
                Username = 'iii-dev-app-exchange@test.com',
                Email = 'iii-dev-app-exchange@test.com',
                Alias = 'blast',
                TimeZoneSidKey = 'Europe/Paris',
                LocaleSidKey = 'fr',
                EmailEncodingKey = 'ISO-8859-1',
                ProfileId = p.Id,
                LanguageLocaleKey = 'fr',
                crta__Contact__c = toto.Id
                );
        insert u1;

        contacts = [SELECT Id FROM Contact];
        System.assertEquals(contacts.size(), 1);

    }
}