//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for search of job page
 */
public with sharing class OESearchController {
 
    public Integer counter = 0; //keeps track of the offset
    public Integer list_size = 20; //sets the page size or number of rows
    public Integer total_size; //used to show user the total size of the list
    public String soql {get;set;} // the soql without the order and limit
    public String selectedSecteur {get;set;}
    public List<Offre_d_emploi__c> offre_emplois {get;set;} // the collection of contacts to display
 
    // the current sort direction. defaults to asc
    public String sortDir {
        get {if(sortDir == null) {sortDir = 'desc';} return sortDir;}
        set;
    }
 
    // the current field to sort by. defaults to last name
    public String sortField {
        get {if(sortField == null) {sortField = 'CT_Date__c';} return sortField;}
        set;
    }
  
    // format the soql for display on the visualforce page
    public String debugSoql {
        get {return soql + ' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 20';}
        set;
    }
  
    /**
    * Intialize the controller and display some sample data when the page loads
    */
    public OESearchController() {
        soql = 'SELECT Name, CT_Date__c, CT_Description__c, CT_Support__c, CT_Duration__c, CT_Code__c, '
            + 'CT_Department__c, CT_City__c '
            + 'FROM Offre_d_emploi__c';
        runQuery();
    }
  
    /**
    * Changes the sort order and re-run the query
    *
    * @return null
    */
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    }
  
    /**
    * Completes and runs the query
    * Runs an SOSL query to get the total number of results
    *
    * @return null
    */
    public void runQuery() {
  
        try {
            offre_emplois = Database.query(soql + ' ORDER BY ' + sortField + ' ' + sortDir 
                                            + ' LIMIT :list_size OFFSET :counter');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! '+soql));
        }
        
        String soql1 = 'SELECT COUNT(name) '+soql.right(soql.length()-soql.indexOf(' FROM'));
        List<AggregateResult> results = Database.query(soql1);
        total_size = Integer.valueof(results[0].get('expr0'));
    }
  
    /**
    * Retrieves  the page's parameters and runs the query
    *
    * @return PageReference
    */
    public PageReference runSearch() {
  
        String date1 = Apexpages.currentPage().getParameters().get('date1'); 
        String intitule_mission = Apexpages.currentPage().getParameters().get('intitule_mission');
        String departement = Apexpages.currentPage().getParameters().get('departement');
        String secteur_d_activite = Apexpages.currentPage().getParameters().get('secteur_d_activite');
    
        soql = 'SELECT Name, CT_Date__c, CT_Description__c, CT_Support__c, CT_Duration__c, CT_Code__c, '
                + 'CT_Department__c, CT_City__c '
            + 'FROM Offre_d_emploi__c WHERE Id != null';

        if(!date1.equals('')) {
            String date2 = String.valueOf(date1);
            if(date2.contains('-')) {
                //American format, we reverse it
                date2=date2.right(2)+'/'+date2.mid(5,2)+'/'+date2.left(4);
            }
            Date mdate = Date.parse(date2) ;
            String date3 = String.valueOf(mdate);
            soql += ' and CT_Date__c>= '+String.escapeSingleQuotes(date3)+' ';  
        }

        if(!intitule_mission.equals('')) {
            soql += ' and Name like \'%'+String.escapeSingleQuotes(intitule_mission)+'%\'';  
        }
        if(!departement.equals('')) {
            String dept1 = String.escapeSingleQuotes(departement) ;
            List<String> dept2 = dept1.split(',') ; 
            String dept3 = '\''+String.join( dept2, '\',\'')+'\'' ;
            soql += ' AND CT_Department__c in (' + dept3 + ')'; 
        }
        if(!secteur_d_activite.equals('')){
            soql += ' AND CT_Industry_of_activities__c =\''+String.escapeSingleQuotes(secteur_d_activite)+'\'';
        }
        // run the query again
        runQuery();
        return null;
    }
  
    // use apex describe to build the picklist values
    public List<SelectOption> Secteur_d_activite {
        get {
            List<SelectOption> options = new List<SelectOption>();
            if (Secteur_d_activite == null) {
                /*
                Offre_d_emploi__c request = new Offre_d_emploi__c();
                Schema.sObjectType objType = request.getSObjectType();
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
                List<Schema.PicklistEntry> values 
                  = fieldMap.get('CT_Industry_of_activities__c').getDescribe().getPickListValues();
                */
              
                Schema.DescribeFieldResult aField 
                    = Schema.SObjectType.Offre_d_emploi__c.fields.CT_Industry_of_activities__c;
                List<Schema.PicklistEntry> values = aField.getPicklistValues();
                
                options.add(new SelectOption('', System.Label.List_all));
                for(Schema.PicklistEntry a : values) {
                  options.add(new SelectOption(a.getValue(), a.getLabel())); 
                }
            }
            return options;
        }
        set;
    } 
  
    public String OEcount {
        get {
            Integer i = [SELECT COUNT() FROM Offre_d_emploi__c LIMIT 100];
            return '' + i;
        }
        set;
    }

    /**
      * Returns to the first page
      *
      * @return null
    */
    public void first() {
        counter = 0;
        runQuery();
    }

    
    /**
    * Goes to the last page
    *
    * @return null
    */
    public void last() {
        counter = total_size - Math.mod(total_size, list_size);
        runQuery();
    }

    
    /**
    * Goes to the previous page
    *
    * @return null
    */
    public void previous() {
        counter -= list_size;
        runQuery();
    }

    
    /**
    * Goes to the next page
    *
    * @return null
    */
    public void next() {
        counter += list_size;
        runQuery();
    }

    /**
     * Whether we disable the previous and first button
     *
     * @return Boolean
     */
    public Boolean getDisablePrevious() { 
        if(counter>0) return false; else return true;
    }
  
    /**
     * Whether we disable the next and last button
     *
     * @return Boolean
    */
    public Boolean getDisableNext() {
        if(counter + list_size < total_size) return false; else return true;
    }
  
    /**
     * Returns the number of results
     *
     * @return Integer
     */
    public Integer getTotal_size() {
        return total_size;
    }
  
    /**
     * Returns the page number
     *
     * @return Integer
    */
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
  
    /**
     * Returns the number of pages
     *
     * @return Integer
     */
    public Integer getTotalPages() {
        if(Math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }
}