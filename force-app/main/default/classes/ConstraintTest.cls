@IsTest
private class ConstraintTest {
    
    private static Date today = System.today();

    @IsTest
    static void constraintManager() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        ConstraintManager.createConstraint(today, today.addDays(6), 'Test', c.Id); //Real test
        ConstraintManager.createConstraint(today, today.addDays(6), 'Test', '002'); //Failing test
        List<Astreinte__c> constraints = [SELECT Id, Motif__c FROM Astreinte__c];
        System.assertEquals(1, constraints.size());
        System.assertEquals('Test', constraints[0].Motif__c);

        ConstraintManager.editConstraint(today.addDays(6), today.addDays(12), 'Test edit', constraints[0].Id); //Real test
        ConstraintManager.editConstraint(today.addDays(6), today.addDays(12), 'Test edit', '002'); //Failing test
        constraints = [SELECT Id, Motif__c FROM Astreinte__c];
        System.assertEquals(1, constraints.size());
        System.assertEquals('Test edit', constraints[0].Motif__c);

        ConstraintManager.deleteConstraint(constraints[0].Id); //Real test
        ConstraintManager.deleteConstraint(constraints[0].Id); //Failing test
    }

    @IsTest
    static void constraintRepository() {
        
        Contact c = new Contact(LastName='Collab');
        insert c;
        Astreinte__c a = new Astreinte__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(6),
                Motif__c = 'Astreinte 1',
                Salarie__c = c.Id
                );
        insert a;

        Contact c2 = new Contact(LastName='Manager');
        insert c2;
        Astreinte__c a2 = new Astreinte__c(
                Date_de_debut__c = today.addDays(7),
                Date_de_fin__c = today.addDays(14),
                Motif__c = 'Astreinte 2',
                Salarie__c = c2.Id
                );
        insert a2;

        List<String> fields = new List<String>{'Date_de_debut__c', 'Motif__c'};
        List<Astreinte__c> constraints = ConstraintRepository.getAll();
        constraints = ConstraintRepository.getAllForFields(fields);
        System.assertEquals(2, constraints.size());

        constraints = ConstraintRepository.getAllByContact(c.Id);
        constraints = ConstraintRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(1, constraints.size());

        constraints = ConstraintRepository.getAllBetweenDates(today, today.addDays(6));
        System.assertEquals(1, constraints.size());
        constraints = ConstraintRepository.getAllBetweenDatesForFields(today, today.addDays(7), fields);
        System.assertEquals(2, constraints.size());
        constraints = ConstraintRepository.getAllByContactBetweenDates(c2.Id, today.addDays(14), today.addDays(21));
        System.assertEquals(1, constraints.size());
        constraints = ConstraintRepository.getAllByContactBetweenDatesForFields(c2.Id, today.addDays(-7), today.addDays(21), fields);
        System.assertEquals(1, constraints.size());

        constraints = ConstraintRepository.getAllWithOffset(0, 1);
        constraints = ConstraintRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, constraints.size());

        constraints = ConstraintRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        constraints = ConstraintRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, constraints.size());

        Astreinte__c constraint = ConstraintRepository.getById(a.Id);
        constraint = ConstraintRepository.getByIdForFields(a.Id, fields);
        System.assertEquals(constraint.Motif__c, 'Astreinte 1');
    }
}