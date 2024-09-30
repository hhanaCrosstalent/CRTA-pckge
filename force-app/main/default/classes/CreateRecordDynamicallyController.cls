public without sharing class CreateRecordDynamicallyController {

    public class FieldWrapper {
        @AuraEnabled
        public Object idValue {get; set;}
        @AuraEnabled
        public String objectApiName {get;set;}
        @AuraEnabled
        public String fieldApiName {get;set;}
        @AuraEnabled
        public String componentName {get;set;} 
        @AuraEnabled
        public String filterLabel {get;set;}
        @AuraEnabled
        public Boolean isLookup {get;set;}
        @AuraEnabled
        public Boolean isPickList {get;set;}
        @AuraEnabled
        public Boolean isText {get;set;}
        @AuraEnabled
        public Boolean isTime {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public String condition {get;set;}
        @AuraEnabled
        public Decimal order {get;set;}
        @AuraEnabled
        public Boolean isMultiSelect {get;set;}

        @AuraEnabled
        public Boolean isSimpleType {get;set;}

        @AuraEnabled
        public List<Map<String, String>> picklistValues {get;set;}
      
        
        public FieldWrapper() {
            //this.idValue='';
        }
    
    }



    @AuraEnabled
    public static Map<String, String> getpicklistValues(String objectName, String fieldName) {
        Map<String, String> result = new Map<String, String>();
        DescribeSObjectResult objResult;
        DescribeFieldResult fieldResult;
        
        String relatedField = fieldName.contains('__r') ? fieldName.replace('__r','__c').SubStringBefore('.') : fieldName;
        String chiledFiled =  fieldName.SubStringAfter('.');     
        DescribeSObjectResult leadDesc = Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        Map<String, sObjectField> leadFields = leadDesc.fields.getMap();
        if(relatedField != fieldName){
            sObjectField lookupField = leadFields.get(relatedField);
            DescribeFieldResult lfDesc = lookupField.getDescribe();
            List<SObjectType> refObjs = lfDesc.getReferenceTo(); 
            objResult = Schema.getGlobalDescribe().get(String.valueOf(refObjs.get(0))).getDescribe();
            fieldResult = objResult.fields.getMap().get(chiledFiled).getDescribe();
        }else{
            objResult = leadDesc;
            fieldResult = leadDesc.fields.getMap().get(fieldName).getDescribe();
        }
        
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
            result.put(pickListVal.getValue(),pickListVal.getLabel());
		}     
		return result;
    }


    
    @AuraEnabled
    public static List<FieldWrapper> getDynamicFieldsFromCustomSettingCntrl(String tableId) {
       
       List<FieldWrapper> fieldWrapperList = new List<FieldWrapper>();
        for(crta__table_field__mdt t : [SELECT Id,   
            crta__Type__c,
            crta__Field_Api_Name__c,
            crta__Component_table__r.crta__Table_name__c ,
            crta__Order__c
            FROM crta__table_field__mdt
            WHERE crta__Component_table__c = :tableId AND crta__Displayed_in_creation__c = true order by crta__Order__c ]){
            FieldWrapper field = new FieldWrapper(); 
            field.objectApiName = t.crta__Component_table__r.crta__Table_name__c;
            field.fieldApiName = t.crta__Field_Api_Name__c;
                Map<String,Schema.SObjectField> mfields = Schema.getGlobalDescribe().get(t.crta__Component_table__r.crta__Table_name__c).getDescribe().fields.getMap();
                String fieldAPIName= t.crta__Field_Api_Name__c.contains('__r.') ? t.crta__Field_Api_Name__c.split('__r.')[0] + '__c' : t.crta__Field_Api_Name__c;
                System.debug(t.crta__Field_Api_Name__c);
                System.debug(fieldAPIName);
              Schema.DescribeFieldResult fieldResult = mfields.get(fieldAPIName).getDescribe();
              System.debug(fieldResult == null);
            field.filterLabel = fieldResult != null ? fieldResult.getLabel() : '';
            field.order = t.crta__Order__c;
            field.type = t.crta__Type__c;
            if(t.crta__Type__c == 'List'){field.isPickList = true;field.isLookup = false;field.isSimpleType=false;field.isText = false; field.isTime = false;
            Map<String,String> picklistValues = getpicklistValues(field.objectApiName, field.fieldApiName);
            List<Map<String,String>> fieldpicklistValues = new List<Map<String,String>>();
            fieldpicklistValues.add(new Map<String,String> {'label' => '', 'value' => ''});
            for(String key : picklistValues.keySet()) {
              fieldpicklistValues.add(new Map<String,String> {'label' => key, 'value' => picklistValues.get(key)});
            }
            System.debug('fieldpicklistValues');
            System.debug(fieldpicklistValues);
            field.picklistValues= fieldpicklistValues;
            }
            else if(t.crta__Type__c == 'Reference'){field.isSimpleType=false; field.isLookup = true;field.isPickList = false;field.isText = false; field.isTime = false; }
            else if(t.crta__Type__c == 'Text') {field.isSimpleType=true;field.isText = true;field.isPickList = false;field.isLookup = false; field.isTime = false; }
            else {field.isSimpleType=true;field.isTime = true; field.isText = false;field.isPickList = false;field.isLookup = false;}
            
            fieldWrapperList.add(field) ;
        }
       return fieldWrapperList;
        
    }


    @AuraEnabled
    public static void createRecord(List<FieldWrapper> fileds){
        if (fileds!=null && !fileds.isEmpty()) {
        String objectApiName = fileds.get(0).objectApiName;
         SObject newRecord = Schema.getGlobalDescribe().get(objectApiName).newSObject();
        
        for (FieldWrapper field : fileds) {
            String fieldApiName = field.fieldApiName.contains('__r.') ? field.fieldApiName.split('__r.')[0] + '__c' : field.fieldApiName;
            System.debug('fieldApiName '+fieldApiName);
            Object value;
            switch on (field.type) {
                when 'datetime' { value=(DateTime)Json.deserialize('"'+field.idValue+'"', DateTime.class);}
                when 'date' { value= (Date)Date.valueOf(field.idValue);}
                when 'time' { value= getTimeValueFromStringCtrl((String)field.idValue);}
                when else  {value=field.idValue;}

            }

            System.debug('value '+value);
            newRecord.put(fieldApiName, value);
        }
        
        try {
            insert newRecord;
            System.debug(objectApiName + ' record created successfully: ' + newRecord);
        } catch(Exception e) {
            System.debug('Error creating ' + objectApiName + ' record: ' + e.getMessage());
        }
        }

    }


      private static Time getTimeValueFromStringCtrl(String s) {
        if(String.isBlank(s) || s.length() < 5) return null;
        return Time.newInstance(Integer.valueOf(s.substring(0, 2)), Integer.valueOf(s.substring(3, 5)), 0, 0);
    }

}