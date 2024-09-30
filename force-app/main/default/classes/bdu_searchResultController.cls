//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the page displaying the result of a search
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.9
 */
public with sharing class bdu_searchResultController{
  public String selectedYear {get; set; } //The wanted year for the BDU_Valeur__c
  public String idIndicateur { get; set; }
  public String idValue { get; set; }
  public BDU_Valeur__c mockValeur { get; set; }
  public Transient List<AggregateResult> availableValeurs {get; set; } //Distinc years for all bdu_valeur
  public BDU_Indicateur__c indicateur { get; set; }
  public BDU_Valeur__c valeur { get; set; }
  public List<BDU_Valeur__c> valeurs {get; set; } //List of BDU_Valeur__c

  /**
   * Retrieves the right parameters and displays the page
   */
  public bdu_searchResultController()  {
    idValue = ApexPages.CurrentPage().getParameters().get('idval');
    idIndicateur = ApexPages.CurrentPage().getParameters().get('idindic');
    this.changeYear();
  }

  /**
   * Retrieves the searched object based on the selected year
   * @return Current page
   */
  public PageReference changeYear()  {
    if(!String.isBlank(idIndicateur)) {
      indicateur = [SELECT Id, Name, CT_Affiche__c, CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c,
                           CT_Domaine__c, CT_BDU_Domaine__c, CT_Code__c, CT_Code_Applicable__c, CT_Decret__c,
                           CT_Article__c, CT_Description__c, CT_Libelle__c, CT_Emplacement__c, Type_de_graphique__c
                    FROM BDU_Indicateur__c
                    WHERE id = :idIndicateur
                    AND CT_Affiche__c = true];

      availableValeurs = [SELECT CT_Annee__c
                          FROM BDU_Valeur__c
                          WHERE CT_BDU_Indicateur__c = :idIndicateur
                          AND CT_A_publier__c = true
                          GROUP BY CT_Annee__c Order By CT_Annee__c DESC];
      if(availableValeurs.size() > 0 && selectedYear == null) {
          String field = Schema.SObjectType.BDU_Valeur__c.fields.CT_Annee__c.getName();
          selectedYear = String.valueOf(availableValeurs.get(0).get(field));
      }

      try {
              valeur = [SELECT Name, CT_Annee__c, CT_A_publier__c, CT_confidentialityDate__c, CT_isConfidential__c,
                               CT_Entite__c, CT_BDU_Indicateur__c, CT_Commentaire__c, CT_Date_de_publication__c,
                               CT_Date_de_fin_de_publication__c, CT_Valeur__c, CT_Val__c, CT_Liaison_Contenu__r.Id,
                               CT_BU__c, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c
                        FROM BDU_Valeur__c
                        WHERE CT_BDU_Indicateur__c = :idIndicateur
                        AND CT_Annee__c =: selectedYear
                        AND CT_A_publier__c = true
                        ORDER BY CreatedDate LIMIT 1];
      } catch(Exception e) {
              System.debug('Valeur : '+e.getMessage());
      }
    } else {
      valeur = [SELECT Name, CT_Annee__c, CT_Mois__c, CT_Trimestre__c,
                       CT_A_publier__c, CT_confidentialityDate__c, CT_isConfidential__c,
                       CT_Entite__c, CT_BDU_Indicateur__r.Id, CT_Commentaire__c, CT_Date_de_publication__c,
                       CT_Date_de_fin_de_publication__c, CT_Valeur__c, CT_Val__c, CT_Liaison_Contenu__r.Id, CT_BU__c,
                       CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c
              FROM BDU_Valeur__c
              WHERE Id = :idValue LIMIT 1];
      idIndicateur = valeur.CT_BDU_Indicateur__r.Id;
      indicateur = [SELECT Id, Name, CT_Affiche__c, CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c,
                           CT_Domaine__c, CT_BDU_Domaine__c, CT_Code__c, CT_Code_Applicable__c, CT_Decret__c,
                           CT_Article__c, CT_Description__c, CT_Libelle__c, CT_Emplacement__c, Type_de_graphique__c
                      FROM BDU_Indicateur__c
                      WHERE id =: idIndicateur
                      AND CT_Affiche__c = true];

      availableValeurs = [SELECT CT_Annee__c FROM BDU_Valeur__c WHERE id = :idValue GROUP BY CT_Annee__c];
    }

    this.getAvailableYears();
    return null;
  }


  /**
   * Populates a select list with the available years.
   * @return The distinct available years
   */
  public List<SelectOption> getAvailableYears(){
    List<SelectOption> options = new List<SelectOption>();
    String field = Schema.SObjectType.BDU_Valeur__c.fields.CT_Annee__c.getName();
    for(AggregateResult valeur: availableValeurs) {
        options.add(new SelectOption(string.valueof(valeur.get(field)), string.valueof(valeur.get(field))));
    }
    return options;
  }
}