//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date: 11/06/2020
**/
public without sharing class LookupFieldController {
    public class ObjectWrapper {
        @AuraEnabled
        public List<SObject> records {get; set;}
        @AuraEnabled
        public String sObjectTypeName {get; set;}
        @AuraEnabled
        public String sObjectApiName {get; set;}
        @AuraEnabled
        public String objectIcon {get; set;}
        
        public ObjectWrapper (
            List<SObject> records,
            String sObjectTypeName,
            String sObjectApiName,
            String objectIcon
        ) {
            this.records = records;
            this.sObjectTypeName = sObjectTypeName;
            this.sObjectApiName = sObjectApiName;
            this.objectIcon = objectIcon;
        }
    }
    
    @AuraEnabled
    public static ObjectWrapper getSobjectList(String childObjectApi, String refFieldName, String fieldDisplayName,
                                               String lookupFilter, String reviewId, String selectedObjectId)
    { 
        String objectApiName = childObjectApi;
        if(refFieldName.contains('.')) {
            objectApiName = getParentObject(childObjectApi, refFieldName.substringBefore('.'));
            system.debug('objectApiName '+objectApiName);
            fieldDisplayName = fieldDisplayName.substringAfter('.');
        } else {
            objectApiName = getParentObject(childObjectApi, refFieldName);
            fieldDisplayName = 'Name';
        }
        
        String whereClause = '';
        if(lookupFilter != null && lookupFilter != '') {
            whereClause = ' WHERE ' + lookupFilter + ' = TRUE';
        }
        String orderby = ' ORDER BY ' + fieldDisplayName;
        if(PortalUtility.checkObjectExist('crtatm__Evaluation_Scale__c')) {
            if(objectApiName == 'crta__GS_Poste_Competence__c' || objectApiName == 'crta__EI_competence_a_evaluer__c'
               || objectApiName == 'crtatm__Evaluation_Scale_Level__c') {
                   crta__EI_Entretien__c review = getReview(reviewId);
                   if(objectApiName == 'crta__GS_Poste_Competence__c') {
                       Set<String> jobIds = getJobDescription(review.crta__EI_Salarie_qui_passe_l_entretien__c, review.crta__EI_Date_de_l_entretien__c);
                       whereClause = ' WHERE (crtatm__Active__c = TRUE AND crta__GS_Fiche_de_poste__c IN :jobIds)';
                   } else if(objectApiName == 'crta__EI_competence_a_evaluer__c') {
                       whereClause = ' WHERE (crtatm__Active__c = TRUE AND crta__EI_Modele_entretien__c = \'' + review.crta__EI_Modele_d_entretien__c + '\')';
                   } else {
                       whereClause = ' WHERE (crtatm__Active__c = TRUE)';
                   }
                   fieldDisplayName = fieldDisplayName + ', crtatm__Evaluation_Scale__c';
                   
               }
            
            orderby = ' ORDER BY ' + fieldDisplayName;
            if( objectApiName == 'crtatm__Evaluation_Scale_Level__c'){
                orderby = ' ORDER BY crtatm__Order__c';
            }
        }
        if(String.isBlank(whereClause)){
           whereClause = ' WHERE Id =:selectedObjectId';
        }else{
           whereClause += ' OR (Id =:selectedObjectId)';
        }
        String query = 'SELECT Id, ' + fieldDisplayName + ' FROM ' + objectApiName + whereClause + orderby + ' LIMIT 500';
        
        system.debug(query);
        List<SObject> records =  new List<SObject>();
        records = Database.query(query);
        
        ObjectWrapper obj = new ObjectWrapper(records, Schema.getGlobalDescribe().get(objectApiName).getDescribe().getLabel(), objectApiName, getObjectIcon(objectApiName));
        return obj;
    }
    
    @AuraEnabled
    public static ObjectWrapper getRecordAutocomplete(String StringSearch, String refFieldName, String objectName, String fieldDisplayName,
                                               String lookupFilter,Boolean filterByEmployee)
    { 
        String objectApiName = objectName;
        if(refFieldName.contains('.')) {
            objectApiName = getParentObject(objectName, refFieldName.substringBefore('.'));
            fieldDisplayName = fieldDisplayName.substringAfter('.');
        } else {
            objectApiName = getParentObject(objectName, refFieldName);
            fieldDisplayName = 'Name';
        }
        String whereClause = '';
        User user=[select id, name,crta__contact__c from User where Id=:UserInfo.getUserId()] ;
        System.debug('StringSearch '+StringSearch);
        if (filterByEmployee && objectApiName=='crta__Dependent__c'){
            whereClause = ' WHERE '+fieldDisplayName +' LIKE'+'\'%'+StringSearch+'%\' AND crta__Employee__c=\''+user.crta__contact__c+'\'' ;  
        }else{
          whereClause = ' WHERE '+fieldDisplayName +' LIKE'+'\''+StringSearch+'%\'' ;    
        }
        
        String orderby = ' ORDER BY ' + fieldDisplayName;
        
        String query = 'SELECT Id, ' + fieldDisplayName + ' FROM ' + objectApiName + whereClause + orderby + ' LIMIT 1000';
        List<SObject> records =  new List<SObject>();
        records = Database.query(query);
        ObjectWrapper obj = new ObjectWrapper(records, Schema.getGlobalDescribe().get(objectApiName).getDescribe().getLabel(), objectApiName, getObjectIcon(objectApiName));
        return obj;
    }
    
    @TestVisible
    private static crta__EI_Entretien__c getReview(String recordId) {
        crta__EI_Entretien__c review = new crta__EI_Entretien__c();
        for(crta__EI_Entretien__c e : [SELECT Id,
                                       crta__EI_Modele_d_entretien__c,
                                       crta__EI_Salarie_qui_passe_l_entretien__c,
                                       crta__EI_Date_de_l_entretien__c
                                       FROM crta__EI_Entretien__c
                                       WHERE Id =: recordId
                                      ]) {
                                          review = e;
                                      }
        return review;
    }
    @TestVisible
    private static Set<String> getJobDescription(String contactId, Datetime dateReview) {
        Set<String> jobId = new Set<String>();
        for(crta__GS_Fiche_de_poste__c f : [SELECT Id
                                            FROM crta__GS_Fiche_de_poste__c
                                            WHERE Id IN
                                            (SELECT crta__GS_Fiche_de_poste__c 
                                             FROM crta__GS_Affectation_poste__c 
                                             WHERE crta__GS_Salarie__c =: contactId
                                             AND crta__GS_Date_de_debut__c <=: dateReview.Date()
                                             AND (crta__GS_Date_de_fin__c >=: dateReview.Date()
                                                  OR crta__GS_Date_de_fin__c = NULL)
                                            )
                                           ]) {
                                               jobId.add(f.Id);
                                           }
        return jobId;
        
    }
    
    public static String getParentObject(String childApiName, String fieldApiName) {
        system.debug('childApiName '+childApiName +'  '+fieldApiName);
        String parentObjectName = childApiName;
        String childField = fieldApiName;
        if(!fieldApiName.endsWith('__c') && !fieldApiName.endsWith('Id')) {
            childField = fieldApiName.contains('__r') ? fieldApiName.replace('__r','__c') : fieldApiName + 'Id';
        }
        Schema.DescribeFieldResult field;
        Schema.SObjectField f = Schema.getGlobalDescribe()
            .get(childApiName).getDescribe()
            .fields
            .getMap()
            .get(childField);
        if(f != null) {
            field = f.getDescribe();
        } else {
            return parentObjectName;
        }
        
        for(Schema.SObjectType reference : field.getReferenceTo()) {
            parentObjectName = reference.getDescribe().getName();
        }
        system.debug('parentObjectName '+parentObjectName);
        return parentObjectName;
    }
    
    private static String getObjectIcon(String objectName) {
        String urlIcon;
        for(TabDefinition t : [SELECT SobjectName, 
                               (SELECT ContentType,
                                Theme,
                                Url 
                                FROM Icons 
                                WHERE ContentType LIKE 'image/svg%')
                               FROM TabDefinition 
                               WHERE sObjectName = :objectName]
           ) {
               if(t.Icons.size() > 0) {
                   urlIcon = t.Icons[0].Url;
               }
           }
        
        String icon;
        if(urlIcon != null) {
            List<String> tmpIcon = urlIcon.split('/');
            if(tmpIcon[tmpIcon.size() - 2] == 'standard') {
                icon = 'standard:' + tmpIcon[tmpIcon.size() - 1].substringBefore('.');
            } else {
                icon = 'custom:' + tmpIcon[tmpIcon.size() - 1].substringBefore('.');
            }
        } else {
            icon = 'standard:custom';
        }
        return icon;
    }
}