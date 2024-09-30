//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the page displaying the BDU_Indicateur__c
 */
public with sharing class BduController {
    public String slug {get; set; } //Slug identifying the parent BDU_Domaine__c
    public String todayDate {get; set; } //Locale date
    public String selectedPeriod {get; set; } //The wanted year for the BDU_Valeur__c
    public List<AggregateResult> availableValeurs {get; set; } //Distinc years for all bdu_valeur
    public List<BDU_Indicateur__c> indicateurs {get; set; } //List of BDU_Indicateur__c
    public transient List<BDU_Valeur__c> valeurs {get; set; } //List of BDU_Valeur__c
    // Map to retrieve an BDU_Indicateur__c's BDU_Valeur__c based on its Id
    public Map<Id, BDU_Valeur__c> indicateursToValeurs {get; set; }
    // Map to retrieve an BDU_Indicateur__c's BDU_Document__c'attachment based on its Id
    public Map<Id, Id> indicateursToAttachments{get; set; }
    // Map to retrieve an BDU_Indicateur__c's AttachedContentDocument based on its Id
    public Map<Id, ContentDocument> indicateursToContentDocuments{get; set; }
    // Map used to check if a BDU_Valeur__c exists for the selected year
    public Map<Id, Boolean> displayValue {get; set; }
    // Map used to check if an attachment exists for the selected year
    public Map<Id, Boolean> displayAttachment{get; set; }
    public Map<Id, Boolean> displayContentDocument{get; set;}
    public Integer page {get; set; } //current page
    public Integer total {get; set; } //total of BDU_Indicateur__c
    public Integer nbIndic {get; set; } //total of BDU_Indicateur__c
    public Boolean displayPopup {get; set;}    //Whether we display the history pop-up or not
    public BDU_Valeur__c mockValeur { get; set; }
    public String filigrane { get; set; }

    /**
    * Displays 5 BDU_Indicateur__c's BDU_Valeur__c from the selected year.
    * We retrieve the 5 BDU_Valeur__c along with the total number of BDU_Indicateur__c
    * We also populate a select list with the available years from BDU_Valeur__c
    */
    public BduController() {
    
        Override__c options = Override__c.getInstance();
        nbIndic = (Integer) options.CT_nbIndic__c;
        filigrane = Bdu_templateController.getResourceURL(options.Filigrane__c);
        Boolean showEmpty = ShowOptions__c.getInstance().showEmptyIndicateur__c;
        todayDate = Datetime.now().format();

        availableValeurs = new List<AggregateResult>();
        displayValue = new Map<Id, Boolean>();
        displayAttachment = new Map<Id, Boolean>();
        displayContentDocument = new Map<Id, Boolean>();
        indicateursToValeurs = new Map<Id, BDU_Valeur__c>();
        indicateursToAttachments = new Map<Id, Id>();
        indicateursToContentDocuments = new Map<Id, ContentDocument>();
        mockValeur = new BDU_Valeur__c(
            CT_BU1__c = bdu_templateController.getSelectedBu('BU1'),
            CT_BU2__c = bdu_templateController.getSelectedBu('BU2'),
            CT_BU3__c = bdu_templateController.getSelectedBu('BU3'),
            CT_BU4__c = bdu_templateController.getSelectedBu('BU4'),
            CT_BU5__c = bdu_templateController.getSelectedBu('BU5')
        );

        slug = ApexPages.CurrentPage().getParameters().get('id');
        String strPage = ApexPages.CurrentPage().getParameters().get('page');
        if(strPage == null) {
            page = 1;
        } else {
            page = Integer.valueOf(strPage);
        }
        String year = ApexPages.CurrentPage().getParameters().get('year');
        if(year != null) {
            selectedPeriod = year+';';
        }

        Integer offset = (page-1)*nbIndic;
        if(showEmpty) {
            total = [SELECT COUNT() 
                    FROM BDU_Indicateur__c 
                    WHERE CT_BDU_Domaine__r.CT_slug__c = :slug 
                    AND CT_Affiche__c = true];
            indicateurs = [SELECT Id, Name, CT_Affiche__c, CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c, 
                                CT_Domaine__c, CT_BDU_Domaine__c, CT_Code__c, CT_Code_Applicable__c, CT_Decret__c, 
                                CT_Article__c, CT_Description__c, CT_Libelle__c, CT_Emplacement__c, 
                                Type_de_graphique__c
                            FROM BDU_Indicateur__c 
                            WHERE CT_BDU_Domaine__r.CT_slug__c = :slug 
                            AND CT_Affiche__c = true 
                            ORDER BY CT_printorder__c 
                            LIMIT :nbIndic 
                            OFFSET :offset];
        } else {
            total = [SELECT COUNT() 
                    FROM BDU_Indicateur__c 
                    WHERE Id IN (SELECT CT_BDU_Indicateur__c 
                            FROM BDU_Valeur__c 
                            WHERE CT_BDU_Indicateur__c != '' 
                            AND CT_A_publier__c = true) 
                    AND CT_BDU_Domaine__r.CT_slug__c = :slug 
                    AND CT_Affiche__c = true];
            indicateurs = [SELECT Id, Name, CT_Affiche__c, CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c, 
                            CT_Domaine__c, CT_BDU_Domaine__c, CT_Code__c, CT_Code_Applicable__c, CT_Decret__c, 
                            CT_Article__c, CT_Description__c, CT_Libelle__c, CT_Emplacement__c, Type_de_graphique__c
                          FROM BDU_Indicateur__c 
                          WHERE Id in (SELECT CT_BDU_Indicateur__c 
                                            FROM BDU_Valeur__c 
                                            WHERE CT_BDU_Indicateur__c != '' 
                                            AND CT_A_publier__c = true) 
                          AND CT_BDU_Domaine__r.CT_slug__c = :slug 
                          AND CT_Affiche__c = true 
                          ORDER BY CT_printorder__c 
                          LIMIT :nbIndic OFFSET :offset ];
        }
        
        //Setting the default year
        Set<Id> ids = new Set<Id>();
        for(BDU_Indicateur__c indicateur: indicateurs) {
            ids.add(indicateur.Id);
        }
        availableValeurs = [SELECT CT_Annee__c, CT_Trimestre__c 
                            FROM BDU_Valeur__c 
                            WHERE CT_BDU_Indicateur__c IN :ids 
                            AND CT_A_publier__c = true 
                            AND CT_Date_de_publication__c <= TODAY 
                            GROUP BY CT_Annee__c, CT_Trimestre__c 
                            ORDER BY CT_Annee__c DESC, CT_Trimestre__c DESC];
        if(availableValeurs.size() > 0 && selectedPeriod == null) {
            String f = Schema.SObjectType.BDU_Valeur__c.fields.CT_Annee__c.getName();
            String availableYear = String.valueOf(availableValeurs.get(0).get(f));
            f = Schema.SObjectType.BDU_Valeur__c.fields.CT_Trimestre__c.getName();
            String availableTrimestre = String.valueOf(availableValeurs.get(0).get(f));
            if(availableTrimestre == null) availableTrimestre = '';
            selectedPeriod = availableYear+';'+availableTrimestre;
        }

        this.getAvailablePeriods();
        this.changeYear();
      }

      /**
       * Retrieves the BDU_Valeur__c for each BDU_Indicateur__c for the selected year (default to the current one).
       * To know whether a BDU_Indicateur__c has  a BDU_Valeur__c for the selected
       * We fill a map accordingly
       * @return null
       */
      public PageReference changeYear() {
        for(BDU_Indicateur__c indicateur: indicateurs){
            List<BDU_Valeur__c> valeur = new List<BDU_Valeur__c>();
            List<Attachment> attach = new List<Attachment>();
          
            String[] splitPeriod = selectedPeriod.split(';');
            String selectedYear = splitPeriod[0];
            String selectedTrimestre = (splitPeriod.size()>1) ? splitPeriod[1] : '';

            valeur = [SELECT Name, CT_Annee__c, CT_Trimestre__c, CT_Mois__c, CT_A_publier__c, 
                            CT_confidentialityDate__c, CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c, 
                            CT_Commentaire__c, CT_Date_de_publication__c, CT_Date_de_fin_de_publication__c, 
                            CT_Valeur__c, CT_Val__c, CT_Liaison_Contenu__r.Id, CT_BU__c, CT_BU1__c, CT_BU2__c, 
                            CT_BU3__c, CT_BU4__c, CT_BU5__c
                    FROM BDU_Valeur__c
                    WHERE CT_BDU_Indicateur__r.Id = :indicateur.Id
                    AND CT_Annee__c = :selectedYear
                    AND CT_A_publier__c = true
                    AND CT_Date_de_publication__c  <= TODAY
                    AND CT_BU1__c = :mockValeur.CT_BU1__c
                    AND CT_BU2__c = :mockValeur.CT_BU2__c
                    AND CT_BU3__c = :mockValeur.CT_BU3__c
                    AND CT_BU4__c = :mockValeur.CT_BU4__c
                    AND CT_BU5__c = :mockValeur.CT_BU5__c
                    AND CT_semestre__c = null
                    AND CT_Trimestre__c = :selectedTrimestre
                    AND CT_Bimestre__c = null
                    AND CT_Mois__c = null
                    ORDER BY CreatedDate 
                    LIMIT 1];

            // defaults
            displayAttachment.put(indicateur.Id, false);
            displayContentDocument.put(indicateur.Id, false);
            displayValue.put(indicateur.Id, false);

            if(valeur.size() == 1) {
                indicateursToValeurs.put(indicateur.Id, valeur.get(0));
                displayValue.put(indicateur.Id, true);
                Id contentId = valeur.get(0).CT_Liaison_Contenu__r.Id;
                if(contentId!=null) {
                    attach = [SELECT Id, Body, ParentId
                              FROM Attachment
                              WHERE ParentId =: contentId
                              ORDER BY CreatedDate DESC
                              LIMIT 1];
                    if(attach.size() > 0){
                        indicateursToAttachments.put(indicateur.Id, attach.get(0).Id);
                        displayAttachment.put(indicateur.Id, true);
                    }

                    List<ContentDocumentLink> l = [SELECT ContentDocumentId, 
                                                        ContentDocument.LatestPublishedVersion.FileType,
                                                        ContentDocument.Title,
                                                        ContentDocument.LatestPublishedVersionId
                                                    FROM ContentDocumentLink
                                                    WHERE LinkedEntityId =: contentId];
                    if(l.size()>0) {
                        indicateursToContentDocuments.put(indicateur.Id, l.get(0).ContentDocument);
                        displayContentDocument.put(indicateur.Id, true);
                    }
                }
            }
        }
        bdu_templateController.setBuCookie(mockValeur.CT_BU1__c, mockValeur.CT_BU2__c, mockValeur.CT_BU3__c, 
                                                mockValeur.CT_BU4__c, mockValeur.CT_BU5__c);

        return null;
    }


    /**
    * Populates a select list with the available periods.
    * @return The distinct available periods
    */
    public List<SelectOption> getAvailablePeriods() {
        List<SelectOption> options = new List<SelectOption>();
        for(AggregateResult valeur: availableValeurs) {
            String f = Schema.SObjectType.BDU_Valeur__c.fields.CT_Annee__c.getName();
            String selectedYear = String.valueOf(valeur.get(f));
            f = Schema.SObjectType.BDU_Valeur__c.fields.CT_Trimestre__c.getName();
            String selectedTrimestre = String.valueOf(valeur.get(f));
            if(selectedTrimestre == null) {
                selectedTrimestre = '';
                options.add(new SelectOption(selectedYear+';'+selectedTrimestre, selectedYear));
            } else {
                options.add(new SelectOption(selectedYear+';'+selectedTrimestre, selectedYear+' T'+selectedTrimestre));
            }
        }
        return options;
    }

    /**
    * Remote action to retrieve an indicateur history
    * @param  period       Which periodicity we want (e.g. annees, semestres, trimestres, bimestres, mois)
    * @param  indicateurId Id of the wanted indicateur
    * @param  year         Year to retrieve if 'annees' is not the selected period
    * @param  BU1          Wanted BU1
    * @param  BU2          Wanted BU2
    * @param  BU3          Wanted BU3
    * @param  BU4          Wanted BU4
    * @param  BU5          Wanted BU5
    * @return              List of BDU Valeurs
    */
    @RemoteAction
    public static List<BDU_Valeur__c> getHistory(String period, String indicateurId, String year, String BU1, 
                                                    String BU2, String BU3, String BU4, String BU5) {
    List<BDU_Valeur__c> valeurs = new List<BDU_Valeur__c>();
    if(period == 'annees') {
        valeurs = [SELECT Name, CT_Annee__c, CT_A_publier__c, CT_confidentialityDate__c, CT_isConfidential__c,
                        CT_Entite__c, CT_BDU_Indicateur__c, CT_BDU_Indicateur__r.CT_Code__c,
                        CT_BDU_Indicateur__r.CT_Libelle__c, CT_BDU_Indicateur__r.Type_de_graphique__c,
                        CT_Commentaire__c, CT_Date_de_publication__c, CT_Valeur__c, CT_Val__c,  CT_BU1__c,
                        CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c
                FROM BDU_Valeur__c 
                WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                AND CT_A_publier__c = true 
                AND CT_Date_de_publication__c  <= TODAY 
                AND (CT_Date_de_fin_de_publication__c = null OR CT_Date_de_fin_de_publication__c > TODAY)
                AND CT_BU1__c = :BU1 
                AND CT_BU2__c = :BU2 
                AND CT_BU3__c = :BU3 
                AND CT_BU4__c = :BU4 
                AND CT_BU5__c = :BU5
                AND CT_semestre__c = null 
                AND CT_Trimestre__c = null 
                AND CT_Bimestre__c = null 
                AND CT_Mois__c = null 
                ORDER BY CT_Annee__c DESC];
    } else if(period == 'semestres') {
        valeurs = [SELECT Name, CT_Annee__c, CT_semestre__c, CT_A_publier__c, CT_confidentialityDate__c,
                        CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c,
                        CT_BDU_Indicateur__r.CT_Code__c, CT_BDU_Indicateur__r.CT_Libelle__c,
                        CT_BDU_Indicateur__r.Type_de_graphique__c, CT_Commentaire__c,
                        CT_Date_de_publication__c, CT_Valeur__c, CT_Val__c,  CT_BU1__c, CT_BU2__c, CT_BU3__c,
                        CT_BU4__c, CT_BU5__c
                FROM BDU_Valeur__c 
                WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                AND CT_A_publier__c = true 
                AND CT_Date_de_publication__c  <= TODAY 
                AND (CT_Date_de_fin_de_publication__c = null OR CT_Date_de_fin_de_publication__c > TODAY)
                AND CT_BU1__c = :BU1 
                AND CT_BU2__c = :BU2 
                AND CT_BU3__c = :BU3 
                AND CT_BU4__c = :BU4 
                AND CT_BU5__c = :BU5
                AND CT_Annee__c = :year 
                AND CT_semestre__c != null 
                AND CT_Trimestre__c = null 
                AND CT_Bimestre__c = null 
                AND CT_Mois__c = null 
                ORDER BY CT_Semestre__c DESC];
    } else if(period == 'trimestres') {
        valeurs = [SELECT Name, CT_Annee__c, CT_Trimestre__c, CT_A_publier__c, CT_confidentialityDate__c,
                        CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c,
                        CT_BDU_Indicateur__r.CT_Code__c, CT_BDU_Indicateur__r.CT_Libelle__c,
                        CT_BDU_Indicateur__r.Type_de_graphique__c, CT_Commentaire__c,
                        CT_Date_de_publication__c, CT_Valeur__c, CT_Val__c,  CT_BU1__c, CT_BU2__c, CT_BU3__c,
                        CT_BU4__c, CT_BU5__c
                FROM BDU_Valeur__c 
                WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                AND CT_A_publier__c = true 
                AND CT_Date_de_publication__c  <= TODAY 
                AND (CT_Date_de_fin_de_publication__c = null OR CT_Date_de_fin_de_publication__c > TODAY)
                AND CT_BU1__c = :BU1 
                AND CT_BU2__c = :BU2 
                AND CT_BU3__c = :BU3 
                AND CT_BU4__c = :BU4 
                AND CT_BU5__c = :BU5
                AND CT_Annee__c = :year 
                AND CT_semestre__c = null 
                AND CT_Trimestre__c != null 
                AND CT_Bimestre__c = null 
                AND CT_Mois__c = null 
                ORDER BY CT_Trimestre__c DESC];
    } else if(period == 'bimestres') {
        valeurs = [SELECT Name, CT_Annee__c, CT_Bimestre__c, CT_A_publier__c, CT_confidentialityDate__c,
                        CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c,
                        CT_BDU_Indicateur__r.CT_Code__c, CT_BDU_Indicateur__r.CT_Libelle__c,
                        CT_BDU_Indicateur__r.Type_de_graphique__c, CT_Commentaire__c,
                        CT_Date_de_publication__c, CT_Valeur__c, CT_Val__c,  CT_BU1__c, CT_BU2__c, CT_BU3__c,
                        CT_BU4__c, CT_BU5__c
                FROM BDU_Valeur__c 
                WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                AND CT_A_publier__c = true 
                AND CT_Date_de_publication__c  <= TODAY 
                AND (CT_Date_de_fin_de_publication__c = null Or CT_Date_de_fin_de_publication__c > TODAY)
                AND CT_BU1__c = :BU1 
                AND CT_BU2__c = :BU2 AND 
                CT_BU3__c = :BU3 
                AND CT_BU4__c = :BU4 
                AND CT_BU5__c = :BU5
                AND CT_Annee__c = :year 
                AND CT_semestre__c = null 
                AND CT_Trimestre__c = null 
                AND CT_Bimestre__c != null 
                AND CT_Mois__c = null 
                ORDER BY CT_Bimestre__c DESC];
    } else if(period == 'mois') {
        valeurs = [SELECT Name, CT_Annee__c, CT_Mois__c, CT_A_publier__c, CT_confidentialityDate__c,
                        CT_isConfidential__c, CT_Entite__c, CT_BDU_Indicateur__c,
                        CT_BDU_Indicateur__r.CT_Code__c, CT_BDU_Indicateur__r.CT_Libelle__c,
                        CT_BDU_Indicateur__r.Type_de_graphique__c, CT_Commentaire__c,
                        CT_Date_de_publication__c, CT_Valeur__c, CT_Val__c,  CT_BU1__c, CT_BU2__c, CT_BU3__c,
                        CT_BU4__c, CT_BU5__c
                FROM BDU_Valeur__c 
                WHERE CT_BDU_Indicateur__r.Id = :indicateurId 
                AND CT_A_publier__c = true 
                AND CT_Date_de_publication__c  <= TODAY 
                AND (CT_Date_de_fin_de_publication__c = null OR CT_Date_de_fin_de_publication__c > TODAY)
                AND CT_BU1__c = :BU1
                AND CT_BU2__c = :BU2 
                AND CT_BU3__c = :BU3 
                AND CT_BU4__c = :BU4 
                AND CT_BU5__c = :BU5
                AND CT_Annee__c = :year 
                AND CT_semestre__c = null 
                AND CT_Trimestre__c = null 
                AND CT_Bimestre__c = null 
                AND CT_Mois__c != null 
                ORDER BY CT_Mois__c DESC];
        }
        return valeurs;
    }

    /**
    * Remote action to mark the joyride plugin as finished
    * @return String Status of the update or an error message
    */
    @RemoteAction
    public static String finishJoyride() {
        try {
            User currentUser = [SELECT Id, hasJoyrideBDU__c FROM User WHERE Id = :UserInfo.getUserId()];
            if (
                Schema.sObjectType.User.isUpdateable()
                && Schema.sObjectType.User.fields.hasJoyrideBDU__c.isUpdateable()
            ) {
                currentUser.hasJoyrideBDU__c = true;
                update currentUser;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_joyride_finish.replace('{0}', e.getDmlMessage(0));
            }
            return System.Label.SI_Error_joyride_finish.replace('{0}', e.getMessage());
        }
    }
}