//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 07/01/2019 
**/
global with sharing class OrgChartController {
	global class ContactWrapper {
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
            String contactId, User user, String managerId,
            Contact contact, String photoContact, List<ContactWrapper> employee,
            Object field1, Object field2, Object field3, Object field4
        ) {
            this.contactId = contactId;
            this.user = user;
            this.managerId = managerId;
            this.contact = contact;
            this.photoContact = photoContact;
            this.employee = employee;
            this.field1 = field1;
            this.field2 = field2;
            this.field3 = field3;
            this.field4 = field4;
        }
    }


    public static String contactConnected {get;set;}
    public static Boolean displaySettings {get;set;}
    public static Boolean activateRedirection {get;set;} 
    public static Boolean redirectToChatter {get;set;} 
    public static String companyName {get;set;}
    public static String colorBanner {get;set;}
    public static String textColorBanner {get;set;} 

    public OrgChartController() {
        contactConnected = getContactConnected();
        Organigramme__c orgaSettings = Organigramme__c.getInstance();
        displaySettings = orgaSettings.Show_Display_Settings__c;
        companyName = (orgaSettings.Company_Name__c == null ? 'Crosstalent' : orgaSettings.Company_Name__c);
        colorBanner = (orgaSettings.Color_Banner__c == null ? '#0047BB' : orgaSettings.Color_Banner__c);
        textColorBanner = (orgaSettings.Text_Color_Banner__c == null ? '#FFF' : orgaSettings.Text_Color_Banner__c);
        activateRedirection = orgaSettings.Activate_Redirection__c;
        redirectToChatter = orgaSettings.Redirect_to_Chatter_Profile__c;
    }

    public static String getContactConnected(){
        try{
            contactConnected = [SELECT crta__Contact__c
                                FROM User
                                WHERE Id = : UserInfo.getUserId()
                                LIMIT 1
                               ].crta__Contact__c;
            return contactConnected;
        } catch(exception e){
            System.debug(e.getMessage());
            return 'Erreur : '+e.getMessage();
        }
    }

    @RemoteAction
    global static List<ContactWrapper> getParentContacts() {
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
        
        List<Contact> employees = OrgChartManager.getContacts(strFields, recordTypesList, orgaSettings.Display_ex_employees__c);
        for(Contact c : employees) {
            allContactIds.add(c.Id);
            String key = (!String.isBlank(c.ReportsToId)) ? String.valueOf(c.ReportsToId) : 'Top';
            if(mapStringToContact.containsKey(key)) {
                mapStringToContact.get(key).add(c);
            } else {
                mapStringToContact.put(key, new List<Contact>{c});
            }
        }
		
        contactToUser = OrgChartManager.getUsers(allContactIds);

        Map<String, String> photoByContact = OrgChartManager.getPhotos(allContactIds);
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

    private static List<ContactWrapper> getChildContacts(String contactId, Map<String, List<Contact>> m, Map<String, User> contactToUser, Map<String, String> photoByContact) {
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
}