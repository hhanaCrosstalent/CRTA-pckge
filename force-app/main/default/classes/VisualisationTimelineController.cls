//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller of the timeline page VisualisationTimeline
 */
public with sharing class VisualisationTimelineController {

    public List<EI_Entretien__c> entretiens { get; set; } //List of the contact's interviews
    public List<Formation__c> formations { get; set; } //List of the contact's trainings
    public List<Participation_session_formation__c> registrations { get; set; } //List of the contact's trainings' registration
    public List<Feuille_Temps_Hebdo__c> weeks { get; set; } //List of the contact's timesheets
    public List<Note_de_frais__c> expenses { get; set; } //List of the contact's timesheets
    public Map<String, Double> expenseAmount { get; set; } //List of the contact's timesheets
    public List<String> sortedDates { get; set; } //Sorted list of the mixed objects date
    public Map<String, List<sObject>> dateToObject {get; set; } //Map to match a date to an object
    public String contactId {get; set; } //Id of the logged contact

    /**
     * Retrieves the interviews, trainings, expenses and times of the logged in user and blends them chronologically
     */
    public VisualisationTimelineController() {
        Sirh__c options = Sirh__c.getInstance(UserInfo.getUserId());
        EI__c entretienOptions = EI__c.getInstance(UserInfo.getUserId());
        dateToObject = new Map<String, List<sObject>>();
        expenseAmount = new Map<String, Double>();
        List<String> dates = new List<String>();

        // TODO: the test should not necessitate a specific contactId
        if(Test.isRunningTest()) {
            contactId = [SELECT Id FROM Contact WHERE Lastname = 'BAYER'].Id;
        } else {
            contactId = sirhTemplateController.contactId;
        }

        if(options.showInterviews__c) { //Retrieves the interviews if the corresponding option is checked
            List<String> interviewFields = new List<String>{'EI_Statut_value__c', 
                'EI_Salarie_qui_fait_passer_l_entretien__c', 'Manager__c',
                'EI_Salarie_qui_passe_l_entretien__r.Name', 'EI_Date_de_l_entretien__c', 
                'EI_Modele_d_entretien__r.Name', 'toLabel(EI_Statut__c)',
                'EI_Duree_de_l_entretien__c'};
            if(entretienOptions.useDate__c) {
                entretiens = InterviewRepository.getAllOpenedByContactForFields(contactId, interviewFields);
            } else {
                entretiens = InterviewRepository.getAllByContactForFields(contactId, interviewFields);
            }
            for(EI_Entretien__c entretien: entretiens) {
                if(dateToObject.containsKey(String.valueOf(entretien.EI_Date_de_l_entretien__c))) {
                    dateToObject.get(String.valueOf(entretien.EI_Date_de_l_entretien__c)).add(entretien);
                } else {
                    List<SObject> sObjectList = new List<SObject>();
                    sObjectList.add(entretien);
                    dateToObject.put(String.valueOf(entretien.EI_Date_de_l_entretien__c), sObjectList);
                    dates.add(String.valueOf(entretien.EI_Date_de_l_entretien__c));
                }
            }
        }
        if(options.showTrainings__c) { //Retrieves the trainings if the corresponding option is checked
            List<String> trainingFields = new List<String>{'FO_Nom_de_la_formation__c', 'FO_statut_value__c', 
                'CT_Start_date__c', 'toLabel(FO_Type__c)', 'toLabel(FO_Statut__c)',
                'FO_Catalogue_de_formation__r.FO_organisme_de_formation__r.Name', 
                'FO_Catalogue_de_formation__r.FO_Duree__c', 'FO_Catalogue_de_formation__r.FO_Lieu__c'};
            formations = TrainingRepository.getAllByContactForFields(contactId, trainingFields);
            for(Formation__c formation: formations) {
                if(dateToObject.containsKey(String.valueOf(formation.CT_Start_date__c))) {
                    dateToObject.get(String.valueOf(formation.CT_Start_date__c)).add(formation);
                } else {
                    List<SObject> sObjectList = new List<SObject>();
                    sObjectList.add(formation);
                    dateToObject.put(String.valueOf(formation.CT_Start_date__c), sObjectList);
                    dates.add(String.valueOf(formation.CT_Start_date__c));
                }
            }

            registrations = TrainingRegistrationRepository.getAllActiveByContact(contactId);
            for(Participation_session_formation__c registration: registrations) {
                if(dateToObject.containsKey(String.valueOf(registration.FO_Date_et_heure_de_debut__c))) {
                    dateToObject.get(String.valueOf(registration.FO_Date_et_heure_de_debut__c)).add(registration);
                } else {
                    List<SObject> sObjectList = new List<SObject>();
                    sObjectList.add(registration);
                    dateToObject.put(String.valueOf(registration.FO_Date_et_heure_de_debut__c), sObjectList);
                    dates.add(String.valueOf(registration.FO_Date_et_heure_de_debut__c));
                }
            }
        }
        if(options.showTimes__c) { //Retrieves the timesheets if the corresponding option is checked
            weeks = TimesheetRepository.getAllByContact(contactId);
            for(Feuille_Temps_Hebdo__c week: weeks) {
                if(dateToObject.containsKey(String.valueOf(week.Date_debut_semaine__c))) {
                    dateToObject.get(String.valueOf(week.Date_debut_semaine__c)).add(week);
                } else {
                    List<SObject> sObjectList = new List<SObject>();
                    sObjectList.add(week);
                    dateToObject.put(String.valueOf(week.Date_debut_semaine__c), sObjectList);
                    dates.add(String.valueOf(week.Date_debut_semaine__c));
                }
            }
        }
        if(options.showExpenses__c) { //Retrieves the expenses if the corresponding option is checked
            expenses = ExpensesRepository.getAllByContact(contactId);
            List<AggregateResult> expenseAmountAgg 
                = ExpenseLineRepository.countAmountByContactGroupByExpenses(contactId);
            String fieldName = Frais__c.Note_de_frais__c.getDescribe().getName();
            for(AggregateResult amount: expenseAmountAgg) {
                expenseAmount.put(String.valueOf(amount.get(fieldName)), Double.valueOf(amount.get('expr0')));
            }
            for(Note_de_frais__c expense: expenses) {
                if(dateToObject.containsKey(String.valueOf(expense.Date_de_debut__c))) {
                    dateToObject.get(String.valueOf(expense.Date_de_debut__c)).add(expense);
                } else {
                    List<SObject> sObjectList = new List<SObject>();
                    sObjectList.add(expense);
                    dateToObject.put(String.valueOf(expense.Date_de_debut__c), sObjectList);
                    dates.add(String.valueOf(expense.Date_de_debut__c));
                }
                //Setting the expenses amount to 0 if no amount was found
                if(!expenseAmount.containsKey(expense.Id)) expenseAmount.put(expense.Id, 0);
            }
        }

        //Sort the mixed objects by date descending
        dates.sort();
        sortedDates = new List<String>();
        for(Integer i = dates.size()-1; i>=0; i--) {
            sortedDates.add(dates.get(i));
        }
    }

    /**
     * Remote action to mark the joyride plugin has finished
     * @return String Status of the update or an error message
     */
    @RemoteAction
    public static String finishJoyride() {
        try {
            User currentUser = [SELECT Id, hasJoyride__c FROM User WHERE Id = :UserInfo.getUserId()];

            if (
                Schema.sObjectType.User.isUpdateable()
                && Schema.sObjectType.User.fields.hasJoyride__c.isUpdateable()
            ) {
                currentUser.hasJoyride__c = true;
                update currentUser;
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_joyride_finish.replace('{0}', e.getDmlMessage(0));
            }
            return System.Label.SI_Error_joyride_finish.replace('{0}', e.getMessage());
        }
    }
}