/**
************************************************************************************************************************
* @Author Fallou MBAYE
*Created Date 2021-07-27
* C'est un classe schedulate qui fait appel les batchs de suppression et de l'anonymisation
* qui sont attachés aux Contacts 
* .
************************************************************************************************************************
**/ 
global class RGPDDeleteOrAnonymizeDataScheduled implements Schedulable {
    global void execute(SchedulableContext sc){
        List<parent_object_Setting__mdt> parentObjectList = [SELECT Id ,
                                                              	  filterCriteria__c,
                                                           		  crta__field_criteria__c,
                                                                  IsTobeAnonymized__c,
                                                                  ObjectAPIName__c,
                                                                  Exist_files_to_delete__c  ,
                                                                  (SELECT Id, 

                                                                   crta__field_criteria__c,
                                                                   		relationshipField__c, 
                                                                   		ObjectAPIName__c,
                                                                   		ParentObjectParameter__c,
                                                                   		Exist_files_to_delete__c,
                                                                        childRelationshipName__c
                                                                   FROM ParentObjectParameter__r
                                                                   WHERE IsActive__c=true) 
                                                              From parent_object_Setting__mdt
                                                              WHERE IsActive__c = true ORDER By order__c ];
         system.debug('Je suis la batch 111' +parentObjectList);
        for(parent_object_Setting__mdt current : parentObjectList) {
            if(current.IsTobeAnonymized__c == 'Deleted') {
                RGPDDeleteDataObjectsAndRelationsBatchV1 deleteRecord = new RGPDDeleteDataObjectsAndRelationsBatchV1(current);
                Database.executeBatch(deleteRecord, RGPDDeleteDataObjectsAndRelationsBatchV1.getScopeSize());
            }
            
        }
    }
    
    

}