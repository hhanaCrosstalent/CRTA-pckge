public without  sharing class MyCareerController {

        public class MissingTranslationException extends Exception {}

   public class Column {
    @AuraEnabled public String label {set;get;}
    @AuraEnabled public String fieldName {set;get;}
    @AuraEnabled public String type {set;get;}
    @AuraEnabled public Boolean displayPhoto {set; get;}
    @AuraEnabled public Boolean ispercent {set; get;}
    @AuraEnabled public Boolean isdate {set; get;}
    @AuraEnabled public Boolean isdatetime {set; get;}
    
    public Column(String label, String fieldName, String type, Boolean displayPhoto) {
        this.label = label;
        this.fieldName = fieldName;
        this.type = type;
        this.displayPhoto=displayPhoto;
        this.ispercent=this.type=='Percent';
        this.isdate = (this.type=='Date');
        this.isdatetime = this.type=='datetime';

    }
       public Column(String label, String fieldName, String type) {
        this.label = label;
        this.fieldName = fieldName;
        this.type = type;

    }
   }

   public class GlobalFilter {
    @AuraEnabled public String label {set;get;}
    @AuraEnabled public String value {set;get;}
    @AuraEnabled public Boolean selected {set;get;}

    public GlobalFilter(String label, String value) {
        this.label=label;
        this.value=value;
        this.selected=false;
    }
   }

   public class FieldWrapper {

    @AuraEnabled public Object value {set;get;}
    @AuraEnabled public Column col {set;get;}

    public FieldWrapper(Column col, Object value) {
        this.value=value;
        this.col=col;
    }
     
   }


    public  class Table {
        @AuraEnabled public String Id {set;get;}
        @AuraEnabled public String btnLabel {set;get;}
        @AuraEnabled public String btnLink {set;get;}
        @AuraEnabled public String objApiName {set;get;}
        @AuraEnabled public Boolean displayADD {set;get;}
        @AuraEnabled public String header {set;get;}
        @AuraEnabled public List<Column> columns {get; set;}
        //@AuraEnabled public List<Map<String,Object>> values {get; set;}  
        @AuraEnabled public List<List<FieldWrapper>> values {get; set;} 
        
        @AuraEnabled
        public  Integer i {get; set;} 
        @AuraEnabled
        public  Integer count {get; set;} 
        @AuraEnabled
        public  Integer totalPages {get; set;} 
        @AuraEnabled
        public  Integer pageLim {get; set;} 
        @AuraEnabled
        public  Integer globalLim {get; set;} 
        @AuraEnabled
        public  Integer offset {get; set;} 
        @AuraEnabled
        public  Boolean isFirst {get; set;} 
        @AuraEnabled
        public  Boolean isLast {get; set;} 
        @AuraEnabled
        public  Boolean isEmpty {get; set;} 

        public Table(String id, Boolean displayADD, String header, List<Column> columns, List<List<FieldWrapper>> values, String btnLabel, String btnLink, String objApiName,
        Integer lim, Integer i, Integer globalLim){
              this.header=header;
              this.columns=columns;
              this.values=values;
              this.Id=id;
              this.displayADD=displayADD;
              this.btnLabel=btnLabel;
              this.btnLink=btnLink;
              this.objApiName=objApiName;
              this.globalLim=globalLim==null ? 0 : globalLim;
              this.count =MyCareerController.getValuesCount(id, globalLim);
              this.pageLim=lim;
              /*Decimal d = ((Decimal)this.count)/this.pageLim;
              Decimal result = Math.round(d) ;
              this.totalPages=Math.mod(this.count, this.pageLim) == 0 || this.count <= this.pageLim ? Integer.valueOf(result) : Integer.valueOf(result)+1;*/
              Decimal c = Decimal.valueOf(this.count);
              this.totalPages=((Integer)Math.ceil(c/this.pageLim));
              this.offset=0;
              this.isFirst=true;
              this.isLast=!(this.totalPages>1 || (this.totalPages==1 && this.count > this.pageLim));
              this.isEmpty=this.count==0;
              this.i=i;
        }   
    }

    public class AggregatedCount {

        @AuraEnabled
    public Object valueToDisplay { get; set; }
    @AuraEnabled
    public String link { get; set; }
    @AuraEnabled
    public String header { get; set; }
    @AuraEnabled
    public Boolean displayCcy { get; set; }
    @AuraEnabled
    public Boolean displaylink { get; set; }
    @AuraEnabled
    public String ccyCode { get; set; }

        public AggregatedCount(Object valueToDisplay, String link, String header, String ccyCode, Boolean displayCcy) {
            this.valueToDisplay=valueToDisplay;
            this.link=link;
            this.header=header;
            this.ccyCode=ccyCode;
            this.displaylink=this.link!=null;
            this.displayCcy=this.ccyCode!=null && displayCcy ==true ? true : null;
        }
    }




    public class Content {
        @AuraEnabled public List<Table> tables;
        @AuraEnabled public String aggResultHeader;
        @AuraEnabled public String link;
        @AuraEnabled public List<GlobalFilter> globalFilters;
        @AuraEnabled public List<AggregatedCount> aggregates;
        @AuraEnabled public List<PortalHomeController.ComponentWrapper> components;
        public Content(String link, List<Table> tables, String aggResultHeader, List<GlobalFilter> globalFilters, List<AggregatedCount> aggregates, List<PortalHomeController.ComponentWrapper> components) {
            this.link=link;
            this.tables=tables;
            this.aggResultHeader=aggResultHeader;
            this.globalFilters=globalFilters;
            this.aggregates=aggregates;
            this.components=components;
            }
    }


    public static Map<String, String> getTranslationMap(Schema.SObjectType t, List<String> fieldNames) {
        Map<String, String> m = new Map<String, String>();
        Schema.DescribeSObjectResult dsor = t.getDescribe();
        if(fieldNames.size()>0) {
            // translations of fields
            Map<String,Schema.SObjectField> fieldNameMap = dsor.fields.getMap();
            for(String fieldName: fieldNames) {
                Schema.SObjectField f = fieldName.contains('__r.') ? fieldNameMap.get(fieldName.split('\\.')[0].replace('__r','__c')) : fieldNameMap.get(fieldName);
                if(f==null)
                    throw new MissingTranslationException('Translation for field "' + fieldName
                                                                + '" of "' + t + '" not found.');
                Schema.DescribeFieldResult dfr = f.getDescribe();
                String fieldLabel = dfr.getLabel();
                m.put(fieldName, fieldLabel);
            }
        }
        // translation of object itself - singular and plural
        /*m.put('Label', dsor.getLabel());
        m.put('LabelPlural', dsor.getLabelPlural());*/
        return m;
    }
    public static List<Column> getTranslationsCtrl(String objectApiName, List<String> fileds) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName); 
        //List<String> fileds = new List<String>{'Id','Name'};
        List<Column> cols = new List<Column>();
        Map<String, String> labels =  getTranslationMap(objType, fileds);
        for(String key : labels.keySet()) {
            cols.add(new Column(labels.get(key), key, 'text'));
        }  
        return cols;
    }


    @AuraEnabled(cacheable=true)
    public static Integer getValuesCount(Id tableId, Integer globalLim) {

           List<crta__Component_table__mdt> tables = [SELECT Id ,  
           crta__Table_name__c , crta__Record_limit__c,
           crta__Connected_contact_filter__c, crta__Filter_criteria__c 
           from crta__Component_table__mdt where id = :tableId];
           crta__Component_table__mdt table = tables.get(0);

        String objectApiName = table.crta__Table_name__c; 
        String filterCriteria = table.crta__Filter_criteria__c; 
        String loggedContactFilter = table.crta__Connected_contact_filter__c;

        String query = ' select count(Id)  FROM ' + objectApiName;
        if (!String.isBlank(filterCriteria) || !String.isBlank(loggedContactFilter)) {
             query += ' where ';
            if (!String.isBlank(filterCriteria)) {
                 query += filterCriteria;
             }
             if (!String.isBlank(filterCriteria) && !String.isBlank(loggedContactFilter)) {
                                 query += ' and ';
             }

             if (!String.isBlank(loggedContactFilter)) {
                String loggedContactId  = getLoggedContactCtrl();
                query += (loggedContactFilter + ' = \''  + loggedContactId) + '\'';
             }
        } 

      
        
        System.debug('the query count '+query);
        //List<SObject> objs = Database.query(query);


       List<AggregateResult> aggregates = Database.query(query);
       Integer count = (Integer) aggregates[0].get('expr0');

         if (globalLim != null && globalLim>0){
           return Integer.valueOf(Math.min(count, globalLim));
        }
        return count;
       // return objs!=null ? objs.size() : 0;
        
    }


    @AuraEnabled
     public static List<List<FieldWrapper>> updateDatableValues(Id tableId, Integer lim, Integer offset) {
         List<crta__Component_table__mdt> tablesByApp = [SELECT Id , crta__Btn_Link__c, crta__btn_add_label__c ,
          crta__German_btn__c,  crta__Dutch_btn__c , crta__English_btn__c  , crta__Italian_btn__c , crta__Portuguese_btn__c , crta__Spanish_btn__c ,
          crta__ordered_by__c , crta__order_way__c ,
           crta__authorize_record_creation__c, header__c, crta__Table_name__c, 
           crta__Record_limit__c,
           crta__Connected_contact_filter__c, crta__Filter_criteria__c from crta__Component_table__mdt where Id = :tableId 
             ];
          crta__Component_table__mdt tableCmp = tablesByApp.get(0);
          List<Column> cols = new List<Column>();
          List<String> fieldNames = new List<String>();
          for(crta__table_field__mdt f : [select crta__Field_Api_Name__c , crta__Type__c , crta__display_contact_photo__c , crta__Order_used__c from crta__table_field__mdt  where crta__Displayed_in_datatable__c = true and crta__Component_table__c  = :tableCmp.Id ORDER BY crta__Order_used__c ASC ]) {
              cols.add(new Column(null,f.crta__Field_Api_Name__c, f.crta__Type__c, f.crta__display_contact_photo__c));
              fieldNames.add(f.crta__Field_Api_Name__c.toLowercase().contains('recordtype') ? 'RecordTypeId' : f.crta__Field_Api_Name__c);
          }
         
        String objectApiName = tableCmp.crta__Table_name__c;
    String filterCriteria = tableCmp.crta__Filter_criteria__c; 
    String loggedContactFilter = tableCmp.crta__Connected_contact_filter__c;
     String orderBy = tableCmp.crta__ordered_by__c;
      String orderWay = tableCmp.crta__order_way__c;
        List<List<FieldWrapper>> values = new List<List<FieldWrapper>>();
        String query = ' select Id , '+ String.join(fieldNames, ',') + ' FROM ' + objectApiName;
        if (!String.isBlank(filterCriteria) || !String.isBlank(loggedContactFilter)) {
             query += ' where ';
            if (!String.isBlank(filterCriteria)) {
                 query += filterCriteria;
             }
             if (!String.isBlank(filterCriteria) && !String.isBlank(loggedContactFilter)) {
                                 query += ' and ';
             }

             if (!String.isBlank(loggedContactFilter)) {
                String loggedContactId  = getLoggedContactCtrl();
                query += (loggedContactFilter + ' = \''  + loggedContactId) + '\'';
             }
        } 
        if(!String.isBlank(orderBy)) {
            query += (' order by '+ orderBy);
                    if(!String.isBlank(orderWay)) {
                         query += (' '+ orderWay);
                    }
        }
        if(lim!=null && lim >0) {
            query += (' LIMIT '+ lim);
        }
        if(offset!=null && offset >0) {
            query += (' OFFSET '+ offset);
        }
        System.debug('the query '+query);
        for (SObject obj : Database.query(query)) {
        //Map<String, Object> resultMap = new Map<String, Object>();
        List<FieldWrapper> fields = new List<FieldWrapper>();
        for(Column col : cols) {
            String fieldName = col.fieldName;
            // Put field name and value into the result map
            Object value;
            if (fieldName.contains('__r.') ) {
                if (col.displayPhoto) {
               value = obj.get(fieldName.split('__r.')[0]+'__c');
                } else {
               String referencedObjName = fieldName.split('\\.')[0];//.replace('__r','__c')
               String requestedFieldName = fieldName.split('__r.')[1];
               SObject refObj = ((SObject) obj.getSObject(referencedObjName));
               value = (refObj!=null) ? refObj.get(requestedFieldName) : '';
                }

            } else {
                value = col.type == 'Percent' ? obj.get('Id') : obj.get(fieldName);
                   if (col.type=='List') {
                      Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldName).getDescribe();
                      List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
                       for (Schema.PicklistEntry picklistEntry : picklistValues) {
                           if(picklistEntry.getValue()==value) {
                                value = picklistEntry.getLabel();
                                     }
                             }


                }

                if (col.fieldName.toLowercase().contains('recordtype')) {
                     value =  Schema.getGlobalDescribe().get(objectApiName).getDescribe().getRecordTypeInfosById().get((Id)obj.get('RecordTypeId')).getName();
                }
            }
            //resultMap.put(fieldName, value);
            fields.add(new FieldWrapper(col,  value));
        }
        values.add(fields);
    
        }
        return values;
        
    }


    public static List<List<FieldWrapper>> getValues(String objectApiName, List<Column> cols, List<String> fieldNames, 
    String filterCriteria, String loggedContactFilter, String orderBy , String orderWay, Integer offset, Integer lim) {
        List<List<FieldWrapper>> values = new List<List<FieldWrapper>>();
        String query = ' select Id , '+ String.join(fieldNames, ',') + ' FROM ' + objectApiName;
        if (!String.isBlank(filterCriteria) || !String.isBlank(loggedContactFilter)) {
             query += ' where ';
            if (!String.isBlank(filterCriteria)) {
                 query += filterCriteria;
             }
             if (!String.isBlank(filterCriteria) && !String.isBlank(loggedContactFilter)) {
                                 query += ' and ';
             }

             if (!String.isBlank(loggedContactFilter)) {
                String loggedContactId  = getLoggedContactCtrl();
                query += (loggedContactFilter + ' = \''  + loggedContactId) + '\'';
             }
        } 
        if(!String.isBlank(orderBy)) {
            query += (' order by '+ orderBy);
                    if(!String.isBlank(orderWay)) {
                         query += (' '+ orderWay);
                    }
        }
        if(lim!=null && lim >0) {
            query += (' LIMIT '+ lim);
        }
        if(offset!=null && offset >0) {
            query += (' OFFSET '+ offset);
        }
        System.debug('the query '+query);
        for (SObject obj : Database.query(query)) {
        //Map<String, Object> resultMap = new Map<String, Object>();
        List<FieldWrapper> fields = new List<FieldWrapper>();
        for(Column col : cols) {
            String fieldName = col.fieldName;
            // Put field name and value into the result map
            Object value;
            if (fieldName.contains('__r.') ) {
                if (col.displayPhoto) {
               value = obj.get(fieldName.split('__r.')[0]+'__c');
                } else {
               String referencedObjName = fieldName.split('\\.')[0];//.replace('__r','__c');
               String requestedFieldName = fieldName.split('__r.')[1];
               System.debug(obj);
               SObject refObj = ((SObject) obj.getSObject(referencedObjName));
               value = (refObj!=null) ? refObj.get(requestedFieldName) : '';
                }

            } else {
                value = col.type == 'Percent' ? obj.get('Id') : obj.get(fieldName);
                if (col.type=='List') {
                      Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            if(picklistEntry.getValue()==value) {
                value = picklistEntry.getLabel();
            }
        }
                }
                
            if (col.fieldName.toLowercase().contains('recordtype')) {
                     value =  Schema.getGlobalDescribe().get(objectApiName).getDescribe().getRecordTypeInfosById().get((Id)obj.get('RecordTypeId')).getName();
                }
            }
            //resultMap.put(fieldName, value);
            fields.add(new FieldWrapper(col,  value));
        }
        values.add(fields);
    
        }
        return values;
        
    }

    private static List<GlobalFilter> getGlobalFilterForAggResults(Id appId) {
        List<crta__application_RH__mdt> currentApps = [select crta__Global_filters_for_aggregated_results__c , crta__Global_filters_labels__c 
        from crta__application_RH__mdt where Id = :appId
        and crta__Global_filters_for_aggregated_results__c != null and crta__Global_filters_labels__c != null LIMIT 1];
        List<GlobalFilter> filters = new List<GlobalFilter>();
        if(currentApps!=null && !currentApps.isEmpty()) {
            crta__application_RH__mdt currentApp = currentApps.get(0);
             String[] globalFilters = currentApp.crta__Global_filters_for_aggregated_results__c.split(';');
             String[] globalFilterLabels = currentApp.crta__Global_filters_labels__c.split(';');
             for(Integer i=0;i<globalFilters.size();i++) {
                filters.add(new GlobalFilter(globalFilterLabels[i], globalFilters[i]));
             }
             filters.get(0).selected=true;
        }
        return filters;
    }


    @AuraEnabled
    public static List<AggregatedCount> getAggregatedResults(Id appId, String globalFilter) {
    
    String userLocale = UserInfo.getLanguage();
   
     List<crta__aggregated_count__mdt> aggretedCountsMdt = [SELECT Id , crta__selection__c, crta__Order__c, 
     crta__Type__c, crta__currency_code__c , crta__Display_curreny__c,  crta__header__c,
     crta__Dutch_Header__c, crta__English_Header__c, crta__German_Header__c , crta__Italian_Header__c , crta__Portuguese_Header__c , crta__Spanish_Header__c ,
     crta__link__c , 
     crta__table_api_name__c , crta__logged_contact_filter__c , crta__Filter_criteria__c  
     from 	crta__aggregated_count__mdt where  crta__application_RH__c = :appId and crta__IsActive__c = true 
     order by crta__Order__c];

    List<AggregatedCount> aggregateCounts = new List<AggregatedCount>();

    for(crta__aggregated_count__mdt aggretedCountMdt : aggretedCountsMdt) {
         String header = aggretedCountMdt.crta__header__c;

            switch on (userLocale) {
                when 'nl_NL'{ header = (!String.isBlank(aggretedCountMdt.Dutch_Header__c) ? aggretedCountMdt.Dutch_Header__c : header); }
                when 'en_US' {header = (!String.isBlank(aggretedCountMdt.crta__English_Header__c) ? aggretedCountMdt.crta__English_Header__c : header);}
                when 'de' {header = (!String.isBlank(aggretedCountMdt.crta__German_Header__c) ? aggretedCountMdt.crta__German_Header__c : header);}
                when 'pt_BR' {header = (!String.isBlank(aggretedCountMdt.crta__Portuguese_Header__c) ? aggretedCountMdt.crta__Portuguese_Header__c : header);}
                when 'es' {header = (!String.isBlank(aggretedCountMdt.crta__Spanish_Header__c) ? aggretedCountMdt.crta__Spanish_Header__c : header);}
                when 'it' {header = (!String.isBlank(aggretedCountMdt.crta__Italian_Header__c) ? aggretedCountMdt.crta__Italian_Header__c : header);}
            }
    String strQuery = aggretedCountMdt.crta__Type__c == 'selection'  ? ('select '+aggretedCountMdt.crta__selection__c + ' FROM ') : aggretedCountMdt.crta__Type__c == 'count' ? 'SELECT count(Id)  FROM ' : 'select SUM(' + aggretedCountMdt.crta__selection__c + ') FROM ' ;
    
    strQuery += aggretedCountMdt.crta__table_api_name__c;
    if (!String.isBlank(aggretedCountMdt.crta__Filter_criteria__c) || !String.isBlank(aggretedCountMdt.crta__logged_contact_filter__c) || !String.isBlank(globalFilter)) {
             strQuery += ' where ';
             if (!String.isBlank(aggretedCountMdt.crta__Filter_criteria__c)) {
                 strQuery += aggretedCountMdt.crta__Filter_criteria__c;
             }
             /*if ((!String.isBlank(aggretedCountMdt.crta__Filter_criteria__c) && !String.isBlank(aggretedCountMdt.crta__logged_contact_filter__c))||!String.isBlank(globalFilter)) {
                                 strQuery += ;
             }*/

             if (!String.isBlank(aggretedCountMdt.crta__logged_contact_filter__c)) {
                String loggedContactId  = getLoggedContactCtrl();
                strQuery += (' and '+(aggretedCountMdt.crta__logged_contact_filter__c + ' = \''  + loggedContactId) + '\'');
             }
             if (!String.isBlank(globalFilter)){
                strQuery += (' and '+globalFilter);
             }
        } 
 
    if (aggretedCountMdt.crta__Type__c == 'selection') {
        strQuery +=  ' LIMIT 1 ';
        List<SObject> selectedObjects = Database.query(strQuery);
        if (selectedObjects!=null && !selectedObjects.isEmpty() ) {
        SObject selectedObj =  Database.query(strQuery)[0];
        Object value = selectedObj.get(aggretedCountMdt.crta__selection__c);
        aggregateCounts.add(new AggregatedCount(value,aggretedCountMdt.crta__link__c,header,
         aggretedCountMdt.crta__currency_code__c, aggretedCountMdt.crta__Display_curreny__c ));
        }

    } else {
     List<AggregateResult> aggregates = Database.query(strQuery);
    Object count = aggregates[0].get('expr0');
     aggregateCounts.add(new AggregatedCount(count,aggretedCountMdt.crta__link__c,header, aggretedCountMdt.crta__currency_code__c, aggretedCountMdt.crta__Display_curreny__c ));
    }
     }

     return aggregateCounts;

  
    }
   
    @AuraEnabled
    public static List<Table> loadTheTableContentCtrl(Id appId, Integer offset, Integer lim){
        //try {
        List<Table> tables = new List<Table>();
        String userLocale = UserInfo.getLanguage();

          List<crta__Component_table__mdt> tablesByApp = [SELECT Id , crta__Btn_Link__c, crta__btn_add_label__c ,
          crta__German_btn__c,  crta__Dutch_btn__c , crta__English_btn__c  , crta__Italian_btn__c , crta__Portuguese_btn__c , crta__Spanish_btn__c ,
          crta__ordered_by__c , crta__order_way__c ,
           crta__authorize_record_creation__c, header__c,
           crta__Dutch_Header__c , crta__English_Header__c , crta__German_Header__c , crta__Italian_Header__c , crta__Portuguese_Header__c ,
            crta__Spanish_Header__c ,
           crta__Table_name__c, 
           crta__Record_limit__c,
           crta__Connected_contact_filter__c, crta__Filter_criteria__c from crta__Component_table__mdt where crta__application__c = :appId and crta__Is_Active__c = true
             ];
          Integer i = 0;
          for(crta__Component_table__mdt tableCmp : tablesByApp ) { 
            String tableHeader = tableCmp.header__c;
            String btnLabel = tableCmp.crta__btn_add_label__c;
            switch on (userLocale) {
                when 'nl_NL'{ tableHeader = (!String.isBlank(tableCmp.Dutch_Header__c) ? tableCmp.Dutch_Header__c : tableHeader); 
                btnLabel = (!String.isBlank(tableCmp.Dutch_btn__c) ? tableCmp.Dutch_btn__c : btnLabel);}
                when 'en_US' {tableHeader = (!String.isBlank(tableCmp.crta__English_Header__c) ? tableCmp.crta__English_Header__c : tableHeader);
                btnLabel = (!String.isBlank(tableCmp.crta__English_btn__c) ? tableCmp.crta__English_btn__c : btnLabel);}
                when 'de' {tableHeader = (!String.isBlank(tableCmp.crta__German_Header__c) ? tableCmp.crta__German_Header__c : tableHeader);
                btnLabel = (!String.isBlank(tableCmp.crta__German_btn__c) ? tableCmp.crta__German_btn__c : btnLabel);}
                when 'pt_BR' {tableHeader = (!String.isBlank(tableCmp.crta__Portuguese_Header__c) ? tableCmp.crta__Portuguese_Header__c : tableHeader);
                btnLabel = (!String.isBlank(tableCmp.crta__Portuguese_btn__c) ? tableCmp.crta__Portuguese_btn__c : btnLabel);}
                when 'es' {tableHeader = (!String.isBlank(tableCmp.crta__Spanish_Header__c) ? tableCmp.crta__Spanish_Header__c : tableHeader);
                btnLabel = (!String.isBlank(tableCmp.crta__Spanish_btn__c) ? tableCmp.crta__Spanish_btn__c : btnLabel);}
                when 'it' {tableHeader = (!String.isBlank(tableCmp.crta__Italian_Header__c) ? tableCmp.crta__Italian_Header__c : tableHeader);
                btnLabel = (!String.isBlank(tableCmp.crta__Italian_btn__c) ? tableCmp.crta__Italian_btn__c : btnLabel);}
            }
      
          List<Column> cols = new List<Column>();
          List<String> fields = new List<String>();
                      System.debug(tableCmp);
          for(crta__table_field__mdt f : [select crta__Field_Api_Name__c , crta__Type__c , crta__display_contact_photo__c , crta__Order_used__c from crta__table_field__mdt  where crta__Displayed_in_datatable__c = true and crta__Component_table__c  = :tableCmp.Id ORDER BY crta__Order_used__c asc]) {
            System.debug(f);
              cols.add(new Column(null,f.crta__Field_Api_Name__c, f.crta__Type__c, f.crta__display_contact_photo__c));
              //fields.add(f.crta__Field_Api_Name__c);
              fields.add(f.crta__Field_Api_Name__c.toLowercase().contains('recordtype') ? 'RecordTypeId' : f.crta__Field_Api_Name__c);
          }
          List<Column> columns = getTranslationsCtrl(tableCmp.crta__Table_name__c, fields);
          List<List<FieldWrapper>> values = getValues(tableCmp.crta__Table_name__c, cols, fields, tableCmp.crta__Filter_criteria__c , tableCmp.crta__Connected_contact_filter__c , tableCmp.crta__ordered_by__c , tableCmp.crta__order_way__c , offset, tableCmp.crta__Record_limit__c != null ? Integer.valueOf(Math.min(lim, tableCmp.crta__Record_limit__c)) : lim);
          tables.add(new Table(tableCmp.Id, tableCmp.crta__authorize_record_creation__c, tableHeader, columns, values, btnLabel, tableCmp.crta__Btn_Link__c , tableCmp.crta__Table_name__c, tableCmp.crta__Record_limit__c != null ? Integer.valueOf(Math.min(lim, tableCmp.crta__Record_limit__c)) : lim, i, tableCmp.crta__Record_limit__c != null ? Integer.valueOf(tableCmp.crta__Record_limit__c): 0));  
          i += 1;
        }
        return tables;
        /*} catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
    }



     @AuraEnabled
     public static Content loadContent(Id appId, Integer limitPage) {

        /*Map<Id,crta__Component_table__mdt> tablesByApp = new Map<Id,crta__Component_table__mdt>([SELECT Id,crta__header__c from crta__Component_table__mdt where crta__application__c = :appId]);

        List<Map<String,Object>> tables = new List<Map<String,Object>>();
        for(String key : tablesByApp.keySet()) {
            tables.add(new Map<String,Object>{'id' => tablesByApp.get(key).Id, 'header' => tablesByApp.get(key).crta__header__c});
        }*/
        crta__application_RH__mdt currentApp = [select crta__Header_for_aggregated_results__c , crta__link__c 
        from crta__application_RH__mdt where Id = :appId];
        List<globalFilter> globalFilters = getGlobalFilterForAggResults(appId);
        String globalFilter = !globalFilters.isEmpty() ? globalFilters.get(0).value : null;
        return new Content (currentApp.crta__link__c,loadTheTableContentCtrl(appId, 0, limitPage), currentApp.crta__Header_for_aggregated_results__c, globalFilters, getAggregatedResults(appId, globalFilter), PortalHomeController.getComponentsCtrl(appId, null, null));
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