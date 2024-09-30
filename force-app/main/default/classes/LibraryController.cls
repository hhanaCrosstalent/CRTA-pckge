//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date: 19/12/2018
*** @Modified by : MBAYE Fallou
*** @Last Modified Date : 27/10/2021
*** added the possibility to deactivate metadata
*** @Modified by : BENMESSAOUD Tenhinene
*** Replace without sharing by with sharing to enforce sharing rules CT-202202#004365
**/
//public without sharing class LibraryController {
public with sharing class LibraryController {
    public class FolderWrapper {
        @AuraEnabled
        public String folderId {get; set;}
        @AuraEnabled
        public String parentId {get; set;}
        @AuraEnabled
        public crta__Dossier_documentaire__c folder {get; set;}
        @AuraEnabled
        public List<FolderWrapper> childFolders {get; set;}
        
        public FolderWrapper(
            String folderId, String parentId,
            crta__Dossier_documentaire__c folder, List<FolderWrapper> childFolders
        ) {
            this.folderId = folderId;
            this.parentId = parentId;
            this.folder = folder;
            this.childFolders = childFolders;
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getConnectedContactIdCtrl() {
        String contactId = [SELECT crta__Contact__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].crta__Contact__c;
        Map<String, String> currentContact = new Map<String, String>();
        currentContact.put('Id', contactId);
        if(contactId != null) {
            Contact c = [SELECT Id, crta__CT_Status_of_employee__c, RecordType.DeveloperName FROM Contact WHERE Id =:contactId];
            if(c != null) {
                if(c.RecordType.DeveloperName == 'Onboarding') {
                    Onboarding_Settings__c settings = Onboarding_Settings__c.getInstance();
                    if(settings.crta__Modification_Status__c != c.crta__CT_Status_of_employee__c) {
                        currentContact.put('Onboarding', 'true');
                    } else {
                         currentContact.put('Onboarding', 'false');
                    }
                }
            }
        }
        return currentContact;
    }
    
    @AuraEnabled
    public static List<FolderWrapper> getFoldersCtrl(Boolean isPrivate, String contactId) {
        List<FolderWrapper> folderList = new List<FolderWrapper>();
        Map<String, List<crta__Dossier_documentaire__c>> m = new Map<String, List<crta__Dossier_documentaire__c>>();
        Contact c = getContact();
        
        if(isPrivate) {
            if(contactId == null) {
                contactId = c.Id;
            }
        } else {
            contactId = null;
        }
        
        System.debug('contactId, ' +  contactId);
        
        String query = '';
        List<crta__Dossier_documentaire__c> folders = new List<crta__Dossier_documentaire__c>();
        
        query = 'SELECT Id, Name, crta__Dossier_parent__c, crta__Folder_Custom_Icon__c, '
            + '(SELECT ContentDocument.Id, ContentDocument.FileExtension, ContentDocument.FileType, '
            + 'ContentDocument.Title, ContentDocument.LatestPublishedVersion.crta__Tags__c, '
            + 'tolabel(ContentDocument.LatestPublishedVersion.crta__Type__c), ContentDocument.OwnerId '
            + 'FROM AttachedContentDocuments WHERE ContentDocument.LatestPublishedVersion.crta__Hide_in_Portal__c = FALSE) '
            + 'FROM crta__Dossier_documentaire__c '
            + 'WHERE crta__A_afficher__c = TRUE '
            + 'AND crta__Salarie__c =: contactId '
            + 'AND (crta__Date_de_fin_de_publication__c = null OR crta__Date_de_fin_de_publication__c > TODAY)'
            + ' ORDER BY Name ASC';
        folders = Database.query(query);
        
        Map<Id, crta__Dossier_documentaire__c> foldersById = new Map<Id, crta__Dossier_documentaire__c>();
        foldersById.putAll(folders);
        
        system.debug(folders);
        for(crta__Dossier_documentaire__c d : folders) {
            String key = (!String.isBlank(d.crta__Dossier_parent__c) && foldersById.containsKey(d.crta__Dossier_parent__c))
                ? String.valueOf(d.crta__Dossier_parent__c) : 'Top';
            if(m.containsKey(key)) {
                m.get(key).add(d);
            } else {
                m.put(key, new List<crta__Dossier_documentaire__c>{d});
            }
        }
        
        if(m.containsKey('Top')) {
            for(crta__Dossier_documentaire__c d : m.get('Top')) {
                folderList.add(new FolderWrapper(
                    d.Id, 'Top', d, getChild(d.Id, m)
                ));
            }
        }
        System.debug('folderList ' + folderList);
        return folderList;
    }
    
    private static List<FolderWrapper> getChild(
        String folderId, Map<String, List<crta__Dossier_documentaire__c>> m
    ) {
        List<FolderWrapper> childs = new List<FolderWrapper>();
        if(m.containsKey(folderId)) {
            for(crta__Dossier_documentaire__c d : m.get(folderId)) {
                childs.add(new FolderWrapper(
                    d.Id, d.crta__Dossier_parent__c, d, getChild(d.Id, m)
                ));
            }
        }
        return childs;
    }
    
    public static Contact getContact() {
        User loggedUser = [SELECT crta__Contact__c FROM User WHERE Id = :UserInfo.getUserId()];
       
        try {
            String query = 'SELECT Id, RecordType.DeveloperName FROM Contact WHERE Id =\''+ loggedUser.crta__Contact__c +'\'';
            System.debug(query);
            Contact currentContact = Database.query(query);
            return currentContact; } catch(Exception e) {Contact currentContact = new Contact();  return currentContact;} }
            
          
        
   

    @AuraEnabled
    public static List<crta__Profile_File_Setting__mdt> getAllFileTypes() {
        List<crta__Profile_File_Setting__mdt> profileFileSettings = new List<crta__Profile_File_Setting__mdt>();
        for(crta__Profile_File_Setting__mdt f : 
            [SELECT Id, 
             crta__API_Name__c, 
             crta__Public_Group__c, 
             crta__Send_Mail__c,
             crta__Email_Template_API_Name__c,
             MasterLabel,
             crta__Required__c,
             crta__Record_Types__c,
             crta__Required_on_Field__c,
             crta__Allow_to_Delete__c
             FROM crta__Profile_File_Setting__mdt WHERE Disable__c =false
             ORDER BY MasterLabel
            ]) {
                profileFileSettings.add(f);
            }
            return profileFileSettings;
        }
    
    @AuraEnabled
    public static List<crta__Profile_File_Setting__mdt> getFileTypes() {
        Set<String> fields = new Set<String>();
        fields.add('Id');
        List<crta__Profile_File_Setting__mdt> profileFileSettings = getAllFileTypes();
        for(crta__Profile_File_Setting__mdt f : profileFileSettings) {
                if(f.Record_Types__c != null) {
                    fields.add('RecordType.DeveloperName');
                }
                 if(f.crta__Required_on_Field__c != null) {
                    fields.add(f.crta__Required_on_Field__c);
                }
            }


            Contact myContact = Database.query(PortalUtility.getSOQLQuery(fields, 'Contact', 'Id = \'' + getConnectedContactIdCtrl().get('Id') + '\'' , '', '1', ''));

            List<crta__Profile_File_Setting__mdt> profileFileSettingsToAdd = new List<crta__Profile_File_Setting__mdt>();
            for(crta__Profile_File_Setting__mdt f : profileFileSettings) {
                List<String> recordTypes = new List<String>();
                if(f.Record_Types__c != null) {
                    recordTypes = f.Record_Types__c.replaceAll( '\\s+', '').split(',');
                    if(recordTypes.contains(String.valueOf(myContact.RecordType.DeveloperName))) {
                        if(f.crta__Required_on_Field__c != null) {
                            if(myContact.get(f.crta__Required_on_Field__c) == true) {     f.crta__Required__c = true;
                            }
                        }
                        profileFileSettingsToAdd.add(f);
                    }
                } else { profileFileSettingsToAdd.add(f);} 
            }

        return profileFileSettingsToAdd;
    }
    
    @AuraEnabled
    public static Map<String, String> getTagsList() {
        Map<String, String> pickListValues = new Map <String, String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('ContentVersion');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map <String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List <Schema.PicklistEntry> pick_list_values = field_map.get('crta__Tags__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: pick_list_values) {
            pickListValues.put(a.getValue(), a.getLabel());
        }
        return pickListValues;
    }
    
    @AuraEnabled
    public static List<crta__Dossier_documentaire__c> getFoldersList(){
        Contact myContact = getContact();
        List<crta__Dossier_documentaire__c> folderList = new List<crta__Dossier_documentaire__c>();
        String contactId = getConnectedContactIdCtrl().get('Id');
        for(crta__Dossier_documentaire__c f : [SELECT Id, 
                                               Name,
                                               is_Onboarding_Folder__c
                                               FROM crta__Dossier_documentaire__c
                                               WHERE crta__A_afficher__c = TRUE
                                               AND crta__Salarie__c =: contactId
                                               ORDER BY Name 
                                              ]) {
                                                  if(String.valueOf(myContact.RecordType.DeveloperName) != 'Onboarding') {
                                                      if(!f.is_Onboarding_Folder__c) {
                                                          folderList.add(f);
                                                      }
                                                  } else {
                                                      if(f.is_Onboarding_Folder__c) {
                                                          folderList.add(f);
                                                      }
                                                  }
                                              }
        return folderList;
    }
    
    @AuraEnabled  
    public static List<ContentDocument> updateFilesCtrl(String documentId, String recordId, String fileType, List<String> tags){  
        String cdId = [SELECT id FROM ContentDocument where Id=:documentId].Id; // Getting files from Parent record 
        ContentVersion file = [SELECT Id, crta__Type__c FROM ContentVersion WHERE ContentDocumentId =:cdId];
        system.debug('type fichier ' + fileType);
        file.crta__Type__c = fileType;
        if(tags.size() > 0) {
            file.crta__Tags__c = String.join(tags, ';' );
        }
        ContentDistribution cd = new ContentDistribution();
        if(fileType == 'CV') {
            cd.ContentVersionId = file.Id;
            cd.RelatedRecordId = recordId;
            cd.Name = 'FilePublicShare';
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;
        }
        try{
            if (
            	Schema.sObjectType.ContentVersion.isUpdateable()
                && Schema.sObjectType.ContentVersion.fields.crta__Type__c.isUpdateable()
                && Schema.sObjectType.ContentVersion.fields.crta__Tags__c.isUpdateable()
            ) {
            	update file;

                if(
                    fileType == 'CV'
                    && Schema.sObjectType.ContentDistribution.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.ContentVersionId.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.RelatedRecordId.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.Name.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.PreferencesAllowViewInBrowser.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.PreferencesLinkLatestVersion.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.PreferencesNotifyOnVisit.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.PreferencesPasswordRequired.isCreateable()
                    && Schema.sObjectType.ContentDistribution.fields.PreferencesAllowOriginalDownload.isCreateable()
                ) {
                    insert cd;
                } else {
                    System.debug('fileType ' + fileType);
                    System.debug(System.Label.Permission + ' LibraryController line 231');
                }
            } else {
                System.debug(System.Label.Permission + ' LibraryController line 217');
            }
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> documentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();
        List<ContentDocumentLink> cdl = [SELECT Id,
                                         LinkedEntityId,
                                         ContentDocumentId 
                                         FROM ContentDocumentLink 
                                         WHERE LinkedEntityId =: recordId];
        
        for(ContentDocumentLink cdLink:cdl){
            documentIds.add(cdLink.ContentDocumentId);
        }
        documentList = [SELECT Id,
                        Title,
                        FileType,
                        ContentSize,
                        Description 
                        FROM ContentDocument 
                        WHERE Id IN: documentIds
                        ORDER BY ContentModifiedDate DESC];
        return documentList;  // Return list of files on parent record
    }

    @AuraEnabled
    public static String deleteFileCtrl(String recordId){
        String result = '';
        try{
            if (Schema.sObjectType.ContentDocument.isDeletable()) {
                delete [SELECT Id FROM ContentDocument WHERE Id=:recordId];
            	result = 'SUCCESS';
            } else {
                return System.Label.Permission;
            }
        } catch(AuraHandledException e){
            result = e.getMessage();
            system.debug(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
        }
        return result;
    }
    
    @AuraEnabled
    public static String sendMailCtrl(String publicGroup, String documentId, String folderId, String emailTemplateName){
        String urlOrg = System.URL.getSalesforceBaseUrl().toExternalForm();
        EmailTemplate templateMail = [SELECT 
                                      Id, 
                                      Subject, 
                                      HtmlValue, 
                                      Body,
                                      BrandTemplateId
                                      FROM EmailTemplate 
                                      WHERE DeveloperName =: emailTemplateName];

        String brandTemplateValue;
        if(templateMail.BrandTemplateId != null) {
            BrandTemplate brandTemplateTmp = [SELECT 
                                                Id,
                                                Value
                                            FROM BrandTemplate
                                            WHERE Id =: templateMail.BrandTemplateId];
            if(brandTemplateTmp != null) {
                brandTemplateValue = brandTemplateTmp.Value
                                        .replaceAll('<!\\[CDATA\\[', '')
                                        .replaceAll('\\]\\]>', '');
            }
        }
        
        Set<String> usersList = new Set<String>();
        Set<String> memberList = new Set<String>();
        
        for(GroupMember g : [SELECT userOrGroupId
                             FROM GroupMember 
                             WHERE Group.DeveloperName =: publicGroup]) {
                                 memberList.add(g.userOrGroupId);
                             }
        
        for(User u : [SELECT Id FROM User WHERE Id IN :memberList]) {
            usersList.add(u.Id);
        }
        
        ContentDocument d = [SELECT Id,
                             Title,
                             FileExtension,
                             LatestPublishedVersion.crta__Type__c
                             FROM ContentDocument 
                             WHERE Id =: documentId LIMIT 1];
        
        system.debug(folderId);
        crta__Dossier_documentaire__c f = [SELECT Id, 
                                           crta__Salarie__r.Name,
                                           crta__Salarie__r.Id 
                                           FROM crta__Dossier_documentaire__c 
                                           WHERE Id =: folderId LIMIT 1];
        
        if(brandTemplateValue != null) {
            Pattern stylePattern = Pattern.compile('<style(.*?)>');
            Matcher stylePatternResult = stylePattern.matcher(brandTemplateValue);
            List<String> stylesTag = new List<String>();
            while (stylePatternResult.find()) {
                String styleTabTmp = 'style="' + stylePatternResult.group(1).replaceAll('=\"', ':').replaceAll('\"', ';') + '"';
                stylesTag.add(styleTabTmp);
            }
            
            Pattern tagsPattern = Pattern.compile('(<body(.*?)>|<td(.*?)>)');
            Matcher tagsPatternResult = tagsPattern.matcher(brandTemplateValue);
            Integer index = 0;
            while (tagsPatternResult.find()) { 
                String tagTmp = tagsPatternResult.group(1);
                String newTag = tagTmp.substringBefore('>') + ' ' + stylesTag.get(index) + '>';
                brandTemplateValue = brandTemplateValue.replaceFirst(tagsPatternResult.group(1), newTag);
                index++;
            }

            //Pour insérer le body
            Pattern tdPattern = Pattern.compile('<td(.*?)\\>');
            Matcher tdPatternResult = tdPattern.matcher(brandTemplateValue);
            Integer index2 = 0;
            while (tdPatternResult.find()) { 
                String tagTmp = tdPatternResult.group(1) + '>';
                String body = '';
                if(index2 == 2) {
                    body = templateMail.HtmlValue;
                    String newTag = tagTmp + body;
                    brandTemplateValue = brandTemplateValue.replaceFirst(tagTmp, newTag);
                }
                index2++;
            }

            Pattern imgPattern = Pattern.compile('(?ms)<img(.*?)>(.*?)<\\/img>');
            Matcher imgPatternResult = imgPattern.matcher(brandTemplateValue);
            while (imgPatternResult.find()) { 
                String tagTmp = imgPatternResult.group(2).replaceAll('\\n', '');
                if(tagTmp != '') {
                    String newTag = '<img ' + imgPatternResult.group(1) + ' src="' + urlOrg + '/' + tagTmp + '"/>';
                    brandTemplateValue = brandTemplateValue.replace(imgPatternResult.group(0), newTag);
                }
            }
        }

        String templateStr;
        if(brandTemplateValue != null) {
                templateStr = brandTemplateValue;
            } else {
                templateStr = templateMail.HtmlValue;
            }
        if(templateStr == null) {
            templateStr = templateMail.Body;
        }
        Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage>();
        
        for(String userId: usersList) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(templateMail.Subject);
            mail.setToAddresses(new List<Id>{userId});
           if( d.LatestPublishedVersion.crta__Type__c != null)
            templateStr = templateStr.replace('{!type}', d.LatestPublishedVersion.crta__Type__c)
                .replace('{!employee}', f.crta__Salarie__r.Name)
                .replace('{!link}', urlOrg + '/' + f.Id)
                .replace('{!file}', d.Title + '.' + d.FileExtension)
                .replaceAll('<!\\[CDATA\\[', '')
                .replaceAll('\\]\\]>', '');
            
               
            if(templateMail.HtmlValue != null) {
                mail.setHtmlBody(templateStr);
                mail.setPlainTextBody(templateMail.Body);
            } else {
                mail.setPlainTextBody(templateStr);
            }
            
            mails.add(mail);
        }
        
        try {
            if(mails.size() > 0) {
               Messaging.sendEmail(mails);
            }
            
            system.debug('SUCCESS ! Email sent !');
            return 'SUCCESS';
        } catch(Exception e) {
            system.debug('Exception has occurred ! ' + e.getMessage());
            return e.getMessage();
        }
    }
}