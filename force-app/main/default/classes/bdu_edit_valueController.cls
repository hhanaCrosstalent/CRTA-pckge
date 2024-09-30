//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the page editing BDU_Valeur__c
 */
public with sharing class bdu_edit_valueController {

    private final BDU_Valeur__c mysObject;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public bdu_edit_valueController(ApexPages.StandardController stdController) {
        this.mysObject = (BDU_Valeur__c) stdController.getRecord();
        String parent_id = ApexPages.CurrentPage().getParameters().get('parent_id');
        if(parent_id != null && parent_id !=  '') {
                BDU_Indicateur__c indic = [SELECT Id FROM BDU_Indicateur__c WHERE Id = :parent_id];
                this.mysObject.CT_BDU_Indicateur__c = indic.id;
        }
    }

}