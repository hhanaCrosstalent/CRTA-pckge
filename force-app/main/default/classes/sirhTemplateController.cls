//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Controller for the frontend's template
* @author Crosstalent
* @group SIRH-Frontend
* @version 1.5
*/
global with sharing class sirhTemplateController {
    public static String contactId {get; set;}
    public Contact loggedContact{ get; set; }
    public Boolean isPreview { get; set; }
    public String photo { get; set; }
    public String locale { get; set; }
    public String customCSS {get; set;}
    public String customLogo {get; set;}
    public List<SIRH_Notification__c> notifications { get; set; }
    public List<SI_Menu_Settings__mdt> menuLinks {get; set;}
    public Integer alertCount { get; set; }
    public Boolean hasJoyride { get; set; }
    public Map<String, String> absoluteUrls {set; get;}
    
    /**
* Retrieves the logged contact
* Checks if we are in preview mode
*/
    global sirhTemplateController() {
        sirhTemplateController.contactId = sirhTemplateController.getContactId();
        String preview = ApexPages.currentPage().getParameters().get('apercu');
        isPreview = (preview == '1') ? true : false;
        locale = UserInfo.getLanguage().left(2);
        
        sirh__c options = sirh__c.getInstance();
        customCSS = getResourceURL(options.css__c);
        customLogo = getResourceUrl(options.logo__c);
        
        photo = '/servlet/servlet.FileDownload?file=';
        
        try {
            hasJoyride = [SELECT hasJoyride__c FROM User WHERE Id = :UserInfo.getUserId()].hasJoyride__c;
            loggedContact = [SELECT Id, Name, CT_Service__c, CT_Matricule__c, Categorie_professionnelle__c, ReportsTo.Name, Title, Birthdate 
                             FROM Contact 
                             WHERE Id= :contactId 
                             LIMIT 1];
            photo += [SELECT Id 
                      FROM Attachment 
                      WHERE ParentId = :contactId 
                      AND Name =: sirhMenuController.CONTACT_PIC].Id;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        notifications = [SELECT Texte__c, Type__c, Objet__c, Id_de_l_objet__c 
                         FROM SIRH_Notification__c 
                         WHERE Salarie__c = :contactId 
                         AND Lu__c = false 
                         AND (Type__c = 'Rappel' OR Type__c = 'Interaction')];
        alertCount = [SELECT COUNT() 
                      FROM SIRH_Notification__c 
                      WHERE Salarie__c = :contactId 
                      AND Lu__c = false 
                      AND Type__c != 'Rappel' 
                      AND Type__c != 'Information'];
        
        List<PermissionSetAssignment> assignments = [SELECT Assignee.Id, PermissionSet.Name 
                                                     FROM PermissionSetAssignment 
                                                     WHERE Assignee.Id = :UserInfo.getUserId()];
        List<String> permissions = new List<String>();
        for(PermissionSetAssignment assignment: assignments) {
            permissions.add(assignment.PermissionSet.Name);
        } 
        menuLinks = [SELECT DeveloperName, MasterLabel, Icone__c, URL__c, Target__c, Ordre__c, Manager_only__c,
                     Visibilite__c
                     FROM SI_Menu_Settings__mdt
                     WHERE A_afficher__c = true
                     AND Visibilite__c IN :permissions
                     ORDER BY Ordre__c ASC];
        absoluteUrls = new Map<String, String>();
        for(SI_Menu_Settings__mdt menuLink:menuLinks) {
            if(!String.isBlank(menuLink.URL__c) && !menuLink.URL__c.contains('/')) {
                absoluteUrls.put(menuLink.URL__c, URL.getSalesforceBaseUrl().toExternalForm() + '/apex/' + menuLink.URL__c);
            } else {
                absoluteUrls.put(menuLink.URL__c, menuLink.URL__c);
            }
        }
    }
    
    /**
* @deprecated  No longer in use
*/
    @deprecated
    global static Boolean getIsLogged() {
        Cookie isLogged = ApexPages.currentPage().getCookies().get('isLogged');
        String apercu = ApexPages.currentPage().getParameters().get('apercu');
        
        if(isLogged == null && apercu != '1') {
            return false;
        } else {
            return true;
        }
    }
    
    /**
* Counts the number of subordinates for a given manager
* @param Id of the manager whose subordinates number should be counted
* 
* @return Integer The number of contacts under direct order from the specified manager
*/
    global static Integer getSubCount(String managerId) {
        Integer countSubordinates = [SELECT COUNT() FROM Contact WHERE ReportsTo.Id = :managerId];
        
        if(countSubordinates != null ) {
            return countSubordinates;
        } else {
            return 0;
        }
    }
    
    /**
* Counts the number of subordinates for the currently logged contact
*
* @return Integer The number of contacts under direct order from the logged contact
*/
    public Integer getSubCount() {
        Integer countSubordinates = sirhTemplateController.getSubCount(contactId);
        
        if(countSubordinates != null ) {
            return countSubordinates;
        } else {
            return 0;
        }
    }
    
    /**
* Checks if the current contact is a manager
*
* @return True if the current contact has employees reporting to him/her
*/
    public Boolean getIsManager() {
        Integer count = [SELECT COUNT() FROM Contact WHERE ReportsToId = :contactId LIMIT 10];
        
        if(count != null && count > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    /**
* Returns current page label
* @return Page label
*/
    public String getPageLabel() {
        String pageName = ApexPages.CurrentPage().getUrl();  
        pageName = pageName.replaceFirst('/apex/','');
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');  
        string[] pageNameExtra = pageName.split('%3F',0);   
        pageName = pageNameExtra[0]; 
        pageName = pageName.replaceFirst('crta__',''); // compatible with development, packaging and subscriber orgs
        try {
            return [SELECT Translation__c 
                    FROM Page_label_translation__mdt 
                    WHERE MasterLabel = :pageName 
                    AND language_code__c = :UserInfo.getLanguage().left(2)].Translation__c;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            try {
                return [SELECT Id, Name, MasterLabel FROM ApexPage WHERE name=:pageName].MasterLabel;
            } catch(Exception e) {
                System.debug(e.getMessage());
                return '';
            }
        }
    }
    
    /**
* Retrieves the current user's contact id
*
* @return The current user's contact id
*/
    global static String getContactId() {
        try {
            return [SELECT Contact__c FROM User WHERE Id = :UserInfo.getUserId()].Contact__c;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
    
    /**
* Prints the url for a resource
* @param Name of the wanted resource
*   
* @return A relative url
*/
    global static String GetResourceURL(String resourceName){
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp 
                                            FROM StaticResource 
                                            WHERE Name = :resourceName];
        
        // Checking if the result is returned or not
        if(resourceList.size() == 1){
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' 
                + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        }
        else return '';
    }
    
    /**
* @deprecated  No longer in use
*/
    @deprecated
    global static String GetPageURL(String pageName, Map<String, String> args){
        // Fetching the resource
        //List<ApexPage> pageList= [SELECT Name, NamespacePrefix, SystemModStamp FROM ApexPage WHERE Name = :pageName];
        
        // Checking if the result is returned or not
        //if(pageList.size() == 1){
        // Getting namespace
        //String namespace = pageList[0].NamespacePrefix;
        // Resource URL
        //String baseUrl = '/apex/' + (namespace != null && namespace != '' ? namespace + '__' : '') + pageName; 
        String baseUrl = '/apex/' + pageName; 
        if(args.size() > 0) {
            baseUrl += '?';
            for(String arg: args.keySet()) {
                baseUrl += arg+'='+args.get(arg)+'&';
            }
        }
        return baseUrl;
        //}
        //else return '';
    }
    
    /**
* @deprecated Replaced by NotificationManager
*/
    @deprecated
    global static void createNotification(
        String contact, String text, String type, String objectName, String objectId
    ) {
        if(
            !Schema.sObjectType.SIRH_Notification__c.isCreateable()
            || !Schema.sObjectType.SIRH_Notification__c.fields.Salarie__c.isCreateable()
            || !Schema.sObjectType.SIRH_Notification__c.fields.Texte__c.isCreateable()
            || !Schema.sObjectType.SIRH_Notification__c.fields.Type__c.isCreateable()
            || !Schema.sObjectType.SIRH_Notification__c.fields.Objet__c.isCreateable()
            || !Schema.sObjectType.SIRH_Notification__c.fields.Id_de_l_objet__c.isCreateable()
        ) {
            System.debug('User does not have sufficient rights.');
            return;
        }
        SIRH_Notification__c notif = new SIRH_Notification__c(
            Salarie__c = contact,
            Texte__c = text,
            Type__c = type
        );
        if(objectName != null && objectId != null) {
            notif.Objet__c = objectName;
            notif.Id_de_l_objet__c = objectId;
        }
        try {
            insert notif;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    /**
* @deprecated Replaced by NotificationManager
*/
    @deprecated
    global static String readNotification(String notifId) {
        try {
            SIRH_Notification__c notification = [SELECT Lu__c FROM SIRH_Notification__c WHERE Id = :notifId LIMIT 1];
            if(
                !Schema.sObjectType.SIRH_Notification__c.isUpdateable()
                || !Schema.sObjectType.SIRH_Notification__c.fields.Lu__c.isUpdateable()
            ) {
                System.debug('User does not have sufficient rights.');
                return 'User does not have sufficient rights.';
            }
            notification.Lu__c = true;
            update notification;
            return 'success';
        } catch(Exception e) {
            return System.Label.SI_Error_notif_read.replace('{0}', e.getMessage());
        }
    }
    
    /**
* @deprecated Replaced by NotificationManager
*/
    webservice static String webReadNotification(String notifId) {
        return sirhTemplateController.readNotification(notifId);
    }
}