//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the training modules page
 */
public with sharing class VisualisationCatalogueController {
    public FO_catalogue_de_formation__c module {get; set;} //Retrieved training module and associated objects
    public List<FO_Session_collective__c> sessions {get; set;} //Training sessions for the current module
    public Boolean hasRequest {get; set;} //Whether the current user has pending training request for the current module
    public String contactId {get; set;}
    public String selectedType {get; set;} //Selected module type
    public String selectedOrganization {get; set;} //Selected module organization
    public String selectedMode {get; set;} //Selected module mode
    public String selectedEmployee {get; set;}

    public VisualisationCatalogueController() {
        contactId = [SELECT Contact__c From User WHERE Id = :UserInfo.getUserId()].Contact__c;
        String moduleId = ApexPages.currentPage().getParameters().get('id');
        if(moduleId != null && moduleId != '') {
            module = TrainingModuleRepository.getWithRequestsById(moduleId, contactId);
            sessions = VisualisationCatalogueController.getSessions(contactId, moduleId);
            hasRequest = VisualisationCatalogueController.hasRequest(contactId, moduleId);
        }
    }

    /**
     * Populates a select list with the types.
     * @return The types
     */
    public List<SelectOption> getTypes(){
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult aField = Schema.SObjectType.FO_catalogue_de_formation__c.fields.FO_Type__c;
        List<Schema.PicklistEntry> values = aField.getPickListValues();

        options.add(new SelectOption('', System.Label.List_all));
        for(Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel())); 
        }

        return options;
    }

    /**
     * Populates a select list with the organizations.
     * @return The organizations
     */
    public List<SelectOption> getOrganizations(){
        List<SelectOption> options = new List<SelectOption>();
        List<AggregateResult> organizations = [SELECT Id, Name 
                                               FROM Organisme_de_formation__c 
                                               GROUP BY Id, Name 
                                               ORDER BY Name ASC];
        options.add(new SelectOption('', System.Label.List_all)); 
        for (AggregateResult a : organizations) {
            options.add(new SelectOption(String.valueOf(a.get('Id')), String.valueOf(a.get('Name')))); 
        }

        return options;
    }

    /**
     * Populates a select list with the available Modes.
     * @return The Modes
     */
    public List<SelectOption> getModes(){
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult aField = Schema.SObjectType.FO_catalogue_de_formation__c.fields.Mode__c;
        List<Schema.PicklistEntry> values = aField.getPickListValues();
        options.add(new SelectOption('', System.Label.List_all));
        for (Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getValue(), a.getLabel())); 
        }

        return options;
    }

    /**
     * Returns contacts reporting to the current manager
     *       * 
     * @return List<Contact> List of contacts
     */
    public List<SelectOption> getEmployees() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', System.Label.List_self)); 
        for(Contact a : [SELECT Id, Name FROM Contact WHERE reportsToId =: contactId]) {
            options.add(new SelectOption(String.valueOf(a.get('Id')), String.valueOf(a.get('Name'))));
        }
        return options;
    }

    /**
     * Retrieves the available training sessions for the given training module
     * And, if selected, for the given contact
     * @param  employeeId Id of the contact for whom to check the availability
     * @param  moduleId   Id of the parent training module
     * @return   List<FO_Session_collective__c>
     */
    @RemoteAction
    public static List<FO_Session_collective__c> getSessions(String employeeId, String moduleId) {
        List<FO_Session_collective__c> sessions = new List<FO_Session_collective__c>();
        TrainingModule__c options = TrainingModule__c.getInstance();

        for(FO_Session_collective__c session: [SELECT Id, FO_Date_et_heure_de_debut__c, FO_Date_et_heure_de_fin__c, 
                                                       FO_Duree_en_heures__c, Lieu__c, toLabel(FO_Statut__c), 
                                                       FO_Formateur__r.Name, 
                                                       Nombre_max_de_participant__c,
                                               (SELECT Id 
                                                    FROM Participations_des_sessions_formations__r 
                                                    WHERE Action_de_formation__r.Contact__c = :employeeId)
                                               FROM FO_Session_collective__c 
                                               WHERE Catalogue_de_formation__c = :moduleId 
                                               ORDER BY FO_Date_et_heure_de_debut__c]) {
            if(options.showUnavailableSessions__c) {
                sessions.add(session);
            } else {
                AggregateResult timeCount = [SELECT COUNT(Id) 
                                             FROM Temps__c 
                                             WHERE Feuille_hebdo__r.Salarie__c = :employeeId 
                                             AND (Date_de_debut__c <= :session.FO_Date_et_heure_de_debut__c 
                                             AND Date_de_fin__c >= :session.FO_Date_et_heure_de_fin__c) 
                                             AND Valeur_type__c < 30];
                if(Integer.valueOf(timeCount.get('expr0')) == 0) sessions.add(session);
            }
        }

        return sessions;
    }

    /**
     * Checks if the given contact has a training request for the given training module
     * @param  employeeId Id of the contact for whom to check
     * @param  moduleId   Id of the module being checked
     * @return   Boolean
     */
    @RemoteAction
    public static Boolean hasRequest(String employeeId, String moduleId) {
        Integer count = TrainingRequestRepository.countPendingRequestByContactAndModule(employeeId, moduleId);
        if(count > 0) {
            return true;
        } else {
            return false;
        }
    }
}