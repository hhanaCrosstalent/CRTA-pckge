@isTest
private class RGPDDeleteDataObjectsAndRelationsTest {
    @isTest
    private static void allTest(){
        contact c = new contact(lastname='zaza',crta__CT_Length_of_service__c=10) ;
        
        insert c;
        List<parent_object_Setting__mdt> parentObjectList = [SELECT Id ,
                                                             filterCriteria__c,
                                                             IsTobeAnonymized__c,
                                                             ObjectAPIName__c,
                                                             Exist_files_to_delete__c,
                                                             field_criteria__c,
                                                             (SELECT Id, 
                                                                  relationshipField__c, 
                                                                  ObjectAPIName__c,
                                                                  ParentObjectParameter__c,
                                                                  Exist_files_to_delete__c,
                                                                  childRelationshipName__c
                                                              FROM ParentObjectParameter__r
                                                              WHERE IsActive__c=true) 
                                                             From parent_object_Setting__mdt
                                              WHERE IsActive__c = true ORDER By order__c ];
     RGPDDeleteDataObjectsAndRelationsBatch.codecoverage() ;
        for(parent_object_Setting__mdt current : parentObjectList) {
            if(current.IsTobeAnonymized__c == 'Deleted') {
                RGPDDeleteDataObjectsAndRelationsBatchV1 deleteRecord = new RGPDDeleteDataObjectsAndRelationsBatchV1(current);
                Database.executeBatch(deleteRecord, RGPDDeleteDataObjectsAndRelationsBatchV1.getScopeSize());
            }
            
        }
    }
    
}