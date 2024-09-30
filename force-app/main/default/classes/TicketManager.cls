//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Manager class for the Demande__c object
* @author Crosstalent
* @group SIRH-Manager
* @version 1.0
*/
global with sharing class TicketManager {
    /**
* Creates a Demande__c object
* @param  name        Name of the ticket
* @param  module      Which module is concerned
* @param  type        Type of ticket
* @param  description Body of the ticket
* @param  contactId   Id of the contact asking the ticket
* @return   'success' or an error message
*/
    webService static String saveTicket(String name, String module, String type, String description, String contactId) {
        try {
            Demande__c ticket = new Demande__c(
                Intitule__c = name,
                Module__c = module,
                Type__c = type,
                Description__c = description,
                Salarie__c = contactId
            );
            if (
                Schema.sObjectType.Demande__c.isCreateable()
                && Schema.sObjectType.Demande__c.fields.Intitule__c.isCreateable()
                && Schema.sObjectType.Demande__c.fields.Module__c.isCreateable()
                && Schema.sObjectType.Demande__c.fields.Type__c.isCreateable()
                && Schema.sObjectType.Demande__c.fields.Description__c.isCreateable()
                && Schema.sObjectType.Demande__c.fields.Salarie__c.isCreateable()
            ) {
                insert ticket;
                String s = System.Label.SI_Notif_Ticket_creation.replace('{0}', name).replace('{1}', module);
                NotificationManager.createNotification(contactId, s, 'Création', ticket.Id);
                
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_creation.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_creation.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_creation.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_creation.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Updates a Demande__c object
* @param  name        Name of the ticket
* @param  module      Which module is concerned
* @param  type        Type of ticket
* @param  description Body of the ticket
* @param  status Status of the ticket
* @param  response (Optional) Response to the ticket
* @param  priority (Optional) Priority of the ticket
* @param  userId (Optional) Id of the assigned user
* @param  ticketId   Id of the ticket to update
* @return   'success' or an error message
*/
    webService static String editTicket(
        String name, String module, String type, String description, String status,
        String response, String priority, String userId, String ticketId
    ) {
        try {
            Demande__c ticket = TicketRepository.getUntranslatedById(ticketId);
            
            if (
                Schema.sObjectType.Demande__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Intitule__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Module__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Type__c.isUpdateable()
            ) {
                ticket.Intitule__c = name;
                ticket.Module__c = module;
                ticket.Type__c = type;
                ticket.Statut__c = status;

                if(
                    description != null && description != ''
                    && Schema.sObjectType.Demande__c.fields.Description__c.isUpdateable()
                ) {
                    ticket.Description__c = description;
                }
                if(
                    response != null && response != ''
                    && Schema.sObjectType.Demande__c.fields.Reponse__c.isUpdateable()
                ) {
                    ticket.Reponse__c = response;
                }
                if(
                    priority != null && priority != ''
                    && Schema.sObjectType.Demande__c.fields.Priorite__c.isUpdateable()
                ) {
                    ticket.Priorite__c = priority;
                }
                if(
                    userId != null && userId != ''
                    && Schema.sObjectType.Demande__c.fields.Attribution__c.isUpdateable()
                ) {
                    ticket.Attribution__c = userId;
                }
                
                update ticket;
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_edit.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_edit.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_edit.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_edit.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Returns a Demande__c object
* @param  response Body of the response
* @param  ticketId   Id of the ticket to return
* @return   'success' or an error message
*/
    webService static String returnTicket(String response, String ticketId) {
        try {
            Demande__c ticket = TicketRepository.getUntranslatedById(ticketId);
			if (
                Schema.sObjectType.Demande__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Reponse__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Statut__c.isUpdateable()
            ) {            
                ticket.Reponse__c = response;
                ticket.Statut__c = '15 Retournée';            
                update ticket;
                
                String s = System.Label.SI_Notif_Ticket_return.replace('{0}', ticket.Intitule__c).replace('{1}', ticket.Module__c);
                NotificationManager.createNotification(ticket.Salarie__c, s, 'Information', ticket.Id);
                
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_return.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_return.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_return.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_return.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Closes a Demande__c object
* @param  response Body of the response
* @param  ticketId   Id of the ticket to close
* @return   'success' or an error message
*/
    webService static String closeTicket(String response, String ticketId) {
        try {
            Demande__c ticket = TicketRepository.getUntranslatedById(ticketId);
			if (
                Schema.sObjectType.Demande__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Reponse__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Statut__c.isUpdateable()
            ) {        
                ticket.Reponse__c = response;
                ticket.Statut__c = '50 Traitée';
                
                update ticket;
                String s = System.Label.SI_Notif_Ticket_close.replace('{0}', ticket.Intitule__c).replace('{1}', ticket.Module__c);
                NotificationManager.createNotification(ticket.Salarie__c, s, 'Information', ticket.Id);
                
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_close.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_close.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_close.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_close.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Rejects a Demande__c object
* @param  response Body of the response
* @param  ticketId   Id of the ticket to reject
* @return   'success' or an error message
*/
    webService static String rejectTicket(String response, String ticketId) {
        try {
            Demande__c ticket = TicketRepository.getUntranslatedById(ticketId);
			if (
                Schema.sObjectType.Demande__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Reponse__c.isUpdateable()
                && Schema.sObjectType.Demande__c.fields.Statut__c.isUpdateable()
            ) {        
                ticket.Reponse__c = response;
                ticket.Statut__c = '60 Rejetée';
                
                update ticket;
                String s = System.Label.SI_Notif_Ticket_reject.replace('{0}', ticket.Intitule__c).replace('{1}', ticket.Module__c);
                NotificationManager.createNotification(ticket.Salarie__c, s, 'Information', ticket.Id);
                
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_reject.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_reject.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_reject.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_reject.replace('{0}', e.getMessage());
        }
    }
    
    /**
* Deletes a Demande__c object
* @param  ticketId   Id of the ticket to return
* @return   'success' or an error message
*/
    webService static String deleteTicket(String ticketId) {
        try {
            Demande__c ticket = TicketRepository.getUntranslatedById(ticketId);
			if (
                Schema.sObjectType.Demande__c.isDeletable()
            ) {        
                delete ticket;
                
                return 'success';
            } else {
                return System.Label.Permission; 
            }
        } catch(Exception e) {
            if(e.getTypeName() == 'System.DmlException') {
                System.debug(System.Label.SI_Error_ticket_delete.replace('{0}', e.getDmlMessage(0)));
                return System.Label.SI_Error_ticket_delete.replace('{0}', e.getDmlMessage(0));
            } 
            System.debug(System.Label.SI_Error_ticket_delete.replace('{0}', e.getMessage()));
            return System.Label.SI_Error_ticket_delete.replace('{0}', e.getMessage());
        }
    }
}