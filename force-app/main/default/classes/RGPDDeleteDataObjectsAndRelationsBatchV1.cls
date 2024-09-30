global class RGPDDeleteDataObjectsAndRelationsBatchV1 implements Database.Batchable<sObject>, Database.Stateful {
    private static final Integer CHUNK_SIZE = 200; // Taille des morceaux
    global static Integer getScopeSize() { return 100; }
    global crta__parent_object_Setting__mdt parent { get; set; }
    public List<String> errorMessagesList = new List<String>();

    global RGPDDeleteDataObjectsAndRelationsBatchV1(crta__parent_object_Setting__mdt parent) {
        this.parent = parent;
        System.debug('Initializing batch with parent: ' + parent);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id FROM ' + this.parent.crta__ObjectAPIName__c;
        if (!String.isBlank(this.parent.crta__field_criteria__c)) {
            query += ' WHERE ' + this.parent.crta__field_criteria__c;
        }
        System.debug('Query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        Set<Id> sobjectIdsSet = new Set<Id>();
        for (sObject current : scope) {
            sobjectIdsSet.add(current.Id);
        }

        if (sobjectIdsSet.isEmpty()) {
            return;
        }

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType parentType = globalDescribe.get(this.parent.crta__ObjectAPIName__c);
        Schema.DescribeSObjectResult parentDescribe = parentType.getDescribe();

        // Collect allowed child object labels
        List<crta__child_object_Setting__mdt> metadataRecords = [
            SELECT crta__ObjectAPIName__c 
            FROM crta__child_object_Setting__mdt 
            WHERE crta__ParentObjectParameter__c = :this.parent.crta__ObjectAPIName__c
        ];
        Set<String> allowedChildObjectLabels = new Set<String>();
        for (crta__child_object_Setting__mdt metadataRecord : metadataRecords) {
            allowedChildObjectLabels.add(metadataRecord.crta__ObjectAPIName__c);
        }

        // Collect all child objects and content document IDs
        List<SObject> allChildObjectsToDelete = new List<SObject>();
        Set<Id> allContentDocumentIdsToDelete = new Set<Id>();

        // Collect child objects and prepare queries for content documents
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        for (Schema.ChildRelationship childRelationship : parentDescribe.getChildRelationships()) {
            String childObjectName = childRelationship.getChildSObject().getDescribe().getName();
            if (isValidChildObject(childObjectName, allowedChildObjectLabels)) {
                String parentFieldApiName = childRelationship.getField().getDescribe().getName();
                if (globalDescribe.containsKey(childObjectName)) {
                    Schema.DescribeSObjectResult childDescribe = globalDescribe.get(childObjectName).getDescribe();
                    if (childDescribe.isQueryable() && childDescribe.isDeletable()) {
                        String childQuery = 'SELECT Id FROM ' + childObjectName + ' WHERE ' + parentFieldApiName + ' IN :sobjectIdsSet';
                        System.debug('Child Query: ' + childQuery);

                        // Query all child objects
                        List<SObject> childObjectsToDelete = Database.query(childQuery);
                        allChildObjectsToDelete.addAll(childObjectsToDelete);

                        // Collect ContentDocumentIds for child objects
                        Set<Id> childObjectIds = new Set<Id>();
                        for (SObject childObject : childObjectsToDelete) {
                            childObjectIds.add(childObject.Id);
                        }

                        if (!childObjectIds.isEmpty()) {
                            contentDocumentLinks.addAll([
                                SELECT ContentDocumentId, LinkedEntityId
                                FROM ContentDocumentLink
                                WHERE LinkedEntityId IN :childObjectIds
                            ]);
                        }
                    }
                }
            }
        }

        // Retrieve files attached to the parent object
        List<ContentDocumentLink> parentContentDocumentLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :sobjectIdsSet
        ];
        contentDocumentLinks.addAll(parentContentDocumentLinks);

        // Collect ContentDocumentIds
        for (ContentDocumentLink cdl : contentDocumentLinks) {
            allContentDocumentIdsToDelete.add(cdl.ContentDocumentId);
        }

        // Delete content documents in chunks
        List<SObject> contentDocumentsToDelete = new List<SObject>();
        for (Id contentDocumentId : allContentDocumentIdsToDelete) {
            contentDocumentsToDelete.add(new ContentDocument(Id = contentDocumentId));
        }
        for (Integer i = 0; i < contentDocumentsToDelete.size(); i += CHUNK_SIZE) {
            List<SObject> chunk = new List<SObject>();
            for (Integer j = i; j < Math.min(i + CHUNK_SIZE, contentDocumentsToDelete.size()); j++) {
                chunk.add(contentDocumentsToDelete[j]);
            }
            try {
                delete chunk;
            } catch (DMLException e) {
                this.errorMessagesList.add(e.getMessage());
            }
        }

        // Delete child objects in chunks
        for (Integer i = 0; i < allChildObjectsToDelete.size(); i += CHUNK_SIZE) {
            List<SObject> chunk = new List<SObject>();
            for (Integer j = i; j < Math.min(i + CHUNK_SIZE, allChildObjectsToDelete.size()); j++) {
                chunk.add(allChildObjectsToDelete[j]);
            }
            try {
                delete chunk;
            } catch (DMLException e) {
                this.errorMessagesList.add(e.getMessage());
            }
        }

        // Attempt to delete parent objects and log any errors
        try {
            delete scope;
        } catch (DMLException e) {
            this.errorMessagesList.add(e.getMessage());
        }
    }

    global void finish(Database.BatchableContext bc) {
        if (!errorMessagesList.isEmpty()) {
            System.debug('Errors encountered during batch execution: ' + String.join(errorMessagesList, ', '));
        }
    }

    public static Boolean isValidChildObject(String childObjectName, Set<String> allowedChildObjectLabels) {
        return childObjectName.endsWith('__c') || allowedChildObjectLabels.contains(childObjectName) || childObjectName.contains('Task') || childObjectName.contains('Email') || childObjectName.contains('Event');
    }
}