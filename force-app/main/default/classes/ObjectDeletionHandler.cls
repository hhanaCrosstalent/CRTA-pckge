public class ObjectDeletionHandler {

    
    public static void deleteRelatedObjects(Set<String> contactIds) {
        // Récupérer le nom du champ API lié au Contact dans l'objet enfant de manière dynamique
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType contactType = globalDescribe.get('Contact');
        Schema.DescribeSObjectResult contactDescribe = contactType.getDescribe();
        Id userId = UserInfo.getUserId();
        
        // Récupérer les enregistrements de la métadonnée personnalisée
        List<crta__Anony_Objet_Asso_Contact__mdt> metadataRecords = [SELECT Id, MasterLabel FROM crta__Anony_Objet_Asso_Contact__mdt];
        Set<String> allowedChildObjectLabels = new Set<String>();

        for(crta__Anony_Objet_Asso_Contact__mdt metadataRecord : metadataRecords) {
            allowedChildObjectLabels.add(metadataRecord.MasterLabel);
        }

        // Parcourir les champs de l'objet enfant pour trouver le champ de type Contact
        for (Schema.ChildRelationship childRelationship : contactDescribe.getChildRelationships()) {
            String childObjectName = childRelationship.getChildSObject().getDescribe().getName();

            // Vérifier si l'objet enfant est autorisé à être supprimé selon la métadonnée personnalisée
            if (isValidChildObject(childObjectName, allowedChildObjectLabels)) {
                String contactFieldApiName = childRelationship.getField().getDescribe().getName();
                System.debug('Nom du champ API du Contact dans l\'objet enfant : ' + contactFieldApiName + '   Object Name   '+childObjectName);
				     if (globalDescribe.containsKey(childObjectName)) {
                    	Schema.DescribeSObjectResult describeResult = globalDescribe.get(childObjectName).getDescribe();
                       
                    // Vérifier si l'objet est interrogeable et s'il est supprimable
                    if (describeResult != null && describeResult.isQueryable() && describeResult.isDeletable()) {
                        String query = 'SELECT Id FROM ' + childObjectName + ' WHERE ' + contactFieldApiName + ' IN :contactIds';
                        system.debug('Query    '+query) ;
                        List<SObject> childObjectsToDelete = Database.query(query);
						// Nouvelle liste pour les ContentVersion à supprimer
                        List<Id> contentDocumentIdsToDelete = new List<Id>();

                      	for (SObject childObject : childObjectsToDelete) {
                            if (childObjectName.endsWith('__c')){
                                // Récupérer les fichiers attachés à l'objet enfant
                                List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :childObject.Id];

                                for (ContentDocumentLink cdl : contentDocumentLinks) { contentDocumentIdsToDelete.add(cdl.ContentDocumentId);
                                }
                                
                                // Récupérer les fichiers attachés au contact
                                List<ContentDocumentLink> contactContentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :contactIds];
                                
                                for (ContentDocumentLink cdl : contactContentDocumentLinks) {   contentDocumentIdsToDelete.add(cdl.ContentDocumentId);
                                }
                            }
                        }

                        // Supprimer les fichiers attachés (ContentVersion is automatically deleted when associated ContentDocument is deleted)
                        if (!contentDocumentIdsToDelete.isEmpty()) { delete [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIdsToDelete];
                        }

                        // Supprimer les objets enfants
                        try {
                            delete childObjectsToDelete; } catch (Exception e) {
                            // Gérer les erreurs de suppression
                        }
                    }
                }
            }
        }
    }

    public static Boolean isValidChildObject(String childObjectName, Set<String> allowedChildObjectLabels) {
        return childObjectName.endsWith('__c') || allowedChildObjectLabels.contains(childObjectName) || childObjectName.contains('Task') || childObjectName.contains('Email') || childObjectName.contains('Event');
    }
}