//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for a training calendar page
 */
public with sharing class sessionCalendarController {

    public sessionCalendarController() {
    }

    /**
    * Returns events corresponding to a given periods
    *
    * @param String jsonStart JSON string sent by fullcalendarjs of the starting date
    * @param String jsonEnd JSON string sent by fullcalendarjs of the ending date
    * @param String contactId Events' owner Id
    *
    * @return List<FO_Session_collective__c> Map of the events and their corresponding name
    */
    @RemoteAction
    public static List<FO_Session_collective__c> getCalendarEvents(String jsonStart, String jsonEnd) {
        List<FO_Session_collective__c> sessions = new List<FO_Session_collective__c>();
        String startString= jsonStart.substring(jsonStart.indexOf('_d')+3, jsonStart.indexOf('_d')+22);
        String endString= jsonEnd.substring(jsonEnd.indexOf('_d')+3, jsonEnd.indexOf('_d')+22);
        DateTime startDate = Datetime.valueOf(startString.replace('T', ' '));
        DateTime endDate = Datetime.valueOf(endString.replace('T', ' '));

        sessions = [SELECT Name, FO_Date_et_heure_de_debut__c, FO_Duree_en_heures__c, FO_Nom_de_la_formation__c, 
                            FO_Formateur__r.Name, Catalogue_de_formation__r.FO_Type__c
                    FROM FO_Session_collective__c
                    WHERE FO_Date_et_heure_de_debut__c >= :startDate
                    AND FO_Date_et_heure_de_debut__c <= :endDate];
        return sessions;
    }

    /**
    * Returns the types' list for training modules
    * @return List<String> list of types
    */
    public List<String> getTypes() {
        List<String> types = new List<String>();
        Schema.DescribeFieldResult aField = Schema.SObjectType.FO_catalogue_de_formation__c.fields.FO_Type__c;
        List<Schema.PicklistEntry> pes = aField.getPickListValues();
        for(Schema.PicklistEntry pe : pes) {
            types.add(pe.getValue());
        }
        return types;
    }
}