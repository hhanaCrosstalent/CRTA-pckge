@IsTest
private class PauseTest {

    @IsTest
    private static void PauseManager_Test() {
        Contact c = new Contact(LastName='Collab');
        insert c;
        Date today = System.today();
        PauseManager.createPause(today, 10, c.Id); //Real test
        PauseManager.createPause(today, 10, '003'); //Failing test
        List<Pause__c> pauses = [SELECT Id, Duree__c FROM Pause__c];
        System.assertEquals(1, pauses.size());
        System.assertEquals(10, pauses[0].Duree__c);

        PauseManager.editPause(today.addDays(1), 15, pauses[0].Id); //Real test
        PauseManager.editPause(today.addDays(1), 15, '003'); //Failing test
        pauses = [SELECT Id, Duree__c FROM Pause__c];
        System.assertEquals(1, pauses.size());
        System.assertEquals(15, pauses[0].Duree__c);

        PauseManager.deletePause(pauses[0].Id); //Real test
        PauseManager.deletePause(pauses[0].Id); //Failing test
        pauses = [SELECT Id, Duree__c FROM Pause__c];
        System.assertEquals(0, pauses.size());
    }

    @IsTest 
    private static void PauseRepository_Test() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Date today = System.today();

        Feuille_Temps_Hebdo__c f = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today,
                Date_de_fin__c = today.addDays(6),
                Salarie__c = c.Id
                );
        insert f;

        Pause__c p = new Pause__c(
                Date__c = today,
                Duree__c = 10,
                Feuille_hebdo__c = f.Id
                );
        insert p;
        Pause__c p2 = new Pause__c(
                Date__c = today.addDays(1),
                Duree__c = 15,
                Feuille_hebdo__c = f.Id
                );
        insert p2;

        List<AggregateResult> counts = PauseRepository.countAllByContactBetweenDate(c.Id, today, 
                today.addDays(1));
        System.assertEquals(2, counts.size());
        System.assertEquals(1, counts[0].get('expr0'));

        counts = PauseRepository.countByContactAndWeekOrDate(c.Id, f.Id, today, today.addDays(6));
        System.assertEquals(2, counts.size());
        System.assertEquals(1, counts[0].get('expr0'));

        List<String> fields = new List<String>{'Duree__c', 'Date__c'};
        List<Pause__c> pauses = PauseRepository.getAll();
        pauses = PauseRepository.getAllForFields(fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllAfterDate(today);
        pauses = PauseRepository.getAllAfterDateForFields(today, fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllAfterDateStrict(today);
        pauses = PauseRepository.getAllAfterDateStrictForFields(today, fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllBeforeDate(today.addDays(1));
        pauses = PauseRepository.getAllBeforeDateForFields(today.addDays(1), fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllBeforeDateStrict(today.addDays(1));
        pauses = PauseRepository.getAllBeforeDateStrictForFields(today.addDays(1), fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllBetweenDate(today, today.addDays(1));
        pauses = PauseRepository.getAllBetweenDateForFields(today, today.addDays(1), fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllBetweenDateStrict(today, today.addDays(1));
        pauses = PauseRepository.getAllBetweenDateStrictForFields(today, today.addDays(1), fields);
        System.assertEquals(0, pauses.size());

        pauses = PauseRepository.getAllByContact(c.Id);
        pauses = PauseRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllByContactAndWeekOrDate(c.Id, f.Id, today, today.addDays(1));
        pauses = PauseRepository.getAllByContactAndWeekOrDateForFields(c.Id, f.Id, today, 
                today.addDays(1), fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllByContactAfterDate(c.Id, today);
        pauses = PauseRepository.getAllByContactAfterDateForFields(c.Id, today, fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllByContactAfterDateStrict(c.Id, today);
        pauses = PauseRepository.getAllByContactAfterDateStrictForFields(c.Id, today, fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllByContactBeforeDate(c.Id, today.addDays(1));
        pauses = PauseRepository.getAllByContactBeforeDateForFields(c.Id, today.addDays(1), fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllByContactBeforeDateStrict(c.Id, today.addDays(1));
        pauses = PauseRepository.getAllByContactBeforeDateStrictForFields(c.Id, today.addDays(1), fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllByContactBetweenDate(c.Id, today, today.addDays(1));
        pauses = PauseRepository.getAllByContactBetweenDateForFields(c.Id, today, today.addDays(1), 
                fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllByContactBetweenDateStrict(c.Id, today, today.addDays(1));
        pauses = PauseRepository.getAllByContactBetweenDateStrictForFields(c.Id, today, 
                today.addDays(1), fields);
        System.assertEquals(0, pauses.size());

        pauses = PauseRepository.getAllByWeek(f.Id);
        pauses = PauseRepository.getAllByWeekForFields(f.Id, fields);
        System.assertEquals(2, pauses.size());

        pauses = PauseRepository.getAllWithOffset(0, 1);
        pauses = PauseRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        pauses = PauseRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, pauses.size());

        pauses = PauseRepository.getAllWithOffsetByWeek(f.Id, 0, 1);
        pauses = PauseRepository.getAllWithOffsetByWeekForFields(f.Id, 0, 1, fields);
        System.assertEquals(1, pauses.size());

        Pause__c pause = PauseRepository.getById(p.Id);
        pause = PauseRepository.getByIdForFields(p.Id, fields);
        System.assertEquals(10, pause.Duree__c);
    }
}