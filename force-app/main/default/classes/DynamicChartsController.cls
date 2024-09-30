public without sharing class DynamicChartsController {



   private enum ChartType {Percent, Bar}
   

    public class ChartData {
        @AuraEnabled
        public String chartLabel { get; set;}
        @AuraEnabled
        public List<Object> data { get; set; }
        @AuraEnabled
        public Set<Object> labels { get; set; }

        public ChartData(String chartLabel, List<Object> data, Set<Object> labels) {
            this.chartLabel=chartLabel;
            this.data=data;
            this.labels=labels;
        }
    }


    private static String getQuery(String selectionField, String datatableName, String typeOfQry,
     String groupbyField, String filterCriteria, String contactFilter){
     String aggQuery = !String.isBlank(groupbyField) ? 'SELECT ' + groupbyField + ' label , '+typeOfQry+ ' ( '+selectionField+')' + ' FROM ' + datatableName :
     'SELECT '+typeOfQry+ ' ( '+selectionField+')' + ' FROM ' + datatableName ;
         if (filterCriteria!=null || contactFilter !=null) {
             aggQuery += ' where ';
             if (filterCriteria!=null) {
                 aggQuery += filterCriteria;
             }
             if (!String.isBlank(contactFilter)!=null && !String.isBlank(filterCriteria)) {
                                 aggQuery += ' and ';
             }

             if (contactFilter !=null) {
                String loggedContactId  = getLoggedContactCtrl();
                aggQuery += (contactFilter + ' = \''  + loggedContactId) + '\'';
             }
        }
        if (!String.isBlank(groupbyField)) {
        aggQuery += ' group by ' + groupbyField;
        }
        return aggQuery;
    }

    @AuraEnabled
    public static ChartData loadData(String selectionField, String datatableName, String typeOfQry,
     String groupbyField, String filterCriteria, String contactFilter, String complementaryFilter, String chartLabels, String chartType){
        Map<Object, Object> dataset = new Map<Object,Object>();
        //try {
        String aggQuery = getQuery(selectionField, datatableName, typeOfQry, groupbyField, filterCriteria, contactFilter);
        System.debug(aggQuery);
        String[] chartlabelsArray  = !String.isBlank(chartLabels) ? chartLabels.split(',') : null;
        for(AggregateResult result :  Database.query(aggQuery)) {
            dataset.put(!String.isBlank(groupbyField) ? result.get('label') : chartlabelsArray!=null && !chartlabelsArray.isEmpty() ? chartlabelsArray[0] : '',result.get('expr0'));  
        }
        if(!String.isBlank(complementaryFilter)) {
        String cmplAggQuery = getQuery(selectionField, datatableName, typeOfQry, groupbyField, complementaryFilter, contactFilter);
        System.debug(cmplAggQuery);
        for(AggregateResult result :  Database.query(cmplAggQuery)) {
            dataset.put(!String.isBlank(groupbyField) ? result.get('label') : chartlabelsArray!=null && chartlabelsArray.size()>1 ? chartlabelsArray[1] : '',result.get('expr0'));  
        } 
        }

        if (!String.isBlank(chartType) && chartType == 'Percent') {
        String totlaQuery = getQuery(selectionField, datatableName, typeOfQry, groupbyField, null, contactFilter);
        System.debug(totlaQuery);
        Decimal total=1;
        for(AggregateResult result :  Database.query(totlaQuery)) {
            total = (Decimal) result.get('expr0');  
        } 
         dataset.put('percentValue', (((Decimal)dataset.get(dataset.keySet().iterator().next()))/total)*100);
        }
        String fieldLabel = '';
        if (!String.isBlank(groupbyField)) {
        Schema.DescribeSObjectResult dsor = Schema.getGlobalDescribe().get(datatableName).getDescribe();
        Map<String,Schema.SObjectField> fieldNameMap = dsor.fields.getMap();
        Schema.SObjectField f = selectionField.contains('__r.') ? fieldNameMap.get(selectionField.split('\\.')[0].replace('__r','__c')) : fieldNameMap.get(selectionField);
         fieldLabel = f.getDescribe().getLabel();
        }
        System.debug(dataset.keySet());
                System.debug(dataset.values());
                        System.debug(fieldLabel);

        return new ChartData(fieldLabel, dataset.values(), dataset.keySet());
        /*} catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
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