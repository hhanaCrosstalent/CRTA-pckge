//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the expenses page
 */
public with sharing class VisualisationFraisController {
    public Note_de_frais__c expense { get; set; }
    public List<Frais__c> expenseLines { get; set; }
    public String selectedExpenseType { get; set; }
    public Boolean isManager { get; set; }
    public Double total { get; set; }

    public VisualisationFraisController() {
        String expenseId = ApexPages.CurrentPage().getParameters().get('id');
        expenseLines = new List<Frais__c>();
        isManager = false;
        try {
            expense = ExpensesRepository.getById(expenseId);
            expenseLines = ExpenseLineRepository.getAllAndAttachmentByExpenses(expenseId);
            total = ExpenseLineRepository.countTotalByExpenses(expenseId);
            User current = [SELECT Contact__c FROM User WHERE Id = :UserInfo.getUserId()];
            if(current.Contact__c == expense.Salarie__r.ReportsToId) isManager = true;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

    /**
     * Validates an expense
     * @return PageReference Current page
     */
    public PageReference validateExpense() {
        ExpensesManager.validateExpenses(expense.Id, String.valueOf(total)+System.Label.Expenses_currency);

        PageReference redirect = ApexPages.currentPage();
        redirect.getParameters().putAll(ApexPages.currentPage().getParameters());
        redirect.setRedirect(true);
        return redirect;
    }

    /**
     * Validates an expense
     * @return PageReference Current page
     */
    public PageReference acceptExpense() {
        ExpensesManager.acceptExpensesWithComment(expense.Id, expense.Commentaire__c, 
                    String.valueOf(total) + System.Label.Expenses_currency);

        PageReference redirect = ApexPages.currentPage();
        redirect.getParameters().putAll(ApexPages.currentPage().getParameters());
        redirect.setRedirect(true);
        return redirect;
    }

    /**
     * Returns an expense to the employee
     * @return PageReference Current page
     */
    public PageReference returnExpense() {
        ExpensesManager.returnExpensesWithComment(expense.Id, expense.Commentaire__c, 
                    String.valueOf(total) + System.Label.Expenses_currency);

        PageReference redirect = ApexPages.currentPage();
        redirect.getParameters().putAll(ApexPages.currentPage().getParameters());
        redirect.setRedirect(true);
        return redirect;
    }

    /**
     * Rejects an expense
     * @return PageReference Current page
     */
    public PageReference rejectExpense() {
        ExpensesManager.rejectExpensesWithComment(expense.Id, expense.Commentaire__c, 
            String.valueOf(total) + System.Label.Expenses_currency);

        PageReference redirect = ApexPages.currentPage();
        redirect.getParameters().putAll(ApexPages.currentPage().getParameters());
        redirect.setRedirect(true);
        return redirect;
    }

    /**
     * Populates a select list with the types of expense.
     * @return The types
     */
    public List<SelectOption> getExpenseTypes() {
        Frais__c request = new Frais__c();
        List<SelectOption> options = new List<SelectOption>();
        Schema.sObjectType objType = request.getSObjectType();

        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> values = Schema.sObjectType.crta__Frais__c.fields.crta__Type__c.getPickListValues();
        for(Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel())); 
        }

        return options;
    }

    /**
     * Populates a select list with the types of expense for food.
     * @return The types
     */
    public List<SelectOption> getFoodExpenseTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Restaurant - Clients', System.Label.Expense_list_restaurant_client));
        options.add(new SelectOption('Restaurant - Interne', System.Label.Expense_list_restaurant_entreprise));
        return options;
    }

    /**
     * Populates a select list with the types of expense for food.
     * @return The types
     */
    public List<SelectOption> getHotelExpenseTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Hotel', System.Label.Expense_list_hotel));
        options.add(new SelectOption('Caution', System.Label.Expense_list_deposit));
        options.add(new SelectOption('Pressing', System.Label.Expense_list_dry_cleaning));
        return options;
    }

    /**
     * Populates a select list with the types of expense for food.
     * @return The types
     */
    public List<SelectOption> getTransportExpenseTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Avion', System.Label.Expense_list_plane));
        options.add(new SelectOption('Train', System.Label.Expense_list_train));
        options.add(new SelectOption('Métro', System.Label.Expense_list_subway));
        options.add(new SelectOption('Location de voiture', System.Label.Expense_list_rental));
        options.add(new SelectOption('Parking', System.Label.Expense_list_parking));
        options.add(new SelectOption('Taxi', System.Label.Expense_list_taxi));
        options.add(new SelectOption('Autre transport', System.Label.Expense_list_other_transport));
        return options;
    }
}