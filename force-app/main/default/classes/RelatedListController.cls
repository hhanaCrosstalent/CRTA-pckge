//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 13/05/2019
**/
public without sharing class RelatedListController {
    public virtual class FileException  extends Exception {}

	public class FieldWrapper {
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public String fieldLabel {get; set;}
        @AuraEnabled
        public String fieldType {get; set;}
        @AuraEnabled
        public Object fieldValue {get; set;}
        @AuraEnabled
        public Boolean isToShowMobile {get; set;}
        @AuraEnabled
        public String fieldValueLabel {get; set;}
        @AuraEnabled
        public String fieldHelpText {get; set;}
        @AuraEnabled
        public Map<String, String> pickListValues {get; set;}

        public FieldWrapper(String fieldName, String fieldLabel, String fieldType,
            Object fieldValue, String fieldValueLabel, String fieldHelpText, Map<String, String> pickListValues,Boolean isToShowMobile) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.fieldType = fieldType;
            this.fieldValue = fieldValue;
            this.fieldValueLabel = fieldValueLabel;
            this.fieldHelpText = fieldHelpText;
            this.pickListValues = pickListValues;
            this.isToShowMobile=isToShowMobile;    
        }
    }

    private static String getCurrentContact() {
        String contactId = [SELECT crta__Contact__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].crta__Contact__c;
        return contactId;
    }

    @AuraEnabled
    public static Map<String, String> retrievePicklistValues(String ObjectApi_name, String Field_name) {
        Map<String, String> pickListValues = new Map <String, String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map <String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List <Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: pick_list_values) {
            pickListValues.put(a.getValue(), a.getLabel());
        }
        return pickListValues;
    }
    
    @AuraEnabled
    public static Map<String, List<Object>> getFieldsCtrl(String objectApi, List<String> fieldList, Boolean createMode,
     String recordId, Boolean isPhone) {
         List<crta__Profile_Field_Setting__mdt> fieldsmdt=[SELECT Id, crta__API_Name__c,crta__Show_in_mobile__c FROM crta__Profile_Field_Setting__mdt where crta__Show_in_mobile__c = true];
         
         /*} else {
          fieldsmdt=[SELECT Id, crta__API_Name__c,crta__Show_in_mobile__c FROM crta__Profile_Field_Setting__mdt ];

         }*/
         Map<String,Boolean> MapFields=new Map<String,Boolean>();
         for(crta__Profile_Field_Setting__mdt p:fieldsmdt){
             MapFields.put(p.crta__API_Name__c,p.crta__Show_in_mobile__c);
         }
        sObject values = Schema.getGlobalDescribe().get(objectApi).newSObject();

        if(!createMode) {
            values = getRecordCtrl(fieldList, objectApi, recordId);
        }

        List<String> fieldListWithoutRef = new List<String>();
        for(String s : fieldList) {
            String tmp = s;
            if(tmp.contains('.')) {
                List<String> tmpSplited = tmp.split('\\.');
                s = (tmpSplited.get(0).contains('__r') ? tmpSplited.get(0).replace('__r','__c') : tmpSplited.get(0) + 'Id');
            }
            fieldListWithoutRef.add(s);
        }
        List<FieldWrapper> fieldsList = new List<FieldWrapper>();
        Map<String, List<Object>> fields = new Map<String, List<Object>>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objectApi);
        Schema.DescribeSObjectResult dsor = objectType.getDescribe();
        Map<String, Schema.SObjectField> mapTypes = dsor.fields.getMap();
        Map<String, String> labelsMap = PortalUtility.getTranslationMap(objectType, fieldListWithoutRef);
        for(String s : fieldList) {
            String init = s;
            if(init.contains('.')) {
                List<String> initSplited = init.split('\\.');
                s = (initSplited.get(0).contains('__r') ? initSplited.get(0).replace('__r','__c') : initSplited.get(0) + 'Id');
            }
            String fieldtype = String.valueOf(mapTypes.get(s).getDescribe().getType());
            String helptext = '';
            Schema.SObjectField field = mapTypes.get(s);
            helptext = field.getDescribe().getInlineHelpText();
            if(fieldType == 'TEXTAREA') {
                if(field.getDescribe().isHtmlFormatted()) {
                    fieldType = 'RICHTEXT';
                }
            }

            fieldsList.add(
                new FieldWrapper(
                    init, 
                    labelsMap.get(s), 
                    fieldtype,
                    (fieldtype == 'REFERENCE' ? PortalUtility.get(values, s) : PortalUtility.get(values, init)), 
                    (fieldtype == 'REFERENCE' ? PortalUtility.get(values, init) : ''), 
                    helptext,
                    RelatedListController.retrievePicklistValues(objectApi, s),
                  MapFields.get(s)
                )
            );
            }
     
        fieldsList.add(new FieldWrapper('objectLabel', labelsMap.get('Label'), '', null, null,'', null,false));
        fieldsList.add(new FieldWrapper('objectLabelPlural', labelsMap.get('LabelPlural'), '', null, null,'', null,false));
        fields.put('Fields', fieldsList);
            
        return fields;
    }
    
    @AuraEnabled
    public static List<sObject> getRecordsCtrl(String fieldsList, 
                                                String objectApi, 
                                                String referenceField, 
                                                String referenceValue, 
                                                String whereClause,
                                                String sortClause,
                                                String recordType) {

        if(String.isBlank(referenceValue)) {
            referenceValue = getCurrentContact();
        }

        SObjectType objectType = Schema.getGlobalDescribe().get(objectApi);
        Schema.DescribeSObjectResult dsor = objectType.getDescribe();
        Map<String, Schema.SObjectField> mapTypes = dsor.fields.getMap();
        List<String> fieldsListTmp = fieldsList.split(',');
        List<String> fieldsListArray = new List<String>();
        for(String s : fieldsListTmp) {
            system.debug(s);
            if(!s.contains('.')) {
                String fieldtype = String.valueOf(mapTypes.get(s).getDescribe().getType());
                if(fieldtype == 'PICKLIST') {
                    fieldsListArray.add('toLabel(' + s + ')');
                }
                //Tenhinene BENMESSAOUD - 19/01/2022
                else if(fieldtype == 'TIME') {
                    fieldsListArray.add('format(' + s + ')');
                }
                //Tenhinene BENMESSAOUD - 19/01/2022
                else {
                    fieldsListArray.add(s);
                }
            } else {
                if(s.toLowerCase().startsWith('recordtype.')) {
                    fieldsListArray.add('toLabel(' + s + ')');
                } else {
                    fieldsListArray.add(s);
                }
            }
        }


        String fields = '';
        fieldsListArray.add('CreatedById');
        if(fieldsListArray.size() > 0) {
            fields = ', ' + String.join(fieldsListArray,',');
        } 
        String query = 'SELECT Id' + fields + ', (SELECT Title FROM AttachedContentDocuments)' +
            ' FROM ' + objectApi + 
            ' WHERE ' + referenceField + ' =:referenceValue';
        if(whereClause != null)
        {
            query  +=  ' AND ('+whereClause+' = TRUE) ';
        }
        if(recordType != null)
        {
            query  +=  ' AND RecordType.DeveloperName =\'' + recordType + '\'';
        }
       
        if(sortClause != null)
        {
            query  += ' '+sortClause;
        }
        system.debug('query ' + query);
        List<sObject> objectToReturn = Database.query(query);
        system.debug('objectToReturn ' + objectToReturn);
        return objectToReturn;
    }

    @AuraEnabled
    public static sObject getRecordCtrl(List<String> fieldsList, String objectApi, String recordId) {
        SObjectType objectType = Schema.getGlobalDescribe().get(objectApi);
        Schema.DescribeSObjectResult dsor = objectType.getDescribe();
        Map<String, Schema.SObjectField> mapTypes = dsor.fields.getMap();
        List<String> fieldsListArray = new List<String>();
        for(String s : fieldsList) {
            system.debug(s);
            if(!s.contains('.')) {
                String fieldtype = String.valueOf(mapTypes.get(s).getDescribe().getType());
                if(fieldtype == 'PICKLIST') { fieldsListArray.add('toLabel(' + s + ')');
                } else {
                    fieldsListArray.add(s);
                }
            } else {  if(s.toLowerCase().startsWith('recordtype.')) {fieldsListArray.add('toLabel(' + s + ')'); } else {  fieldsListArray.add(s);
                }
            }
        }
        String fields = '';
        if(fieldsList.size() > 0) {
            fields = ', ' + String.join(fieldsListArray,',');
        } 

        String query = 'SELECT Id' + fields + ' FROM ' + objectApi + ' WHERE Id =: recordId LIMIT 1';
        sObject objectToReturn = Database.query(query);
        return objectToReturn;
    }

    @AuraEnabled
    public static Object insertNewRecord(sObject data, String objectApi, String referenceField, String referenceValue, String recordType, String requiredOnfield, List<String> contentDocumentIds) {
        String result = '';
        String errorFile = '';
      
        
        if(String.isBlank(referenceValue)) {
            referenceValue = getCurrentContact();
        }
        try {
            //ebe 27/05/2024
           // Récupérer la valeur de crta__Nom_Dossier_doc__c
		   list<crta__Nom_Dossier_doc__c>  dossierDoc = [SELECT crta__Nom_Dossier_doc__c 
                                            FROM crta__Nom_Dossier_doc__c  
                                            LIMIT 1];
              system.debug('dossierDocumentaireList' +dossierDoc+'****'+referenceValue);
            List<crta__Dossier_documentaire__c> dossierDocumentaireList;
            if (!dossierDoc.isEmpty())
            { system.debug('if 11 ' );
            if (dossierDoc[0].crta__Nom_Dossier_doc__c != null && dossierDoc[0].crta__Nom_Dossier_doc__c != '') {
                system.debug('if 22 ' );
    		// Utiliser la valeur récupérée pour exécuter la première requête
    		dossierDocumentaireList = [SELECT Id 
                               FROM crta__Dossier_documentaire__c 
                               WHERE crta__Salarie__c = :referenceValue 
                               AND Name = :dossierDoc[0].crta__Nom_Dossier_doc__c 
                               ORDER BY CreatedDate ASC 
                               LIMIT 1];
        	} }else {
                system.debug('else 11 ' );
    			// Exécuter la deuxième requête si crta__Nom_Dossier_doc__c est vide
   				 dossierDocumentaireList = [SELECT Id 
                               FROM crta__Dossier_documentaire__c 
                               WHERE crta__Salarie__c = :referenceValue 
                               AND crta__is_Onboarding_Folder__c = true 
                               ORDER BY CreatedDate ASC 
                               LIMIT 1];
			}
            system.debug('dossierDocumentaireList' +dossierDocumentaireList);
            // ebe fin 
            data.put(referenceField, referenceValue);
            if(recordType != null) {data.put('RecordTypeId', Schema.getGlobalDescribe().get(objectApi).getDescribe().getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId());
            }
            
            if (
                Schema.getGlobalDescribe().get(objectApi).getDescribe().isCreateable()
            ) {
                insert data;
                Formula.recalculateFormulas(new List<sObject>{data});
                if(requiredOnfield != null && requiredOnfield != '') {if(data.get(requiredOnfield) == true){throw new FileException(System.Label.Attachment_Required);
                    }
                }
                String Typecrta ='';
                List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
                List<ContentDocumentLink> fileLinks1 = new List<ContentDocumentLink>();
                List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.ContentVersion.fields.crta__Type__c.getPicklistValues();
                    Map<String, String> picklistValues = RelatedListController.retrievePicklistValues('ContentVersion', 'crta__Type__c');
                    for (String apiValue : picklistValues.keySet()) {
            		String label = picklistValues.get(apiValue);
                    system.debug('objectApi '+objectApi +' label aaa '+label+' ***** '+apiValue);
                    if (objectApi == apiValue ) { Typecrta = apiValue  ;
        		}}
                system.debug('Linkeeed Entity'+data.Id  + 'objectApi'+objectApi) ;
                if(contentDocumentIds != null) {
                    for(String s : contentDocumentIds) {
                        ContentDocumentLink fileLink = new ContentDocumentLink();
                        fileLink.LinkedEntityId = data.Id;
                        fileLink.ContentDocumentId = s;
                        fileLink.Sharetype = 'I';
                        fileLink.Visibility = 'AllUsers';
                        fileLinks.add(fileLink);
                        //ebe 27/05/2024
                       ContentDocumentLink fileLink1 = new ContentDocumentLink();
                        if (!dossierDocumentaireList.isEmpty())
                        {
                        fileLink1.LinkedEntityId = dossierDocumentaireList[0].Id;
                        fileLink1.ContentDocumentId = s;
                        fileLink1.Sharetype = 'V';
                        fileLink1.Visibility = 'AllUsers';
                        fileLinks1.add(fileLink1);
                        }
                    }
                    //fin ebe
                    if(fileLinks.size() > 0) {
                        insert fileLinks;
                    }
                    if(fileLinks1.size() > 0 &!dossierDocumentaireList.isEmpty() ) {
                    insert fileLinks1;
                    // Extraire les ContentDocumentIds de fileLink1
					Set<Id> contentDocumentIds1 = new Set<Id>();
					for(ContentDocumentLink link : fileLinks1) {
   					 contentDocumentIds1.add(link.ContentDocumentId);
					}
                    List<ContentVersion> contentVersionsToUpdate = [SELECT Id, title, crta__Etat__c, CreatedDate, ContentDocumentId, crta__Commentaire__c, PathOnClient,
                                                crta__Tags__c, crta__Type__c 
                                                FROM ContentVersion 
                                                WHERE islatest=true 
                                                AND ContentDocumentId IN :contentDocumentIds1];

					// Mettre à jour le champ crta__Type__c pour chaque enregistrement
					for (ContentVersion c : contentVersionsToUpdate) {
  					c.crta__Type__c = Typecrta ;// Remplacez 'new value' par la valeur que vous souhaitez assigner
					}

					// Effectuer la mise à jour dans la base de données
					update contentVersionsToUpdate;
                }
                }
                return data;
            } else { result = System.Label.Permission.removeEnd('.') + ' on ' + objectApi + ' Object';
            }
        } catch(AuraHandledException e){ result = e.getMessage();
            system.debug(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
        }
        return result;
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getFilesCtrl(String recordId) {
        List<ContentDocumentLink> l = new List<ContentDocumentLink>();
        for(ContentDocumentLink cdl : [
            SELECT Id, LinkedEntityId, ContentDocumentId,
                ContentDocument.LatestPublishedVersion.CreatedDate,
                ContentDocument.LatestPublishedVersion.Title,
                ContentDocument.OwnerId
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: recordId ]) { l.add(cdl);
        }
        return l;
    }

    @AuraEnabled
    public static Object editRecordCtrl(sObject data) {
        String result = '';
        try {
            Schema.DescribeSObjectResult dsor = data.Id.getSObjectType().getDescribe();
            if (dsor.isUpdateable()) {
                update data;
                Formula.recalculateFormulas(new List<sObject>{data});
            } else {return System.Label.Permission.removeEnd('.') + ' on ' + dsor.getName() + ' Object';
            }
            return data;
        } catch(AuraHandledException e){
            result = e.getMessage();
            //throw new AuraHandledException(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            system.debug(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            //throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static String deleteRecordCtrl(Id recordId) {
        String result = '';
        try {
            Schema.DescribeSObjectResult dsor = recordId.getSObjectType().getDescribe();
            if (dsor.isDeletable()) {
            	Database.delete(recordId); 
            	result = 'success';} else {return System.Label.Permission.removeEnd('.') + ' on ' + dsor.getName() + ' Object';
            }
        } catch(AuraHandledException e){
            result = e.getMessage();
            //throw new AuraHandledException(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            system.debug(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            //throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

   @AuraEnabled
    public static String deleteFileCtrl(String recordId){
        String result = '';
        try{
            if (Schema.sObjectType.ContentDocument.isDeletable()) {
                delete [SELECT Id FROM ContentDocument WHERE Id=:recordId];
            	result = 'SUCCESS';} else { return System.Label.Permission;
            }
        } catch(AuraHandledException e){
            result = e.getMessage();
            //throw new AuraHandledException(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            system.debug(e.getMessage().replaceFirst(':\\s+\\[\\]\\s+.*',''));
            //throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
    
}