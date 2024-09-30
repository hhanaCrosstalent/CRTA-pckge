@IsTest
private class ExpenseLineTest {

    @IsTest 
    private static void expenseLineManagerTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;

        Date today = System.today();

        Note_de_frais__c e = new Note_de_frais__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(30),
                Salarie__c = c.Id
                );
        insert e;

        String image = 'data:image/gif;base64,R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxs'
            + 'bP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0Cc'
            + 'guWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7';

        // Real test
        ExpenseLineManager.createExpenseLine('other', 'test', today, 'centre de test', 'Restaurant', 30, 
            true, c.Id, e.Id, image, 'image.gif');
        // Failing test
        ExpenseLineManager.createExpenseLine('other', 'test', today, 'centre de test', 'Restaurant', 30, 
            true, '003', e.Id, '', '');
        List<Frais__c> lines = [SELECT Id, Centre_de_frais__c FROM Frais__c];
        System.assertEquals(1, lines.size());
        System.assertEquals(lines[0].Centre_de_frais__c, 'centre de test');

        // Real test
        ExpenseLineManager.editExpenseLine('other', 'test edit', today, 'centre de test edit', 'Restaurant', 
            35, true, lines[0].Id, image, 'image.gif');
        // Failing test
        ExpenseLineManager.editExpenseLine('other', 'test edit', today, 'centre de test edit', 'Restaurant', 
            35, true, '003', '', '');
        lines = [SELECT Id, Centre_de_frais__c FROM Frais__c];
        System.assertEquals(1, lines.size());
        System.assertEquals('centre de test edit', lines[0].Centre_de_frais__c);

        ExpenseLineManager.cloneExpenseLine(lines[0].Id); //Real test
        ExpenseLineManager.cloneExpenseLine('003'); //Failing test
        lines = [SELECT Id, Centre_de_frais__c FROM Frais__c];
        System.assertEquals(2, lines.size());

        ExpenseLineManager.deleteExpenseLine(lines[0].Id); //Real test
        ExpenseLineManager.deleteExpenseLine('003'); //Failing test
        lines = [SELECT Id, Centre_de_frais__c FROM Frais__c];
        System.assertEquals(1, lines.size());
        System.assertEquals('centre de test edit', lines[0].Centre_de_frais__c);
    }

    @IsTest
    private static void expenseLineRepositoryTest() {
        Contact c = new Contact(LastName='Collab');
        insert c;
        
        Date today = System.today();

        Contact c2 = new Contact(LastName='Manager');
        insert c2;

        Note_de_frais__c e = new Note_de_frais__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(30),
                Salarie__c = c.Id
                );
        insert e;

        Note_de_frais__c e2 = new Note_de_frais__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(30),
                Salarie__c = c2.Id
                );
        insert e2;

        Frais__c f = new Frais__c(
                Date__c = today,
                Montant__c = 30,
                TVA_1__c = 4.65,
                Note_de_frais__c = e.Id,
                Salarie__c = c.Id
                );
        insert f;
        Attachment a = new Attachment(
                parentId = f.Id,
                body = Blob.valueOf('test'),
                Name = 'test'
                );
        insert a;

        Frais__c f2 = new Frais__c(
                Date__c = today.addDays(6),
                Montant__c = 10,
                TVA_1__c = 3.2,
                Note_de_frais__c = e2.Id,
                Salarie__c = c2.Id
                );
        insert f2;

        Double amount = ExpenseLineRepository.countAmountByContact(c.Id);
        System.assertEquals(30, amount);

        List<AggregateResult> amounts = ExpenseLineRepository.countAmountByContactGroupByExpenses(c.Id);
        System.assertEquals(1, amounts.size());

        amount = ExpenseLineRepository.countAmountByExpenses(e2.Id);
        System.assertEquals(10, amount);

        Double total = ExpenseLineRepository.countTotalByContact(c.Id);
        System.assertEquals(34.65, total);

        List<AggregateResult> totals = ExpenseLineRepository.countTotalByContactGroupByExpenses(c.Id);
        System.assertEquals(1, totals.size());

        total = ExpenseLineRepository.countTotalByExpenses(e2.Id);
        System.assertEquals(13.2, total);

        List<String> fields = new List<String>{'Date__c', 'Montant__c'};
        List<Frais__c> lines = ExpenseLineRepository.getAll();
        lines = ExpenseLineRepository.getAllForFields(fields);
        System.assertEquals(2, lines.size());

        lines = ExpenseLineRepository.getAllAndAttachment();
        lines = ExpenseLineRepository.getAllAndAttachmentForFields(fields);
        System.assertEquals(2, lines.size());

        lines = ExpenseLineRepository.getAllAndAttachmentByContact(c.Id);
        lines = ExpenseLineRepository.getAllAndAttachmentByContactForFields(c.Id, fields);
        System.assertEquals(1, lines.size());
        System.assertEquals(1, lines[0].Attachments.size());

        lines = ExpenseLineRepository.getAllAndAttachmentByExpenses(e.Id);
        lines = ExpenseLineRepository.getAllAndAttachmentByExpensesForFields(e.Id, fields);
        System.assertEquals(1, lines.size());
        System.assertEquals(1, lines[0].Attachments.size());

        lines = ExpenseLineRepository.getAllAndAttachmentWithOffset(1, 1);
        lines = ExpenseLineRepository.getAllAndAttachmentWithOffsetForFields(1, 1, fields);
        System.assertEquals(1, lines.size());
        System.assertEquals(1, lines[0].Attachments.size());

        lines = ExpenseLineRepository.getAllAndAttachmentWithOffsetByContact(c.Id, 0, 1);
        lines = ExpenseLineRepository.getAllAndAttachmentWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, lines.size());
        System.assertEquals(1, lines[0].Attachments.size());

        lines = ExpenseLineRepository.getAllAndAttachmentWithOffsetByExpenses(e.Id, 0, 1);
        lines = ExpenseLineRepository.getAllAndAttachmentWithOffsetByExpensesForFields(e.Id, 0, 1, fields);
        System.assertEquals(1, lines.size());
        System.assertEquals(1, lines[0].Attachments.size());

        lines = ExpenseLineRepository.getAllByContact(c2.Id);
        lines = ExpenseLineRepository.getAllByContactForFields(c2.Id, fields);
        System.assertEquals(1, lines.size());

        lines = ExpenseLineRepository.getAllByExpenses(e2.Id);
        lines = ExpenseLineRepository.getAllByExpensesForFields(e2.Id, fields);
        System.assertEquals(1, lines.size());

        lines = ExpenseLineRepository.getAllWithOffset(0, 1);
        lines = ExpenseLineRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, lines.size());

        lines = ExpenseLineRepository.getAllWithOffsetByContact(c2.Id, 0, 1);
        lines = ExpenseLineRepository.getAllWithOffsetByContactForFields(c2.Id, 0, 1, fields);
        System.assertEquals(1, lines.size());

        lines = ExpenseLineRepository.getAllWithOffsetByExpenses(e2.Id, 0, 1);
        lines = ExpenseLineRepository.getAllWithOffsetByExpensesForFields(e2.Id, 0, 1, fields);
        System.assertEquals(1, lines.size());

        Frais__c line = ExpenseLineRepository.getById(f2.Id);
        line = ExpenseLineRepository.getByIdForFields(f2.Id, fields);
        System.assertEquals(10, line.Montant__c);

        line = ExpenseLineRepository.getByIdAndAttachment(f.Id);
        line = ExpenseLineRepository.getByIdAndAttachmentForFields(f.Id, fields);
        System.assertEquals(30, line.Montant__c);
        System.assertEquals(1, line.Attachments.size());
    }
}