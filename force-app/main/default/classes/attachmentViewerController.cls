//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for displaying an embedded document
 * 
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.1
 */
public with sharing class attachmentViewerController {
    public Attachment attach { set; get; }
    public ContentVersion file { set; get; }

    public attachmentViewerController() {
        if(ApexPages.CurrentPage().getParameters().get('isFile') == null) {
            try {
                attach =  [SELECT Id, Body, ParentId
                           FROM Attachment
                           WHERE Id = :ApexPages.CurrentPage().getParameters().get('id') LIMIT 1];
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        } else {
            try {
                file =  [SELECT Id
                         FROM Contentversion
                         WHERE Contentdocumentid=:ApexPages.CurrentPage().getParameters().get('id')
                         AND IsLatest=true];
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
}