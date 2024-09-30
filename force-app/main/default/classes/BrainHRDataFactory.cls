//Security isCreateable() isUpdateable() isDeletable() checked
public without sharing class BrainHRDataFactory {
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx + 1);
        }
        return randStr; 
    }

    public static Profile getAdminProfile() {
        return [SELECT Id FROM Profile WHERE Name LIKE '%syst%' AND Name LIKE '%dmin%' LIMIT 1];
    }

    public static RecordType getRecordType(String objectApi, String devName) {
        try {
            return [SELECT Id FROM RecordType WHERE SobjectType =: objectApi AND DeveloperName =: devName LIMIT 1];
        } catch (Exception e) {
            System.debug('RecordType not found ' + devName + ' on object ' + objectApi);
            return null;
        }
    }

    public static Account newAccount() {
        return BrainHRDataFactory.newAccount('Core_HR');
    }

    public static Account newAccount(String devName) {
        RecordType rt = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account'
            AND DeveloperName =: devName
            AND NamespacePrefix = 'crta'
            LIMIT 1
        ];

        return new Account(
            Name = 'AccountTest',
            RecordTypeId = rt.Id
        );
    }

    public static Contact newContact() {
        return newContact(null, null);
    }

    public static Contact newContact(Account acc) {
        return newContact(acc, null);
    }

    public static Contact newContact(RecordType rt) {
        return newContact(null, rt);
    }

    public static Contact newContact(Account acc, RecordType rt) {
        String rFirstName = BrainHRDataFactory.generateRandomString(20);
        String rLastName = BrainHRDataFactory.generateRandomString(20);
        String rDomain = BrainHRDataFactory.generateRandomString(5);

        if (rt == null) {
            rt = getRecordType('Contact', 'Salarie');
        }

        Contact c = new Contact(
            RecordTypeId = rt.Id,
            Salutation = 'M',
            FirstName = rFirstName,
            LastName = rLastName,
            Birthdate = System.today().addYears(-25),
            Email = rLastName + '.' + rFirstName + '@' + rDomain + '.fr',
            Phone = '0606060606',
            MobilePhone = '0606060606',
            crta__CT_Date_of_entry_to_the_society__c = System.today().addYears(-5),
            crta__CT_Gross_fiscal_annual_salary__c = 1,
            MailingStreet = rFirstName,
            MailingPostalCode = '75001',
            MailingCity = rFirstName,
            MailingCountry = rLastName,
            crta__Social_Number_Key__c = '39',
            crta__Numero_de_ss__c = '1621199350269'
        );
        if (acc != null) {
            c.AccountId = acc.id;
        }
        return c;
    }

    public static List<Contact> newContacts(Account acc, Integer nbr) {
        return newContacts(acc, null, nbr);
    }

    public static List<Contact> newContacts(Account acc, RecordType rt, Integer nbr) {
        List<Contact> contactsList = new List<Contact>();
        for(Integer i = 0; i < nbr; i++) {
            Contact c = BrainHRDataFactory.newContact(acc, rt);
            c.Email += String.valueOf(i);
            c.FirstName += String.valueOf(i);
            c.LastName += String.valueOf(i);
            contactsList.add(c);
        }
        return contactsList;
    }

    public static Id getSystemAdminProfile() {
        return [SELECT Id FROM Profile WHERE Name LIKE '%dmin%' AND Name LIKE '%syst%' LIMIT 1].Id;
    }

    public static User newUser(Id profileId, Id employeeId) {
        String rFirstName = generateRandomString(20);
        String rLastName = generateRandomString(20);
        String rDomain = generateRandomString(5);

        return new User(
            ProfileId = profileId,
            FirstName = rFirstName,
            LastName = rLastName,
            Alias = rFirstName.substring(0, 1) + rLastName.substring(0, 5),
            CommunityNickname = rFirstName + rLastName,
            Username = rLastName + '.' + rFirstName + '@' + rDomain + '.fr',
            Email = rLastName + '.' + rFirstName + '@' + rDomain + '.fr',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO',
            crta__Contact__c = employeeId
        );
    }

    public static crta__GS_Fiche_de_poste__c newJob() {
        return new crta__GS_Fiche_de_poste__c(
            crta__GS_Actif__c = true,
            Name = 'Developer',
            crta__GS_Description__c = 'Programming'
        );
    }

    public static crta__GS_Affectation_poste__c newHrAssignment(Contact c, crta__GS_Fiche_de_poste__c job) {
        Date d = System.today();
        Id recordTypeAccountHierarchical = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Hierarchical').getRecordTypeId();
        Account accountHierarchical = BrainHRDataFactory.newAccount();
        accountHierarchical.RecordtypeId = recordTypeAccountHierarchical;
        insert accountHierarchical;
        
        return new crta__GS_Affectation_poste__c(
            crta__GS_Salarie__c = c.Id,
            crta__GS_Fiche_de_poste__c = job.Id,
            crta__GS_Date_de_debut__c = d.addYears(-3),
            crta__Hierarchical_Account__c = accountHierarchical.Id
        );
    }

    public static crta__Labor_contract__c newContract(Account acc, Contact c) {
        return BrainHRDataFactory.newContract(acc, c, 'Contract');
    }

    public static crta__Labor_contract__c newContract(Account acc, Contact c, String devName) {
        Date d = System.today();

        RecordType rt = getRecordType('crta__Labor_contract__c', devName);

        return new crta__Labor_contract__c(
            crta__Company__c = acc.Id,
            crta__Employee__c = c.Id,
            RecordTypeId = rt.Id,
            crta__Status__c = '5',
            crta__Start_date__c = d.addYears(-3),
            crta__Zone_Value_1__c = '1',
            crta__Zone_Value_2__c = '2',
            crta__Zone_Value_3__c = '3',
            crta__Zone_Value_4__c = '4',
            crta__Zone_Value_5__c = '5'
        );
    }
}