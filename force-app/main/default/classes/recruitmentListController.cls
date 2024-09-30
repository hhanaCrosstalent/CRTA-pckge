//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller to only display contacts set as Candidates
 * 
 * @author Crosstalent
 * @group Recrutement
 */
public with sharing class recruitmentListController {

    public ApexPages.StandardSetController contactsController {get; set;}
    public String view  {get; set;}

    public recruitmentListController(ApexPages.StandardSetController controller) {
        contactsController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name 
                                                                                           FROM Contact 
                                                                                           LIMIT 1]));
        for(SelectOption res : contactsController.getListViewOptions() ) {
            if(res.getLabel().equals('Candidats')) {
                view = res.getValue().substring(0,15);
                break;
            }
        }
    }
}