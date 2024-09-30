//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the calendar page
 * 
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.1
 */
public with sharing class bdu_calendarController {

  public bdu_calendarController() {
  }

  /**
   * Returns events corresponding to a given periods
   *
   * @param String jsonStart JSON string sent by fullcalendarjs of the starting date
   * @param String jsonEnd JSON string sent by fullcalendarjs of the ending date
   *
   * @return List<Event> Map of the events and their corresponding name
   */
  @RemoteAction
  public static List<Event> getCalendarEvents(String jsonStart, String jsonEnd) {
    List<Event> events = new List<Event>();
    String startString= jsonStart.substring(jsonStart.indexOf('_d')+3, jsonStart.indexOf('_d')+22);
    String endString= jsonEnd.substring(jsonEnd.indexOf('_d')+3, jsonEnd.indexOf('_d')+22);
    Datetime startDate = Datetime.valueOf(startString.replace('T', ' '));
    Datetime endDate = Datetime.valueOf(endString.replace('T', ' '));
    events = [SELECT Description, StartDateTime, EndDateTime, IsAllDayEvent, DurationInMinutes, Location, Subject 
              FROM Event 
              WHERE StartDateTime >= :startDate AND EndDateTime <= :endDate 
              AND Owner.Id = :UserInfo.getUserId()
              AND Subject LIKE 'BD%'];
    return events;
  }

  public List<String> getTypes() {
    List<String> types = new List<String>();
    Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Event');//From the Object Api name retrieving the SObject
    sObject objectName = targetType.newSObject();
    Schema.sObjectType sObjectType = objectName.getSObjectType(); //grab the sobject that was passed
    Schema.DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe(); //describe the sobject
    Map<String, Schema.SObjectField> fieldMap = sObjectDescribe.fields.getMap(); //get a map of fields for the passed sobject
    List<Schema.PicklistEntry> pickListValues = fieldMap.get('Subject').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
    System.debug(pickListValues);
    for (Schema.PicklistEntry a : pickListValues) { //for all values in the picklist list
        if(a.getValue().startsWith('BD')) types.add(a.getValue());
    }

    return types;
  }
}