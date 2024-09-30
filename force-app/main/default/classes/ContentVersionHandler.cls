//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/12/2019 
**/
public without sharing class ContentVersionHandler {
	private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<ContentVersion> triggerNew;
    private Map<Id, ContentVersion> triggerNewMap;
    private List<ContentVersion> triggerOld;
    private Map<Id, ContentVersion> triggerOldMap;
    private Integer size;

    public ContentVersionHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<ContentVersion> triggerNew,
        Map<Id, ContentVersion> triggerNewMap,
        List<ContentVersion> triggerOld,
        Map<Id, ContentVersion> triggerOldMap,
        Integer size
    ) {
        this.isExecuting = isExecuting;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.triggerNew = triggerNew;
        this.triggerNewMap = triggerNewMap;
        this.triggerOld = triggerOld;
        this.triggerOldMap = triggerOldMap;
        this.size = size;
    }

    public void handleTrigger() {
        if(this.isAfter) {
            if(this.isInsert) {
                shareFiles();
            } else if(this.isUpdate) {
                shareFiles();
                //createContentDistribution();
            }
        }
    }

    private void shareFiles() {
        Set<String> contentDocumentsId = new Set<String>();
        for(ContentVersion cv : this.triggerNew) {
            contentDocumentsId.add(cv.ContentDocumentId);
        }

        Set<String> alreadyIn = new Set<String>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        for(ContentDocumentLink cdl : [
            SELECT Id,
                ContentDocumentId,
                LinkedEntityId,
                LinkedEntity.Type
            FROM ContentDocumentLink
            WHERE ContentDocumentId IN:contentDocumentsId
        ]) {
            if(cdl.LinkedEntity.Type == 'crta__Dossier_documentaire__c' ||
                cdl.LinkedEntity.Type == 'Contact') {
                if(!alreadyIn.contains(cdl.ContentDocumentId)) {
                    cdlList.add(cdl);
                    alreadyIn.add(cdl.ContentDocumentId);
                }
            }
        }
        System.debug('hier');
        System.debug(cdlList);
        ContentDocumentLinkHandler.manageSharing(cdlList);
    }
}