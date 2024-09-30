@IsTest
private class InterviewTest {

    @IsTest
    private static void interviewManagerTest() {
        EI_Entretien__c i = [SELECT Id 
                             FROM EI_Entretien__c
							 LIMIT 1][0];
        System.assert(i != null);
        InterviewManager.deleteInterview(i.Id); //Real test
        InterviewManager.deleteInterview(i.Id); //Failing test
    }

    @IsTest
    private static void interviewRepository_Test() {
        Contact c = [SELECT Id FROM Contact WHERE LastName = 'Collab'][0];
        Contact c2 = [SELECT Id FROM Contact WHERE LastName = 'Manager'][0];
        Date today = System.today();
        
        System.assert(c != null);
        System.assert(c2 != null);
        EI_Entretien__c i2 = new EI_Entretien__c(
                EI_Commentaire_du_manager__c = 'Test 2',
                EI_Date_de_l_entretien__c = today.addDays(30),
                EI_Statut__c = '70 Fermé',
                Date_d_ouverture__c = today.addDays(1),
                EI_Salarie_qui_fait_passer_l_entretien__c = c.Id,
                EI_Salarie_qui_passe_l_entretien__c = c2.Id
                );
        insert i2;

        List<String> fields = new List<String>{'Date_d_ouverture__c', 'EI_Commentaire_du_manager__c'};
        List<EI_Entretien__c> interviews = InterviewRepository.getAll();
        interviews = InterviewRepository.getAllForFields(fields);
        System.assertEquals(2, interviews.size());

        interviews = InterviewRepository.getAllByContact(c.Id);
        interviews = InterviewRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, interviews.size());

        interviews = InterviewRepository.getAllByEmployee(c.Id);
        interviews = InterviewRepository.getAllByEmployeeForFields(c.Id, fields);
        System.assertEquals(1, interviews.size());
        System.assertEquals('Test 1', interviews[0].EI_Commentaire_du_manager__c);

        interviews = InterviewRepository.getAllByEmployeeBetweenDate(c.Id, today, today.addDays(6));
        interviews = InterviewRepository.getAllByEmployeeBetweenDateForFields(c.Id, today, today.addDays(6), fields);
        System.assertEquals(1, interviews.size());
        System.assertEquals('Test 1', interviews[0].EI_Commentaire_du_manager__c);

        interviews = InterviewRepository.getAllByManager(c.Id);
        interviews = InterviewRepository.getAllByManagerForFields(c.Id, fields);
        System.assertEquals(1, interviews.size());
        System.assertEquals('Test 2', interviews[0].EI_Commentaire_du_manager__c);

        interviews = InterviewRepository.getAllByManagerBetweenDate(c.Id, today.addDays(30), today.addDays(36));
        interviews = InterviewRepository.getAllByManagerBetweenDateForFields(c.Id, today.addDays(30), 
            today.addDays(36), fields);
        System.assertEquals(1, interviews.size());
        System.assertEquals('Test 2', interviews[0].EI_Commentaire_du_manager__c);

        interviews = InterviewRepository.getAllOpened();
        interviews = InterviewRepository.getAllOpenedForFields(fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedByContact(c.Id);
        interviews = InterviewRepository.getAllOpenedByContactForFields(c.Id, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedByEmployee(c.Id);
        interviews = InterviewRepository.getAllOpenedByEmployeeForFields(c.Id, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedByEmployeeBetweenDate(c.Id, today, today.addDays(6));
        interviews = InterviewRepository.getAllOpenedByEmployeeBetweenDateForFields(c.Id, today, today.addDays(6), 
            fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedByManager(c.Id);
        interviews = InterviewRepository.getAllOpenedByManagerForFields(c.Id, fields);
        System.assertEquals(0, interviews.size());

        interviews = InterviewRepository.getAllOpenedByManagerBetweenDate(c.Id, today.addDays(30), today.addDays(36));
        interviews = InterviewRepository.getAllOpenedByManagerBetweenDateForFields(c.Id, today.addDays(30), 
            today.addDays(36), fields);
        System.assertEquals(0, interviews.size());

        interviews = InterviewRepository.getAllOpenedWithOffset(0, 1);
        interviews = InterviewRepository.getAllOpenedWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedWithOffsetByContact(c.Id, 0, 1);
        interviews = InterviewRepository.getAllOpenedWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedWithOffsetByEmployee(c.Id, 0, 1);
        interviews = InterviewRepository.getAllOpenedWithOffsetByEmployeeForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllOpenedWithOffsetByManager(c.Id, 0, 1);
        interviews = InterviewRepository.getAllOpenedWithOffsetByManagerForFields(c.Id, 0, 1, fields);
        System.assertEquals(0, interviews.size());

        interviews = InterviewRepository.getAllWithOffset(0, 1);
        interviews = InterviewRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        interviews = InterviewRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllWithOffsetByEmployee(c.Id, 0, 1);
        interviews = InterviewRepository.getAllWithOffsetByEmployeeForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, interviews.size());

        interviews = InterviewRepository.getAllWithOffsetByManager(c.Id, 0, 1);
        interviews = InterviewRepository.getAllWithOffsetByManagerForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, interviews.size());

        EI_Entretien__c i = [SELECT Id 
                             FROM EI_Entretien__c
							 LIMIT 1][0];
        EI_Entretien__c interview = InterviewRepository.getById(i.Id);
        interview = InterviewRepository.getByIdForFields(i.Id, fields);
        System.assertEquals('Test 1', interview.EI_Commentaire_du_manager__c);
    }
    
    @TestSetup
    private static void testSetup() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Contact c2 = new Contact(LastName='Manager');
        insert c2;

        Date today = System.today();

        EI_Entretien__c i = new EI_Entretien__c(
                EI_Commentaire_du_manager__c = 'Test 1',
                EI_Date_de_l_entretien__c = today,
                EI_Statut__c = '10 Ouvert',
                Date_d_ouverture__c = today,
                EI_Salarie_qui_fait_passer_l_entretien__c = c2.Id,
                EI_Salarie_qui_passe_l_entretien__c = c.Id
                );
        insert i;
    }
}