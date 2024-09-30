//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Schedulable class creating the new BDU_Valeur__c for the given parameters
 */
global with sharing class bduBatch implements Database.Batchable<BduBatchParam>, Schedulable {
    global List<BduBatchParam> pendingParams;

    global bduBatch(List<BduBatchParam> batchParams) {
        pendingParams = batchParams;
    }
    
    global Iterable<BduBatchParam> start(Database.BatchableContext bc)  {
        return pendingParams;
    } 

    /**
     * Executes bduBatch for the given parameters
     * @param  Database.BatchableContext info
     * @param  List<bduBatchParam>       scope         List of parameters to process
     */
    global void execute( Database.BatchableContext info, List<bduBatchParam> scope ) {
        for(BduBatchParam currentParam : scope) {
            if(!currentParam.indi.CT_isSOQL__c) {
                if(!BDU_Valeur__c.sObjectType.getDescribe().isDeletable()) {
                    System.debug('User does not have sufficient rights.');
                    return;
                }
                //Remove existing values
                List<BDU_Valeur__c> delList = [SELECT Id 
                    FROM BDU_Valeur__c 
                    WHERE CT_BDU_Indicateur__c = :currentParam.indi.id 
                    AND CT_BU1__c = :currentParam.BU1 
                    AND CT_BU2__c = :currentParam.BU2 
                    AND CT_BU3__c = :currentParam.BU3 
                    AND CT_BU4__c = :currentParam.BU4 
                    AND CT_BU5__c = :currentParam.BU5 
                    AND CT_Annee__c = :String.valueOf(currentParam.year) 
                    AND CT_semestre__c = :String.valueOf(currentParam.semester) 
                    AND CT_Trimestre__c = :String.valueOf(currentParam.quarter) 
                    AND CT_Bimestre__c = :String.valueOf(currentParam.bimestre) 
                    AND CT_Mois__c = :String.valueOf(currentParam.month)];
                delete delList;
                
                //Starts batch for the current parameters
                bduValuesCalc.processReport( currentParam.indi.CT_Code__c, currentParam.indi.Id, currentParam.BU1, 
                    currentParam.BU2, currentParam.BU3, currentParam.BU4, currentParam.BU5, currentParam.startDate, 
                    currentParam.endDate, currentParam.year, currentParam.semester, currentParam.quarter, 
                    currentParam.bimestre, currentParam.month); 
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        //System.abortJob(this.id); idée à explorer 
    }

    global void execute(SchedulableContext c) {
        Database.executeBatch(this, 1); // un report à la fois
    }
}