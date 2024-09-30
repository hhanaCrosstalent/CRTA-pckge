//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the printing of the history page
 */
public with sharing class bdu_print_historiqueController {
    public String user {get; set; }
    public List<BDU_Valeur__c> valeurs {get; set; } //List of BDU_Valeur__c

    /**
      * We retrieve the wanted indicateur__c based on the given slug
      * of the parent chapitre__c
      */
    public bdu_print_historiqueController() {
        String indicateur_id = ApexPages.currentPage().getParameters().get('id');
        String bu1 = ApexPages.currentPage().getParameters().get('bu1');
        String bu2 = ApexPages.currentPage().getParameters().get('bu2');
        String bu3 = ApexPages.currentPage().getParameters().get('bu3');
        String bu4 = ApexPages.currentPage().getParameters().get('bu4');
        String bu5 = ApexPages.currentPage().getParameters().get('bu5');
      
        user = Userinfo.getName();
        valeurs = [SELECT Name, CT_Annee__c, CT_A_publier__c, CT_confidentialityDate__c, CT_isConfidential__c, 
                        CT_Entite__c, CT_BDU_Indicateur__c, CT_Commentaire__c, CT_Date_de_publication__c, 
                        CT_Date_de_fin_de_publication__c, CT_Valeur__c, CT_Val__c, CT_Liaison_Contenu__r.Id, 
                        CT_BU__c, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c
            FROM BDU_Valeur__c 
            WHERE CT_BDU_Indicateur__r.Id =: indicateur_id 
            AND CT_A_publier__c = true 
            AND CT_Date_de_publication__c  <= TODAY
            AND CT_BU1__c =: bu1 
            AND CT_BU2__c =: bu2 
            AND CT_BU3__c =: bu3 
            AND CT_BU4__c =: bu4 
            AND CT_BU5__c =: bu5 
            ORDER BY CreatedDate DESC];
    }
}