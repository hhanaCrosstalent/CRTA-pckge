//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 10/06/2020 
**/
public without sharing class OrgChartManager {
    public static List<Contact> getContacts(String strFields, List<String> recordTypesList, Boolean displayExEmployees) {
        String query = 'SELECT Id, Name, Owner.SmallPhotoUrl, ReportsToId' + strFields
                        + ' FROM Contact'
                        + ' WHERE RecordType.DeveloperName IN :recordTypesList ';
        if(!displayExEmployees) {
            query += ' AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ';
        }
        
        system.debug('query ' +  query);
        List<Contact> employees = Database.query(query);
        return employees;
    }
    
    public static Map<String, User> getUsers(Set<String> allContactIds) {
        Map<String, User> contactToUser = new Map<String, User>();
        for(User u : [SELECT Id, SmallPhotoUrl, Contact__c FROM User WHERE IsActive = TRUE AND Contact__c IN :allContactIds]) {
            contactToUser.put(u.crta__Contact__c, u);
        }
        return contactToUser;
    }
    
     public static Map<String, String> getPhotos(Set<String> allContactIds) {
         Map<String, String> photoByContact = new Map<String, String>();
         for(ContentDistribution c : [
             SELECT Id,
                 ContentDownloadUrl,
                 //ContentDocumentId,
                 ContentVersion.Type__c,
                 ContentVersion.Title,
                 ContentVersion.ContentDocumentId,
                 RelatedRecordId
             FROM ContentDistribution
             WHERE ContentVersion.crta__Type__c='profilPicture' AND RelatedRecordId IN:allContactIds
             ORDER BY CreatedDate DESC]) {
                 if(!photoByContact.containsKey(c.RelatedRecordId)) {
                     photoByContact.put(c.RelatedRecordId, c.ContentDownloadUrl);
                 }
             }
         return photoByContact;
     }
}