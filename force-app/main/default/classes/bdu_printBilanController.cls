//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the printing of the different legal documents
 */
public with sharing class bdu_printBilanController {

    public List<BDU_Domaine__c> domaines {get; set; } //List of domaines
    public Map<String, List<BDU_Valeur__c>> domaineToValeurs {get; set; } //List of domaine and their associated valeur__c
    public String selectedYear {get; set; } //The selected year
    public String selectedDocument {get; set; } //The selected document
    public String bu1 {get; set; } //The selected business unit
    public String bu2 {get; set; } //The selected business unit
    public String bu3 {get; set; } //The selected business unit
    public String bu4 {get; set; } //The selected business unit
    public String bu5 {get; set; } //The selected business unit
    public ShowOptions__c option {get; set;}
    public Override__c printOptions {get; set;}
    public String selectedFormat {get; set;}
    public String topRight {get; set;}
    public String bottomLeft {get; set;}
    public String bottomRight {get; set;}
    public String topRightResource {get; set;}
    public String bottomLeftResource {get; set;}
    public String bottomRightResource {get; set;}
    public String render {get; set;}
    public String customCSS {get; set;}

    /**
       * Retrieves and print all the BDU_Indicateur__c for a given BDU_Domaine__c
       * We retrieve the wanted document and year from the previous page
       * We query all the corresponding BDU_Indicateur__c 
       * and loop on them to query for their BDU_Valeur__c according to the year
     */
    public bdu_printBilanController() {
        option = showOptions__c.getInstance();

        printOptions = override__c.getInstance();
        selectedDocument = ApexPages.CurrentPage().getParameters().get('document');
        selectedYear = ApexPages.CurrentPage().getParameters().get('year');
        selectedFormat = ApexPages.CurrentPage().getParameters().get('format');
        bu1 = ApexPages.CurrentPage().getParameters().get('bu1');
        bu2 = ApexPages.CurrentPage().getParameters().get('bu2');
        bu3 = ApexPages.CurrentPage().getParameters().get('bu3');
        bu4 = ApexPages.CurrentPage().getParameters().get('bu4');
        bu5 = ApexPages.CurrentPage().getParameters().get('bu5');
        topRight = getResourceName(printOptions.printTopRight__c);
        bottomLeft = getResourceName(printOptions.printBottomLeft__c);
        bottomRight = getResourceName(printOptions.printBottomRight__c);
        topRightResource = getResourceUrl(printOptions.printTopRight__c);
        bottomLeftResource = getResourceUrl(printOptions.printBottomLeft__c);
        bottomRightResource = getResourceUrl(printOptions.printBottomRight__c);

        render = 'html';
        if(selectedFormat == 'word') {
            ApexPages.currentPage().getHeaders().put('Content-Disposition', 'attachment; filename="'+selectedDocument+'.doc"');
            ApexPages.currentPage().getHeaders().put('Content-Type', 'application/msword#'+selectedDocument+'.doc; charset=UTF-16');
        } else if (selectedFormat == 'pdf') {
            render = 'pdf';
        }

        domaineToValeurs = new Map<String, List<BDU_Valeur__c>>();
        domaines = [SELECT Id, Name, CT_slug__c, CT_Order__c, CT_BDU_Chapitre__c, CT_Description__c 
                  FROM BDU_Domaine__c 
                  WHERE CT_Affiche__c = true 
                  ORDER BY CT_BDU_Chapitre__r.CT_Order__c, CT_Order__c];

        for(BDU_Domaine__c domaine: domaines) {
            List<BDU_Valeur__c> valeurs = new List<BDU_Valeur__c>();
            valeurs = [SELECT CT_BDU_Indicateur__r.Id, 
                              CT_BDU_Indicateur__r.Name, 
                              CT_BDU_Indicateur__r.CT_Origine__c, 
                              CT_BDU_Indicateur__r.CT_Affiche__c, 
                              CT_BDU_Indicateur__r.CT_Afficher_le_graphique__c, 
                              CT_BDU_Indicateur__r.CT_Afficher_le_tableau__c, 
                              CT_BDU_Indicateur__r.Type_de_graphique__c, 
                              CT_BDU_Indicateur__r.CT_BDU_Domaine__c, 
                              CT_BDU_Indicateur__r.CT_Code__c, 
                              CT_BDU_Indicateur__r.CT_Code_Applicable__c, 
                              CT_BDU_Indicateur__r.CT_Decret__c, 
                              CT_BDU_Indicateur__r.CT_Article__c, 
                              CT_BDU_Indicateur__r.CT_Description__c, 
                              CT_BDU_Indicateur__r.CT_Libelle__c, 
                              CT_BDU_Indicateur__r.CT_Emplacement__c, 
                              Name, 
                              CT_Annee__c, 
                              CT_Entite__c, 
                              CT_A_publier__c, 
                              CT_isConfidential__c, 
                              CT_confidentialityDate__c, 
                              CT_BDU_Indicateur__c, 
                              CT_Commentaire__c, 
                              CT_Date_de_publication__c, 
                              CT_Date_de_fin_de_publication__c , 
                              CT_Valeur__c, 
                              CT_Val__c 
                        FROM BDU_Valeur__c 
                        WHERE CT_BDU_Indicateur__r.CT_Origine__c INCLUDES (:selectedDocument)
                        AND CT_BDU_Indicateur__r.CT_BDU_Domaine__c =: domaine.Id 
                        AND CT_BDU_Indicateur__r.CT_Affiche__c = true
                        AND CT_A_publier__c = true
                        AND CT_Annee__c=: selectedYear 
                        AND CT_Semestre__c = null
                        AND CT_Trimestre__c = null 
                        AND CT_Bimestre__c = null
                        AND CT_Mois__c = null
                        AND CT_BU1__c =: bu1
                        AND CT_BU2__c =: bu2 
                        AND CT_BU3__c =: bu3 
                        AND CT_BU4__c =: bu4 
                        AND CT_BU5__c =: bu5 
                        ORDER BY CT_BDU_Indicateur__r.CT_printOrder__c];
                        domaineToValeurs.put(domaine.Name, valeurs);
        }
    }

      /**
       * Prints the name for a resource
       * @param String Name of the wanted resource
       * @return String A name
       */
      public String GetResourceName(String resourceName){
            // Fetching the resource
            List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp 
                                                FROM StaticResource 
                                                WHERE Name = :resourceName];

            // Checking if the result is returned or not
            if(resourceList.size() == 1){
               // Getting namespace
               String namespace = resourceList[0].NamespacePrefix;
               // Resource URL
               return (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
            }
            else return '';
      }
      
    /**
     * Prints the url for a resource
     * @param String Name of the wanted resource
     * @return String A relative url
     */
    public String GetResourceURL(String resourceName){
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp 
                                          FROM StaticResource 
                                          WHERE Name = :resourceName];

        // Checking if the result is returned or not
        if(resourceList.size() == 1) {
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' 
                  + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        } else {
            return '';
        }
      }
}