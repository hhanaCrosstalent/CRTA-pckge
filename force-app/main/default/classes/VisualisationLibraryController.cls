//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the library page
 * @author Crosstalent
 * @group SIRH-Frontend
 * @version 1.0
 */
public with sharing class VisualisationLibraryController {

    public List<Dossier_documentaire__c> publicRoots { get; set; }
    public List<Dossier_documentaire__c> privateRoots { get; set; }
    public String contactId { get; set; }

    public VisualisationLibraryController() {
        contactId = sirhTemplateController.contactId;
        publicRoots = [SELECT Id, Name, 
                       (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title 
                               FROM AttachedContentDocuments), 
                       (SELECT Id, Name, ContentType 
                               FROM Attachments 
                               ORDER BY Name) 
                       FROM Dossier_documentaire__c 
                       WHERE A_afficher__c = true 
                       AND Salarie__c = null 
                       AND Dossier_parent__c = null 
                       AND Date_de_publication__c <= TODAY 
                       AND (Date_de_fin_de_publication__c = null OR Date_de_fin_de_publication__c > TODAY) 
                       ORDER BY Name ASC];
        privateRoots = [SELECT Id, Name, 
                        (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title 
                                FROM AttachedContentDocuments), 
                        (SELECT Id, Name, ContentType 
                                FROM Attachments 
                                ORDER BY Name) 
                        FROM Dossier_documentaire__c 
                        WHERE A_afficher__c = true 
                        AND Salarie__c = :contactId 
                        AND Dossier_parent__c = null 
                        AND Date_de_publication__c <= TODAY 
                        AND (Date_de_fin_de_publication__c = null OR Date_de_fin_de_publication__c > TODAY) 
                        ORDER BY Name ASC];
    }

    /**
     * Retrieves public Dossier_documentaire__c for the given parent Id
     * @param  parentId Id of the parent Dossier_documentaire__c
     * @return   List<Dossier_documentaire__c>
     */
    @RemoteAction
    public static List<Dossier_documentaire__c> getPublicChildren(String parentId) {
        List<Dossier_documentaire__c> folders = [SELECT Id, Name, 
                                                 (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title 
                                                         FROM AttachedContentDocuments), 
                                                 (SELECT Id, Name, ContentType 
                                                         FROM Attachments 
                                                         ORDER BY Name) 
                                                 FROM Dossier_documentaire__c 
                                                 WHERE A_afficher__c = true 
                                                 AND Salarie__c = null 
                                                 AND Dossier_parent__c = :parentId 
                                                 AND Date_de_publication__c <= TODAY 
                                                 AND (Date_de_fin_de_publication__c = null OR Date_de_fin_de_publication__c > TODAY) 
                                                 ORDER BY Name ASC];

        return folders;
    }

    /**
     * Retrieves private Dossier_documentaire__c for the given parent Id and employee Id
     * @param  parentId Id of the parent Dossier_documentaire__c
     * @param  contactId Id of the employee
     * @return   List<Dossier_documentaire__c>
     */
    @RemoteAction
    public static List<Dossier_documentaire__c> getPrivateChildren(String parentId, String contactId) {
        List<Dossier_documentaire__c> folders = [SELECT Id, Name, 
                                                 (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title 
                                                         FROM AttachedContentDocuments), 
                                                 (SELECT Id, Name, ContentType 
                                                         FROM Attachments ORDER BY Name) 
                                                 FROM Dossier_documentaire__c 
                                                 WHERE A_afficher__c = true 
                                                 AND Salarie__c = :contactId 
                                                 AND Dossier_parent__c = :parentId 
                                                 AND Date_de_publication__c <= TODAY 
                                                 AND (Date_de_fin_de_publication__c = null OR Date_de_fin_de_publication__c > TODAY) 
                                                 ORDER BY Name ASC];
        return folders;
    }
}