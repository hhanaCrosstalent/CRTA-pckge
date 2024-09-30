//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/12/2019 
**/
public without sharing class ContentDocumentLinkHandler {
	private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<ContentDocumentLink> triggerNew;
    private Map<Id, ContentDocumentLink> triggerNewMap;
    private List<ContentDocumentLink> triggerOld;
    private Map<Id, ContentDocumentLink> triggerOldMap;
    private Integer size;

    public ContentDocumentLinkHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<ContentDocumentLink> triggerNew,
        Map<Id, ContentDocumentLink> triggerNewMap,
        List<ContentDocumentLink> triggerOld,
        Map<Id, ContentDocumentLink> triggerOldMap,
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
            }
        }
    }

    private void shareFiles() {
        ContentDocumentLinkHandler.manageSharing(this.triggerNew);
    }

    public static void manageSharing(List<ContentDocumentLink> cdlList) {
        Map<String, ContentVersion> versionByContentDocumentId = new Map<String, ContentVersion>();
        Set<String> contentDocumentsId = new Set<String>();
        Set<String> linkedEntityIds = new Set<String>();

        for(ContentDocumentLink cdl : cdlList) {
            if(String.valueOf(cdl.LinkedEntityId.getSobjectType()) == 'crta__Dossier_documentaire__c'
            || String.valueOf(cdl.LinkedEntityId.getSobjectType()) == 'Contact') {
                contentDocumentsId.add(cdl.ContentDocumentId);
                linkedEntityIds.add(cdl.LinkedEntityId);
            }
        }

        for(ContentVersion cv : [
            SELECT Id,
                crta__Type__c,
                ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId IN: contentDocumentsId
            AND crta__Hide_in_Portal__c = FALSE
        ]) {
            versionByContentDocumentId.put(cv.ContentDocumentId, cv);
        }

        Set<String> alreadyIn = new Set<String>();
        for(ContentDistribution d : [
            SELECT Id,
                RelatedRecordId,
                ContentDocumentId
            FROM ContentDistribution
            WHERE RelatedRecordId IN: linkedEntityIds
        ]) {
            alreadyIn.add(d.ContentDocumentId);
        }

        List<ContentDistribution> toInsert = new List<ContentDistribution>();
        for(ContentDocumentLink cdl : cdlList) {
            System.debug('H');
            if(versionByContentDocumentId.size() > 0) {
                System.debug('H');
                if(!alreadyIn.contains(cdl.ContentDocumentId) &&
                String.valueOf(cdl.LinkedEntityId.getSobjectType()) != 'User') {
                    System.debug('H');
                    ContentVersion cv = versionByContentDocumentId.get(cdl.ContentDocumentId);

                    ContentDistribution cd = new ContentDistribution();
                    cd.ContentVersionId = cv.Id;
                    cd.RelatedRecordId = cdl.LinkedEntityId;
                    cd.Name = String.valueOf(cdl.LinkedEntityId.getSobjectType()) + '_' + cdl.Id + '_PublicShare';
                    cd.PreferencesAllowViewInBrowser = true;
                    cd.PreferencesLinkLatestVersion = true;
                    cd.PreferencesNotifyOnVisit = false;
                    cd.PreferencesPasswordRequired = false;
                    cd.PreferencesAllowOriginalDownload = true;
                    toInsert.add(cd);
                }
            }
        }

                    System.debug('to insert ');
            System.debug(toInsert);

        if (
            Schema.sObjectType.ContentDistribution.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.ContentVersionId.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.RelatedRecordId.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.Name.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.PreferencesAllowViewInBrowser.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.PreferencesLinkLatestVersion.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.PreferencesNotifyOnVisit.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.PreferencesPasswordRequired.isCreateable()
            && Schema.sObjectType.ContentDistribution.fields.PreferencesAllowOriginalDownload.isCreateable()
        ) {
            System.debug('to insert ');
            Database.SaveResult[] srList = Database.insert(toInsert, false);
            
            for(Database.SaveResult sr : srList) {
                if(!sr.isSuccess()) {
                    List<String> tmpErrors = new List<String>();
                    for(Database.Error r : sr.getErrors()) {
                        tmpErrors.add(r.getMessage());
                    }
                    System.debug('Error : ' + String.join(tmpErrors, ', '));
                }
            }
        } else {
            System.debug(System.Label.Permission);
        }
    }
}