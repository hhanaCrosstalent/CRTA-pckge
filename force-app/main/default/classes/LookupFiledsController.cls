public without sharing class LookupFiledsController {
   
    


    public class OptionWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public OptionWrapper(String value, String  label) {
            this.label=label;
            this.value=value;
        }
    }

    @AuraEnabled
    public static List<OptionWrapper> getSobjectList(String childObjectApi, String refFieldName, String fieldDisplayName,
                                               String lookupFilter, List<String> searchList, String reviewId, String selectedObjectId)
    { 
        String objectApiName = childObjectApi;
        if(refFieldName.contains('.')) {
            objectApiName = getParentObject(childObjectApi, refFieldName.substringBefore('.'));
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
        /*if(checkObjectExist('crtatm__Evaluation_Scale__c')) {
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
        }*/
        System.debug('test '+searchList);
        if(String.isBlank(whereClause)){
            System.debug('test1 '+searchList.size());
            if(searchList.size()>0){
               whereClause = ' WHERE Id IN: searchList';  
            }else{
               whereClause = !String.isBlank(selectedObjectId) ? ' WHERE Id =:selectedObjectId' : ''; 
            }
           
        }else{
            System.debug('test2 '+searchList.size());
           if(searchList.size()>0){
               whereClause += ' OR (Id IN: searchList)'; 
            }else{
               whereClause += ' OR (Id =:selectedObjectId)';
            }
           
        }
        String query = 'SELECT Id, ' + fieldDisplayName + ' FROM ' + objectApiName + whereClause + orderby + ' LIMIT 500';
        
        system.debug(query);
        List<OptionWrapper> options =  new List<OptionWrapper>();

        
        for(SObject record : Database.query(query)) {
              options.add(new OptionWrapper( (String) record.get('Id'), (String) record.get(fieldDisplayName) ));
        }

        /*
        ObjectWrapper obj = new ObjectWrapper(records, Schema.getGlobalDescribe().get(objectApiName).getDescribe().getLabel(), objectApiName, getObjectIcon(objectApiName));
        return obj;*/


        return options;
    }


    
    private static String getParentObject(String childApiName, String fieldApiName) {
        String parentObjectName = childApiName;
        String childField = fieldApiName;
        if(!fieldApiName.endsWith('__c') && !fieldApiName.endsWith('Id')) {
            childField = fieldApiName.contains('__r') ? fieldApiName.replace('__r','__c') : fieldApiName + 'Id';
        }
        Schema.DescribeFieldResult field;
        Schema.SObjectField f = Schema.getGlobalDescribe()
            .get(childApiName)
            .getDescribe()
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
    
    public static Boolean checkObjectExist(String objectName){
        for (Schema.SObjectType sObjectType : Schema.getGlobalDescribe().values() ) {
            String sobjName = String.valueOf(sObjectType);
            if (sobjName.contains(objectName) ) {
                return true;
            }
        }
        return false;
   }
}