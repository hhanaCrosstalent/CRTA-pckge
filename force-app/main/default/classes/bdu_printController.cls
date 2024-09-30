//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the printing of BDU_Indicateur__c
 * @deprecated
 */
public with sharing class bdu_printController {
      public List<BDU_Indicateur__c> indicateurs {get; set; } //List of indicateur__c
      public Map<ID, BDU_Valeur__c> indicateursToValeurs {get; set; } //Map to retrieve an indicateur__c's valeur__c based on its id
      public Map<ID, Boolean> displayValue {get; set; } //Map used to check if a valeur__c exists for the selected year
      public String user {get; set; } //Current user's infos
      public String selectedYear {get; set; } //The selected year

      /**
       * Retrieves and print all the BDU_Indicateur__c for a given BDU_Domaine__c
       * We retrieve the slug and year from the previous page, and the current user infos
       * We query all the corresponding BDU_Indicateur__c 
       * and loop on them to query for their BDU_Valeur__c according to the year
       */
      public bdu_printController() {        
            String slug = ApexPages.CurrentPage().getParameters().get('id');
            selectedYear = ApexPages.CurrentPage().getParameters().get('year');
            String bu1 = ApexPages.CurrentPage().getParameters().get('bu1');
            String bu2 = ApexPages.CurrentPage().getParameters().get('bu2');
            String bu3 = ApexPages.CurrentPage().getParameters().get('bu3');
            String bu4 = ApexPages.CurrentPage().getParameters().get('bu4');
            String bu5 = ApexPages.CurrentPage().getParameters().get('bu5');
            displayValue = new Map<Id, Boolean>();
            indicateursToValeurs = new Map<Id, BDU_Valeur__c>();
            user = Userinfo.getName();

            indicateurs = [SELECT Id, Name, CT_Affiche__c, CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c, CT_Domaine__c, CT_BDU_Domaine__c, CT_Code__c, CT_Code_Applicable__c, CT_Decret__c, CT_Article__c, CT_Description__c, CT_Libelle__c, CT_Emplacement__c, Type_de_graphique__c 
                        FROM BDU_Indicateur__c 
                        WHERE CT_BDU_Domaine__r.CT_slug__c =: slug 
                        AND CT_Affiche__c = true 
                        ORDER BY CT_PrintOrder__c];
                                            
            for(BDU_Indicateur__c indicateur : indicateurs) {
                 BDU_Valeur__c valeur = new BDU_Valeur__c();
                 try {
                        valeur = [SELECT Name, CT_Annee__c, CT_A_publier__c, CT_confidentialityDate__c, CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c, CT_Commentaire__c, CT_Date_de_publication__c, CT_Date_de_fin_de_publication__c, CT_Valeur__c, CT_Val__c, CT_Liaison_Contenu__r.Id, CT_BU__c, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c
                              FROM BDU_Valeur__c 
                              WHERE CT_BDU_Indicateur__r.Id =: indicateur.Id 
                              AND CT_Annee__c =: selectedYear 
                              AND CT_A_publier__c = true 
                              AND CT_Date_de_publication__c  <= TODAY
                              AND CT_BU1__c =: bu1 
                              AND CT_BU2__c =: bu2 
                              AND CT_BU3__c =: bu3 
                              AND CT_BU4__c =: bu4 
                              AND CT_BU5__c =: bu5 
                              AND CT_semestre__c = null 
                              AND CT_Trimestre__c = null 
                              AND CT_Bimestre__c = null 
                              AND CT_Mois__c = null 
                              ORDER BY CreatedDate Limit 1];
                        indicateursToValeurs.put(indicateur.id, valeur);
                        displayValue.put(indicateur.id, true);
                  } catch(Exception e) {
                        displayValue.put(indicateur.id, false);
                        continue;
                  }
            }
      }
}