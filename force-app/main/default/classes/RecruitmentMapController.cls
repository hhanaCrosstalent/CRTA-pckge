//Security isCreateable() isUpdateable() isDeletable() checked
// @author Felix van Hove
global with sharing class RecruitmentMapController {
    public String p1 {get;set;}
    public String p2 {get;set;}

    public RecruitmentMapController() {
        p1 = 'https://maps.googleapis.com/maps/api/js?key=';
        p2 = '&v=3.exp&callback=initMap';
    }

    @AuraEnabled
    public static String getPicklists() {
        Map<String, Object> m = new Map<String, Object>();
        m.put('contactTypes', getContactTypes());
        m.put('managementLevels', getPickList(Schema.SObjectType.Contact.fields.crta__CT_Management_level__c));
        m.put('programs', getPickList(Schema.SObjectType.Contact.fields.crta__CT_Support__c));
        m.put('situations', getPickList(Schema.SObjectType.Contact.fields.crta__CT_Situation__c));
        m.put('industries', getPickList(Schema.SObjectType.crta__Offre_d_emploi__c.fields.crta__CT_Industry_of_activities__c));
        m.put('workAreas', getPickList(Schema.SObjectType.crta__Offre_d_emploi__c.fields.crta__Filiere__c));
        m.put('categories', getPickList(Schema.SObjectType.crta__Offre_d_emploi__c.fields.crta__Categorie__c));
        return JSON.serialize(m);
    }

    public static List<String> getContactTypes() {
        List<String> options = new List<String>();
        List<RecordType> contact_typeLst = [SELECT RecordType.Name FROM RecordType WHERE sObjectType='contact'];
        options.add(System.Label.List_all);
        for(RecordType ct: contact_typeLst){
           options.add(String.valueOf(ct.get('Name')));
        }
        options.sort();
        return options;
    }

    public static List<String> getPicklist(Schema.DescribeFieldResult fr) {
        List<String> options = new List<String>();
        options.add(System.Label.List_all);
        List<Schema.PicklistEntry> ples = fr.getPicklistValues();
        for(Schema.PicklistEntry ple: ples) {
            options.add(ple.getLabel());
        }
        options.sort();
        return options;
    }

    @RemoteAction
    global static List<Contact> getContacts(String searchText, String position, String selectedType, Integer distance,
            String managementLevel, String support, String situation, String fields) {
        String sar = getProperSelect(fields, true);
        if(String.isBlank(searchText)) {
            return getContacts(selectedType, managementLevel, support, situation, position, distance, sar);
        }
        return getContacts(searchText, position, distance, sar);
    }

    private static List<Contact> getContacts(String searchText, String position, Integer distance, String fields) {
        searchText += '*';
        String query = 'FIND {'+String.escapeSingleQuotes(searchText)+'} IN ALL FIELDS RETURNING '
            + 'Contact (Id, '
            + fields
            + 'Name, '
            + SObjectType.Contact.fields.crta__Location__Latitude__s.getName() + ', '
            + SObjectType.Contact.fields.crta__Location__Longitude__s.getName() + ' '
            + 'WHERE DISTANCE('
                + SObjectType.Contact.fields.crta__Location__c.getName() + ', '
                + 'GEOLOCATION'+position+', \'km\') < '+ distance + ' '
            + 'ORDER BY LastName '
            + 'LIMIT 100 '
            + ')';
        System.debug('quering contacts text: ' + query);
        List<List<SObject>> contacts = Search.query(String.escapeSingleQuotes(query));
        List<Contact> l = (List<Contact>) contacts[0];
        return l;
    }

    private static List<Contact> getContacts(String selectedType, String managementLevel, String support, 
                                                String situation, String position, Integer distance, String fields) {
        String query = 'SELECT Id, '
                + fields
                + 'Name, '
                + 'crta__Location__Latitude__s, '
                + 'crta__Location__Longitude__s '
                + 'FROM Contact '
                + 'WHERE DISTANCE(crta__Location__c, GEOLOCATION'+String.escapeSingleQuotes(position)+', \'km\') < '
                    + distance + ' ';
        if(!String.isBlank(selectedType) && selectedType != System.Label.List_all) {
            query += ' AND RecordTypeId IN ('
                + 'SELECT Id FROM RecordType WHERE sobjecttype = \'contact\' AND Name = \''
                + String.escapeSingleQuotes(selectedType) + '\') ';
        }
        if(!String.isBlank(managementLevel) && managementLevel != System.Label.List_all) {
            query += 'AND toLabel(crta__CT_Management_level__c) = \''+managementLevel+'\' ';
        }
        if(!String.isBlank(support) && support != System.Label.List_all) {
            query += 'AND toLabel(crta__CT_Support__c) = \''+support+'\' ';
        }
        if(!String.isBlank(situation) && situation != System.Label.List_all) {
            query += 'AND toLabel(crta__CT_Situation__c) = \''+situation+'\' ';
        }
        query += 'ORDER BY LastName '
            + 'LIMIT 100';
        System.debug('quering contacts category: ' + query);
        List<Contact> l = Database.query(String.escapeSingleQuotes(query));
        return l;
      }

    @RemoteAction
    global static List<crta__Offre_d_emploi__c> getJobPostings(String searchText, String position,
        String selectedIndustry, Integer distance, String filiere, String category, Boolean scope, String fields) {
        String sar = getProperSelect(fields, false);
        if(String.isBlank(searchText)) {
            return getJobPostings(selectedIndustry, filiere, category, scope, position, distance, sar);
        }
        return getJobPostings(searchText, position, distance, sar);
    }

    private static List<crta__Offre_d_emploi__c> getJobPostings(String searchText, String position, Integer distance, String fields) {
        searchText += '*';
        String query = 'FIND {'+String.escapeSingleQuotes(searchText)+'} IN ALL FIELDS RETURNING '
            + 'crta__Offre_d_emploi__c (Id, Name, '
            + fields
            + SObjectType.crta__Offre_d_emploi__c.fields.crta__Location__Latitude__s.getName() + ','
            + SObjectType.crta__Offre_d_emploi__c.fields.crta__Location__Longitude__s.getName() + ' '
            + 'WHERE DISTANCE('
                + SObjectType.crta__Offre_d_emploi__c.fields.crta__Location__c.getName() + ', '
                + 'GEOLOCATION'+position+', \'km\') < '+ distance + ' '
            + 'LIMIT 100 '
            +')';
        System.debug('query jobPostings text: ' + query);
        List<List<SObject>>searchOffers = Search.query(String.escapeSingleQuotes(query));
        List<crta__Offre_d_emploi__c> l = ((List<crta__Offre_d_emploi__c>) searchOffers[0]);
        return l;
    }

    private static List<crta__Offre_d_emploi__c> getJobPostings(String selectedIndustry, String filiere, 
                                    String category, Boolean scope, String position, Integer distance, String fields) {
        String query = 'SELECT Id, Name, '
            + fields
            + 'crta__Location__Latitude__s, '
            + 'crta__Location__Longitude__s '
            + 'FROM crta__Offre_d_emploi__c '
            + 'WHERE DISTANCE(crta__Location__c, GEOLOCATION'+String.escapeSingleQuotes(position)+', \'km\') < '
            + distance + ' ';
        if(!String.isBlank(selectedIndustry) && selectedIndustry != System.Label.List_all) {
            query += 'AND crta__CT_Industry_of_activities__c INCLUDES (\''+String.escapeSingleQuotes(selectedIndustry)+'\') ';
        }
        if(!String.isBlank(filiere) && filiere != System.Label.List_all) {
            query += 'AND crta__Filiere__c = \'' + filiere + '\' ';
        }
        if(!String.isBlank(category) && category != System.Label.List_all) {
            query += 'AND crta__Categorie__c = \'' + category + '\' ';
        }
        query += 'AND crta__CT_Scope__c = ' + scope + ' ';
        query += 'LIMIT 100';
        List<crta__Offre_d_emploi__c> l = Database.query(String.escapeSingleQuotes(query));
        return l;
    }

    @TestVisible
    private static String getProperSelect(String s, Boolean isContact) {
        String result = '';
        if(String.isBlank(s)) {
            return result;
        }
        String[] sar = s.split(',');
        Map<String, Schema.SObjectField> m;
        if(isContact) m = Schema.SObjectType.Contact.fields.getMap();
        else m = Schema.SObjectType.crta__Offre_d_emploi__c.fields.getMap();

        for(Integer i=0; i<sar.size(); i++) {
            String fieldName = sar[i].trim();
            if(fieldName != 'Name' 
                    && fieldName != 'crta__Location__Latitude__s'
                    && fieldName != 'crta__Location__Longitude__s') {
                Schema.SObjectField f = m.get(fieldName); 
                Schema.DisplayType t = f.getDescribe().getType();
                if(t == Schema.DisplayType.Picklist || t == Schema.DisplayType.MultiPicklist) {
                    result += 'toLabel(' + sar[i].trim() + '), ';
                } else {
                    result += sar[i].trim() + ', ';
                }
            }
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Map<String, String>> getTranslations(String contactFields, String jobPostingFields) {
        Map<String, Map<String, String>> m = new Map<String, Map<String, String>>();

        Map<String, String> contactM = new Map<String, String>();
        m.put('Contact', contactM);
        Map<String, String> jobPostingM = new Map<String, String>();
        m.put('crta__Offre_d_emploi__c', jobPostingM);

        Map<String,Schema.SObjectField> fieldNameMap = Contact.sObjectType.getDescribe().fields.getMap();
        String[] additionalFields = new String[] {'FirstName', 'LastName', 'crta__CT_Management_level__c',
                    'crta__CT_Support__c', 'crta__CT_Situation__c'};
        String[] fieldNames = contactFields.split(',');
        fieldNames.addAll(additionalFields);
        for(String fieldName: fieldNames) {
            if(String.isBlank(fieldName)) continue;
            Schema.SObjectField f = fieldNameMap.get(fieldName.trim());
            Schema.DescribeFieldResult dfr = null;
            try {
                dfr = f.getDescribe();
            } catch(Exception e) {
                throw new AuraHandledException('Translations failed for Contact field: ' + fieldName);
            }
            String fieldLabel = dfr.getLabel();
            contactM.put(fieldName.trim(), fieldLabel);
        }
        contactM.put('Label', Schema.getGlobalDescribe().get('Contact').getDescribe().getLabel());

        fieldNameMap = crta__Offre_d_emploi__c.sObjectType.getDescribe().fields.getMap();
        additionalFields = new String[] {'Name', 'crta__CT_Industry_of_activities__c', 'crta__Filiere__c', 'crta__Categorie__c',
                        'crta__CT_Scope__c'};
        fieldNames = jobPostingFields.split(',');
        fieldNames.addAll(additionalFields);
        for(String fieldName: fieldNames) {
            if(String.isBlank(fieldName)) continue;
            Schema.SObjectField f = fieldNameMap.get(fieldName.trim());
            Schema.DescribeFieldResult dfr = null;
            try {
	            dfr = f.getDescribe();
            } catch(Exception e) {
                throw new AuraHandledException('Translations failed for Job Posting field: ' + fieldName);
            }
            String fieldLabel = dfr.getLabel();
            jobPostingM.put(fieldName.trim(), fieldLabel);
        }
        jobPostingM.put('Label', Schema.getGlobalDescribe().get('crta__Offre_d_emploi__c').getDescribe().getLabel());

        return m;
    }
}