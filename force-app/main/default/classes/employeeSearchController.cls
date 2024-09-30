//Security isCreateable() isUpdateable() isDeletable() checked
// @author Felix van Hove
public with sharing class employeeSearchController {
    
    public String searchText { get; set; } //Text to search
    public Contact mockContact { get; set; } //Empty contact used for the picklist
    public List<Contact> matchedContacts { get; set; } //Retrieved contacts
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir; }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'lastname'; } return sortField; }
        set;
    }
    
    public employeeSearchController() {
        searchText = '';
        mockContact = new Contact();
        matchedContacts = new List<Contact>();
        //search();
    }
    
    /**
* Retrieves the contacts. If a search text is entered we use it otherwise we use the picklists values
* @return PageReference
*/
    public PageReference search() {
        if(searchText != '' && searchText != null) {
            searchText += '*';
            String sosl = 'FIND {'+String.escapeSingleQuotes(searchText)+'} IN ALL FIELDS RETURNING '
                + 'Contact (Id, Name, Lastname, Firstname, Title, '
                + SObjectType.Contact.fields.CT_Date_of_entry_to_the_society__c.getName() + ', '
                + SObjectType.Contact.fields.Contrat_pret__c.getName() + ', '
                + SObjectType.Contact.fields.CT_Exit_date__c.getName() + ', '
                + SObjectType.Contact.fields.Temps_de_travail_en_pourcentage__c.getName() + ', '
                + SObjectType.Contact.fields.Niveau_de_Diplome__c.getName() + ', '
                + SObjectType.Contact.fields.RC_Annees_d_experience__c.getName() + ', '
                + 'Createddate, '
                + SObjectType.Contact.fields.CT_Type_poste_recherche__c.getName() + ', '
                + SObjectType.Contact.fields.CT_Brut_fixe_recherche__c.getName() + ' '
                + 'WHERE recordtype.name=\'Salarié\')';
            List<List<SObject>>searchContacts  =  Search.query(sosl);
            matchedContacts = ((List<Contact>)searchContacts[0]);
        } else {
            mockContact.FirstName = (mockContact.FirstName == null) ? '' : mockContact.FirstName;
            mockContact.MailingState = (mockContact.MailingState == null) ? '' : mockContact.MailingState;
            matchedContacts = Database.query('SELECT Id, Name, Lastname, Firstname, Title, '
                                             + 'CT_Date_of_entry_to_the_society__c, CT_Exit_date__c, Contrat_pret__c, Temps_de_travail_en_pourcentage__c, '
                                             + 'Niveau_de_Diplome__c,  RC_Annees_d_experience__c,createddate,CT_Type_poste_recherche__c, '
                                             + 'CT_Brut_fixe_recherche__c '
                                             + 'FROM Contact '
                                             + 'WHERE Recordtype.Name=\'Salarié\' '
                                             + 'AND (FirstName LIKE \''+String.escapeSingleQuotes(mockContact.FirstName)+'%\' '
                                             + 'OR LastName LIKE \''+String.escapeSingleQuotes(mockContact.FirstName)+'%\') '
                                             + 'AND MailingState LIKE \''+String.escapeSingleQuotes(mockContact.MailingState)+'%\' '
                                             + 'LIMIT 100');
        }
        
        return null;
    }
    
    /**
* Toggles the sorting of query between asc and desc
*/
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        search();
    }
}