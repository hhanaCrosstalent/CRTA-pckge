@IsTest
private class ModificationTest {

    @IsTest 
    private static void modificationManagerTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        //Real test
        ModificationManager.createModification('Collab', 'Collab 2', 'Nom de famille', 'LastName', c.Id);
        //Failing test
        ModificationManager.createModification('Collab', 'Collab 2', 'Nom de famille', 'LastName', '003');
        List<Demande_de_modification__c> requests = [SELECT Id, Nouvelle_valeur__c FROM Demande_de_modification__c];
        System.assertEquals(1, requests.size());
        System.assertEquals('Collab 2', requests[0].Nouvelle_valeur__c);
        
        //Real test
        ModificationManager.editModification('Collab', 'Manager', 'Nom de famille', 'LastName', requests[0].Id);
        //Failing test
        ModificationManager.editModification('Collab', 'Manager', 'Nom de famille', 'LastName', '003');
        requests = [SELECT Id, Nouvelle_valeur__c FROM Demande_de_modification__c];
        System.assertEquals(1, requests.size());
        System.assertEquals('Manager', requests[0].Nouvelle_valeur__c);

        ModificationManager.approve(requests[0].Id); //Real test
        ModificationManager.approve('003'); //Failing test
        c = [SELECT Id, LastName FROM Contact WHERE Id = :c.Id];
       // System.assertEquals('Manager', c.LastName); 

        ModificationManager.revert(requests[0].Id); //Real test
        ModificationManager.revert('003'); //Failing test
        c = [SELECT Id, LastName FROM Contact WHERE Id = :c.Id];
       // System.assertEquals('Collab', c.LastName); 

        ModificationManager.deleteModification(requests[0].Id); //Real test
        ModificationManager.deleteModification(requests[0].Id); //Failing test
        requests = [SELECT Id, Nouvelle_valeur__c FROM Demande_de_modification__c];
        System.assertEquals(0, requests.size());

        Demande_de_modification__c requestSalutation = new Demande_de_modification__c(
                Champ_technique__c = 'Salutation',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestSalutation;
        Demande_de_modification__c requestFirstName = new Demande_de_modification__c(
                Champ_technique__c = 'FirstName',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestFirstName;
        Demande_de_modification__c requestSexe = new Demande_de_modification__c(
                Champ_technique__c = 'Sexe__c',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestSexe;
        Demande_de_modification__c requestSituation = new Demande_de_modification__c(
                Champ_technique__c = 'Situation_familiale__c',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestSituation;
        Demande_de_modification__c requestPhone = new Demande_de_modification__c(
                Champ_technique__c = 'Phone',
                Nouvelle_valeur__c = '0000000000',
                Ancienne_valeur__c = '0123456789',
                Salarie__c = c.Id
                );
        insert requestPhone;
        Demande_de_modification__c requestMobilePhone = new Demande_de_modification__c(
                Champ_technique__c = 'MobilePhone',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestMobilePhone;
        Demande_de_modification__c requestEmail = new Demande_de_modification__c(
                Champ_technique__c = 'Email',
                Nouvelle_valeur__c = 'Test@test.com',
                Ancienne_valeur__c = 'Truc@truc.com',
                Salarie__c = c.Id
                );
        insert requestEmail;

        ModificationManager.approve(requestSalutation.Id);
        ModificationManager.revert(requestSalutation.Id);
        ModificationManager.approve(requestFirstName.Id);
        ModificationManager.revert(requestFirstName.Id);
        ModificationManager.approve(requestSexe.Id);
        ModificationManager.revert(requestSexe.Id);
        ModificationManager.approve(requestSituation.Id);
        ModificationManager.revert(requestSituation.Id);
        ModificationManager.approve(requestPhone.Id);
        ModificationManager.revert(requestPhone.Id);
        ModificationManager.approve(requestMobilePhone.Id);
        ModificationManager.revert(requestMobilePhone.Id);
        ModificationManager.approve(requestEmail.Id);
        ModificationManager.revert(requestEmail.Id);
    }

    @IsTest
    private static void modificationRepositoryTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Demande_de_modification__c requestSalutation = new Demande_de_modification__c(
                Champ_technique__c = 'Salutation',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestSalutation;
        Demande_de_modification__c requestFirstName = new Demande_de_modification__c(
                Champ_technique__c = 'FirstName',
                Nouvelle_valeur__c = 'Test',
                Ancienne_valeur__c = 'Truc',
                Salarie__c = c.Id
                );
        insert requestFirstName;

        List<String> fields = new List<String>{'Champ_technique__c', 'Ancienne_valeur__c'};
        List<Demande_de_modification__c> requests = ModificationRepository.getAll();
        requests = ModificationRepository.getAllForFields(fields);
        System.assertEquals(2, requests.size());

        requests = ModificationRepository.getAllByContact(c.Id);
        requests = ModificationRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, requests.size());

        requests = ModificationRepository.getAllWithOffset(0, 1);
        requests = ModificationRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, requests.size());

        requests = ModificationRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        requests = ModificationRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, requests.size());

        Demande_de_modification__c request = ModificationRepository.getById(requestSalutation.Id);
        request = ModificationRepository.getByIdForFields(requestSalutation.Id, fields);
        System.assertEquals('Salutation', request.Champ_technique__c);
    }

}