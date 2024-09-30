/*
* @Author Fallou MBAYE
* Cretead Date 2021-07-15
* update list
*   ==> Modified by XXX
*   ==> Modified date YYYY-mm-dd
*/
global class RGPDAnonymizeDataObjectsAndRelationships implements Database.Batchable<sObject>,
    Database.Stateful, Database.AllowsCallouts{
    private static Integer SCOPE_SIZE = 100;
    global static Integer getScopeSize() {return SCOPE_SIZE;}
    global parent_object_Setting__mdt parent {get;set;}
    public List<String> errorMessagesList= new List<String>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String req = ' SELECT Id  '
                    +' FROM '+ this.parent.ObjectAPIName__c;

        if(!String.isBlank(this.parent.filterCriteria__c)){
            req += ' WHERE '+this.parent.filterCriteria__c;
        }
        System.debug('req :'+req);
        return Database.getQueryLocator(req);
    }
    
    global void execute(Database.BatchableContext bc , List<sObject> scope) {
    }
    global void finish(Database.BatchableContext bc) {
        
    }

}