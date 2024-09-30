//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Extension for the training ction page
 * @author Crosstalent
 * @group SIRH-Frontend
 */
public with sharing class VisualisationFormationExtension {

    private final Action_de_formation__c trainingAction;

    // The extension constructor initializes the private member
    // variable trainingAction by using the getRecord method from the standard
    // controller.
    public VisualisationFormationExtension(ApexPages.StandardController stdController) {
        List<String> fieldList = new List<String>{'Contact__c'};
        if(!Test.isRunningTest()) stdController.addFields(fieldList);
        this.trainingAction = (Action_de_formation__c)stdController.getRecord();
    }

    public List<Participation_session_formation__c> getTrainingRegistrations() {
        return TrainingRegistrationRepository.getAllActiveByAction(this.trainingAction.Id);
    }

    /**
     * Checks if the current user is the manager of the training action's owner
     * @return Boolean
     */
    public Boolean getIsManager() {
        try {
            Contact employee = [SELECT Id, reportsToId FROM Contact WHERE Id = :this.trainingAction.Contact__c];
            User currentUser = [SELECT Id 
                                FROM User 
                                WHERE Id = :UserInfo.getUserId() 
                                AND Contact__c = :String.valueOf(employee.reportsToId).left(15)];
            return true;
        } catch(Exception e) {
            return false;
        }
    }

    /**
     * Checks if the current user is the training action's owner
     * @return Boolean
     */
    public Boolean getIsCollab() {
        try {
            User currentUser = [SELECT Id 
                                FROM User 
                                WHERE Id = :UserInfo.getUserId() 
                                AND Contact__c = :String.valueOf(this.trainingAction.Contact__c).left(15)];
            return true;
        } catch(Exception e) {
            return false;
        }
    }
}