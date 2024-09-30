//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the time scheduler page
 * @author Crosstalent
 * @group SIRH-Frontend
 * @version 1.0
 */
public with sharing class VisualisationSchedulerController {
    public String locale {get; set;} //Language locale of the logged user
    public String managerId {get; set;} //Id of the logged or specified manager
    public String selectedTimeType {get; set;} //Name of the telected time type
    public String selectedTimePeriod {get; set;} //Name of the selected time period
    public String selectedManager {get; set;} //Id of the selected manager
    public String selectedTeam {get; set;} //Name of the selected team
    public Integer dailyRequirements {get; set;} //Number of employee required per day

    public VisualisationSchedulerController() {
        locale = UserInfo.getLanguage().left(2);
        managerId = ApexPages.currentPage().getParameters().get('managerId');
        if(managerId == null) {
            managerId = [SELECT contact__c 
                         FROM User
                         WHERE Id = :UserInfo.getUserId()].contact__c;
        }
        selectedManager = managerId;
        dailyRequirements = 0;
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

    /**
     * Populates a select list with the managers reporting directly to the selected manager.
     * @return The managers
     */
    public List<SelectOption> getManagers(){
        List<SelectOption> managers = new List<Selectoption>();
        try {
            String contactId = [SELECT contact__c 
                                FROM User 
                                WHERE Id = :UserInfo.getUserId()].contact__c;
            Contact currentManager = [SELECT Id, Name 
                                      FROM Contact 
                                      WHERE Id = :contactId]; //Adding the name of the current logged manager
            Contact selectedContact = [SELECT Id, Name 
                                       FROM Contact 
                                       WHERE Id = :selectedManager]; //Adding the name of the selected manager
            List<AggregateResult> ManagerLst = [SELECT Id, Name 
                                                FROM Contact
                                                WHERE ReportsToId!=null 
                                                AND ReportsToId = :selectedManager 
                                                GROUP BY Id, Name];
            
            managers.add(new SelectOption(String.valueOf(currentManager.Id), String.valueOf(currentManager.Name)));
            if(selectedContact.Id != currentManager.Id) {
                managers.add(new SelectOption(String.valueOf(selectedContact.Id),
                    String.valueOf(selectedContact.Name)));
            }
            for(AggregateResult a: ManagerLst) {
                if(String.valueOf(a.get('Id')) != currentManager.Id 
                        && String.valueOf(a.get('Id')) != selectedContact.Id) {
                    managers.add(new selectOption(String.valueOf(a.get('Id')),String.valueOf(a.get('Name'))));
                }  
            }
            return managers;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return managers;
        }
    }

    /**
     * Populates a select list with the teams of employees reporting directly to the selected manager.
     * @return The teams
     */
    public List<SelectOption> getTeams(){
        List<SelectOption> teams = new List<SelectOption>();
        List<AggregateResult> teamLst = [SELECT CT_BU3__c bu
                                         FROM Contact 
                                         WHERE CT_BU3__c!=null 
                                         AND ReportsToId = :selectedManager
                                         GROUP BY CT_BU3__c];
        teams.add(new SelectOption('', System.Label.List_all));
        for(AggregateResult a: teamLst) {  
            teams.add(new SelectOption(String.valueOf(a.get('bu')),String.valueOf(a.get('bu'))));  
        }
        return teams;
    }

    /**
     * Returns events corresponding to a given periods
     *
     * @param jsonStart JSON string sent by fullcalendarjs of the starting date
     * @param jsonEnd JSON string sent by fullcalendarjs of the ending date
     * @param managerId Id of the Events' owner manager
     * @param team Team to which the retrieved employees must be from
     *
     * @return Map of the events and their corresponding name
     */
    @RemoteAction
    public static Map<String, List<sObject>> getCalendarEvents(String jsonStart, String jsonEnd, String managerId, 
                                                               String team) {
        Map<String, List<sObject>> returnList = new Map<String, List<sObject>>();
        if(!String.isBlank(managerId)) {
            timesheet__c timeOptions = timesheet__c.getInstance(UserInfo.getUserId());
            String startString= jsonStart.substring(jsonStart.indexOf('_d')+3, jsonStart.indexOf('_d')+22);
            String endString= jsonEnd.substring(jsonEnd.indexOf('_d')+3, jsonEnd.indexOf('_d')+22);
            Date startDate = Date.valueOf(startString.replace('T', ' '));
            Date endDate = Date.valueOf(endString.replace('T', ' '));
            
            //Retrieving the time
            //Counting the day worked
            //Counting the day constrained
            String timeSOQL = 'SELECT Date__c, Heure_de_debut__c, Heure_de_fin__c, toLabel(Type__c), Valeur_type__c, '
                                + 'Type_text__c, Feuille_hebdo__r.Salarie__c, Feuille_hebdo__r.Commentaire__c, '
                                + 'Feuille_hebdo__r.Valeur_statut__c, toLabel(Feuille_hebdo__r.Statut__c) '
                             + 'FROM Temps__c '
                             + 'WHERE Date__c >= :startDate AND Date__c <= :endDate '
                             + 'AND Feuille_hebdo__r.Salarie__r.ReportsToId = :managerId ';
            String dayCountSOQL = 'SELECT COUNT(Id), Date__c dt '
                             + 'FROM Temps__c '
                             + 'WHERE Date__c >= :startDate AND Date__c <= :endDate AND Valeur_type__c < 30 '
                             + 'AND Feuille_hebdo__r.Salarie__r.ReportsToId = :managerId ';
            String constraintCountSOQL = 'SELECT COUNT(Id), Date__c dt '
                             + 'FROM Temps__c '
                             + 'WHERE Date__c >= :startDate '
                             + 'AND Date__c <= :endDate AND Valeur_type__c >= 70 '
                             + 'AND Feuille_hebdo__r.Salarie__r.ReportsToId = :managerId ';
            if(!String.isBlank(team)) {
                timeSOQL += 'AND Feuille_hebdo__r.Salarie__r.CT_BU3__c = :team ';
                dayCountSOQL += 'AND Feuille_hebdo__r.Salarie__r.CT_BU3__c = :team ';
                constraintCountSOQL += 'AND Feuille_hebdo__r.Salarie__r.CT_BU3__c = :team ';
            }
            timeSOQL += 'ORDER BY Date__c ASC ';
            dayCountSOQL += 'GROUP BY Date__c,Feuille_hebdo__r.Salarie__c ORDER BY Date__c ASC ';
            constraintCountSOQL += 'GROUP BY Date__c, Feuille_hebdo__r.Salarie__c ORDER BY Date__c ASC ';
            List<Temps__c> times = Database.query(timeSOQL);
            List<AggregateResult> dayCount = Database.query(dayCountSOQL);
            returnList.put('times', times);
            returnList.put('dayCount', dayCount);

            if(timeOptions.useConstraint__c) {
                List<AggregateResult> constraintCount = Database.query(constraintCountSOQL);
                returnList.put('constraintCount', constraintCount);
            }

            //Retrieving leaves
            // Either the start date must be inside, or the end date must be inside, or the start date
            // must be earlier than the displayed period and the end date must be later than the displayed period.
            String leaveSOQL = 'SELECT Id, Name, Date_de_debut__c, Date_de_fin__c, Type__c, Periode__c, '
                                + 'Afficher_dans_le_planning__c, Valeur_statut__c, toLabel(Statut__c), '
                                + 'Salarie__r.ReportsToId, Periode_de_fin__c '
                             + 'FROM Demande_de_conges__c '
                             + 'WHERE Date_de_debut__c <=: endDate '
                             + 'AND Date_de_fin__c >=: startDate '
                             + 'AND (Valeur_statut__c < 50 OR Valeur_statut__c >= 70) ';
            if(managerId != null && managerId != '') {
                leaveSOQL += 'AND Salarie__r.ReportsToId = :managerId ';
            }
            if(team != null && team != '') {
                leaveSOQL += 'AND Salarie__r.CT_BU3__c = :team ';
            }
            List<Demande_de_conges__c> leaves = Database.query(leaveSOQL);
            returnList.put('leaves', leaves);

            //Retrieving constraints
            if(timeOptions.useConstraint__c) {
                // Either the start date must be inside, or the end date must be inside, or the start date
                // must be earlier than the displayed period and the end date must be later than the displayed period.
                String constraintSOQL = 'SELECT Id, Name, Date_de_debut__c, Date_de_fin__c, Motif__c, Salarie__c '
                                      + 'FROM Astreinte__c '
                                      + 'WHERE Date_de_debut__c <=: endDate AND Date_de_fin__c >=: startDate ';
                if(managerId != null && managerId != '') {
                    constraintSOQL += 'AND Salarie__r.ReportsToId = :managerId ';
                }
                if(team != null && team != '') {
                    constraintSOQL += 'AND Salarie__r.CT_BU3__c = :team ';
                }
                List<Astreinte__c> constraints = Database.query(constraintSOQL);
                returnList.put('constraints', constraints);
            }
        }
        return returnList;
    }

    /**
     * Returns contacts reporting to the specified manager
     *
     * @param managerId Id of the Events' owner manager
     * @param team Team to which the retrieved employees must be from
     * 
     * @return List of contacts
     */
    @RemoteAction
    public static List<Contact> getCalendarResources(String managerId, String team) {
        List<Contact> employeeList = new List<Contact>();
        if(managerId != null && managerId != '') {
            Organigramme__c options = Organigramme__c.getInstance();
            String contactSOQL = 'SELECT Id, Name, '
                            + 'CT_BU3__c, Repos_compensateurs_solde__c, Conges_solde_n__c, Conges_solde_n_1__c '
                            + 'FROM Contact '
                            + 'WHERE ReportsToId != null AND ReportsToId = :managerId ';
            if(team != null && team != '') {
                contactSOQL += 'AND CT_BU3__c = :team ';
            }
            if(!options.Display_ex_employees__c) {
                contactSOQL += 'AND (CT_Exit_date__c = null OR CT_Exit_date__c >= TODAY) ';
            }
            contactSOQL += 'ORDER BY Name ';
            employeeList = Database.query(contactSOQL);
        }
        return employeeList;
    }
}