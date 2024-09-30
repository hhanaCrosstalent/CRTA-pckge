//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author: Ophélie ABOA
 * @Date: 13/02/2019
**/
public without sharing class ArticleDetailsController {
	@AuraEnabled
    public static crta__Article__c getArticleDetails(String articleId) {
        crta__Article__c currentArticle = new crta__Article__c();
        currentArticle = [
            SELECT Id,
            RecordTypeId,
            Name,
            crta__Couleur_du_titre__c,
            crta__Categories__c, 
            crta__Date_de_publication__c, 
            crta__Texte__c, 
            crta__Banner__c,
            crta__Link__c,
            crta__Pin_to_Top__c,
            OwnerId,
            CreatedDate, 
            Owner.Name,
            CreatedBy.SmallPhotoUrl
            FROM crta__Article__c 
            WHERE Id = :articleId
        ];

        User u = [
            SELECT Id, 
                SmallPhotoUrl 
            FROM User 
            WHERE Id =: currentArticle.OwnerId];
        currentArticle.crta__Couleur_du_titre__c = u.SmallPhotoUrl;
        return currentArticle;
    }

    @AuraEnabled
    public static String getFileFromArticle(String articleId) {
        Set<Id> contentIds = new Set<Id>();
        List<Id> ids = new List<Id>();
        String fileId = '';
        
        for(ContentDocumentLink cLink :[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: articleId]) {
            contentIds.add(cLink.ContentDocumentId);
        }

        for(ContentVersion cver : [SELECT Id
                                    FROM ContentVersion 
                                    WHERE ContentDocumentId 
                                    IN :contentIds
                                    ORDER BY CreatedDate 
                                    DESC LIMIT 1
            ]) {
            fileId = cver.Id;
        }
        
        return fileId;
    }
}