//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the ticket page
 * @author Crosstalent
 * @group SIRH-Frontend
 * @version 1.0
 */
public with sharing class VisualisationTicketController {
    public Demande__c ticket {get; set;} //Retrieved ticket
    public Demande__c mockTicket {get; set;}
    public String contactId {get; set;}
    public String selectedType {get; set;} //Selected ticket type
    public String selectedModule {get; set;} //Selected ticket module
    public String selectedPriority {get; set;} //Selected ticket priority

    public VisualisationTicketController() {
        contactId = [SELECT Contact__c FROM User WHERE Id = :UserInfo.getUserId()].Contact__c;
        mockTicket = new Demande__c();
        String ticketId = ApexPages.currentPage().getParameters().get('id');
        if(ticketId != null && ticketId != '') ticket = TicketRepository.getById(ticketId);
    }
}