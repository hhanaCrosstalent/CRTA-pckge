//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 23/11/2018
**/
public without sharing class PortalHeaderController {

    

    @AuraEnabled
    public static string getLoggedContactCtrl(){
        String contactId = getLoggedUserCtrl().crta__Contact__c;
        List<Contact> loggedContact = [
            SELECT Id, FirstName
            FROM Contact
            WHERE Id =: contactId
            LIMIT 1
        ];
        if(loggedContact != null && loggedContact.size() > 0) {
            return loggedContact.get(0).FirstName;
        } else { return null; }
    }
    
    /**
    * This method returns the logged User
    * Return type : User
    **/
    private static User getLoggedUserCtrl() {
        return [
            SELECT Id,
                FirstName,
             
                crta__Contact__c
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
    }
    @AuraEnabled
    public static crta__Article__c getHeader() {
        crta__Article__c article = new crta__Article__c();
        Contact contactConnected = getCurrentContact();
        String currentProfile = getCurrentUser();
        for(crta__Article__c a : [
            SELECT Id, 
                Name, 
                crta__Categories__c, 
                crta__Banner__c, 
                crta__Date_de_publication__c, 
                Texte__c,
            	(SELECT Id, crta__Account__c,  crta__Filter_Field_1__c, crta__Filter_Field_2__c FROM crta__Articles_Visibilities__r)
            FROM crta__Article__c 
            WHERE crta__Date_de_publication__c <= TODAY
            AND crta__Banner__c = true
            AND RecordType.DeveloperName = 'Media'
            AND (crta__Publication_End_Date__c >= TODAY OR crta__Publication_End_Date__c = NULL) 
            ORDER BY Date_de_publication__c DESC
            LIMIT 1
        ]) {
            
            if(contactConnected != NULL || !currentProfile.toLowerCase().contains('admin')) {
                if(a.crta__Articles_Visibilities__r.size() > 0 ) {
                    for(crta__Article_Visibility__c v : a.crta__Articles_Visibilities__r) {
                         Boolean filter1 = true;
                            if(v.crta__Filter_Field_1__c != null) {
                                if(contactConnected.get(v.crta__Filter_Field_1__c) == true) {
                                    filter1 = true;
                                } else {
                                    filter1 = false;
                                }
                            }
                        Boolean filter2 = true;
                        if(v.crta__Filter_Field_2__c != null) {
                            if(contactConnected.get(v.crta__Filter_Field_2__c) == true) {
                                filter2 = true;
                            } else {
                                filter2 = false;
                            }
                        }
                        if(v.Account__c == contactConnected.AccountId && filter1 && filter2) {
                           article = a;
                        }
                    }
                } else {
                    article = a;
                }
            } else {
                article = a;
            }
        }
        return article;
    }
    
    private static Contact getCurrentContact()
    {
        List<String> l = new List<String>(Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet());
        Set<String> contactFields = new Set<String>();
        for(String s : l) {
            contactFields.add(s.toLowerCase());
        }
        String contactId = [SELECT crta__Contact__c
            FROM User
            WHERE Id = : UserInfo.getUserId()
            LIMIT 1
        ].crta__Contact__c;

        String whereClause = 'Id = \'' + contactId + '\'';
        String query = PortalUtility.getSOQLQuery(contactFields, 'Contact', whereClause , '', '1', '');
        if(contactId != NULL) {
            Contact contactConnected = Database.query(query);
            return contactConnected;
        } else {
            return null;
        }
    }
    
    private static String getCurrentUser()
    {
        String userProfile = [SELECT Profile.Name
                        FROM User
                        WHERE Id = : UserInfo.getUserId()
                        LIMIT 1
                       ].Profile.Name;
        return userProfile;
    }

    @AuraEnabled
    public static String getFileFromArticle(String articleId) {
        Set<Id> contentIds = new Set<Id>();
        List<Id> ids = new List<Id>();
        String fileId = '';
        
        if(articleId != ''){
            for(ContentDocumentLink cLink :[
                SELECT Id, 
                    LinkedEntityId, 
                    ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId =: articleId]) {
                contentIds.add(cLink.ContentDocumentId);
            }

            for(ContentVersion cver : [
                SELECT Id
                FROM ContentVersion 
                WHERE ContentDocumentId 
                IN :contentIds
                ORDER BY CreatedDate 
                DESC LIMIT 1]) {
                fileId = cver.Id;
            }
        }
        return fileId;
    }
}