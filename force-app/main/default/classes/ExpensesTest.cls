@IsTest
private class ExpensesTest {

    @IsTest
    private static void expensesManagerTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        ExpensesManager.createExpenses(System.today(), System.today().addDays(6), 'Test', c.Id); //Real test
        ExpensesManager.createExpenses(System.today(), System.today().addDays(6), 'Test', '003'); //Failing test
        List<Note_de_frais__c> expenses = [SELECT Id, Nom__c FROM Note_de_frais__c];
        System.assertEquals(1, expenses.size());

        ExpensesManager.editExpenses(System.today().addDays(6), System.today().addDays(12), 'Test edit', expenses[0].Id); //Real test
        ExpensesManager.editExpenses(System.today().addDays(6), System.today().addDays(12), 'Test edit', '003'); //Failing test
        expenses = [SELECT Id, Nom__c FROM Note_de_frais__c];
        System.assertEquals(1, expenses.size());
        System.assertEquals('Test edit', expenses[0].Nom__c);

        ExpensesManager.validateExpenses(expenses[0].Id, '10€'); //Real test
        ExpensesManager.validateExpenses('003', '10€'); //Failing test
        expenses = [SELECT Id, Statut__c FROM Note_de_frais__c];
        System.assertEquals('20 À valider', expenses[0].Statut__c);

        ExpensesManager.acceptExpenses(expenses[0].Id, '10€'); //Real test
        ExpensesManager.acceptExpenses('003', '10€'); //Failing test
        expenses = [SELECT Id, Statut__c FROM Note_de_frais__c];
        System.assertEquals('30 Validée', expenses[0].Statut__c);

        expenses[0].Statut__c = '10 Enregistrée';
        update expenses;

        ExpensesManager.returnExpenses(expenses[0].Id, '10€'); //Real test
        ExpensesManager.returnExpenses('003', '10€'); //Failing test
        expenses = [SELECT Id, Statut__c FROM Note_de_frais__c];
        System.assertEquals('15 Retournée', expenses[0].Statut__c);

        expenses[0].Statut__c = '10 Enregistrée';
        update expenses;

        ExpensesManager.rejectExpenses(expenses[0].Id, '10€'); //Real test
        ExpensesManager.rejectExpenses('003', '10€'); //Failing test
        expenses = [SELECT Id, Statut__c FROM Note_de_frais__c];
        System.assertEquals('55 Annulée', expenses[0].Statut__c);

        ExpensesManager.deleteExpenses(expenses[0].Id); //Real test
        ExpensesManager.deleteExpenses(expenses[0].Id); //Failing test
        expenses = [SELECT Id, Statut__c FROM Note_de_frais__c];
        System.assertEquals(0, expenses.size());

    }

    @IsTest
    private static void testMethodTwo() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Contact c2 = new Contact(LastName='Manager');
        insert c2;

        Note_de_frais__c e = new Note_de_frais__c(
                Date_de_debut__c = System.today(),
                Date_de_fin__c = System.today().addDays(30),
                Nom__c = 'Test 1',
                Salarie__c = c.Id
                );
        insert e;

        Note_de_frais__c e2 = new Note_de_frais__c(
                Date_de_debut__c = System.today(),
                Date_de_fin__c = System.today().addDays(30),
                Nom__c = 'Test 2',
                Salarie__c = c2.Id
                );
        insert e2;

        List<String> fields = new List<String>{'Nom__c', 'Date_de_debut__c'};
        List<Note_de_frais__c> expenses = ExpensesRepository.getAll();
        expenses = ExpensesRepository.getAllForFields(fields);
        System.assertEquals(2, expenses.size());

        expenses = ExpensesRepository.getAllByContact(c.Id);
        expenses = ExpensesRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(1, expenses.size());

        expenses = ExpensesRepository.getAllWithOffset(0, 1);
        expenses = ExpensesRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, expenses.size());

        expenses = ExpensesRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        expenses = ExpensesRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, expenses.size());

        Note_de_frais__c expense = ExpensesRepository.getById(e.Id);
        expense = ExpensesRepository.getByIdForFields(e.Id, fields);
        System.assertEquals('Test 1', expense.Nom__c);
    }
}