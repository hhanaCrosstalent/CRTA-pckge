//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Note_de_frais__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class ExpensesRepository {
      /**
       * Retrieves all the Note_de_frais__c
       *
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Note_de_frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                        + 'FROM Note_de_frais__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Note_de_frais__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Note_de_frais__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
            return Database.query(sObjectSOQL);
      }

       /**
       * Retrieves all the Note_de_frais__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Note_de_frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                        + 'FROM Note_de_frais__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Note_de_frais__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Note_de_frais__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Note_de_frais__c for a given contact
       * @param contactId Id of the Note_de_frais__c owner
       *
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Note_de_frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                        + 'FROM Note_de_frais__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Note_de_frais__c for a given contact and fields
       * @param contactId Id of the Note_de_frais__c owner
       * @param fields   List of fields' API name
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Note_de_frais__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Note_de_frais__c for a given contact, limit and offset
       * @param contactId Id of the Note_de_frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Note_de_frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                        + 'FROM Note_de_frais__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Note_de_frais__c for a given contact, limit, offset and fields
       * @param contactId Id of the Note_de_frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Note_de_frais__c>
       */
      webService static List<Note_de_frais__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Note_de_frais__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Note_de_frais__c from its Id
       * @param expensesId Id of the Note_de_frais__c
       *
       * @return Note_de_frais__c
       */
      webService static Note_de_frais__c getById(String expensesId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Note_de_frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                        + 'FROM Note_de_frais__c '
                        + 'WHERE Id = :expensesId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT 1';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a Note_de_frais__c from its Id
       * @param expensesId Id of the Note_de_frais__c
       * @param fields   List of fields' API name
       * @return Note_de_frais__c
       */
      webService static Note_de_frais__c getByIdForFields(String expensesId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Note_de_frais__c '
                        + 'WHERE Id = :expensesId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}