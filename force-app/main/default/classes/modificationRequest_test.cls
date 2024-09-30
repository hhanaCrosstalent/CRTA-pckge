@IsTest
private class modificationRequest_test {

    @IsTest 
    private static void approve() {
        modificationRequest.approve(insertRequest());
        System.assertEquals(modificationRequest.approve(insertRequest()), 'success');
    }

    @IsTest 
    private static void revert() {
        modificationRequest.approve(insertRequest());
        modificationRequest.revert(insertRequest());
        System.assertEquals(modificationRequest.approve(insertRequest()), 'success');
    }

    private static List<Id> insertRequest() {
        List<Id> args = new List<Id>();

        Contact c = new Contact(LastName='Test');
        insert c;
        Contact c2 = new Contact(LastName='Test2');
        insert c2;
        Contact c3 = new Contact(LastName='Test3');
        insert c3;
        Contact c4 = new Contact(LastName='Test4');
        insert c4;
        Contact c5 = new Contact(LastName='Test5');
        insert c5;
        Contact c6 = new Contact(LastName='Test6');
        insert c6;
        Contact c7 = new Contact(LastName='Test7');
        insert c7;
        Contact c8 = new Contact(LastName='Test8');
        insert c8;
		
        System.assertEquals(c.LastName, 'Test');
        System.assertEquals(c2.LastName, 'Test2');
        System.assertEquals(c3.LastName, 'Test3');
        System.assertEquals(c4.LastName, 'Test4');
        System.assertEquals(c5.LastName, 'Test5');
        System.assertEquals(c6.LastName, 'Test6');
        System.assertEquals(c7.LastName, 'Test7');
        System.assertEquals(c8.LastName, 'Test8');
        
        Demande_de_modification__c requestSalutation = new Demande_de_modification__c(
                Champ_technique__c = 'Salutation',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestSalutation;
        args.add(requestSalutation.Id);
        Demande_de_modification__c requestLastName = new Demande_de_modification__c(
                Champ_technique__c = 'LastName',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c2.Id
                );
        insert requestLastName;
        args.add(requestLastName.Id);
        Demande_de_modification__c requestFirstName = new Demande_de_modification__c(
                Champ_technique__c = 'FirstName',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c3.Id
                );
        insert requestFirstName;
        args.add(requestFirstName.Id);
        String fieldName = Schema.SObjectType.Contact.fields.Sexe__c.getName();
        Demande_de_modification__c requestSexe = new Demande_de_modification__c(
                Champ_technique__c = fieldName,
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c4.Id
                );
        insert requestSexe;
        args.add(requestSexe.Id);
        fieldName = Schema.SObjectType.Contact.fields.Situation_familiale__c.getName();
        Demande_de_modification__c requestSituation = new Demande_de_modification__c(
                Champ_technique__c = fieldName,
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c5.Id
                );
        insert requestSituation;
        args.add(requestSituation.Id);
        Demande_de_modification__c requestPhone = new Demande_de_modification__c(
                Champ_technique__c = 'Phone',
                Nouvelle_valeur__c = '0000000000',
                Ancienne_valeur__c = '0123456789',
                Salarie__c = c6.Id
                );
        insert requestPhone;
        args.add(requestPhone.Id);
        Demande_de_modification__c requestMobilePhone = new Demande_de_modification__c(
                Champ_technique__c = 'MobilePhone',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c7.Id
                );
        insert requestMobilePhone;
        args.add(requestMobilePhone.Id);
        Demande_de_modification__c requestEmail = new Demande_de_modification__c(
                Champ_technique__c = 'Email',
                Nouvelle_valeur__c = 'Test@test.com',
                Ancienne_valeur__c = 'Truc@truc.com',
                Salarie__c = c8.Id
                );
        insert requestEmail;
        args.add(requestEmail.Id);

        return args;
    }
}