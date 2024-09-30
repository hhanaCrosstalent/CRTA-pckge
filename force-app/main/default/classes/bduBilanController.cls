//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller to select the legal documents to print
 */
public with sharing class bduBilanController {
    public String selectedDocument {get; set;} //The wanted document
    public String selectedYear {get; set;} //The wanted year for the BDU_Valeur__c
    public String selectedFormat {get; set;} //The wanted year for the BDU_Valeur__c
    public BDU_Indicateur__c indic {get; set;}
    
    public String selectedBU1 {get; set;}
    public String selectedBU2 {get; set;}
    public String selectedBU3 {get; set;}
    public String selectedBU4 {get; set;}
    public String selectedBU5 {get; set;}

    public bduBilanController() {
        indic = new BDU_Indicateur__c();
    }

    /**
     * Populates a select list with the documents to be printed.
     * @return The Documents
     */
    public List<SelectOption> getAvailableDocuments() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult aField 
            = Schema.SObjectType.BDU_Indicateur__c.fields.CT_Origine__c;
        List<Schema.PicklistEntry> values = aField.getPicklistValues();
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }

        return options;
    }

     /**
     * Populates a select list with available years.
     * @return years that are referred to by Valeur
     */
    public List<SelectOption> getAvailableYears() {
        List<AggregateResult> values = [SELECT CT_Annee__c a 
                                        FROM BDU_Valeur__c 
                                        GROUP BY CT_Annee__c 
                                        ORDER BY CT_Annee__c DESC];
        List<SelectOption> options = new List<SelectOption>();
        for(AggregateResult v:values) {
            options.add(new SelectOption(String.valueOf(v.get('a')), String.valueOf(v.get('a'))));
        }
        return options;
    }

    public List<SelectOption> getFormats(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('word', 'Word'));
        options.add(new SelectOption('html', 'HTML+PDF'));
        return options;
    } 

    /**
     * Retrieves the list of BU1
     * Necessary to circumvent the record types limitation
     * We lose the dependance between picklist
     * @return List<SelectOption>
     */
    public List<SelectOption> getListBU1() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult champ = BDU_valeur__c.CT_BU1__c.getDescribe();
        List<Schema.PicklistEntry> values =  champ.getPickListValues();
        options.add(new SelectOption('','-- Aucun --')); 
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }

    /**
     * Retrieves the list of BU2
     * Necessary to circumvent the record types limitation
     * We lose the dependance between picklist
     * @return List<SelectOption>
     */
    public List<SelectOption> getListBU2() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult champ = BDU_valeur__c.CT_BU2__c.getDescribe();
        List<Schema.PicklistEntry> values =  champ.getPickListValues();
        options.add(new SelectOption('','-- Aucun --')); 
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }

    /**
     * Retrieves the list of BU3
     * Necessary to circumvent the record types limitation
     * We lose the dependance between picklist
     * @return List<SelectOption>
     */
    public List<SelectOption> getListBU3()  {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult champ = BDU_valeur__c.CT_BU3__c.getDescribe();
        List<Schema.PicklistEntry> values =  champ.getPickListValues();
        options.add(new SelectOption('','-- Aucun --')); 
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }

    /**
     * Retrieves the list of BU4
     * Necessary to circumvent the record types limitation
     * We lose the dependance between picklist
     * @return List<SelectOption>
     */
    public List<SelectOption> getListBU4() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult champ = BDU_valeur__c.CT_BU4__c.getDescribe();
        List<Schema.PicklistEntry> values =  champ.getPickListValues();
        options.add(new SelectOption('','-- Aucun --')); 
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }

    /**
     * Retrieves the list of BU5
     * Necessary to circumvent the record types limitation
     * We lose the dependance between picklist
     * @return List<SelectOption>
     */
    public List<SelectOption> getListBU5() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult champ = BDU_valeur__c.CT_BU5__c.getDescribe();
        List<Schema.PicklistEntry> values =  champ.getPickListValues();
        options.add(new SelectOption('','-- Aucun --')); 
        for (Schema.PicklistEntry a : values) {
           options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }

    /**
     * Redirects to the print page
     * @return PageReference The print page with the selected parameters
     */
    public PageReference generate() {
        PageReference print = Page.bdu_printBilan;

        print.setRedirect(true);
        print.getParameters().put('document', selectedDocument); 
        print.getParameters().put('year', selectedYear); 
        print.getParameters().put('format', selectedFormat); 
        print.getParameters().put('bu1', selectedBU1 ); 
        print.getParameters().put('bu2', selectedBU2 ); 
        print.getParameters().put('bu3', selectedBU3 ); 
        print.getParameters().put('bu4', selectedBU4 ); 
        print.getParameters().put('bu5', selectedBU5 ); 

        return print;
    }
}