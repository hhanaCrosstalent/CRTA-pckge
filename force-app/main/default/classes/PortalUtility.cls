//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author: Ophélie ABOA
 * @Date: 05/11/2019
**/
public with sharing class PortalUtility {
    public class FieldTooDeepException Extends Exception{}
    public class MissingTranslationException extends Exception {}
    public static String get(sObject so, String fieldName) {
        String[] splittedName = fieldName.split('\\.');
        return get_CORE(so, splittedName, 0);
    }

    private static String get_CORE(sObject so, List<String> splitted, Integer currentRelationDepth) {
        if(splitted.size() == 1) {
            if(so != NULL) {
                if(so.get(splitted[0]) instanceOf Date) {
                    return String.valueOf((Date)so.get(splitted[0]));
                }
                else {
                    return String.valueOf(so.get(splitted[0]));
                }
            } else {
                return '';
            }
        }
        else {
            if(currentRelationDepth >= 5) {
                throw new FieldTooDeepException('cannot go deeper than 5 level in relationship.');
            }
            sObject tmp= so.getSObject(splitted[0]);
            splitted.remove(0);
            return get_CORE(tmp, splitted, currentRelationDepth + 1);
        }
    }

    //FUNCTION FOR MAKING REQUEST STRING
    public static String getSOQLQuery(
        Set<String> fieldNameSet, String sObjectName, String whereClause,
        String orderByClause, String limitClause, String offsetClause
    ) {
        String query = 'SELECT '
                + String.join(new List<String>(fieldNameSet), ', ')
                + ' FROM ' + sObjectName
                + ((String.isBlank(whereClause)) ? '' : ' WHERE ' + whereClause)
                + ((String.isBlank(orderByClause)) ? '' : ' ORDER BY ' + orderByClause)
                + ((String.isBlank(limitClause)) ? '' : ' LIMIT ' + limitClause)
                + ((String.isBlank(offsetClause)) ? '' : ' OFFSET ' + offsetClause);
        System.debug('PortalUtility.getSOQLQuery() : \n' + query);
        return query;
    }


    public static String getFieldType(Map<String, Schema.SObjectField> mapTypes, String fieldApiName) {
        Schema.SObjectField field = mapTypes.get(fieldApiName);
        String type;
        try {
            type = String.valueOf(field.getDescribe().getType());
            if(type == 'TEXTAREA' && field.getDescribe().isHtmlFormatted()) {
                type = 'RICHTEXT';
            }
        } catch (Exception e) {
            type = 'REFERENCE';
        }
        return type;
    }

    public static Map<String, String> getTranslationMap(Schema.SObjectType t, List<String> fieldNames) {
        Map<String, String> m = new Map<String, String>();
        Schema.DescribeSObjectResult dsor = t.getDescribe();
        if(fieldNames.size()>0) {
            // translations of fields
            Map<String,Schema.SObjectField> fieldNameMap = dsor.fields.getMap();
            for(String fieldName: fieldNames) {
                String tmp = fieldName;
                if(tmp.contains('.')) {
                    List<String> tmpSplited = tmp.split('\\.');
                    system.debug(fieldName);
                    system.debug(tmpSplited);
                    fieldName = (tmpSplited.get(0).contains('__r') ? tmpSplited.get(0).replace('__r','__c') : tmpSplited.get(0) + 'Id');
                }
                Schema.SObjectField f = fieldNameMap.get(fieldName);
                if(f==null)
                    throw new MissingTranslationException('Translation for field "' + fieldName
                                                                + '" of "' + t + '" not found.');
                Schema.DescribeFieldResult dfr = f.getDescribe();
                String fieldLabel = dfr.getLabel();
                m.put(fieldName, fieldLabel);
            }
        }
        // translation of object itself - singular and plural
        m.put('Label', dsor.getLabel());
        m.put('LabelPlural', dsor.getLabelPlural());
        return m;
    }

    public static Map<String, String> getTranslationMap(Schema.SObjectType t) { 
        return getTranslationMap(t, new List<String>(t.getDescribe().fields.getMap().keySet()));
    }
    
    public static Object setFieldValue(String fieldValue, String fieldType) {
        Object newValue = fieldValue;
        if(fieldValue == '') {
            newValue = null;
        } else {
            switch on fieldType {
                when 'currency', 'double', 'integer', 'long', 'percent' {
                    fieldValue = fieldValue.replace(',','.');
                    newValue = Decimal.valueOf(fieldValue);
                }
                when 'date' {
                    newValue = Date.valueOf(fieldValue);
                }
                when 'datetime' {
                    newValue = Datetime.valueOf(fieldValue);
                }
                when 'picklist' {
                    newValue = fieldValue;
                }
                when 'string' {
                    newValue = fieldValue;
                }
                when 'boolean' {
                    if(fieldValue == 'true') {
                        newValue = true;
                    } else {
                        newValue = false;
                    }
                }
                when 'url' {
                    newValue = fieldValue;
                }
                when else {
                    newValue = String.valueOf(fieldValue);
                }
            }
        }
        return newValue;
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