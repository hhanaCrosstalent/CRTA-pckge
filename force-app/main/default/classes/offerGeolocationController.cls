//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the page displaying the geolocation map
 * @author Crosstalent
 * @group Recrutement
 */
public with sharing class offerGeolocationController {
    public String location { get; set; } //Human-readable starting position of the map
    public Integer distance { get; set; } //Maximum distance between starting point and candidates and offers
    public String position { get; set; } //Coordinates of the starting point
    public String searchText { get; set; } //Text to search
    public String selectedType { get; set; } //Selected contact's record type
    public String selectedIndustry { get; set; } //Selected offer's industry
    public Contact mockContact { get; set; } //Empty contact used for the picklist
    public Offre_d_emploi__c mockOffer { get; set; } //Empty offer used for the picklist
    public List<Contact> matchedContacts { get; set; } //Retrieved contacts
    public List<Offre_d_emploi__c> matchedOffers { get; set; } //Retrieved offers
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if(sortField == null) {sortField = 'lastname'; } return sortField;  }
        set;
    }

    public offerGeolocationController() {
        location = 'Paris, FR';
        distance = 50;
        searchText = '';
        position = '(48.856578, 2.351828)';
        selectedType = '';
        selectedIndustry = '';
        mockContact = new Contact();
        mockOffer = new Offre_d_emploi__c();
        matchedContacts = new List<Contact>();
        matchedOffers = new List<Offre_d_emploi__c>();
        String soql = 'SELECT ID, Name, LastName, FirstName, CT_Management_level__c, CT_Support__c, CT_Situation__c, '
                + 'MailingState, Location__Latitude__s, Location__Longitude__s '
                + 'FROM Contact '
                + 'WHERE DISTANCE(Location__c, GEOLOCATION' + String.escapeSingleQuotes(position) + ', \'km\') < ' 
                + String.escapeSingleQuotes(''+distance) + ' '
                + 'LIMIT 100';
        matchedContacts = Database.query(soql);
        soql = 'SELECT ID, Name, CT_City__c, CT_Scope__c, Location__Latitude__s, Location__Longitude__s '
            + 'FROM Offre_d_emploi__c '
            + 'WHERE DISTANCE(Location__c, GEOLOCATION' + String.escapeSingleQuotes(position) + ', \'km\') < ' 
            + String.escapeSingleQuotes(''+distance) + ' '
            + 'LIMIT 100';
        matchedOffers = Database.query(soql);
    }

    /**
     * Populates a select list with the contacts record types.
     * @return The record types
     */
    public List<SelectOption> getContactTypes() {
        List<SelectOption> options = new List<SelectOption>();
        List<RecordType> contact_typeLst = [SELECT RecordType.Name FROM RecordType WHERE sobjecttype='contact'];
        options.add(new SelectOption(' ', '--Aucun--'));
        for(RecordType ct: contact_typeLst){
            options.add(new SelectOption(String.valueof(ct.get('name')), String.valueof(ct.get('name'))));
        }

        return options;
    }

    /**
     * Populates a select list with the offers industries.
     * @return The industries
     */
    public List<SelectOption> getOfferIndustries() {
        List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> values 
            = Schema.sObjectType.Offre_d_emploi__c.fields.crta__CT_Industry_of_activities__c.getPicklistValues();
        options.add(new SelectOption(' ', '--Aucun--'));
        for (Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    /**
     * Retrieves the contacts and offers. If a search text is entered we use it otherwise we use the picklists values
     * @return PageReference
     */
    public PageReference search() {
        if(searchText != '' && searchText != null) {
            searchText += '*';
            String sosl = 'FIND {'+String.escapeSingleQuotes(searchText)+'} IN ALL FIELDS RETURNING '
                    + 'Contact (Id, Name, LastName, FirstName, '
                    + SObjectType.Contact.fields.CT_Management_level__c.getName() + ', '
                    + SObjectType.Contact.fields.CT_Support__c.getName() + ', '
                    + SObjectType.Contact.fields.CT_Situation__c.getName() + ', '
                    + SObjectType.Contact.fields.Location__Latitude__s.getName() + ', '
                    + SObjectType.Contact.fields.Location__Longitude__s.getName() + ' '
                    + 'WHERE DISTANCE('
                    + SObjectType.Contact.fields.Location__c.getName() + ', '
                    + 'GEOLOCATION'+position+', \'km\') < '+ distance +')';
            List<List<SObject>>searchContacts  =  Search.query(sosl);
            sosl = 'FIND {'+String.escapeSingleQuotes(searchText)+'} IN ALL FIELDS RETURNING '
                    + 'Offre_d_emploi__c (Id, Name, '
                    + SObjectType.Offre_d_emploi__c.fields.CT_City__c.getName() + ','
                    + SObjectType.Offre_d_emploi__c.fields.CT_Scope__c.getName() + ','
                    + SObjectType.Offre_d_emploi__c.fields.Location__Latitude__s.getName() + ','
                    + SObjectType.Offre_d_emploi__c.fields.Location__Longitude__s.getName() + ' '
                    + 'WHERE DISTANCE('
                    + SObjectType.Offre_d_emploi__c.fields.Location__c.getName() + ', '
                    + 'GEOLOCATION'+position+', \'km\') < '+ distance +')';
            List<List<SObject>>searchOffers  =  Search.query(sosl);
            matchedContacts = ((List<Contact>)searchContacts[0]);
            matchedOffers = ((List<Offre_d_emploi__c>)searchOffers[0]);
        } else {
            String contactQuery = 'SELECT Id, Name, LastName, FirstName, CT_Management_level__c, CT_Support__c, '
                    + 'CT_Situation__c, MailingState, Location__Latitude__s, Location__Longitude__s '
                    + 'FROM Contact '
                    + 'WHERE DISTANCE(Location__c, GEOLOCATION'+String.escapeSingleQuotes(position)+', \'km\') < '
                    + distance;
            if(selectedType != null && selectedType != '') {
                contactQuery += ' AND RecordTypeId IN '
                    + '(SELECT Id FROM RecordType WHERE sobjecttype = \'contact\' AND Name = \''
                    +String.escapeSingleQuotes(selectedType)+'\')';
            }
            if(mockContact.CT_Management_level__c != null && mockContact.CT_Management_level__c != '') {
                contactQuery += ' OR CT_Management_level__c = \''+mockContact.CT_Management_level__c+'\'';
            }
            if(mockContact.CT_Support__c != null && mockContact.CT_Support__c != '') {
                contactQuery += ' OR CT_Support__c = \''+mockContact.CT_Support__c+'\'';
            }
            if(mockContact.CT_Situation__c != null && mockContact.CT_Situation__c != '') {
                contactQuery += ' OR CT_Situation__c = \''+mockContact.CT_Situation__c+'\'';
            }
            contactQuery += ' Limit 100';
            matchedContacts = Database.query(contactQuery);

            String offerQuery = 'SELECT Id, Name, CT_City__c, CT_Scope__c, '
                    + 'Location__Latitude__s, Location__Longitude__s '
                    + 'FROM Offre_d_emploi__c '
                    + 'WHERE DISTANCE(Location__c, GEOLOCATION'+String.escapeSingleQuotes(position)+', \'km\') < '
                    + distance;
            if(selectedIndustry != null && selectedIndustry != '') {
                offerQuery += ' AND CT_Industry_of_activities__c includes (\''
                            + String.escapeSingleQuotes(selectedIndustry) + '\')';
            }
            if(mockOffer.Filiere__c != null && mockOffer.Filiere__c != '') {
                offerQuery += ' OR Filiere__c = \''+mockOffer.Filiere__c+'\'';
            }
            if(mockOffer.Categorie__c != null && mockOffer.Categorie__c != '') {
                offerQuery += ' OR Categorie__c = \''+mockOffer.Categorie__c+'\'';
            }
            offerQuery += ' AND CT_Scope__c = '+mockOffer.CT_Scope__c;
            offerQuery += ' LIMIT 100';
            matchedOffers = Database.query(offerQuery);
        }
        return null;
    }

    /**
     * Toggles the sorting of query between asc and desc
     * @return void
     */
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        search();
    }
}