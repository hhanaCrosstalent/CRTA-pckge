//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Demande__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TicketRepository {
      /**
       * Retrieves all the Demande__c
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * 
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllFiltered(List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c';
            sObjectSOQL += BaseRepository.addFilter(filterFields, filterOperations, filterValues);
            sObjectSOQL += ' ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c filtered by the given lists for the given fields 
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param fields   List of fields' API name
       * 
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllFilteredForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues, 
                                                                                                          List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact
       * @param contactId Id of the Demande__c owner
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param contactId Id of the Demande__c owner
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllFilteredByContact(List<String> filterFields, List<String> filterOperations, List<String> filterValues, String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact and fields
       * @param contactId Id of the Demande__c owner
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact, limit and offset
       * @param contactId Id of the Demande__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact, limit and offset filtered by the given lists
       * @param contactId Id of the Demande__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * 
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllFilteredWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber, 
                                                                                                                  List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact, limit, offset and fields
       * @param contactId Id of the Demande__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given timesheet
       * @param userId Id of the assigned user
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllByUser(String userId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Attribution__c = :userId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given timesheet and fields
       * @param userId Id of the assigned user
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllByUserForFields(String userId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Attribution__c = :userId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact, limit and offset
       * @param userId Id of the assigned user
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffsetByUser(String userId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Attribution__c = :userId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande__c for a given contact, limit, offset and fields
       * @param userId Id of the assigned user
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande__c>
       */
      webService static List<Demande__c> getAllWithOffsetByUserForFields(String userId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Attribution__c = :userId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Demande__c from its Id
       * @param ticketId Id of the Demande__c
       *
       * @return Demande__c
       */
      webService static Demande__c getById(String ticketId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Id = :ticketId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT 1';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves an untranslated Demande__c from its Id
       * @param ticketId Id of the Demande__c
       *
       * @return Demande__c
       */
      webService static Demande__c getUntranslatedById(String ticketId) {
            String sObjectSOQL = 'SELECT Id, Name';
            Set<String> fields = BaseRepository.getObjectFieldsUntranslated(Demande__c.sObjectType);
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Id = :ticketId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Demande__c for a given Id and fields
       * @param ticketId Id of the Demande__c
       * @param fields   List of fields' API name
       * @return Demande__c
       */
      webService static Demande__c getByIdForFields(String ticketId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande__c '
                        + 'WHERE Id = :ticketId '
                        + 'ORDER BY Valeur_priorite__c ASC, CreatedDate DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}