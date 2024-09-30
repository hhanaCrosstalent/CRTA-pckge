@IsTest
private class VisualisationFraisController_test {

    @IsTest 
    private static void testAll() {
        Note_de_frais__c expense = [SELECT Id FROM Note_de_frais__c][0];
        PageReference pg = Page.VisualisationFrais;
        pg.getParameters().put('id', expense.Id);
        Test.setCurrentPage(pg);

        VisualisationFraisController con = new VisualisationFraisController();
        List<SelectOption> options = con.getExpenseTypes();
        System.assert(options.size()>0);
        con.getFoodExpenseTypes();
        con.getHotelExpenseTypes();
        con.getTransportExpenseTypes();
        con.selectedExpenseType = 'Transport';
        con.validateExpense();
        con.acceptExpense();
        con.returnExpense();
        con.rejectExpense();
    }

    @TestSetup
    private static void testSetup() {
        Contact c = new Contact(Lastname = 'test');
        insert c; 

        Note_de_frais__c expense = new Note_de_frais__c(
                Date_de_debut__c = Date.today(),
                Date_de_fin__c = Date.today().addDays(1),
                Salarie__c = c.id
                );
        insert expense;

        Frais__c expenseLine = new Frais__c(
                Note_de_frais__c = expense.Id,
                Salarie__c = c.id,
                Date__c = Date.today(),
                Montant__c = 25.02,
                Type__c = 'Transport'
                );
        insert expenseLine;
    }
}