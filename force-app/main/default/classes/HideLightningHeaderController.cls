//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 23/03/2019
**/
public without sharing class HideLightningHeaderController {
    @AuraEnabled
    public static String getContactId(){
        String contactId = [SELECT crta__Contact__c
                            FROM User
                            WHERE Id = : UserInfo.getUserId()
                            LIMIT 1].crta__Contact__c;
        if(contactId != null) {
            Contact verifContact;
            for(Contact c : [
                SELECT Id 
                FROM Contact 
                WHERE Id =: contactId]) {
                    verifContact = c;
                }
            if(verifContact == null) {
                contactId = null;
            }
        }
        return contactId;
    }
}