//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the team page
 * @author Crosstalent
 * @group SIRH-Frontend
 */
public with sharing class VisualisationEquipeController {

    public List<Contact> employees { get; set; }

    /**
     * Retrieves a manager's employees and their children objects
     */
    public VisualisationEquipeController() {
        String contactId = SirhTemplateController.contactId;
        Organigramme__c options = Organigramme__c.getInstance();
        if(contactId != null) {
            if(options.Display_ex_employees__c) {
                employees = [SELECT Id, Title, CT_Service__c, Categorie_professionnelle__c, CT_Matricule__c,
                             LastName, Name, CT_Date_of_entry_to_the_society__c,
                             (SELECT Id FROM Entretiens_passes__r),
                             (SELECT Id FROM Entretiens_diriges__r),
                             (SELECT Id FROM Actions_de_formation__r),
                             (SELECT Id FROM Demandes_de_conges__r), (SELECT Id FROM Feuilles_de_temps__r),
                             (SELECT Id FROM Attachments WHERE Name LIKE '%contact_frontend_picture')
                             FROM contact
                             WHERE ReportsTo.Id = :contactId
                             OR ReportsTo.ReportsTo.Id = :contactId
                             OR ReportsTo.ReportsTo.ReportsTo.Id = :contactId
                             ORDER BY LastName];
            } else {
                employees = [SELECT Id, Title, CT_Service__c, Categorie_professionnelle__c, CT_Matricule__c,
                             LastName, Name, CT_Date_of_entry_to_the_society__c,
                             (SELECT Id FROM Entretiens_passes__r), (SELECT Id FROM Entretiens_diriges__r),
                             (SELECT Id FROM Actions_de_formation__r),
                             (SELECT Id From Demandes_de_conges__r), (SELECT Id FROM Feuilles_de_temps__r),
                             (SELECT Id From Attachments
                                     WHERE Name LIKE '%contact_frontend_picture')
                             FROM contact
                             WHERE (ReportsTo.Id = :contactId 
                                        OR ReportsTo.ReportsTo.Id = :contactId 
                                        OR ReportsTo.ReportsTo.ReportsTo.Id = :contactId)
                             AND (CT_Exit_date__c = null OR CT_Exit_date__c >= TODAY)
                             ORDER BY LastName];
            }
        }
    }
}