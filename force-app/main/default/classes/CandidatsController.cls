//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for candidate listing page
 * @author Crosstalent
 * @group Recrutement
 * @version 1.3
 */
public with sharing class  CandidatsController {
    
    public List<Contact> results {get;set;}
    public String filterIdSituation {get;set;}
    public String filterIdclient {get;set;}
    public String filterIdconsultant {get;set;}
    public String filterContrat {get;set;}
    public String filterLieu {get;set;}
    
    private Integer counter = 0;    //keeps track of the offset
    private Integer list_size = 20; //Number of lines on the screen
    public Integer total_size = 0; //used to show user the total size of the list
    
    private String sql {get;set;}
    public Id CCRecordType ;
    
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if(sortDir == null) {  sortDir = 'asc'; } return sortDir; }
        set;
    }
    
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if(sortField == null) {sortField = 'Lastname'; } return sortField; }
        set;
    }
    
    /**
     * Toggles the sorting of query between asc and desc
     * @return void
     */
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
    
    /**
     * Processes the request whenever there is a change of options
     * @return void
     */
    public void onloadfunction()
    {
        processRequests();
    }
    
    /**
     * Processes the query and adds the relevant filter.
     * Passes onto the runSearch function
     * @return PageReference
     */
    public PageReference processRequests()
    {
        //write the query for getting the data based on filterId
        CCRecordType = [SELECT Id FROM RecordType WHERE Name = 'Outplacement'].Id;
        
        sql = 'SELECT Id, Name, Account.Name, Accountid, CreatedDate, Ownerid, CT_Contract__c, CT_Job_lending_location__c, CT_Situation__c, Texte_situation__c, CT_Support__c '
            + 'FROM Contact '
            + 'WHERE Recordtypeid=:CCRecordType ';
        
        if (filterIdclient == 'All' || filterIdclient == NULL ) {
        } else {
            sql = sql + ' AND Account.Name=\''+ String.escapeSingleQuotes(filterIdclient) +'\'';
        }
        
        if (filterIdconsultant == 'All' || filterIdconsultant == NULL ) {
        } else {
             sql = sql + ' AND Owner.Name=\''+ String.escapeSingleQuotes(filterIdconsultant) +'\'';
        }
        
        
        if (filterIdSituation == 'All' || filterIdSituation == NULL) {
        } else if (filterIdSituation == 'Open') {
            sql = sql + ' AND Valeur_situation__c >= 10 AND Valeur_situation__c < 90'; 
        } else {
            sql = sql + ' AND Valeur_situation__c  >= 90'; 
        }
        
        if (filterContrat == 'All' || filterContrat == NULL ) {
        } else {
            sql = sql + ' AND CT_contract__r.Name=\''+ String.escapeSingleQuotes(filterContrat) +'\'';
        }
        
        if (filterLieu == 'All' || filterLieu == NULL ) {
        } else {
            sql = sql + ' AND CT_Job_lending_location__c =\''+ String.escapeSingleQuotes(filterLieu) +'\'';
        }

        runQuery();
        return null;
    }
    
    /**
     * Runs the search query and the count query
     * @return void
     */
    public void runQuery() {
        
        results = Database.query(sql + ' ORDER BY ' + sortField + ' ' + sortDir + ' limit :list_size offset :counter');
        System.debug('SOQL: '+sql + ' result size: '+results.size() + ' recorddtype: '+CCRecordType);
        string soql1='SELECT count(name) '+sql.right(sql.length()-sql.indexof(' FROM'));
        
        List<AggregateResult> AggResults ; 
        AggResults = Database.query( soql1  );
        total_size = Integer.valueof(String.valueof(AggResults[0].get('expr0')));
        
    }
    
    /**
     * Populates the situation select list
     * @return List<SelectOption>
     */
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', Label.Tous));
        options.add(new SelectOption('Open', Label.En_cours));
        options.add(new SelectOption('Close', Label.Clos));
        
        return options;
    }
    
    /**
     * Populates the client select list
     * @return List<SelectOption>
     */
    public List<SelectOption> getclient() {
        List<SelectOption> clients = new List<SelectOption>();
        List<AggregateResult> clientLst = [SELECT Account.Name FROM Contact
                                           WHERE RecordTypeId =:CCRecordType AND Account.Name !=null
                                           GROUP BY Account.Name
                                           ORDER BY Account.Name];
        clients.add(new SelectOption('All', Label.Tous));
        for(AggregateResult a: clientLst){  
            if(a.get('Name') != null) clients.add(new selectOption(string.valueof(a.get('Name')),string.valueof(a.get('Name'))));  
        }
        return clients;
    }
    
    /**
     * Populates the consultant select list
     * @return List<SelectOption>
     */
    public List<SelectOption> getconsultant() {
        List<SelectOption> consultants = new List<SelectOption>();
        List<AggregateResult> consultantLst = [SELECT Owner.Id, Owner.Name
                                               FROM Contact
                                               WHERE RecordTypeId=:CCRecordType
                                               GROUP BY Owner.Id, Owner.Name
                                               ORDER BY Owner.Name];
        consultants.add(new SelectOption('All', Label.Tous));
        for(AggregateResult a: consultantLst){  
            if(a.get('Name') != null) consultants.add(new selectOption(string.valueof(a.get('Name')),string.valueof(a.get('Name'))));  
        }
        return consultants;
    }
    
    /**
     * Populates the contract select list
     * @return List<SelectOption>
     */
    public List<SelectOption> getcontract() {
        List<SelectOption> contrats = new List<SelectOption>();
        List<AggregateResult> contratLst = [SELECT CT_Contract__r.Name
                                            FROM Contact
                                            WHERE RecordTypeId=:CCRecordType
                                            AND CT_Contract__c != null
                                            GROUP BY CT_Contract__r.Name
                                            ORDER BY CT_Contract__r.Name];
        contrats.add(new SelectOption('All', Label.Tous));
        for(AggregateResult a: contratLst){  
           if(a.get('Name') != null) contrats.add(new selectOption(string.valueof(a.get('Name')),string.valueof(a.get('Name'))));  
        }
        return contrats;
    }
    
    /**
     * Populates the location select list
     * @return List<SelectOption>
     */
    public List<SelectOption> getplace() {
        List<SelectOption> lieus = new List<Selectoption>();
        List<AggregateResult> lieuLst = [SELECT CT_Job_lending_location__c jl
                                         FROM contact
                                         WHERE recordtypeid=:CCRecordType
                                         AND CT_Job_lending_location__c!=NULL
                                         GROUP BY CT_Job_lending_location__c
                                         ORDER BY CT_Job_lending_location__c];
        lieus.add(new SelectOption('All', Label.Tous));
        for(AggregateResult a: lieuLst){  
          if(a.get('jl') != null) lieus.add(new selectOption(string.valueof(a.get('jl')),string.valueof(a.get('jl'))));
        }
        return lieus;
    }
    
    /**
     * Goes back to the first page
     * @return void
     */
    public void first() {
        counter = 0;
        runQuery();
    }
    
    /**
     * Goes to the last page
     * @return void 
     */
    public void last() {
        counter = total_size - math.mod(total_size, list_size);
        runQuery();
    }
    
    /**
     * Goes to the previous page
     * @return void
     */
    public void previous() {
        counter -= list_size;
        runQuery();
    }
    
    /**
     * Goes to the next page 
     * @return void
     */
    public void next() {
        counter += list_size;
        runQuery();
    }
    
    /** 
     * Whether we disable or not the previous page button
     * @return Boolean
     */ 
    public Boolean getDisablePrevious() { 
        if (counter>0) return false; else return true;
    }
    
    /** 
     * Whether we disable or not the next page button
     * @return Boolean
     */ 
    public Boolean getDisableNext() { 
        if (counter + list_size < total_size) return false; else return true;
    }
    
    /**
     * Gets the total number of candidates
     * @return Integer
     */
    public Integer getTotal_size() {
        return total_size;
    }
    
    /**
     * Gets the number of the current page
     * @return Integer
     */
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    
    /**
     * Gets the number of pages
     * @return Integer
     */
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }
}