public with sharing class LightningHelperbis {
    
    public class MissingTranslationException extends Exception {}

    public static Map<String, String> getTranslationMap(Schema.SObjectType t, List<String> fieldNames) {
        Map<String, String> m = new Map<String, String>();
        Schema.DescribeSObjectResult dsor = t.getDescribe();
        if(fieldNames.size()>0) {
            // translations of fields
            Map<String,Schema.SObjectField> fieldNameMap = dsor.fields.getMap();
            for(String fieldName: fieldNames) {
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
}