//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the job offers page
 */
public with sharing class VisualisationEmploiController {
    public String contactId {get; set;}
    public Map<String, List<SObject>> offerMap {get; set;} //Map of the retrieved offer and its associated objects
    public Boolean hasOffer {get; set;} //Whether we initially load an offer
    public Boolean hasPositions {get; set;} //Whether the loaded offer has associated positions
    public Boolean hasSkills {get; set;} //Whether the loaded offer has associated skills
    public Boolean hasPermits {get; set;} //Whether the loaded offer has associated permits
    public Boolean hasTrainings {get; set;} //Whether the loaded offer has associated trainings
    public Boolean hasExperiences {get; set;} //Whether the loaded offer has associated experiences
    public String selectedFiliere {get; set;} //Selected offer filiere
    public String selectedIndustry {get; set;} //Selected offer industry
    public String selectedCity {get; set;} //Selected offer city

    public VisualisationEmploiController() {
        contactId = [SELECT Contact__c FROM User WHERE Id = :UserInfo.getUserId()].Contact__c;
        hasOffer = false;
        hasPermits = false;
        hasPositions = false;
        hasSkills = false;
        hasTrainings = false;
        hasExperiences = false;

        offerMap = new Map<String, List<sObject>>();
        String offerId = ApexPages.currentPage().getParameters().get('id');
        if(offerId != null && offerId != '') offerMap = VisualisationEmploiController.getOffer(offerId, contactId);
        if(offerMap.containsKey('offer')) { 
            hasOffer = true;
            if(offerMap.containsKey('permits') && offerMap.get('permits').size() > 0) hasPermits = true;
            if(offerMap.containsKey('skills') && offerMap.get('skills').size() > 0) hasSkills = true;
            if(offerMap.containsKey('positions') && offerMap.get('positions').size() > 0) hasPositions = true;
            if(offerMap.containsKey('experiences') && offerMap.get('experiences').size() > 0) hasExperiences = true;
            if(offerMap.containsKey('trainings') && offerMap.get('trainings').size() > 0) hasTrainings = true;
        }
    }


    /**
     * Populates a select list with the filieres.
     * @return The filieres
     */
    public List<SelectOption> getFilieres() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Offre_d_emploi__c.Filiere__c.getDescribe();
        List<Schema.PicklistEntry> pes = fieldResult.getPicklistValues();
        options.add(new SelectOption('', System.Label.List_all));
        for(Schema.PicklistEntry pe : pes) {
            options.add(new SelectOption(pe.getValue(), pe.getLabel())); 
        }

        return options;
    }

    /**
     * Populates a select list with the industries.
     * @return The industries
     */
    public List<SelectOption> getIndustries() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Offre_d_emploi__c.CT_Industry_of_activities__c.getDescribe();
        List<Schema.PicklistEntry> pes = fieldResult.getPicklistValues();
        options.add(new SelectOption('', System.Label.List_all)); 
        for(Schema.PicklistEntry pe : pes) {
            options.add(new SelectOption(pe.getValue(), pe.getLabel())); 
        }

        return options;
    }

    /**
     * Populates a select list with the available cities.
     * @return The cities
     */
    public List<SelectOption> getCities() {
        List<SelectOption> options = new List<SelectOption>();
        List<AggregateResult> cities = [SELECT CT_City__c city
                                        FROM Offre_d_emploi__c
                                        WHERE CT_Date__c <= TODAY
                                        AND CT_Scope__c = false
                                        GROUP BY CT_City__c
                                        ORDER BY CT_City__c ASC];
        options.add(new SelectOption('', System.Label.List_all)); 
        for(AggregateResult a : cities) {
            String s = String.valueOf(a.get('city'));
            if(!String.isBlank(s)) {
                options.add(new SelectOption(s, s)); 
            }
        }
        return options;
    }

    /**
     * Loads an offer
     * @param  offerId Id of the offer
     * 
     * @return   Map of the offer and its associated objects (e.g. positions)
     */
    @RemoteAction
    public static Map<String, List<sObject>> getOffer(String offerId, String contactId) {
        Map<String, List<SObject>> sObjectMap = new Map<String, List<SObject>>();
        try {
            List<Offre_d_emploi__c> offers = [SELECT Id, Name, CT_Description__c, Filiere__c, 
                                                CT_Industry_of_activities__c, Fiche_de_poste__r.Id, 
                                                Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c, 
                                                CT_City__c, CT_Date_debut_Contrat__c 
                                              FROM Offre_d_emploi__c 
                                              WHERE Id = :offerId 
                                              LIMIT 1];
            sObjectMap.put('offer', offers);
            if(offers[0].Fiche_de_poste__r.Id != null) {
                List<GS_Poste_Competence__c> skills = [SELECT CreatedDate, EI_Competence__r.Id, EI_Competence__r.Name, 
                                                        EI_Competence__r.Type__c, 
                                                        EI_Competence__r.EI_Description_de_la_competence__c, 
                                                        EI_Competence__r.Description_detaillee__c 
                                                       FROM GS_Poste_Competence__c 
                                                       WHERE GS_Fiche_de_poste__c = :offers[0].Fiche_de_poste__r.Id 
                                                       ORDER BY CreatedDate ASC 
                                                       LIMIT 3];
                sObjectMap.put('skills', skills);
                List<Habilitation_de_poste__c> permits = [SELECT CreatedDate, Habilitation__r.Id, 
                                                            Habilitation__r.Name, Habilitation__r.Description__c, 
                                                            Habilitation__r.Description_detaillee__c 
                                                          FROM Habilitation_de_poste__c 
                                                          WHERE Fiche_de_poste__c = :offers[0].Fiche_de_poste__r.Id 
                                                          ORDER BY CreatedDate ASC 
                                                          LIMIT 3];
                sObjectMap.put('permits', permits);
            }

            List<Positionnement__c> positions = [SELECT Id 
                                                 FROM Positionnement__c 
                                                 WHERE CT_Job__c = :offers[0].Id 
                                                 AND CT_Candidate__c =:contactId 
                                                 LIMIT 1];
            sObjectMap.put('positions', positions);
            List<Formation_d_offre__c> trainings = [SELECT Catalogue_de_formation__r.FO_Nom_de_la_formation__c 
                                                    FROM Formation_d_offre__c 
                                                    WHERE Offre_d_emploi__c = :offers[0].Id 
                                                    ORDER BY Catalogue_de_formation__r.FO_Nom_de_la_formation__c DESC 
                                                    LIMIT 3];
            sObjectMap.put('trainings', trainings);
            List<Experience_d_offre__c> experiences = [SELECT Fiche_de_poste__r.Name, Duree_minimale__c 
                                                       FROM Experience_d_offre__c 
                                                       WHERE Offre_d_emploi__c = :offers[0].Id 
                                                       ORDER BY Fiche_de_poste__r.Name DESC 
                                                       LIMIT 3];
            sObjectMap.put('experiences', experiences);

            return sObjectMap;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Creates a position for the selected offer
     * @param  offerId   Id of the offer being applied for
     * @param  offerName Name of the offer being applied for
     * 
     * @return   Status of the creation
     */
    @RemoteAction
    public static String apply(String offerId, String offerName, String contactId) {
        Positionnement__c application = new Positionnement__c(
                CT_Candidate__c = contactId,
                CT_Job__c = offerId
                );

        try {
            if (
                Schema.sObjectType.Positionnement__c.isCreateable()
                && Schema.sObjectType.Positionnement__c.fields.CT_Candidate__c.isCreateable()
                && Schema.sObjectType.Positionnement__c.fields.CT_Job__c.isCreateable()
            ) {
                insert application;
                NotificationManager.createNotification(contactId, 
                        System.Label.SI_Notif_application_creation.replace('{0}', offerName), 'Création', 
                        'Positionnement__c', application.Id);
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            System.debug(e.getMessage()+ ' :'+e.getLineNumber());
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_application_creation.replace('{0}', e.getDmlMessage(0));
            }
            return System.Label.SI_Error_application_creation.replace('{0}', e.getMessage());
        }
    }
}