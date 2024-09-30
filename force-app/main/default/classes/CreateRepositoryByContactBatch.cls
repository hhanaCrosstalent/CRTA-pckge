//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Generate repository for contacts
 * @author Abdel NAJI
 * @version 1.0
**/
global with sharing class CreateRepositoryByContactBatch implements
	Database.Batchable<Contact>,
	Database.Stateful,
    Schedulable
{
    private static final Integer SCOPE_SIZE = 200;
    public static Integer getScopeSize(){return SCOPE_SIZE;}

    private List<String> contactIds = new List<String>();

    global CreateRepositoryByContactBatch(List<Id> contactIds) {
        this.contactIds = contactIds;
    }

    global CreateRepositoryByContactBatch(Id contactId) {
        this.contactIds = new List<Id>{contactId};
    }

    global CreateRepositoryByContactBatch() {}

    global List<Contact> start(Database.BatchableContext BC) {
        if(this.contactIds.size() == 0) {
            return [
                SELECT Id, 
                    Name,
                    FirstName,
                    LastName,
                	RecordType.DeveloperName
                FROM Contact
                LIMIT 500];
        }

        return [
            SELECT Id, 
                Name,
                FirstName,
                LastName, 
                RecordType.DeveloperName
            FROM Contact 
            WHERE Id IN :contactIds
        ];
    }

    global void execute(SchedulableContext bc) {
        Database.executeBatch(this, CreateRepositoryByContactBatch.SCOPE_SIZE);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Set<String> allcontactIds = new Set<String>();
        if(this.contactIds.size() == 0) {
            for(Contact contact : scope) {
                allcontactIds.add(contact.Id);
            }
        } else {
            allcontactIds.addAll(this.contactIds);
        }
        List<crta__Dossier_documentaire__c> foldersToInsert = new List<crta__Dossier_documentaire__c>();

        Map<String, List<crta__Folder_Setting__mdt>> foldersByRT = new Map<String, List<crta__Folder_Setting__mdt>>();
        for(crta__Folder_Setting__mdt folder : [
            SELECT Id,
                crta__Record_Types__c,
                crta__Is_Root__c,
                crta__Name__c,
                DeveloperName,
                crta__Parent_Folder_API_Name__c,
                crta__To_Display__c,
                crta__Publication_Start_Date__c,
                crta__Publication_End_Date__c,
            	crta__Folder_Custom_Icon__c,
            	crta__is_Doc_Gen_Folder__c,
            	crta__is_Onboarding_Folder__c
            FROM crta__Folder_Setting__mdt WHERE crta__IsActive__c = true
        ]) {
            if(foldersByRT.containsKey(folder.crta__Record_Types__c)) {
                foldersByRT.get(folder.crta__Record_Types__c).add(folder);
            } else {
                foldersByRT.put(folder.crta__Record_Types__c, new List<crta__Folder_Setting__mdt>{folder});
            }
        }

        Set<String> existingfolderByContact = new Set<String>();
        for(crta__Dossier_documentaire__c folder : [
            SELECT Id,
                crta__Unique_Name__c,
                Name,
                crta__Parent_Name__c,
                crta__Salarie__c
            FROM crta__Dossier_documentaire__c
            WHERE crta__Salarie__c IN: allcontactIds
        ]) {
            existingfolderByContact.add(folder.crta__Salarie__c + folder.crta__Unique_Name__c);
        }

        Map<String, Map<String, String>> folderIdByNameByContact = new Map<String, Map<String, String>>();
        for(Contact contact : scope) {
            if(!foldersByRT.containsKey(contact.RecordType.DeveloperName)) continue;
            List<crta__Folder_Setting__mdt> folders = foldersByRT.get(contact.RecordType.DeveloperName);

            Boolean check = false;
            for(crta__Folder_Setting__mdt folder : folders) {
                if(existingfolderByContact.contains(contact.Id + folder.DeveloperName)) {
                    check = true;
                    break;
                }
            }

            if(check) {
                System.debug('The repository is already created for : ' + contact.Firstname + ' ' + contact.LastName);
                continue;
            }

            Map<String,String> folderIdbyName = new Map<String,String>();
            for(crta__Folder_Setting__mdt folder : folders) {
                crta__Dossier_documentaire__c currentFolder = new crta__Dossier_documentaire__c();
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Unique_Name__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Unique_Name__c.isUpdateable()) {
                    currentFolder.crta__Unique_Name__c = folder.DeveloperName;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.Name.isCreateable() 
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.Name.isUpdateable()) {
                    currentFolder.Name = folder.crta__Name__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Parent_Name__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Parent_Name__c.isUpdateable()) {
                    currentFolder.crta__Parent_Name__c = folder.crta__Parent_Folder_API_Name__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Salarie__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Salarie__c.isUpdateable()) {
                    currentFolder.crta__Salarie__c = contact.Id;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__A_afficher__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__A_afficher__c.isUpdateable()) {
                    currentFolder.crta__A_afficher__c = folder.crta__To_Display__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Date_de_publication__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Date_de_publication__c.isUpdateable()) {
                    currentFolder.crta__Date_de_publication__c = folder.crta__Publication_Start_Date__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Date_de_fin_de_publication__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Date_de_fin_de_publication__c.isUpdateable()) {
                    currentFolder.crta__Date_de_fin_de_publication__c = folder.crta__Publication_End_Date__c;
                }
                
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Folder_Custom_Icon__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__Folder_Custom_Icon__c.isUpdateable()) {
                    currentFolder.crta__Folder_Custom_Icon__c = folder.crta__Folder_Custom_Icon__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__is_Doc_Gen_Folder__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__is_Doc_Gen_Folder__c.isUpdateable()) {
                    currentFolder.crta__is_Doc_Gen_Folder__c = folder.crta__is_Doc_Gen_Folder__c;
                }
                if(Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__is_Onboarding_Folder__c.isCreateable()
                    || Schema.sObjectType.crta__Dossier_documentaire__c.fields.crta__is_Onboarding_Folder__c.isUpdateable()) {
                    currentFolder.crta__is_Onboarding_Folder__c = folder.crta__is_Onboarding_Folder__c;
                }
                foldersToInsert.add(currentFolder);
                folderIdbyName.put(currentFolder.crta__Unique_Name__c, currentFolder.Id);
            }
            folderIdByNameByContact.put(contact.Id, folderIdbyName);
        }

        if(foldersToInsert.size() > 0) {
            if(Schema.sObjectType.crta__Dossier_documentaire__c.isCreateable()) {
                insert foldersToInsert;
            }
            for(crta__Dossier_documentaire__c folder : foldersToInsert) {
                folderIdByNameByContact.get(folder.crta__Salarie__c).put(folder.crta__Unique_Name__c,folder.Id);
            }

            for(crta__Dossier_documentaire__c folder : foldersToInsert) {
                folder.crta__Dossier_parent__c = folderIdByNameByContact.get(folder.crta__Salarie__c).get(folder.crta__Parent_Name__c);
            }
            if(Schema.sObjectType.crta__Dossier_documentaire__c.isUpdateable()) {
                update foldersToInsert;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {}
}