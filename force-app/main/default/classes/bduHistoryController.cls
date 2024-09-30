//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the 'history' of an 'indicateur' popup
 * @deprecated
 */
public with sharing class bduHistoryController {
    public String indicateurId {set; get;}
    public String indicateurName {set; get;}
    public Boolean displayTable {set; get; }
    public Boolean displayChart {set; get; }
    public String chartType {get; set;}
    public boolean displayPopup {get; set;}    //Whether we display the history pop-up or not
    public List<BDU_Valeur__c> valeurs {get; set; } //List of BDU_Valeur__c
    public String bu1 { get; set; }
    public String bu2 { get; set; }
    public String bu3 { get; set; }
    public String bu4 { get; set; }
    public String bu5 { get; set; }

    /**
     * Popup is closed by default
     */
    public bduHistoryController() {
        displayPopup = false;
    }

    /**
     * Closes the history pop-up
     */
    public void closePopup() {
        displayPopup = false;
    }

    /**
     * Displays the history pop-up
     * We retrieve the given BDU_Indicateur__c id and fetch all the corresponding BDU_Valeur__c
     */
    public void showPopup() {
        String indicateurId = Apexpages.currentPage().getParameters().get('indicateur_id');
        String bu1 = Apexpages.currentPage().getParameters().get('bu1');
        String bu2 = Apexpages.currentPage().getParameters().get('bu2');
        String bu3 = Apexpages.currentPage().getParameters().get('bu3');
        String bu4 = Apexpages.currentPage().getParameters().get('bu4');
        String bu5 = Apexpages.currentPage().getParameters().get('bu5');

        valeurs =  [SELECT Name, CT_Annee__c, CT_Entite__c, CT_A_publier__c, CT_confidentialityDate__c, 
                            CT_isConfidential__c,  CT_Valeur__c, CT_Val__c, CT_Date_de_publication__c, 
                            CT_Date_de_fin_de_publication__c, CT_Commentaire__c, CT_BDU_Indicateur__c 
                    FROM BDU_Valeur__c 
                    WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                    AND CT_semestre__c = null 
                    AND CT_Trimestre__c = null 
                    AND CT_Bimestre__c = null 
                    AND CT_Mois__c = null 
                    AND CT_BU1__c = :bu1
                    AND CT_BU2__c = :bu2 
                    AND CT_BU3__c = :bu3 
                    AND CT_BU4__c = :bu4 
                    AND CT_BU5__c = :bu5 
                    ORDER BY CT_Annee__c DESC];
        displayPopup = true;
    }
}