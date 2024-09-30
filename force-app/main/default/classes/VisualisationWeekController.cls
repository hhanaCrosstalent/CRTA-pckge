//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the week details page
 * @author Crosstalent
 * @group SIRH-Frontend
 */
public with sharing class VisualisationWeekController {
    public Contact employee {get; set;} //Owner of the displayed time planning
    public String weekId {get; set;} //Id of the displayed timesheet
    public Long weekStart {get; set;} //Start date of the week in milliseconds
    public String locale {get; set;} //Language locale of the logged user
    public String selectedTimeType {get; set;} //Name of the selected time type
    public String selectedTimePeriod {get; set;} //Name of the selected time period
    public Boolean isManager {get; set;} //Whether the logged user is also the manager of the employee
    public Feuille_Temps_Hebdo__c week {get; set;} //Timesheet displayed

    /**
     * Retrieves the given week
     */
    public VisualisationWeekController() {
        isManager = false;
        locale = UserInfo.getLanguage().left(2);
        String contactId = ApexPages.currentPage().getParameters().get('contactId');

        //If a Timesheet is specified we load it
        weekId = ApexPages.currentPage().getParameters().get('id');
        if(weekId != null && weekId != '')  {
            week = TimesheetRepository.getById(weekId);
            Time weekTime = Time.newInstance(0, 0, 0, 0);
            weekStart = Datetime.newInstanceGmt(week.Date_debut_semaine__c, weekTime).getTime();
            if(contactId == null) contactId = week.Salarie__c;
        }
        if(contactId == null) contactId = [SELECT contact__c FROM User WHERE Id = :UserInfo.getUserId()].contact__c;

        try {
            employee = [SELECT Id, Name, Repos_compensateurs_solde__c, reportsToId FROM Contact WHERE Id = :contactId];
            if(employee.ReportsToId == [SELECT Contact__c 
                                        FROM User 
                                        WHERE Id =:UserInfo.getUserId()].Contact__c) {
                isManager = true;
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

    /**
     * Populates a select list with the types of time.
     * @return The types
     */
    public List<SelectOption> getTimeTypes(){
        return TimeManager.getTimeTypes();
    }

    /**
     * Populates a select list with the periods.
     * @return The periods
     */
    public List<SelectOption> getTimePeriods(){
        return LeaveManager.getLeavePeriods();
    }
}