//Security isCreateable() isUpdateable() isDeletable() checked
public with sharing class TrainingRegistrationHandler {
    
    // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
    // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
    private Boolean m_isExecuting = false;
    private Integer BatchSize = 0;

    public TrainingRegistrationHandler(Boolean isExecuting, Integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(Participation_session_formation__c[] newTrainingRegistrations){
    }

    public void OnAfterInsert(Participation_session_formation__c[] newTrainingRegistrations){
        Map<Id, List<Participation_session_formation__c>> actionToSessions 
            = TrainingRegistrationHandler.constructRegistrationMap(newTrainingRegistrations);
        List<Action_de_formation__c> trainingActions 
            = TrainingRegistrationHandler.getTrainingActions(actionToSessions.keySet());

        trainingActions = TrainingRegistrationHandler.fillTrainingActionsDates(trainingActions, actionToSessions);
        if (Schema.sObjectType.Action_de_formation__c.isUpdateable()) {
            try {
                Database.SaveResult[] srList = Database.update(trainingActions, false);
                for(Database.SaveResult sr : srList) {
                    if(!sr.isSuccess()) {
                        // Operation failed, so get all errors
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Training actions fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        } else {
            
        }
    }

    @future
    public static void OnAfterInsertAsync(Set<ID> newTrainingRegistrationsIDs) {
    }

    public void OnBeforeUpdate(Participation_session_formation__c[] oldTrainingRegistrations, 
                            Participation_session_formation__c[] updatedTrainingRegistrations, 
                            Map<ID, Participation_session_formation__c> TrainingRegistrationsMap) {
    }

    public void OnAfterUpdate(Participation_session_formation__c[] oldTrainingRegistrations, 
                            Participation_session_formation__c[] updatedTrainingRegistrations, 
                            Map<ID, Participation_session_formation__c> TrainingRegistrationsMap) {
    }

    @future 
    public static void OnAfterUpdateAsync(Set<ID> updatedTrainingRegistrationsIDs) {
    }

    public void OnBeforeDelete(Participation_session_formation__c[] TrainingRegistrationsToDelete, 
                Map<ID, Participation_session_formation__c> TrainingRegistrationsMap) {
    }

    public void OnAfterDelete(Participation_session_formation__c[] deletedTrainingRegistrations, 
            Map<ID, Participation_session_formation__c> TrainingRegistrationsMap) {
    }

    @future 
    public static void OnAfterDeleteAsync(Set<Id> deletedTrainingRegistrationsIDs) {
    }

    public void OnUndelete(Participation_session_formation__c[] restoredTrainingRegistrations) {
    }

    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }

    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }

    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }

    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }

    public static List<Action_de_formation__c> getTrainingActions(Set<Id> trainingActionsIds) {
        return [SELECT Id, Date_et_heure_de_debut__c, Date_et_heure_de_fin__c 
                FROM Action_de_formation__c 
                WHERE Id IN :trainingActionsIds];
    }

    /**
     * Creates a map of training registration and their parent training action
     * @param  trainingRegistrations List of training registration to convert
     * @return Map<Id , List<Participation_session_formation__c>>                      
     */
    public static Map<Id , List<Participation_session_formation__c>> constructRegistrationMap(
            List<Participation_session_formation__c> trainingRegistrations) {
        Map<Id, List<Participation_session_formation__c>> actionToSessions 
            = new Map<Id, List<Participation_session_formation__c>>();
        for(Participation_session_formation__c session: trainingRegistrations) {
            if(actionToSessions.containsKey(session.Action_de_formation__c)) {
                List<Participation_session_formation__c> tempList 
                    = actionToSessions.get(session.Action_de_formation__c);
                tempList.add(session);
                actionToSessions.put(session.Action_de_formation__c, tempList);
            } else {
                List<Participation_session_formation__c> tempList = new List<Participation_session_formation__c>();
                tempList.add(session);
                actionToSessions.put(session.Action_de_formation__c, tempList);
            }
        }

        return actionToSessions;
    }

    /**
     * Fills out training actions dates from their associated training registrations
     * @param  trainingActions  List of training actions to update
     * @param  actionToSessions Map of training action and their training registration children
     * @return List<Action_de_formation__c>
     */
    public static List<Action_de_formation__c> fillTrainingActionsDates(List<Action_de_formation__c> trainingActions, 
                Map<Id, List<Participation_session_formation__c>> actionToSessions) {
        for(Action_de_formation__c action: trainingActions) {
            List<Participation_session_formation__c> registrationsList 
                = new List<Participation_session_formation__c>();
            registrationsList = actionToSessions.get(action.Id);
            for(Participation_session_formation__c registration: registrationsList) {
                if(action.Date_et_heure_de_debut__c == null 
                   || registration.FO_Date_et_heure_de_debut__c < action.Date_et_heure_de_debut__c) {
                    action.Date_et_heure_de_debut__c = registration.FO_Date_et_heure_de_debut__c;
                } 
                if(action.Date_et_heure_de_fin__c == null 
                   || registration.FO_Date_et_heure_de_fin__c > action.Date_et_heure_de_fin__c) {
                    action.Date_et_heure_de_fin__c = registration.FO_Date_et_heure_de_fin__c;
                } 
            } 
        }
        return trainingActions;
    }
}