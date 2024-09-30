/*
 * @Author: Nouha Maddeh
 * Ce batch  permert de copier les valeurs de l'enregistrement RT = Anonymisation dans le contact dont la case "A anonymiser" = True
 * 
 * */       


  public class BATCHContactAnonymization implements  Database.Stateful, Database.Batchable<sObject>,Schedulable{ 
          private List<Contact> processedContacts = new List<Contact>();
          public static List<String> getSObjectFieldNames(final String sObjectName) {
                return new List<String>(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keySet());
            }
      
      
          public Database.QueryLocator start(Database.BatchableContext bc) { 
			crta__Param_Anonymization_filtre__c crtiteriaConf = crta__Param_Anonymization_filtre__c.getOrgDefaults();
			String crtiteriaValue = crtiteriaConf.crta__Anonymization_crtiteria__c ;
            List<String> fieldString = getSObjectFieldNames('Contact');
             String fieldList = String.join(fieldString, ',');
              if (crtiteriaValue == null)   {   crtiteriaValue = 'crta__To_anonymize__c' ;}   
              //String soqlQuery = 'SELECT ' + fieldList + ' '+ 'FROM Contact  '+ ' WHERE '+crtiteriaValue+' = TRUE ';  
             String soqlQuery = 'SELECT ' + fieldList + ' '+ 'FROM Contact  '+ ' WHERE  '+crtiteriaValue+'  = TRUE ';        
            // String soqlQuery = 'SELECT ' + fieldList + ' '+ 'FROM Contact  where recordtype.developerName=\'Anonymization\'';
             system.debug('La requete'+soqlQuery) ;
           // Stocker les contacts traités dans la variable processedContacts
        	processedContacts = Database.query(soqlQuery);

             return Database.getQueryLocator(soqlQuery);
              
          }
      
           public void execute(Database.BatchableContext bc,List<Contact> ListContact) { 
               //Get fields that can be editable in the contact Object 
                String SobjectApiName = 'Contact';
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
				Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
               Map<String,Boolean> fieldseditable=new Map<String,Boolean>();
                Map<String,Schema.DisplayType> fieldstype=new Map<String,Schema.DisplayType>();

               for(String fieldName : fieldMap.keySet()) {
                   fieldseditable.put(fieldName,fieldMap.get(fieldName).getDescribe().isUpdateable());
                   fieldstype.put(fieldName,fieldMap.get(fieldName).getDescribe().getType());
                   
                }

               List<String> fieldString = getSObjectFieldNames('Contact');
               String fieldList = String.join(fieldString, ',');
               String soqlQuery = 'SELECT ' + fieldList + ' '+ 'FROM Contact  where recordtype.developerName=\'Anonymization\' LIMIT 1';
               Contact contactAnonymized=Database.query(soqlQuery);
               Map<String,Contact> MapContactById = new Map<String,Contact>();
               for(Contact con:ListContact){
                   MapContactById.put(con.Id,con);
               }
               for(Contact c:ListContact){
                   for(String field:fieldString) {
                       if(fieldseditable.get(field) && field!='RecordtypeId'){
                           if(contactAnonymized.get(field)!=null && String.valueOf(fieldstype.get(field))=='STRING') {
                               if(field=='FirstName' || field=='LastName'){
                                   MapContactById.get(c.Id).put(field,contactAnonymized.get(field)+generateRandomString(10,'Text'));
                           }
                            else{
                              MapContactById.get(c.Id).put(field,contactAnonymized.get(field));
  
                            }
                           }
                           if(contactAnonymized.get(field)!=null  && String.valueOf(fieldstype.get(field))!='STRING'){
                              MapContactById.get(c.Id).put(field,contactAnonymized.get(field));
                           }
                       }
                   }
                
               }
               
               //Exclure tout ce qui est lié à la sécurité sociale + IBAN
                   system.debug(MapContactById);
                    update MapContactById.values();
                  
             //supprimer les fichiers + objets enfant
               		Set<String> mesContactsIds = MapContactById.keySet();
        			ObjectDeletionHandler.deleteRelatedObjects(mesContactsIds);
                 
               
           }
      
      
       public void execute(SchedulableContext sc)
    {
        BATCHContactAnonymization b = new BATCHContactAnonymization ();
        database.executebatch(b,10);
    }
      
      
        public void finish(Database.BatchableContext bc) {
		deleteRelatedObjects('ContactHistory','ContactId');
        }
      
      public static String generateRandomString(Integer len,String type) {
        final String chars;
          if(type=='Number'){
              chars='0123456789';
          }   
          else {
              chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
          }   
        String randStr = '';
        while (randStr.length() < len) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        randStr += chars.substring(idx, idx+1);
        }
        return randStr;
          }

 private void deleteRelatedObjects( String childObjectName ,String contactFieldApiName) {
        // Récupérer les IDs des contacts traités dans le lot
        Set<String> contactIds = new Set<String>();
        for (Contact c : processedContacts) {
            contactIds.add(c.Id);
        }

        // Supprimer les objets enfants liés aux contacts traités
        List<sObject> childObjectsToDelete = new List<sObject>();
        childObjectsToDelete.addAll(Database.query('SELECT Id FROM ' + childObjectName + ' WHERE ' + contactFieldApiName + ' IN :contactIds'));
        Database.delete(childObjectsToDelete);
    }
    

        }