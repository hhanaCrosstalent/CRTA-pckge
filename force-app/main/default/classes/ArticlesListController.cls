//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author: Ophélie ABOA
 * @Date: 26/11/2018
**/
public without sharing class ArticlesListController {
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
    public static List<crta__Article__c> getArticlesList(Decimal limiter, String articleType) {
        List<crta__Article__c> l = new List<crta__Article__c>();
        Contact contactConnected = getCurrentContact();
        String currentProfile = getCurrentUser();
        Set<Id> articleAlreadyIn = new Set<Id>();

        String recordType = articleType;
        if(articleType == null) {
            recordType = 'Media';
        }
        if(recordType == 'Archives') {
            recordType = 'Media';
        }
        if(articleType != 'Media') {
            limiter = 50;
        }
        
        Integer skipped = 0;
        for(crta__Article__c a : [
            SELECT Id, 
                RecordTypeId,
                Name, 
                crta__Categories__c, 
                crta__Date_de_publication__c,
                crta__Texte__c, 
                crta__Banner__c,
                crta__Link__c,
                crta__Pin_to_Top__c,
                crta__Start_Date__c,
                crta__End_Date__c,
                crta__Start_Time__c,
                crta__End_Time__c,
                CreatedDate,
                (SELECT Id, crta__Account__c, crta__Filter_Field_1__c, crta__Filter_Field_2__c FROM crta__Articles_Visibilities__r),
                (SELECT ContentDocument.LatestPublishedVersionId FROM AttachedContentDocuments ORDER BY CreatedDate DESC LIMIT 1)
            FROM crta__Article__c 
            WHERE RecordType.DeveloperName =: recordType 
            AND crta__Banner__c = FALSE
            AND crta__Date_de_publication__c <= TODAY
            AND (crta__Publication_End_Date__c >= TODAY OR crta__Publication_End_Date__c = NULL)
            AND (crta__End_Date__c >= TODAY OR crta__End_Date__c = NULL)
            AND ((crta__Start_Date__c >= TODAY OR crta__Start_Date__c = NULL) OR (
                crta__Start_Date__c <= TODAY AND crta__End_Date__c >= TODAY))
            ORDER BY crta__Pin_to_Top__c DESC, crta__Start_Date__c ASC, crta__Date_de_publication__c DESC
        ]) {
            if(articleType == 'Archives') {
                if(skipped < 3) {
                    skipped ++;
                    continue;
                }
            }
                
            if(l.size() < limiter || articleType != 'Media') {
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
                            if(v.crta__Account__c == contactConnected.AccountId && filter1 && filter2) {
                                if(!articleAlreadyIn.contains(a.Id)) {
                                    l.add(a);
                                }
                            }
                        }
                    } else {
                        l.add(a);
                    }
                } else {
                    l.add(a);
                }
            }
        }
        return l;
    }
}