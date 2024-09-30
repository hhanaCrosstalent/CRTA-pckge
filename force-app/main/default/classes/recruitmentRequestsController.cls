//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller to only display Job offers set as 'Demande de recrutement'
 * 
 * @author Crosstalent
 * @group Recrutement
 * @version 1.0
 */
public with sharing class recruitmentRequestsController {
    public ApexPages.StandardSetController ctrl {get; set;}
    public String selectedView {get; set;}

    public recruitmentRequestsController(ApexPages.StandardSetController controller) {
        ctrl = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id FROM Offre_d_emploi__c LIMIT 1]));
        for(SelectOption res : ctrl.getListViewOptions() ) {
            if(selectedView==null && res.getLabel().equals('Demande de recrutement')) {
                selectedView = res.getValue().substring(0,15);
                break;
            }
        }
    }
}