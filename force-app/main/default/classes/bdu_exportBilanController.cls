//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller to export a BDU report as a csv
 * 
 * @author Crosstalent
 * @group BDU-Backend
 * @deprecated
 */
public with sharing class bdu_exportBilanController {
    public String selectedDocument { get; set; }
    public String csv {get; set; } //List of valeur__c

    /**
     * Retrieves and print all the BDU_Indicateur__c for a given BDU_Domaine__c
     * We retrieve the wanted document and year from the previous page
     * We query all the corresponding BDU_Indicateur__c 
     * and loop on them to query for their BDU_Valeur__c according to the year
     */
    public bdu_exportBilanController() {
        selectedDocument = ApexPages.CurrentPage().getParameters().get('document');
        String selectedYear = ApexPages.CurrentPage().getParameters().get('year');
        String bu1 = ApexPages.CurrentPage().getParameters().get('bu1');
        String bu2 = ApexPages.CurrentPage().getParameters().get('bu2');
        String bu3 = ApexPages.CurrentPage().getParameters().get('bu3');
        String bu4 = ApexPages.CurrentPage().getParameters().get('bu4');
        String bu5 = ApexPages.CurrentPage().getParameters().get('bu5');
        Apexpages.currentPage().getHeaders().put(
            'Content-Disposition', 'attachment; filename="' + selectedDocument + '.csv"');
        Apexpages.currentPage().getHeaders().put(
            'Content-Type', 'text/csv#' + selectedDocument + '.csv; charset=iso-8859-1');

        List<BDU_Valeur__c> valeurs = [ 
           SELECT 
               CT_BDU_Indicateur__r.CT_BDU_Domaine__r.Name, 
               CT_BDU_Indicateur__r.CT_Code__c, 
               CT_BDU_Indicateur__r.CT_Code_Applicable__c, 
               CT_BDU_Indicateur__r.CT_Decret__c, 
               CT_BDU_Indicateur__r.CT_Article__c, 
               CT_BDU_Indicateur__r.CT_Description__c, 
               CT_BDU_Indicateur__r.CT_Libelle__c, 
               CT_Annee__c, 
               CT_BU1__c, 
               CT_BU2__c, 
               CT_BU3__c, 
               CT_BU4__c, 
               CT_BU5__c, 
               CT_isConfidential__c, 
               CT_confidentialityDate__c, 
               CT_Commentaire__c, 
               CT_Date_de_publication__c, 
               CT_Date_de_fin_de_publication__c , 
               CT_Valeur__c,
               CT_Val__c
           FROM BDU_Valeur__c 
           WHERE CT_BDU_Indicateur__r.CT_Origine__c Includes (:selectedDocument)
           AND CT_BDU_Indicateur__r.CT_Affiche__c = true
           AND CT_A_publier__c = true
           AND CT_Annee__c=:selectedYear 
           AND CT_Semestre__c = null 
           AND CT_Trimestre__c = null 
           AND CT_Bimestre__c = null 
           AND CT_Mois__c = null 
           AND CT_BU1__c = :bu1
           AND CT_BU2__c = :bu2 
           AND CT_BU3__c = :bu3 
           AND CT_BU4__c = :bu4 
           AND CT_BU5__c = :bu5
           ORDER BY CT_BDU_Indicateur__r.CT_Code__c];

        csv = 'Nom,Code,Année,Domaine,Code applicable,Décret,Article,Description,Confidentiel,Date de fin de '
            + 'confidentialité,Date de publication, Date de fin de publication,Valeur,Commentaire|';
        csv += 'Nom,Code,Année,Domaine,Code applicable,Décret,Article,Description,Confidentiel,Date de fin de '
            + 'confidentialité,Date de publication, Date de fin de publication,Valeur,Commentaire|';

        for(BDU_Valeur__c valeur: valeurs) {
            if(valeur.CT_Commentaire__c != null) {
                valeur.CT_Commentaire__c = valeur.CT_Commentaire__c.replaceAll(',', ';').replaceAll('\n', ' ');
            } else {
                valeur.CT_Commentaire__c = ' ';
            }
            csv += valeur.CT_BDU_Indicateur__r.CT_Libelle__c.replaceAll(',', ';')+','
                +valeur.CT_BDU_Indicateur__r.CT_Code__c+','
                +valeur.CT_Annee__c+','
                +valeur.CT_BDU_Indicateur__r.CT_BDU_Domaine__r.Name+','
                +valeur.CT_BDU_Indicateur__r.CT_Code_Applicable__c+','
                +valeur.CT_BDU_Indicateur__r.CT_Decret__c+','
                +valeur.CT_BDU_Indicateur__r.CT_Article__c+','
                +valeur.CT_BDU_Indicateur__r.CT_Description__c+','
                +valeur.CT_isConfidential__c+','
                +valeur.CT_confidentialityDate__c+','
                +valeur.CT_Date_de_publication__c+','
                +valeur.CT_Date_de_fin_de_publication__c+','
                +valeur.CT_Valeur__c.replaceAll(',', ';').replaceAll('\n', ' ')+','
                +valeur.CT_Commentaire__c+'|';
        }
        csv.removeEnd('|');
    }
}