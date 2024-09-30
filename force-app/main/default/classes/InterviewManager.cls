//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Manager class for the EI_Entretien__c object
 * @author Crosstalent
 * @group SIRH-Manager
 */
global with sharing class InterviewManager {
    /**
     * Deletes a EI_Entretien__c object
     * @param  interviewId Id of the EI_Entretien__c to delete
     * @return   String      'success' or an error message
     */
    webService static String deleteInterview(String interviewId) {
        try {
            EI_Entretien__c interview = InterviewRepository.getById(interviewId);
            if (
                Schema.sObjectType.EI_Entretien__c.isDeletable()
            ) {
                delete interview;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_interview_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_interview_delete.replace('{0}', e.getDmlMessage(0));
            }
            System.debug(System.Label.SI_Error_interview_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_interview_delete.replace('{0}', e.getMessage());
        }
    }
}