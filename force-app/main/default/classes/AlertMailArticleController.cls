//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author Crosstalent
 * @UpdateList :
 * Ophélie ABOA -> 11/06/2019 (CreatedDate)
**/
public without sharing class AlertMailArticleController {
    @AuraEnabled
    public static Integer sendMailCtrl(Id recordId, String templateName, String senderEmailId) {
        Integer response = 1;
        crta__Article__c article = getArticle(recordId);
        if(article != null) {
            if(!article.crta__Banner__c) {
                if(hasEmailPermission()) {
                    Database.executeBatch(new AlertMailArticleBatch(article, templateName, senderEmailId), 20);
                } else {
                    response = 2;
                }
            } else {
                response = 3;
            }
        }
        return response;
    }

    @AuraEnabled
    public static Map<String, String> getEmailTemplates() {
        Map<String, String> emailTemplateList = new Map<String, String>();
        for(EmailTemplate e : [
            SELECT Id,
                Name,
                DeveloperName
            FROM EmailTemplate
            WHERE Folder.Name = 'Portal'
            ORDER BY Name ASC
        ]) {
            emailTemplateList.put(e.DeveloperName, e.Name);
        }
        return emailTemplateList;
    }

    @AuraEnabled
    public static Map<String, String> getOrgEmails() {
        Map<String, String> orgEmailList = new Map<String, String>();
        for(OrgWideEmailAddress o : [
            SELECT Id,
                Address,
                DisplayName
            FROM OrgWideEmailAddress
            ORDER BY DisplayName]) {
                orgEmailList.put(o.Id, o.DisplayName + ' - ' + o.Address);
        }
        return orgEmailList;
    }

    private static Boolean hasEmailPermission() {
        try {
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.reserveMassEmailCapacity(1);
            return true;
        } catch (System.NoAccessException e) {
            return false;
        }
    }

    private static crta__Article__c getArticle(Id articleId) {
        crta__Article__c article = new crta__Article__c();
        article = [
            SELECT 
                Id, 
                Name, 
                crta__Texte__c, 
                crta__Email_Sent__c, 
                crta__Banner__c 
            FROM crta__Article__c 
            WHERE Id =: articleId
        ];
        return article;
    }
}