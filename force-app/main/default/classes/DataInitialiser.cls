//Security isCreateable() isUpdateable() isDeletable() checked
global with sharing class DataInitialiser {
// @author Felix van Hove

    global static void init() {
        List<Country__c> l = [SELECT Id FROM Country__c];
        if(l.size()==0) initCountries(l);
    }
    
    // https://www.iso.org/obp/ui/#search
    private static void initCountries(List<Country__c> l) {
        if (
                Schema.sObjectType.Country__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.Code__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.EEA__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.EU__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.Internal_Code__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.Name.isCreateable()
                && Schema.sObjectType.Country__c.fields.Name_French__c.isCreateable()
                && Schema.sObjectType.Country__c.fields.Time_Zone__c.isCreateable()
        ) {
            List<List<String>> countries = getFieldsFromFile();
            List<Country__c> inserts = new List<Country__c>();
            for(List<String> fields:countries) {
                Country__c c = new Country__c(
                    Code__c = fields[2],
                    EEA__c = Boolean.valueOf(fields[5]),
                    EU__c = Boolean.valueOf(fields[6]),
                    Internal_Code__c = fields[3],
                    Name = fields[0],
                    Name_French__c = fields[1],
                    Time_Zone__c = (fields.size()<8 || String.isBlank(fields[7]))?null:fields[7]
                );
                inserts.add(c);
            }
            insert inserts;
        } else {
            System.debug(System.Label.Permission);
        }
    }

    @TestVisible
    private static List<List<String>> getFieldsFromFile() {
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'countries_csv'];
        Blob data = sr.Body;
        String csv = data.toString();
        String[] lines = csv.split('\n');
        
        List<List<String>> parsedLines = new List<List<String>>();
        Integer firstRelevantLine = 1;
        for(Integer i=firstRelevantLine; i<lines.size(); i++) {
            String[] fields = lines[i].split('\\t');
            System.debug('fields: ' + fields);
            parsedLines.add(fields);
        }
        return parsedLines;
    }
}