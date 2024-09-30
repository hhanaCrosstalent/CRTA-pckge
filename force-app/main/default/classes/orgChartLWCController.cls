/*
* @Author Fallou MBAYE
* Cretead Date 2022-01-06
* List modified
*  ==> Modified by XXXX
*  ==> Modified Date yyyy-mm-dd
*/
public without sharing class orgChartLWCController {
    public class ContactWrapper {
        @AuraEnabled
        public String contactId {get; set;}
        @AuraEnabled
        public User user {get; set;}
        @AuraEnabled
        public String managerId {get; set;}
        @AuraEnabled
        public Contact contact {get; set;}
        @AuraEnabled
        public String photoContact {get; set;}
        @AuraEnabled
        public List<ContactWrapper> employee {get; set;}
        @AuraEnabled
        public Object field1 {get; set;}
        @AuraEnabled
        public Object field2 {get; set;}
        @AuraEnabled
        public Object field3 {get; set;}
        @AuraEnabled
        public Object field4 {get; set;}

        public ContactWrapper(
            String contactId , User user,String managerId,
            Contact contact, String photoContact, List<ContactWrapper> employee,
            Object field1, Object field2, Object field3, Object field4
        ) {
            this.contactId = contactId;
            this.managerId = managerId;
            this.user = user;
            this.contact = contact;
            this.photoContact = photoContact;
            this.employee = employee;
            this.field1 = field1;
            this.field2 = field2;
            this.field3 = field3;
            this.field4 = field4;
        
        }
    }
    public static string test;
    public orgChartLWCController(){
        test = 'fallou';
    }
    public static String getCurrentContact(){
        String contactConnected = null;
        try{
            contactConnected = [SELECT Contact__c
                                FROM User
                                WHERE Id = : UserInfo.getUserId()
                                LIMIT 1
                               ].Contact__c;
            return contactConnected;
        } catch(exception e){
            System.debug(e.getMessage());
            return 'Erreur : '+e.getMessage();
        }
    }
    @AuraEnabled(cacheable=true)
    public static Organigramme__c getSetting(){
        Organigramme__c orgaSettings = Organigramme__c.getInstance();
        return orgaSettings;
    }
    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> getParentContacts() {
        List<ContactWrapper> contactList = new List<ContactWrapper>();
        Map<String, List<Contact>> mapStringToContact = new Map<String, List<Contact>>();
        Set<String> allContactIds = new Set<String>();
        Map<String, User> contactToUser = new Map<String, User>();
        Set<String> allUsersId = new Set<String>();

        Organigramme__c orgaSettings = Organigramme__c.getInstance();
        String strFields = '';
        Set<String> setFields = new Set<String>();
        if(orgaSettings.Field_1__c != NULL) {
            setFields.add(orgaSettings.Field_1__c);
        }
        if(orgaSettings.Field_2__c != NULL) {
            setFields.add(orgaSettings.Field_2__c);
        }
        if(orgaSettings.Field_3__c != NULL) {
            setFields.add(orgaSettings.Field_3__c);
        }
        if(orgaSettings.Field_4__c != NULL) {
            setFields.add(orgaSettings.Field_4__c);
        } 
        if(setFields.size() > 0) {
        	strFields = ',' + String.join(new List<String>(setFields), ',');
        }
        List<String> recordTypesList = new List<String>();
        String recordTypes = orgaSettings.Record_Types__c;
        if(recordTypes != NULL) {
             recordTypes = recordTypes.replaceAll( '\\s+', '');
            if(recordTypes == '') {
                recordTypesList.add('Salarie');
            } else {
                recordTypesList = recordTypes.split(',');
            }
        } else {
            recordTypesList.add('Salarie');
        }
        List<Contact> employees = orgChartLWCController.getContacts(strFields, recordTypesList, orgaSettings.Display_ex_employees__c);
        for(Contact c : employees) {
            allContactIds.add(c.Id);
            String key = (!String.isBlank(c.ReportsToId)) ? String.valueOf(c.ReportsToId) : 'Top';
            if(mapStringToContact.containsKey(key)) {
                mapStringToContact.get(key).add(c);
            } else {
                mapStringToContact.put(key, new List<Contact>{c});
            }
        }
		
        contactToUser = orgChartLWCController.getUsers(allContactIds);

        Map<String, String> photoByContact = orgChartLWCController.getPhotos(allContactIds);
        if(mapStringToContact.containsKey('Top')) {
            for(Contact c : mapStringToContact.get('Top')) {
                contactList.add(new ContactWrapper(
                    c.Id, 
                    getUser(c.Id, contactToUser),
                    'Top', 
                    c, 
                    getContactPhoto(c.Id, photoByContact), 
                    getChildContacts(c.Id, mapStringToContact, contactToUser, photoByContact),
                    (orgaSettings.Field_1__c != NULL ? PortalUtility.get(c,orgaSettings.Field_1__c) : NULL),
                    (orgaSettings.Field_2__c != NULL ? PortalUtility.get(c,orgaSettings.Field_2__c) : NULL), 
                    (orgaSettings.Field_3__c != NULL ? PortalUtility.get(c,orgaSettings.Field_3__c) : NULL),
                    (orgaSettings.Field_4__c != NULL ? PortalUtility.get(c,orgaSettings.Field_4__c) : NULL)
                ));
            }
        }

        System.debug('contactList ' + contactList);
        return contactList;
    }


    private static List<ContactWrapper> getChildContacts(String contactId, Map<String, List<Contact>> m, Map<String, User>  contactToUser, Map<String, String> photoByContact) {
        Organigramme__c orgaSettings = Organigramme__c.getInstance();
        List<ContactWrapper> children = new List<ContactWrapper>();
        if(m.containsKey(contactId)) {
            for(Contact c : m.get(contactId)) {
               
                children.add(new ContactWrapper(
                    c.Id, 
                    getUser(c.Id, contactToUser), 
                    c.ReportsToId, 
                    c, 
                    getContactPhoto(c.Id, photoByContact),
                    getChildContacts(c.Id, m, contactToUser, photoByContact),
                    (orgaSettings.Field_1__c != NULL ? PortalUtility.get(c,orgaSettings.Field_1__c) : NULL),
                    (orgaSettings.Field_2__c != NULL ? PortalUtility.get(c,orgaSettings.Field_2__c) : NULL), 
                    (orgaSettings.Field_3__c != NULL ? PortalUtility.get(c,orgaSettings.Field_3__c) : NULL),
                    (orgaSettings.Field_4__c != NULL ? PortalUtility.get(c,orgaSettings.Field_4__c) : NULL)
                ));
            }
        }
        return children;
    }
    private static String getContactPhoto(String contactId, Map<String, String> photoByContact) {
        String photoUrl = '';
        if(photoByContact.containsKey(contactId))
        {
            photoUrl = photoByContact.get(contactId);
        }
        return photoUrl;
    }

    private static User getUser(String contactId,  Map<String, User> contactToUser)
    {
        User user = new User();
        if(contactToUser.containsKey(contactId))
        {
            user = contactToUser.get(contactId);
        }
        return user;
    }
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
            contactToUser.put(u.Contact__c, u);
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

    /*@AuraEnabled(cacheable=true)
    public static list<user> getReportIds(id userId) {
        return [select id, Name, MediumPhotoUrl from user where ManagerId =: userid];
    }

    @AuraEnabled(cacheable=true)
    public static list<user> searchUsers(string searchString) {
        string sosl = 'find \''  + searchString + '\' in ALL FIELDS returning User(Name, Title)';
        List<List <sObject>> results = search.query(sosl);
        return results[0];
    }*/

}