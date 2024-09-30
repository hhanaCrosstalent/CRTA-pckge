//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date :  06/02/2019
**/
public without sharing class TeamController {
    public class FieldWrapper {
        @AuraEnabled
        public String fieldType {get; set;}
        @AuraEnabled
        public Object fieldValue {get; set;}
        
        public FieldWrapper(String fieldType, Object fieldValue) {
            this.fieldType = fieldType;
            this.fieldValue = fieldValue;
        }
    }
    
    public class ContactWrapper {
        @AuraEnabled
        public String contactId {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public ContentDistribution photo {get; set;}
        @AuraEnabled
        public ContentDistribution cv {get; set;}
        @AuraEnabled
        public List<FieldWrapper> fields {get; set;}
        
        public ContactWrapper(
            String contactId,
            String name,
            ContentDistribution photo,
            ContentDistribution cv,
            List<FieldWrapper> fields
        ) {
            this.contactId = contactId;
            this.name = name;
            this.photo = photo;
            this.cv = cv;
            this.fields = fields;
        }
    }

    public class ContactsLevelWrapper {
        @AuraEnabled
        public String level {get; set;}
        @AuraEnabled
        public List<ContactWrapper> contactsList {get; set;}
        public ContactsLevelWrapper(String level , List<ContactWrapper> contactsList) {
            this.level=level;
            this.contactsList=contactsList;
        }
    }
    
    @AuraEnabled
    public static Map<String, Map<String, String>> getTranslations() {
        Map<String, Map<String, String>> m = new Map<String, Map<String, String>>();
        m.put('Contact', PortalUtility.getTranslationMap(Contact.SObjectType, new String[] {
            'Title', 'crta__CT_Service__c', 'crta__CT_Matricule__c', 'crta__CT_Date_of_entry_to_the_society__c'
                }));
        return m;
    }
    
    private static String getContactId() {
        return [
            SELECT crta__Contact__c 
            FROM User 
            WHERE Id = :UserInfo.getUserId()
        ].crta__Contact__c;
    }
    
   /* @AuraEnabled
    public static Map<String, Object> getEmployees(Integer level, String recordTypes) {
        Map<String, Schema.SObjectField> mapTypes = Schema.SObjectType.Contact.fields.getMap();
        Map<String, Object> m = new Map<String, Object>();
        Map<String, List<ContactWrapper>> employeesList = new Map<String, List<ContactWrapper>>();
        String contactId = getContactId();
        List<Contact> employees = new List<Contact>();
        
        crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
        Set<String> strFields = new Set<String>();
        if(teamSettings.crta__Field_1__c != NULL) {
            strFields.add(teamSettings.crta__Field_1__c);
        }
        if(teamSettings.crta__Field_2__c != NULL) {
            strFields.add(teamSettings.crta__Field_2__c);
        }
        if(teamSettings.crta__Field_3__c != NULL) {
            strFields.add(teamSettings.crta__Field_3__c);
        }
        if(teamSettings.crta__Field_4__c != NULL) {
            strFields.add(teamSettings.crta__Field_4__c);
        }
        
        for(Integer i = 0; i <= level ; i++) {
            if(i == 1) {
                strFields.add('ReportsToId');
            }
            if(i == 2) {
                strFields.add('ReportsTo.ReportsToId');
            }
            if(i == 3) {
                strFields.add('ReportsTo.ReportsTo.ReportsToId');
            }
            // SRA 28-04-2023 debut ajout des N+4 à N+8
            if(i == 4) {
                strFields.add('ReportsTo.ReportsTo.ReportsTo.ReportsToId');
            }
            if(i == 5) {
                strFields.add('ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId');
            } 
            
            if(i == 6) {
                //   strFields.add('ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId');
                //   strFields.add('crta__N_6__c ');
            } 
            
            if(i == 7) {
                //  strFields.add('ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId');
            } 
            
            if(i == 8) {
                //   strFields.add('ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId');
            }           
            // fin
        }
        
        String levels = getLevels(level);
        List<String> recordTypesList = new List<String>();
        
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
        // SRA 10-05-2023
        
         List<crta__Contact_Level__mdt> listFields= [SELECT ID, crta__Contact_N_6__c, crta__Contact_N_7__c, crta__Contact_N_8__c FROM crta__Contact_Level__mdt];
        
        system.debug('contactId : ' + contactId);
        if(listFields.size() > 0){
        String query_N_6 = 'SELECT Id , Name, '+ listFields[0].crta__Contact_N_6__c + ' , ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId , ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsToId  FROM Contact WHERE RecordType.DeveloperName IN :recordTypesList '
            + ' AND (ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsToId =:contactId  OR ReportsToId =: contactId  )'
            + ' AND  (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ORDER BY LastName LIMIT 500 ';
       
        String query_N_7 = 'SELECT Id , Name, '+ listFields[0].crta__Contact_N_6__c + ',' + listFields[0].crta__Contact_N_7__c +' , ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId FROM Contact WHERE RecordType.DeveloperName IN :recordTypesList '
            + ' AND (crta__N_7__c != null OR ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsToId =:contactId  OR ReportsToId =: contactId  )'
            + ' AND  (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ORDER BY LastName LIMIT 500 ';
        
        String query_N_8 = 'SELECT Id , Name, '+ listFields[0].crta__Contact_N_6__c + ',' + listFields[0].crta__Contact_N_7__c + ',' + listFields[0].crta__Contact_N_8__c + ',  ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId , ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsTo.ReportsToId, ReportsTo.ReportsToId FROM Contact WHERE RecordType.DeveloperName IN :recordTypesList '
            + ' AND (crta__N_7__c != null OR  crta__N_8__c != null  OR ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsTo.ReportsTo.ReportsToId =: contactId OR ReportsTo.ReportsTo.ReportsToId =: contactId OR  ReportsTo.ReportsToId =:contactId  OR ReportsToId =: contactId  )'
            + '  AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ORDER BY LastName LIMIT 500 ';
        
        system.debug('query_N_8 : ' + query_N_8);
            if(level == 6) {
                system.debug('55555 '+recordTypesList  );
                                system.debug('6666 '+contactId   );
                system.debug('level 6' +query_N_6);           
                employees = Database.query(query_N_6);   
                
            } else if(level == 7){
                employees = Database.query(query_N_7);  
                system.debug(' query_N_7 : ' + query_N_7);
            } else if (level == 8){
                employees = Database.query(query_N_8);    
                
            }
        }

        String query = 'SELECT Id, Name, ' + String.join(new List<String>(strFields),',')
            + ' FROM Contact '
            + 'WHERE RecordType.DeveloperName IN :recordTypesList '
            + levels
            + ' AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) '
            + 'ORDER BY LastName LIMIT 500';
        
        //     system.debug('level value : ' + levels);
        //     system.debug('query value : ' + Database.query(query));
      system.debug('queryqueryquery '+query);
        if(level <= 5){
            system.debug('level 5 ou inferieur');
            employees = Database.query(query);
        } 
        
        system.debug('employee : ' + employees);
        Set<String> contactIds = new Set<String>();
        for(Contact c : employees) {
            contactIds.add(c.Id);
        }
        
        Map<String, Map<String, ContentDistribution>> filesURLByDocumentId = getPublicProfilePicture(contactIds);
        for(Contact c : employees) {
            List<FieldWrapper> fw = new List<FieldWrapper>();
            if(teamSettings.crta__Field_1__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_1__c),
                    PortalUtility.get(c,teamSettings.crta__Field_1__c)
                ));
            }
            
            if(teamSettings.crta__Field_2__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_2__c),
                    PortalUtility.get(c,teamSettings.crta__Field_2__c)
                ));
            }
            
            if(teamSettings.crta__Field_3__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_3__c),
                    PortalUtility.get(c,teamSettings.crta__Field_3__c)
                ));
            }
            
            if(teamSettings.crta__Field_4__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_4__c),
                    PortalUtility.get(c,teamSettings.crta__Field_4__c)
                ));
            }
            
            ContentDistribution photo = new ContentDistribution();
            ContentDistribution cv = new ContentDistribution();
            Boolean hasPhoto = false;
            Boolean hasCV = false;
            if(!hasPhoto) {
                hasPhoto = true;
                photo = filesURLByDocumentId.get('photo').get(c.Id);
            }
            if(!hasCV) {
                hasCV = false;
                cv = filesURLByDocumentId.get('cv').get(c.Id);
            }
            
            String levelName;
            if(level == 1){
                if(c.ReportsToId == contactId) { levelName = 'N-1';  
                }
            }
            if(level == 2) {

                if(c.ReportsToId == contactId) {levelName = 'N-1';  
                }
  
                if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                }
            }
            if(level == 3) {
              system.debug('innnnn level 3');
                system.debug('111 '+c.ReportsToId);
                system.debug('contactId '+contactId);
                if(c.ReportsToId == contactId) {
                    levelName = 'N-1';  
                }                   
                
                if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                }
                
                if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                

                
            }
            
            if(level == 4) {
                
      
                    if(c.ReportsToId == contactId) {
                        levelName = 'N-1';  
                    }
       
                
                if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                }
                
                if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                // SRA 28-04-2023 debut 
                if(c.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-4';
                }
            }
            
            if(level == 5) {
                
                if(c.ReportsToId == contactId) {
                    levelName = 'N-1';  
                }
                
                if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                }
                
                if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                // SRA 28-04-2023 debut 
                if(c.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-4';
                }
                if(c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-5';
                }
            }
            
            if(level == 6) {
                
                if(c.ReportsToId == contactId) {
                    levelName = 'N-1';  
                }
                
                if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                }
                
                if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                // SRA 28-04-2023 debut 
                if(c.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-4';
                }
                if(c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-5';
                }
                if( c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-6';
                } 
            }
            
            if(level == 7){
                if(c.ReportsToId == contactId) {
                    levelName = 'N-1';  
                }  else if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                } 
                
                else if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                // SRA 28-04-2023 debut 
                else if(c.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-4';
                }
                else if(c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-5';
                }
                else if( c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-6';
                } 
                
               if(c.crta__N_7__c == contactId || c.crta__N_7__c != null) {
                    system.debug('je suis ici ');
                    system.debug('c.crta__N_7__c : ' + c.crta__N_7__c);
                    levelName = 'N-7';
                } 
            }
            
            if(level == 8){
                if(c.ReportsToId == contactId) {
                    levelName = 'N-1';  
                }  else if(c.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-2';
                } 
                
                else if(c.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-3';
                }
                // SRA 28-04-2023 debut 
                else if(c.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-4';
                }
                else if(c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-5';
                }
                else if( c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
                    levelName = 'N-6';

                } else if(c.crta__N_7__c == contactId || c.crta__N_7__c != null) {
                    system.debug('je suis ici ');
                    system.debug('c.crta__N_7__c : ' + c.crta__N_7__c);
                    levelName = 'N-7';
                } 
                
                if (c.crta__N_8__c != null || c.crta__N_8__c == contactId){
                    system.debug('je suis ici ' + c.crta__N_8__c);
                  levelName = 'N-8';  
                }
            }
            //fin SRA 10-05-2023
            /*
* if(c.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsTo.ReportsToId == contactId) {
levelName = 'N-8';
} */
            // fin
            // ebe COMMENT
          /*  system.debug('levelNamelevelName '+levelName);
            if(!employeesList.containsKey(levelName)) {
                employeesList.put(
                    levelName, 
                    new List<ContactWrapper>{
                        new ContactWrapper(
                            c.Id,
                            c.Name,
                            photo,
                            cv,
                            fw
                        )
                            }
                );
            } else {
                employeesList.get(levelName).add(
                    new ContactWrapper(
                        c.Id,
                        c.Name,
                        photo,
                        cv,
                        fw
                    )
                );
            }
        }
        m.put('employees', employeesList);
        Map<String, Map<String, String>> settings = getSettings();
        m.put('settings', settings);
        return m;
    }*/
    
    private static Map<String, Map<String, ContentDistribution>> getPublicProfilePicture(Set<String> contactIds) {
        Map<String, Map<String, ContentDistribution>> documentsByType = new Map<String, Map<String, ContentDistribution>>();
        documentsByType.put('cv', new Map<String, ContentDistribution>());
        documentsByType.put('photo', new Map<String, ContentDistribution>());
        Map<String, String> folderIds = new Map<String, String>();
        
        for(crta__Dossier_documentaire__c d : [
            SELECT Id,
            crta__Salarie__c 
            FROM crta__Dossier_documentaire__c 
            WHERE crta__Salarie__c IN: contactIds
        ]) {
            folderIds.put(d.Id, d.crta__Salarie__c);
        }
        //Begin ==> Tenhinene : put the query out of loop and replace it by the variable contentDistributionList : 10/09/2021 - CT-202108#003412
        List<ContentDistribution> contentDistributionList = [
            SELECT Id,
            ContentDownloadUrl,
            ContentDocumentId,
            ContentVersion.crta__Type__c,
            ContentVersion.Title,
            ContentVersion.ContentDocumentId,
            RelatedRecordId
            FROM ContentDistribution
            WHERE RelatedRecordId IN:contactIds OR RelatedRecordId IN:folderIds.keySet()
            ORDER BY CreatedDate DESC
        ];
        
        
        
        for(ContentDistribution c : contentDistributionList) {
            //End ==> Tenhinene :put the query out of loop and replace it by the variable contentDistributionList : 06/09/2021 - CT-202108#003412
            if(c.ContentVersion.crta__Type__c == 'CV') {
                String relatedContactId = folderIds.get(c.RelatedRecordId);
                if(!documentsByType.get('cv').containsKey(relatedContactId)) {
                    documentsByType.get('cv').put(relatedContactId, c);
                }
            }
            if(c.ContentVersion.crta__Type__c == 'profilPicture') {
                if(!documentsByType.get('photo').containsKey(c.RelatedRecordId)) {
                    documentsByType.get('photo').put(c.RelatedRecordId, c);
                }
            }
        }
        return documentsByType;
    }
    
    /*private static String getLevels(Integer level) {
        if(level == null || level <= 0) { level = 1; }
        
        String query = ' AND (';
        for(Integer i = level; i > 0 ; i--) {
            
            if(i != level) { query += 'OR '; }
            for(Integer j = 0; j < i; j++) {
                query += 'ReportsTo.';
            }
            query += 'Id =: contactId ';
        }
        query += ') ';
        
        system.debug('query level value : ' + query);
        return query;
    }*/

//Hana.H (18/09/2024) : OPTIMISATION : resolution des pbs de limit du gouverneur/perf (interroger que les contacts concernés par les niveaux)
@AuraEnabled
public static Map<String, Object> getEmployee(Integer level, String recordTypes) {
    // Initialisation et Configuration
    Map<String, Object> result = new Map<String, Object>();
    List<ContactsLevelWrapper> employeesList = new List<ContactsLevelWrapper>();
    String contactId = getContactId();
    List<Contact> employees = new List<Contact>();
    List<String> recordTypesList = new List<String>();
    crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
    Set<String> strFields = new Set<String>();
    
    // Ajout des champs configurés dans teamSettings
    if (teamSettings.crta__Field_1__c != NULL) strFields.add(teamSettings.crta__Field_1__c);
    if (teamSettings.crta__Field_2__c != NULL) strFields.add(teamSettings.crta__Field_2__c);
    if (teamSettings.crta__Field_3__c != NULL) strFields.add(teamSettings.crta__Field_3__c);
    if (teamSettings.crta__Field_4__c != NULL) strFields.add(teamSettings.crta__Field_4__c);

    // Traitement des recordTypes
    if (recordTypes != NULL) {
        recordTypes = recordTypes.replaceAll('\\s+', '');
        if (recordTypes == '') {
            recordTypesList.add('Salarie');
        } else {
            recordTypesList = recordTypes.split(',');
        }
    } else {
        recordTypesList.add('Salarie');
    }

    // Construire la requête
    String query;
    if (strFields.isEmpty()) {
        query = 'SELECT Id, Name, ReportsToId FROM Contact ' +
                'WHERE RecordType.DeveloperName IN :recordTypesList ' +
                'AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ' ;
    } else {
        query = 'SELECT Id, Name, ReportsToId, ' + String.join(new List<String>(strFields), ',') + 
                ' FROM Contact ' +
                'WHERE RecordType.DeveloperName IN :recordTypesList ' +
                'AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ' ;
    }

    //Get ALL descenedants and their Ids for the entry param of the getPublicProfilePicture method
    Map<String, Object> usedResult = getAllDescendants(contactId, level, query, recordTypesList);
    Map<String, List<Contact>> contactsByLevel = (Map<String, List<Contact>>)usedResult.get('contactsByLevel');

    Map<String, Map<String, ContentDistribution>> filesURLByDocumentId = getPublicProfilePicture((Set<String>)usedResult.get('cIds'));

    // Parcourir et traiter les contacts
    for (String levelName : contactsByLevel.keySet()) {
        List<ContactWrapper> contactsForLevel = new List<ContactWrapper>();
        List<Contact> contacts = contactsByLevel.get(levelName);
            System.debug(levelName + ' ' + contacts.size());

        for (Contact c : contacts) {
            contactsForLevel.add(new ContactWrapper(
                c.Id,
                c.Name,
                filesURLByDocumentId.get('photo').get(c.Id),
                filesURLByDocumentId.get('cv').get(c.Id),
                generateFieldWrappers(c)
            ));
        }
        employeesList.add(new ContactsLevelWrapper(levelName, contactsForLevel));
    }

    // Retourner les résultats
    result.put('employees', employeesList);
    Map<String, Map<String, String>> settings = getSettings();
    result.put('settings', settings);
    return result;
}

//Created by Hana.H (18/09/2024) and used for getEmployee
public static Map<String, Object> getAllDescendants(Id contactId, Integer level, String query, List<String> recordTypesList) {
        Map<String, List<Contact>> contactsByLevel = new Map<String, List<Contact>>();
        Set<String> cIds = new Set<String>();

        Set<String> allDescendantsIds = new Set<String>();
        List<Contact> contacts = new List<Contact>();

        // Initial query to get immediate descendants
        List<Contact> immediateDescendants = Database.query(query + 'AND ReportsToId = :contactId ORDER BY Name');
        
        // Add immediate descendants to the set
        contactsByLevel.put('N-1', new List<Contact>());
        for(Contact u : immediateDescendants) {
            allDescendantsIds.add(u.Id); cIds.add(u.Id);
            contacts.add(u);
            contactsByLevel.get('N-1').add(u);
        }
        
        contacts.clear();
        // Recursively get all descendants
        Integer i = 1;
        while (!allDescendantsIds.isEmpty() && i<level) {
            List<Contact> nextLevelDescendants = Database.query(query + ' AND ReportsToId IN :allDescendantsIds ORDER BY Name');

            if (nextLevelDescendants.isEmpty()) {
                break;
            }

            contactsByLevel.put('N-'+ (i+1), new List<Contact>());
            
            allDescendantsIds.clear();

            for (Contact u : nextLevelDescendants) {
                allDescendantsIds.add(u.Id);cIds.add(u.Id);
                contacts.add(u);
                contactsByLevel.get('N-'+ (i+1)).add(u);
            }

            contacts.clear();
          
            i++;
        }
     
        //return contacts + cIds;
        return new Map<String, Object>{'contactsByLevel' => contactsByLevel , 'cIds' => cIds};
    }


//Ebe prob prof  24/05/2024
/*@AuraEnabled
public static Map<String, Object> getEmployee(Integer level, String recordTypes) {
    // Initialisation et Configuration
    Map<String, Object> result = new Map<String, Object>();
    Map<String, List<ContactWrapper>> employeesList = new Map<String, List<ContactWrapper>>();
    String contactId = getContactId();
    List<Contact> employees = new List<Contact>();
    List<String> recordTypesList = new List<String>();
    crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
    Set<String> strFields = new Set<String>();
    
    // Ajout des champs configurés dans teamSettings
    if (teamSettings.crta__Field_1__c != NULL) strFields.add(teamSettings.crta__Field_1__c);
    if (teamSettings.crta__Field_2__c != NULL) strFields.add(teamSettings.crta__Field_2__c);
    if (teamSettings.crta__Field_3__c != NULL) strFields.add(teamSettings.crta__Field_3__c);
    if (teamSettings.crta__Field_4__c != NULL) strFields.add(teamSettings.crta__Field_4__c);

    // Traitement des recordTypes
    if (recordTypes != NULL) {
        recordTypes = recordTypes.replaceAll('\\s+', '');
        if (recordTypes == '') {
            recordTypesList.add('Salarie');
        } else {
            recordTypesList = recordTypes.split(',');
        }
    } else {
        recordTypesList.add('Salarie');
    }

    // Construire la requête
    String query;
    if (strFields.isEmpty()) {
        query = 'SELECT Id, Name, ReportsToId FROM Contact ' +
                'WHERE RecordType.DeveloperName IN :recordTypesList ' +
                'AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ' +
                'ORDER BY LastName LIMIT 1000';
    } else {
        query = 'SELECT Id, Name, ReportsToId, ' + String.join(new List<String>(strFields), ',') + 
                ' FROM Contact ' +
                'WHERE RecordType.DeveloperName IN :recordTypesList ' +
                'AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) ' +
                'ORDER BY LastName LIMIT 1000';
    }
    
    // Exécution de la requête
    system.debug('Query test' + query);
    employees = Database.query(query);

    // Appeler les méthodes utilitaires
    Set<String> contactIds = new Set<String>();
    for (Contact c : employees) {
        contactIds.add(c.Id);
    }
    
    Map<String, List<Contact>> contactsByLevel = getContactsByHierarchy(contactId, level, employees);
    Map<String, Map<String, ContentDistribution>> filesURLByDocumentId = getPublicProfilePicture(contactIds);

    // Parcourir et traiter les contacts
    for (String levelName : contactsByLevel.keySet()) {
        List<ContactWrapper> contactsForLevel = new List<ContactWrapper>();
        List<Contact> contacts = contactsByLevel.get(levelName);

        for (Contact c : contacts) {
           
        
            ContactWrapper contactWrapper = new ContactWrapper(
                c.Id,
                c.Name,
                filesURLByDocumentId.get('photo').get(c.Id),
                filesURLByDocumentId.get('cv').get(c.Id),
                generateFieldWrappers(c)
            );

            contactsForLevel.add(contactWrapper);
        }
        
        if (!employeesList.containsKey(levelName)) {
            employeesList.put(levelName, contactsForLevel);
        } else {employeesList.get(levelName).addAll(contactsForLevel);
        }
    }

    // Retourner les résultats
    result.put('employees', employeesList);
    Map<String, Map<String, String>> settings = getSettings();
    result.put('settings', settings);
    system.debug('List employee' + result);
    return result;
}*/

  /* public static Map<String, List<Contact>> getContactsByHierarchy(String specificReportsToId, Integer level, List<Contact> allContacts) {
    // Définir la liste pour stocker les contacts pour chaque niveau hiérarchique
    Map<String, List<Contact>> contactsByLevel = new Map<String, List<Contact>>();

    // Parcourir chaque niveau hiérarchique
    for (Integer i = 1; i <= level; i++) {
        List<Contact> contactsForLevel = new List<Contact>();
        
        // Pour le niveau actuel, récupérer les contacts avec ReportsToId correspondant au niveau précédent
        for (Contact c : allContacts) {
            if (i == 1) {
              
                // Pour le premier niveau, les contacts ont ReportsToId égal au contact actuel
                if (c.ReportsToId == specificReportsToId) {
                    contactsForLevel.add(c);
                }
            } else {
                // Pour les niveaux suivants, les contacts ont ReportsToId égal au contact du niveau précédent
                List<Contact> previousLevelContacts = contactsByLevel.get('N-' + String.valueOf(i - 1));
                for (Contact previousLevelContact : previousLevelContacts) {
                    if (i == 2) {
                        // Pour le niveau 2, les contacts ont ReportsToId égal au contact du niveau 1
                        if (c.ReportsToId == previousLevelContact.Id) {contactsForLevel.add(c);break; // Sortir de la boucle interne une fois que le contact est ajouté
                        }
                    } else {if (c.ReportsToId == previousLevelContact.Id) {contactsForLevel.add(c);
                        }
                    }
                }
            }
        }
        
        // Stocker les contacts pour ce niveau dans la map avec la clé au format "N-i"
        contactsByLevel.put('N-' + String.valueOf(i), contactsForLevel);
    }
    return contactsByLevel;
}*/
//EBE FIN deb CRTA 
    
    @TestVisible
    private static Map<String,Map<String, String>> getSettings() {
        Map<String, Map<String, String>> settings = new Map<String, Map<String, String>>();
        crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
        Map<String, String> m = new Map<String, String>();
        m.put('Display_CV__c', String.valueOf(teamSettings.crta__Display_CV__c));
        settings.put('Team_Settings__c', m);
        
        return settings;
    }
    private static List<FieldWrapper> generateFieldWrappers(Contact contact) {
    List<FieldWrapper> fw = new List<FieldWrapper>();
    Map<String, Schema.SObjectField> mapTypes = Schema.SObjectType.Contact.fields.getMap();
    crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
    if (teamSettings.crta__Field_1__c != NULL) {
        fw.add(new FieldWrapper(
            PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_1__c),
            PortalUtility.get(contact, teamSettings.crta__Field_1__c)
        ));
    }
    
    if (teamSettings.crta__Field_2__c != NULL) {
        fw.add(new FieldWrapper(
            PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_2__c),
            PortalUtility.get(contact, teamSettings.crta__Field_2__c)
        ));
    }
    
    if (teamSettings.crta__Field_3__c != NULL) {
        fw.add(new FieldWrapper(
            PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_3__c),
            PortalUtility.get(contact, teamSettings.crta__Field_3__c)
        ));
    }
    
    if (teamSettings.crta__Field_4__c != NULL) {
        fw.add(new FieldWrapper(
            PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_4__c),
            PortalUtility.get(contact, teamSettings.crta__Field_4__c)
        ));
    }
    
    return fw;
}
     /*@AuraEnabled
    public static Map<String, Object> getEmployee1(Integer level, String recordTypes) {
      
        Map<String, Schema.SObjectField> mapTypes = Schema.SObjectType.Contact.fields.getMap();
        Map<String, Object> m = new Map<String, Object>();
        Map<String, List<ContactWrapper>> employeesList = new Map<String, List<ContactWrapper>>();
        String contactId = getContactId();
        List<Contact> employees = new List<Contact>();
        
        crta__Team_Settings__c teamSettings = crta__Team_Settings__c.getInstance();
        Set<String> strFields = new Set<String>();
        if(teamSettings.crta__Field_1__c != NULL) {
            strFields.add(teamSettings.crta__Field_1__c);
        }
        if(teamSettings.crta__Field_2__c != NULL) {
            strFields.add(teamSettings.crta__Field_2__c);
        }
        if(teamSettings.crta__Field_3__c != NULL) {
            strFields.add(teamSettings.crta__Field_3__c);
        }
        if(teamSettings.crta__Field_4__c != NULL) {
            strFields.add(teamSettings.crta__Field_4__c);
        }

        String levels = getLevels(level);
        List<String> recordTypesList = new List<String>();
        
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
        String query ;
        if (strFields.isEmpty()) 
        query = 'SELECT Id, Name , ReportsToId ' 
            + ' FROM Contact '
            + 'WHERE RecordType.DeveloperName IN :recordTypesList  '
           + ' AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) '
            + 'ORDER BY LastName LIMIT 1000';
        else 
            query = 'SELECT Id, Name , ReportsToId ,' + String.join(new List<String>(strFields),',')
            + ' FROM Contact '
            + 'WHERE RecordType.DeveloperName IN :recordTypesList  '
           + ' AND (crta__CT_Exit_date__c = null OR crta__CT_Exit_date__c >= TODAY) '
            + 'ORDER BY LastName LIMIT 1000';
        
        //     system.debug('level value : ' + levels);
        //     system.debug('query value : ' + Database.query(query));
system.debug('Query test'+query) ;
employees = Database.query(query);

// Appeler la méthode getContactsByHierarchy pour obtenir les contacts organisés par niveau hiérarchique
Map<String, List<Contact>> contactsByLevel = getContactsByHierarchy(contactId,level, employees);
ContentDistribution photo = new ContentDistribution();
ContentDistribution cv = new ContentDistribution();
List<FieldWrapper> fw = new List<FieldWrapper>();
        
        system.debug('employee : ' + employees);
        Set<String> contactIds = new Set<String>();
        for(Contact c : employees) {
               if (c.Id =='0030900000SDM3BAAX')
                system.debug('Contaaact Marie');
            contactIds.add(c.Id);
        }
        
        Map<String, Map<String, ContentDistribution>> filesURLByDocumentId = getPublicProfilePicture(contactIds);
        for(Contact c : employees) {
            if(teamSettings.crta__Field_1__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_1__c),
                    PortalUtility.get(c,teamSettings.crta__Field_1__c)
                ));
            }
            
            if(teamSettings.crta__Field_2__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_2__c),
                    PortalUtility.get(c,teamSettings.crta__Field_2__c)
                ));
            }
            
            if(teamSettings.crta__Field_3__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_3__c),
                    PortalUtility.get(c,teamSettings.crta__Field_3__c)
                ));
            }
            
            if(teamSettings.crta__Field_4__c != NULL) {
                fw.add(new FieldWrapper(
                    PortalUtility.getFieldType(mapTypes, teamSettings.crta__Field_4__c),
                    PortalUtility.get(c,teamSettings.crta__Field_4__c)
                ));
            }
            
          
            Boolean hasPhoto = false;
            Boolean hasCV = false;
            if(!hasPhoto) {
                hasPhoto = true;
                photo = filesURLByDocumentId.get('photo').get(c.Id);
            }
            if(!hasCV) {
                hasCV = false;
                cv = filesURLByDocumentId.get('cv').get(c.Id);
            }


            }
        for (String levelName1 : contactsByLevel.keySet()) {
    List<ContactWrapper> contactsForLevel = new List<ContactWrapper>();
    
    // Récupérez les contacts pour ce niveau
    List<Contact> contacts = contactsByLevel.get(levelName1);

    // Parcourir chaque contact et créer un ContactWrapper
    for (Contact c1 : contacts) {
        // Récupérez les informations nécessaires pour le ContactWrapper
        // Par exemple, photo, cv, fw...

        // Créez un ContactWrapper avec les informations récupérées
        ContactWrapper contactWrapper = new ContactWrapper(
            c1.Id,
            c1.Name,
            photo, // Remplacez photo par la photo réelle du contact
            cv,    // Remplacez cv par le cv réel du contact
            fw     // Remplacez fw par le fw réel du contact
        );

        // Ajoutez le ContactWrapper à la liste des contacts pour ce niveau
        contactsForLevel.add(contactWrapper);
    }
    
    // Vérifiez si la clé levelName1 existe déjà dans employeesList
    if (!employeesList.containsKey(levelName1)) {
        // Si la clé n'existe pas, ajoutez-la avec la liste des contacts pour ce niveau
        employeesList.put(levelName1, contactsForLevel);
    } else {
        // Si la clé existe déjà, ajoutez les contacts à la liste existante
        employeesList.get(levelName1).addAll(contactsForLevel);
    }
}


        m.put('employees', employeesList);
        Map<String, Map<String, String>> settings = getSettings();
        m.put('settings', settings);
        system.debug('List employee'+m);
        return m;
    }*/
}