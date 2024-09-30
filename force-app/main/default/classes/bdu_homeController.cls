//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the homepage of the BDU frontend
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.0
 */
public with sharing class bdu_homeController {
    
    public String page {set; get;}

    /**
     * Retrieve the homepage text from a custom setting
     */
    public bdu_homeController() {
        page = Override__c.getInstance().CT_Home__c;
    }

    /**
     * Remote action to mark the joyride plugin as finished
     * @return String Status of the update or an error message
     */
    @RemoteAction
    public static String finishJoyride() {
        try {
            User currentUser = [SELECT Id, hasJoyrideBDU__c FROM User WHERE Id =: UserInfo.getUserId()];
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
            System.debug(e.getMessage());
            if(e.getTypeName() == 'System.DmlException') {
                return System.Label.SI_Error_joyride_finish.replace('{0}', e.getDmlMessage(0));
            }
            return System.Label.SI_Error_joyride_finish.replace('{0}', e.getMessage());
        }
    }
}