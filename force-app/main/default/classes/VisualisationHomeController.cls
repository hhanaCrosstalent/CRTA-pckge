//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the home page of the Portal
 */
public with sharing class VisualisationHomeController {
    public String contactId { get; set; }
    public List<Article__c> posts { get; set; } //Blog posts
    public String locale { get; set; } //locale of the user

    public VisualisationHomeController() {
        locale = UserInfo.getLanguage().left(2);
        contactId = sirhTemplateController.contactId;
        posts = [SELECT Name, Owner.Name, Texte__c, Date_de_publication__c, Categories__c, Couleur_du_titre__c, 
                    (SELECT Id
                     FROM Attachments 
                     WHERE ContentType LIKE 'image/%' 
                     ORDER BY LastModifiedDate DESC 
                     LIMIT 1) 
                 FROM Article__c 
                 WHERE Date_de_publication__c <= TODAY 
                 ORDER BY Date_de_publication__c DESC 
                 LIMIT 5];
    }

    /**
     * Returns events corresponding to a given periods
     *
     * @param jsonStart JSON string sent by fullcalendarjs of the starting date
     * @param jsonEnd JSON string sent by fullcalendarjs of the ending date
     * @param contactId Events' owner Id
     *
     * @return Map of the events and their corresponding name
     */
    @RemoteAction
    public static Map<String, List<sObject>> getCalendarEvents(String jsonStart, String jsonEnd, String contactId) {
        Map<String, List<sObject>> returnList = new Map<String, List<sObject>>();
        EI__c options = EI__c.getInstance(UserInfo.getUserId());
        Timesheet__c timeOptions = Timesheet__c.getInstance(UserInfo.getUserId());
        String startString= jsonStart.substring(jsonStart.indexOf('_d')+3, jsonStart.indexOf('_d')+22);
        String endString= jsonEnd.substring(jsonEnd.indexOf('_d')+3, jsonEnd.indexOf('_d')+22);
        Date startDate = Date.valueOf(startString.replace('T', ' '));
        Date endDate = Date.valueOf(endString.replace('T', ' '));

        //Retrieving interviews
        List<EI_Entretien__c> interviews = new List<EI_Entretien__c>();
        if(options.useDate__c) {
            interviews = getAllOpenedByEmployeeBetweenDate(contactId, startDate, endDate);
        } else {
            interviews = getAllByEmployeeBetweenDate(contactId, startDate, endDate);
        }
        returnList.put('interview', interviews);

        // Id, EI_Date_de_l_entretien__c, EI_Salarie_qui_fait_passer_l_entretien__r.Name
        return returnList;
    }
    
    private static List<EI_Entretien__c> getAllOpenedByEmployeeBetweenDate(String contactId, Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT EI_Date_de_l_entretien__c, EI_Salarie_qui_fait_passer_l_entretien__r.Name '
                           + 'FROM EI_Entretien__c '
                           + 'WHERE EI_Salarie_qui_passe_l_entretien__c =: contactId '
                           + 'AND Date_d_ouverture__c <= TODAY '
                           + 'AND EI_Date_de_l_entretien__c >=: startDate '
                           + 'AND EI_Date_de_l_entretien__c <=: endDate '
                           + 'ORDER BY EI_Date_de_l_entretien__c DESC ';
        return Database.query(sObjectSOQL);
    }

    private static List<EI_Entretien__c> getAllByEmployeeBetweenDate(String contactId, Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT EI_Date_de_l_entretien__c, EI_Salarie_qui_fait_passer_l_entretien__r.Name '
                           + 'FROM EI_Entretien__c '
                           + 'WHERE EI_Salarie_qui_passe_l_entretien__c =: contactId '
                           + 'AND EI_Date_de_l_entretien__c >=: startDate '
                           + 'AND EI_Date_de_l_entretien__c <=: endDate '
                           + 'ORDER BY EI_Date_de_l_entretien__c DESC ';
        return Database.query(sObjectSOQL);
    }
}