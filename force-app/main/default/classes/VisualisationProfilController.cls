//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the contact detail page
 * @author Crosstalent
 * @group SIRH-Frontend
 * @version 1.9
 */
public with sharing class VisualisationProfilController {
    public Contact loggedContact{ get; set; }
    public String hrManager { get; set; }
    public List<GS_Affectation_poste__c> postes {get; set; }
    public List<EI_Entretien__c> entretiens { get; set; }
    public List<Action_de_formation__c> trainingActions { get; set; }
    public List<Demande_de_formation__c> trainingRequests { get; set; }
    public List<Feuille_Temps_Hebdo__c> weeks { get; set; }
    public String selectedLeaveType { get; set; }
    public String selectedLeavePeriod { get; set; }

    /**
     * Retrieves the wanted contact if specified or the logged one and its associated interviews, trainings and jobs
     */
    public VisualisationProfilController() {
        String contactId;
        EI__c options = EI__c.getInstance();
        if(ApexPages.currentPage().getParameters().get('id') != null) {
            contactId = ApexPages.currentPage().getParameters().get('id');
        } else {
            contactId = sirhTemplateController.contactId;
        }
        try {
            loggedContact = [SELECT Id, Salutation, FirstName, LastName, Name, Sexe__c, Categorie_professionnelle__c, 
                            Numero_de_ss__c, Situation_familiale__c, Department, Birthdate, 
                            MailingStreet, MailingCity, MailingPostalCode, MailingCountry, OtherStreet, 
                            OtherPostalCode, OtherCity, OtherCountry, Email, Title, Description, CT_Service__c, Phone, 
                            OtherPhone, HomePhone, MobilePhone, CT_Matricule__c, CT_Date_of_entry_to_the_society__c, 
                            ReportsTo.Name, Superieur__c, Responsable_rh__r.Name, Conges_acquis_n_1__c, 
                            Conges_acquis_n__c, Repos_compensateurs_acquis__c, Conges_pris_n_1__c, Conges_pris_n__c, 
                            Repos_compensateurs_pris__c, Conges_solde_n_1__c, Conges_solde_n__c, 
                            Repos_compensateurs_solde__c 
                        FROM Contact 
                        WHERE Id =: contactId 
                        LIMIT 1];
            //To circumvent this bug https://developer.salesforce.com/forums/ForumsMain?id=906F0000000A6WsIAK
            hrManager = loggedContact.Responsable_RH__r.Name;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        if(options.useDate__c) {
            //entretiens = [SELECT Id, Name, EI_Salarie_qui_fait_passer_l_entretien__r.Name, Manager__c , EI_Salarie_qui_passe_l_entretien__r.Name, EI_Salarie_qui_passe_l_entretien__r.Id, toLabel(EI_Statut__c), EI_Statut_value__c, EI_Statut_texte__c, EI_Date_de_l_entretien__c, EI_Duree_de_l_entretien__c, EI_Lieu__c, EI_Modele_d_entretien__r.Name FROM EI_Entretien__c WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId AND Date_d_ouverture__c <= TODAY ORDER BY EI_Date_de_l_entretien__c DESC];
            entretiens = InterviewRepository.getAllOpenedByEmployee(contactId);
        } else {
            //entretiens = [SELECT Id, Name, EI_Salarie_qui_fait_passer_l_entretien__r.Name, Manager__c , EI_Salarie_qui_passe_l_entretien__r.Name, EI_Salarie_qui_passe_l_entretien__r.Id, toLabel(EI_Statut__c), EI_Statut_value__c, EI_Statut_texte__c, EI_Date_de_l_entretien__c, EI_Duree_de_l_entretien__c, EI_Lieu__c, EI_Modele_d_entretien__r.Name FROM EI_Entretien__c WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId ORDER BY EI_Date_de_l_entretien__c DESC];
            entretiens = InterviewRepository.getAllByEmployee(contactId);
        }
        trainingActions = TrainingActionRepository.getAllByContact(contactId);
        trainingRequests = TrainingRequestRepository.getAllByContact(contactId);
        postes = [SELECT Id, GS_date_de_debut__c,GS_date_de_fin__c, GS_fiche_de_poste__c, GS_fiche_de_poste__r.Id, 
                         GS_fiche_de_poste__r.Name 
                  FROM GS_affectation_poste__c 
                  WHERE GS_salarie__c = :contactId 
                  ORDER BY GS_date_de_debut__c DESC];
        weeks = TimesheetRepository.getAllByContact(contactId);
    }

    /**
     * Populates a select list with the types of leave.
     * @return The types
     */
    public List<SelectOption> getLeaveTypes() {
        return LeaveManager.getLeaveTypes();
    }

    /**
     * Populates a select list with the periods.
     * @return The periods
     */
    public List<SelectOption> getLeavePeriods() {
        return LeaveManager.getLeavePeriods();
    }
}