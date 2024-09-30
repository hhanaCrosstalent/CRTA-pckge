@IsTest
private class TimeTest {

    @IsTest
    private static void timeManager() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Timesheet__c options = new Timesheet__c(
                StartHour__c = '08:00',
                EndHourMorning__c = '12:00',
                StartHourAfternoon__c = '13:00',
                EndHour__c = '18:00'
                );
        insert options;

        Date today = System.today();

        TimeManager.createWithTime(today, '08:00', '17:00', '10 Présence', c.Id); //Real test
        TimeManager.createWithTime(today, '08:00', '17:00', '10 Présence', '003'); //Failing test
        List<Temps__c> times = [SELECT Id FROM Temps__c];
        System.assertEquals(1, times.size());

        TimeManager.editWithTime(today, '09:00', '18:00', '70 Astreinte', times[0].Id); //Real test
        TimeManager.editWithTime(today, '09:00', '18:00', '70 Astreinte', '003'); //Failing test
        times = [SELECT Id, Type__c FROM Temps__c];
        System.assertEquals(1, times.size());
        System.assertEquals('70 Astreinte', times[0].Type__c);

        TimeManager.deleteTime(times[0].Id); //Real test
        TimeManager.deleteTime(times[0].Id); //Failing test
        times = [SELECT Id, Type__c FROM Temps__c];
        System.assertEquals(0, times.size());

        TimeManager.createWithoutTime(today, 'Journée complète', '10 Présence', c.Id); //Real test
        TimeManager.createWithoutTime(today, 'Matin', '10 Présence', c.Id); //Real test
        TimeManager.createWithoutTime(today, 'Après-midi', '10 Présence', c.Id); //Real test
        TimeManager.createWithoutTime(today, 'Après-midi', '10 Présence', '003'); //Failing test
        times = [SELECT Id, Type__c FROM Temps__c];
        System.assertEquals(3, times.size());

        //Real test
        TimeManager.editWithoutTime(today.addDays(1), 'Journée complète', '70 Astreinte', times[0].Id);
        //Failing test
        TimeManager.editWithoutTime(today.addDays(1), 'Journée complète', '70 Astreinte', '003');
        Temps__c temps = [SELECT Id, Date__c, Heure_de_debut__c, Heure_de_fin__c 
                        FROM Temps__c 
                        WHERE Id = :times[0].Id];
        System.assertEquals(today.addDays(1), temps.Date__c);
        System.assertEquals('08:00', temps.Heure_de_debut__c);
        System.assertEquals('18:00', temps.Heure_de_fin__c);

        List<SelectOption> types = TimeManager.getTimeTypes();
    }

    @IsTest
    private static void timeRepository() {
        
        Date today = System.today();
        Contact c = new Contact(LastName = 'Collab');
        insert c;

        Feuille_Temps_Hebdo__c f = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today,
                Date_de_fin__c = today.addDays(6),
                Salarie__c = c.Id
                );
        insert f;

        Temps__c t = new Temps__c(
                Date__c = today,
                Heure_de_debut__c = '08:00',
                Heure_de_fin__c = '17:00',
                Type__c = '10 Présence',
                Feuille_hebdo__c = f.Id
                );
        insert t;
        Temps__c t2 = new Temps__c(
                Date__c = today.addDays(1),
                Heure_de_debut__c = '08:00',
                Heure_de_fin__c = '17:00',
                Type__c = '70 Astreinte',
                Feuille_hebdo__c = f.Id
                );
        insert t2;

        List<AggregateResult> counts = TimeRepository.countAllByContactBetweenDate(c.Id, today, today.addDays(1));
        System.assertEquals(2, counts.size());
        System.assertEquals(1, counts[0].get('expr0'));

        counts = TimeRepository.countByContactAndWeekOrDate(c.Id, f.Id, today, today.addDays(6));
        System.assertEquals(2, counts.size());
        System.assertEquals(1, counts[0].get('expr0'));

        List<String> fields = new List<String>{'Date__c', 'Type__c'};
        List<Temps__c> times = TimeRepository.getAll();
        times = TimeRepository.getAllForFields(fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllAfterDate(today);
        times = TimeRepository.getAllAfterDateForFields(today, fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllAfterDateStrict(today);
        times = TimeRepository.getAllAfterDateStrictForFields(today, fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllBeforeDate(today.addDays(1));
        times = TimeRepository.getAllBeforeDateForFields(today.addDays(1), fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllBeforeDateStrict(today.addDays(1));
        times = TimeRepository.getAllBeforeDateStrictForFields(today.addDays(1), fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllBetweenDate(today, today.addDays(1));
        times = TimeRepository.getAllBetweenDateForFields(today, today.addDays(1), fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllBetweenDateStrict(today, today.addDays(1));
        times = TimeRepository.getAllBetweenDateStrictForFields(today, today.addDays(1), fields);
        System.assertEquals(0, times.size());

        times = TimeRepository.getAllByContact(c.Id);
        times = TimeRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllByContactAndWeekOrDate(c.Id, f.Id, today, today.addDays(1));
        times = TimeRepository.getAllByContactAndWeekOrDateForFields(c.Id, f.Id, today, today.addDays(1), fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllByContactAfterDate(c.Id, today);
        times = TimeRepository.getAllByContactAfterDateForFields(c.Id, today, fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllByContactAfterDateStrict(c.Id, today);
        times = TimeRepository.getAllByContactAfterDateStrictForFields(c.Id, today, fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllByContactBeforeDate(c.Id, today.addDays(1));
        times = TimeRepository.getAllByContactBeforeDateForFields(c.Id, today.addDays(1), fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllByContactBeforeDateStrict(c.Id, today.addDays(1));
        times = TimeRepository.getAllByContactBeforeDateStrictForFields(c.Id, today.addDays(1), fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllByContactBetweenDate(c.Id, today, today.addDays(1));
        times = TimeRepository.getAllByContactBetweenDateForFields(c.Id, today, today.addDays(1), fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllByContactBetweenDateStrict(c.Id, today, today.addDays(1));
        times = TimeRepository.getAllByContactBetweenDateStrictForFields(c.Id, today, today.addDays(1), fields);
        System.assertEquals(0, times.size());

        times = TimeRepository.getAllByWeek(f.Id);
        times = TimeRepository.getAllByWeekForFields(f.Id, fields);
        System.assertEquals(2, times.size());

        times = TimeRepository.getAllWithOffset(0, 1);
        times = TimeRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        times = TimeRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, times.size());

        times = TimeRepository.getAllWithOffsetByWeek(f.Id, 0, 1);
        times = TimeRepository.getAllWithOffsetByWeekForFields(f.Id, 0, 1, fields);
        System.assertEquals(1, times.size());

        Temps__c temps = TimeRepository.getById(t.Id);
        temps = TimeRepository.getByIdForFields(t.Id, fields);
        System.assertEquals(today, temps.Date__c);
    }
}