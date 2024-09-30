//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for all objects
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing virtual class BaseRepository {

    private static final Map<String, String> PREFIX_TO_OBJECT_NAME = new Map<String, String>();
    
    static {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(Schema.SObjectType stype : gd.values()) {
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String prefix = r.getKeyPrefix();
            if(prefix!=null) {
                PREFIX_TO_OBJECT_NAME.put(prefix, r.getName());
            }
        }
    }
    
  /**
   * Retrieves all records for the given sObject
   * @param  sObjectName API Name of the sObject to retrieve
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObject(String sObjectName) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all records for the given sObject ordered by the given field
   * @param  sObjectName API Name of the sObject to retrieve
   * @param  orderedField API Name of the field to order
   * @param  order        Direction of the order (i.e. ASC or DESC)
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObjectOrderedBy(String sObjectName, String orderedField, String order) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' ORDER BY '+orderedField+' '+order;

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves all records for the given sObject with untranslated picklists
   * @param  sObjectName API Name of the sObject to retrieve
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObjectUntranslated(String sObjectName) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFieldsUntranslated(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves all records for the given sObject ordered by the given field with untranslated picklists
   * @param  sObjectName API Name of the sObject to retrieve
   * @param  orderedField API Name of the field to order
   * @param  order        Direction of the order (i.e. ASC or DESC)
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObjectUntranslatedOrderedBy(String sObjectName, String orderedField, 
                                                                      String order) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFieldsUntranslated(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' ORDER BY '+orderedField+' '+order;

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves all records for the given sObject and given fields
   * @param  sObjectName API Name of the sObject to retrieve
   * @param  fields   List of fields' API name
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObjectAndFields(String sObjectName, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves all records for the given sObject and given fields
   * @param  sObjectName API Name of the sObject to retrieve
   * @param  fields   List of fields' API name
   * @param  orderedField API Name of the field to order
   * @param  order        Direction of the order (i.e. ASC or DESC)
   * @return   List<sObject>
   */
  webService static List<sObject> getAllForObjectAndFieldsOrderedBy(String sObjectName, List<String> fields, String orderedField, String order) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' ORDER BY '+orderedField+' '+order;

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves a record for the given sObject and Id
   * @param  sObjectId   Id of the sObject to retrieve
   * @param  sObjectName API Name of the sObject to retrieve
   * @return   List<sObject>
   */
  webService static sObject getByIdForObject(String sObjectId, String sObjectName) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' WHERE Id = \''+sObjectId+'\' LIMIT 1';

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves a record for the given sObject and Id with untranslated picklists
   * @param  sObjectId   Id of the sObject to retrieve
   * @param  sObjectName API Name of the sObject to retrieve
   * @return   List<sObject>
   */
  webService static sObject getByIdForObjectUntranslated(String sObjectId, String sObjectName) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFieldsUntranslated(sObjectName)) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' WHERE Id = \''+sObjectId+'\' LIMIT 1';

    return Database.query(sObjectSOQL);  
  }

  /**
   * Retrieves a record for the given sObject, Id and fields
   * @param  sObjectId   Id of the sObject to retrieve
   * @param  sObjectName API Name of the sObject to retrieve
   * @param  fields   List of fields' API name
   * @return   List<sObject>
   */
  webService static sObject getByIdForObjectAndFields(String sObjectId, String sObjectName, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM '+sObjectName;
    sObjectSOQL += ' WHERE Id = \''+sObjectId+'\' LIMIT 1';

    return Database.query(sObjectSOQL);  
  }

  /**
   * Felix, 20/4/2017: DO NOT USE FROM INSIDE OF THE PACKAGE! This is a legacy. Use the method with the same
   * name taking a sObjectType instead. This is safer and, more importantly, works in an environment with and 
   * without namespace.
   *
   * Returns the given object's fields
   * Minus Id and Name
   * @param  sObjectName API Name of the sObject to parse
   * @return   List of fields' API name
   */
    global static List<String> getObjectFields(String sObjectName) {
        SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
        return getObjectFields(t);
  }

    public static List<String> getObjectFields(SObjectType t) {
        List<String> fieldList = new List<String>();
        Set<String> fieldSet = getObjectFieldsUntranslated(t);
        Map<String,Schema.SObjectField> mfields = t.getDescribe().fields.getMap();
        for(String fieldName: fieldSet) {
            Schema.SObjectField field = mfields.get(fieldName);
            Schema.DisplayType fieldType = field.getDescribe().getType();
            if(fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST) {
                fieldList.add('toLabel('+fieldName+')');
            } else {
                fieldList.add(fieldName);
            }
        }
        return fieldList;
    }

  /**
   * Felix, 20/4/2017: DO NOT USE FROM INSIDE OF THE PACKAGE! This is a legacy. Use the method with the same
   * name taking a sObjectType instead. This is safer and, more importantly, works in an environment with and 
   * without namespace.
   *
   * Returns the given object's fields
   * Minus Id and Name
   * Untranslated
   * @param  sObjectName API Name of the sObject to parse
   * @return   List of fields' API name
   */
  global static Set<String> getObjectFieldsUntranslated(String sObjectName) {
    SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
    return getObjectFieldsUntranslated(sObjectType);
  }
  
    public static Set<String> getObjectFieldsUntranslated(SObjectType t) {
        Map<String,Schema.SObjectField> mfields = t.getDescribe().fields.getMap();
        Set<String> fieldSet = mfields.keySet();
        fieldSet.remove('id');
        fieldSet.remove('name');
        return fieldSet;
    }

  global static String addFilter(List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
    String sObjectSOQL = '';
    if(!filterFields.isEmpty() && filterFields.size() == filterValues.size() && filterFields.size() == filterOperations.size()) {
      sObjectSOQL += ' WHERE Id != null';
      for(Integer i = 0; i < filterFields.size(); i++) {
        if(filterValues[i] != null && filterValues[i] != '' && filterValues[i] != 'null') {
          if(filterOperations[i].toLowerCase() == 'includes') {
            sObjectSOQL += ' AND '+filterFields[i]+' '+filterOperations[i]+' (\''+filterValues[i]+'\')';
          } else {
            sObjectSOQL += ' AND '+filterFields[i]+' '+filterOperations[i]+' \''+filterValues[i]+'\'';
          }
        }
      }
    } else if(!filterFields.isEmpty() && filterFields.size() == filterValues.size()) {
      sObjectSOQL += ' WHERE Id != null';
      for(Integer i = 0; i < filterFields.size(); i++) {
        if(filterValues[i] != null && filterValues[i] != '' && filterValues[i] != 'null') sObjectSOQL += ' AND '+filterFields[i]+' = \''+filterValues[i]+'\'';
      }
    }

    return sObjectSOQL;
  }
  
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix) {
        String prefix = String.valueOf(recordIdOrPrefix).substring(0,3);
        return PREFIX_TO_OBJECT_NAME.get(prefix);
    }
}