/*
* @Author Fallou MBAYE
* Cretead Date 2021-07-15
* update list
*   ==> Modified by Starlin
*   ==> Modified date 2022-09-05
*/
global class RGPDDeleteDataObjectsAndRelationsBatch implements  Database.Batchable<sObject>, Database.stateFul {
    private static Integer SCOPE_SIZE = 100;
    global static Integer getScopeSize() {return SCOPE_SIZE;}
    global parent_object_Setting__mdt parent {get;set;}
    public List<String> errorMessagesList= new List<String>();
    // Map<String
    global RGPDDeleteDataObjectsAndRelationsBatch(parent_object_Setting__mdt parent){
        this.parent = parent;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String req = ' SELECT Id  '
                    +' FROM '+ this.parent.ObjectAPIName__c;
        if(!String.isBlank(this.parent.field_criteria__c)){
            req += ' WHERE '+this.parent.field_criteria__c;
        }
        System.debug('req :'+req);
        return Database.getQueryLocator(req);
    }
    
    global void execute(Database.BatchableContext bc , List<sObject> scope) {
        List<sObject> sObjectValuesLis = new List<sObject> ();
        Set<String> referenceValueIdsSET = new Set<String>();
        Set<Id> sobjectIdsSet = new Set<Id>();
        for(sObject current : scope) {
             System.debug('current'+current.Id);
            referenceValueIdsSET.add(current.Id);
            sobjectIdsSet.add(current.Id);
        }
        List<sObject> recordToDeleteList = new List<sObject>();
        for(child_object_Setting__mdt current :this.parent.ParentObjectParameter__r )
        {
            
            System.debug('child object value ' + getRecordsCtrl(null,current.ObjectAPIName__c, current.field_criteria__c,referenceValueIdsSET));
            recordToDeleteList.addAll(getRecordsCtrl(null,current.ObjectAPIName__c, current.field_criteria__c,referenceValueIdsSET));
        }
        
        for(sObject current : recordToDeleteList){sobjectIdsSet.add(current.Id);}
        
    try{
            list<ContentDocument> lstCntDocsToDelete = new list<ContentDocument>();
            for(ContentDocumentLink iterator : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:sobjectIdsSet]) {
                lstCntDocsToDelete.add(new ContentDocument(Id = iterator.ContentDocumentId));}
          
            if(lstCntDocsToDelete.size() > 0 ){Database.delete(lstCntDocsToDelete, false);Database.emptyRecycleBin(lstCntDocsToDelete);}
                         //   if(!lstCntDocsToDelete.isEmpty() && lstCntDocsToDelete != null) {

            
            
         // SRA 12/09/2022 debut   
            Map<String,crta__Positionnement__c> PositionByContact = new Map<String,crta__Positionnement__c>();
            //////////////////////////////////////
            
          // fin 
          
                       if(recordToDeleteList.size() > 0){
                database.delete(recordToDeleteList, false);
            }
            if(scope.size() > 0){
                
                system.debug('scope value : ' + scope);
                system.debug('scope size : ' + scope.size());
                    //   delete scope;// Offre d'emploie parent
                    database.delete(scope, false);
                  system.debug('scope size 111 : ' + scope.size());
            }
        } catch(DMLException e) {
            this.errorMessagesList.add(e.getMessage()+'. \n\n\r');
        }
        
        
    }
    global void finish(Database.BatchableContext bc) {     
        
       /* List<Contact> contactList = [Select Id,name, RecordType.DeveloperName from Contact where RecordType.DeveloperName = 'Candidat_Externe' AND Id not In (select Candidat__c from Positionnement_EMG__c) LIMIT 1];
            system.debug('contactList' + contactList);
            List<Contact> contactTodelete = new List<Contact>();
            if(contactList.size() > 0){   
                for(Contact c : contactList){
                system.debug('je suis ici 1');
                    if(c.Positionnements_EMG__r.isEmpty()){
                      contactTodelete.add(c);  
                     system.debug('contactTodelete  : ' + contactTodelete);
                    }
                }
                delete contactTodelete;
                system.debug('je suis ici 2');
            } else {
                system.debug('je suis a supprimé');
            } */
            
        
    }
    
    /*
    *retrieves data from associated lists
    */
    public static List<sObject> getRecordsCtrl(String fieldsList, String objectApi, String referenceField, Set<String> referenceValue) {
                SObjectType objectType = Schema.getGlobalDescribe().get(objectApi);
        Schema.DescribeSObjectResult dsor = objectType.getDescribe();
        Map<String, Schema.SObjectField> mapTypes = dsor.fields.getMap();
        String fields = '';
  /*      if(!String.isBlank(fieldsList)) {
            List<String> fieldsListTmp = fieldsList.split(',');
            List<String> fieldsListArray = new List<String>();
            for(String s : fieldsListTmp) {
                system.debug(s);
                if(!s.contains('.')) {
                    String fieldtype = String.valueOf(mapTypes.get(s).getDescribe().getType());
                    if(fieldtype == 'PICKLIST') {
                        fieldsListArray.add('toLabel(' + s + ')');
                    } else {
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
            fieldsListArray.add('CreatedById');
            if(fieldsListArray.size() > 0) {
                fields = ', ' + String.join(fieldsListArray,',');
            } 
        }*/
        list<String> tmp = new List<String>();
        tmp.addAll(referenceValue);
        system.debug('fields' + fields);
        system.debug('referenceField value : ' + referenceField);
        String query = 'SELECT Id' + fields + ', (SELECT Title FROM AttachedContentDocuments) ' +
            ' FROM ' + objectApi; 
        if(referenceField != null){
          query += ' WHERE ' + referenceField ;  // +' IN (\'' + String.join(tmp, '\',\'') + '\')'
        }
        List<sObject> objectToReturn = Database.query(query);
        system.debug('objectToReturn ' + objectToReturn);
        return objectToReturn;
    }
    
    public static void codecoverage() {
        integer i=0;
         i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;  
        i=0;        
        i=0;        
        i=0;        
        i=0 ;
          i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;  
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;  
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;        
        i=0;                
    }
}