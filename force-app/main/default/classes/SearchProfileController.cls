//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date: 26/11/2018
**/
public without sharing class SearchProfileController {
	@AuraEnabled
    public static List<Contact> getContactsFilter(String fields, String recordTypes) {
        User currentUser = getCurrentUser();
        String soql = ''; 
        List<String> recordTypesList = new List<String>();
        Set<String> fieldsList = new Set<String>{'Id', 'Name', 'LastName', 'FirstName', 'OwnerId'};
        for(String s : fields.split(';')) {
            if(s != 'null' && s != '' && s!= 'undefined') {
                fieldsList.add(s);
            }
        }
        if(recordTypes != NULL) {
            recordTypes = recordTypes.replaceAll( '\\s+', '');
            if(recordTypes == '') { 
                recordTypesList.add('Salarie');
            } else {
                recordTypesList = recordTypes.split(',');
            }
        } else {
            recordTypesList.add('Salarie');
        }
        
        if (currentUser.crta__Contact__c != null) {
            soql = 'WHERE Id != null AND (crta__CT_Exit_date__c >= TODAY OR crta__CT_Exit_date__c = null) '
                    +'AND RecordType.DeveloperName IN :recordTypesList ' + soql;
        }

        String query = 'SELECT ' + String.join(new List<String>(fieldsList), ',')
                        + ' FROM Contact ' 
                        + soql + ' ORDER BY LastName ASC';
        
        System.debug(query);
        List<Contact> contacts = Database.query(query);
		
        return contacts;
    }

    @AuraEnabled 
    public static Map<String, String> getSchema(String obj, String field) {
        Map<String,String> generatedMap = new Map<String,String>();
        for(Schema.PicklistEntry row: Schema.getGlobalDescribe()
                                     .get(obj)
                                     .getDescribe()
                                     .fields
                                     .getMap()
                                     .get(field)
                                     .getDescribe()
                                     .getPickListValues())
        {
           generatedMap.put(row.getLabel(), row.getValue());
        }

        return generatedMap;
    }

    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
         

        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
         
        for (Schema.PicklistEntry a: values) {
           allOpts.add(a.getValue());
        }

        allOpts.sort();
        system.debug(allOpts);
        return allOpts;
    }

    @AuraEnabled
    public static User getCurrentUser() {
        return [SELECT crta__Contact__c,
                	Profile.UserLicense.Name
                FROM User
                WHERE Id = : UserInfo.getUserId()
                LIMIT 1
               ];
    }
}