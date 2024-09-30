//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the candidate search page
 *
 * @author Crosstalent
 * @group Recrutement
 * @version 1.0
 */
public with sharing class candidateSearchController {
  public String searchText { get; set; } //Text to search
  public Contact mockContact { get; set; } //Empty contact used for the picklist
  public List<Contact> matchedContacts { get; set; } //Retrieved contacts
  // the current sort direction. defaults to asc
  public String sortDir {
          get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
          set;
  }
  // the current field to sort by. defaults to last name
  public String sortField {
          get  { if (sortField == null) {sortField = 'lastname'; } return sortField;  }
          set;
  }

  public candidateSearchController() {
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
                + SObjectType.Contact.fields.CT_Exit_date__c.getName() + ', '
                + SObjectType.Contact.fields.Temps_de_travail_en_pourcentage__c.getName() + ', '
                + SObjectType.Contact.fields.Niveau_de_Diplome__c.getName() + ', '
                + SObjectType.Contact.fields.RC_Annees_d_experience__c.getName() + ', '
                + 'Createddate, '
                + SObjectType.Contact.fields.CT_Type_poste_recherche__c.getName() + ', '
                + SObjectType.Contact.fields.CT_Brut_fixe_recherche__c.getName() + ' '
                + 'WHERE recordtype.name=\'Recrutement\')';
                System.debug(sosl);
      List<List<SObject>>searchContacts = Search.query(sosl);
      matchedContacts = ((List<Contact>)searchContacts[0]);
    } else {
      mockContact.RC_Annees_d_experience__c = (mockContact.RC_Annees_d_experience__c == null) ? 0 : mockContact.RC_Annees_d_experience__c;
      mockContact.CT_Brut_fixe_recherche__c = (mockContact.CT_Brut_fixe_recherche__c == null) ? 0 : mockContact.CT_Brut_fixe_recherche__c;
      String diplome = (mockContact.Niveau_de_Diplome__c == null) ? '*' : mockContact.Niveau_de_Diplome__c;
      String langue_mat = (mockContact.CT_Langue_maternelle__c == null) ? '*' : mockContact.CT_Langue_maternelle__c;
      //String langue = (mockContact.CT_Langue_1__c == null) ? '*' : mockContact.CT_Langue_1__c;
      //String niveau_langue = (mockContact.CT_Niveau_Langue_1__c == null) ? '*' : mockContact.CT_Niveau_Langue_1__c;
      String poste = (mockContact.CT_Type_poste_recherche__c == null) ? '*' : mockContact.CT_Type_poste_recherche__c;
      /*matchedContacts = Database.query('SELECT Id, Name, Lastname, Firstname, Title, '
                + 'CT_Date_of_entry_to_the_society__c, CT_Exit_date__c, Temps_de_travail_en_pourcentage__c, '
                + 'Niveau_de_Diplome__c, RC_Annees_d_experience__c,createddate,CT_Type_poste_recherche__c, '
                + 'CT_Brut_fixe_recherche__c '
                + 'FROM Contact '
                + 'WHERE Recordtype.Name=\'Recrutement\' '
                + 'AND Niveau_de_Diplome__c = \''+String.escapeSingleQuotes(diplome)+'\' '
                + 'AND RC_Annees_d_experience__c >= '+Double.valueOf(mockContact.RC_Annees_d_experience__c)+' '
                + 'AND CT_Langue_maternelle__c = \''+String.escapeSingleQuotes(langue_mat)+'\' '
                + 'AND ((CT_Langue_1__c = \''+String.escapeSingleQuotes(langue)+'\' '
                    + 'OR CT_Langue_2__c = \''+String.escapeSingleQuotes(langue)+'\' '
                    + 'OR CT_Langue_3__c = \''+String.escapeSingleQuotes(langue)+'\') '
                + 'AND (CT_Niveau_Langue_1__c = \''+String.escapeSingleQuotes(niveau_langue)+'\' '
                    + 'OR CT_Niveau_Langue_2__c = \''+String.escapeSingleQuotes(niveau_langue)+'\' '
                    + 'OR CT_Niveau_Langue_3__c = \''+String.escapeSingleQuotes(niveau_langue)+'\')) '
                + 'AND CT_Type_poste_recherche__c = \''+String.escapeSingleQuotes(poste)+'\' '
                + 'AND CT_Brut_fixe_recherche__c >= '+mockContact.CT_Brut_fixe_recherche__c + ' '
                + 'LIMIT 100');*/
        matchedContacts = Database.query('SELECT Id, Name, Lastname, Firstname, Title, '
                + 'CT_Date_of_entry_to_the_society__c, CT_Exit_date__c, Temps_de_travail_en_pourcentage__c, '
                + 'Niveau_de_Diplome__c, RC_Annees_d_experience__c,createddate,CT_Type_poste_recherche__c, '
                + 'CT_Brut_fixe_recherche__c '
                + 'FROM Contact '
                + 'WHERE Recordtype.Name=\'Recrutement\' '
                + 'AND Niveau_de_Diplome__c = \''+String.escapeSingleQuotes(diplome)+'\' '
                + 'AND RC_Annees_d_experience__c >= '+Double.valueOf(mockContact.RC_Annees_d_experience__c)+' '
                + 'AND CT_Langue_maternelle__c = \''+String.escapeSingleQuotes(langue_mat)+'\' '
                + 'AND CT_Type_poste_recherche__c = \''+String.escapeSingleQuotes(poste)+'\' '
                + 'AND CT_Brut_fixe_recherche__c >= '+mockContact.CT_Brut_fixe_recherche__c + ' '
                + 'LIMIT 100');
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