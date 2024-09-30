public without sharing class AggregatedCountController {


    public class AggregatedCount {

        @AuraEnabled
    public Integer count { get; set; }
    @AuraEnabled
    public String link { get; set; }
        public AggregatedCount(Integer count, String link) {
            this.count=count;
            this.link=link;
        }
    }
   

   @AuraEnabled
   public static List<Id> getAggregatedCountIdsByApp (Id appId) {
        Map<Id, crta__aggregated_count__mdt> aggretedCountdsMdt = new Map<Id, crta__aggregated_count__mdt>([SELECT Id  from 	crta__aggregated_count__mdt where crta__application_RH__c = :appId]);
        return new List<Id>(aggretedCountdsMdt.keySet());
   }


   @AuraEnabled
    public static AggregatedCount getAggregatedResults(Id aggCountId) {
    crta__aggregated_count__mdt aggretedCountMdt = [SELECT Id , crta__table_api_name__c , crta__logged_contact_filter__c , crta__Filter_criteria__c  from 	crta__aggregated_count__mdt where Id = :aggCountId];

    String strQuery = 'SELECT count(Id)  from ' + aggretedCountMdt.crta__table_api_name__c;
 if (aggretedCountMdt.crta__Filter_criteria__c!=null || aggretedCountMdt.crta__logged_contact_filter__c !=null) {
             strQuery += ' where ';
             if (aggretedCountMdt.crta__Filter_criteria__c!=null) {
                 strQuery += aggretedCountMdt.crta__Filter_criteria__c;
             }
             if (!String.isBlank(aggretedCountMdt.crta__Filter_criteria__c) && !String.isBlank(aggretedCountMdt.crta__logged_contact_filter__c)) {
                                 strQuery += ' and ';
             }

             if (aggretedCountMdt.crta__logged_contact_filter__c !=null) {
                String loggedContactId  = getLoggedContactCtrl();
                strQuery += (aggretedCountMdt.crta__logged_contact_filter__c + ' = \''  + loggedContactId) + '\'';
             }
        } 
    List<AggregateResult> aggregates = Database.query(strQuery);
    Integer count = Integer.valueOf(aggregates[0].get('expr0'));
    return  new AggregatedCount(count,'');

  
    }


     private static User getLoggedUserCtrl() {
        return [
            SELECT Id,
                FirstName,
             
                crta__Contact__c
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
    }

    private static string getLoggedContactCtrl(){
        return getLoggedUserCtrl().crta__Contact__c;
    }
}