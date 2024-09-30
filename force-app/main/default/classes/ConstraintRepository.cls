//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Astreinte__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class ConstraintRepository {
    
    /**
     * Retrieves all Astreinte__c
     *
     * @return List<Astreinte__c>
     */
    webService static List<Astreinte__c> getAll() {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Astreinte__c ORDER BY Date_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
      * Retrieves all Astreinte__c with the given fields
      * @param fields   List of fields' API name
      *
      * @return List<Astreinte__c>
      */
    webService static List<Astreinte__c> getAllForFields(List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Astreinte__c ORDER BY Date_de_debut__c DESC';
        return Database.query(sObjectSOQL);  
    }

       /**
       * Retrieves all the Astreinte__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c ORDER BY Date_de_debut__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

       /**
       * Retrieves all the Astreinte__c for a given offset limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c ORDER BY Date_de_debut__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves the Astreinte__c for a given set of dates
       * @param startDate Earliest date possible for the Astreinte__c
       * @param endDate Oldest date possible for the Astreinte__c
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllBetweenDates(Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'ORDER BY Date_de_debut__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves the Astreinte__c for a given set of dates
       * @param startDate Earliest date possible for the Astreinte__c
       * @param endDate Oldest date possible for the Astreinte__c
       * @param fields   List of fields' API name
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllBetweenDatesForFields(Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'ORDER BY Date_de_debut__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Astreinte__c for a given contact
       * @param contactId Id of the Astreinte__c owner
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c WHERE Salarie__c = :contactId ORDER BY Date_de_debut__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Astreinte__c for a given contact
       * @param contactId Id of the Astreinte__c owner
       * @param fields   List of fields' API name
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c WHERE Salarie__c = :contactId ORDER BY Date_de_debut__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Astreinte__c for a given contact, limit and offset
       * @param contactId Id of the Astreinte__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Astreinte__c for a given contact, limit, offset and fields
       * @param contactId Id of the Astreinte__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves the Astreinte__c for a given contact and set of dates
       * @param contactId Id of the Astreinte__c owner
       * @param startDate Earliest date possible for the Astreinte__c
       * @param endDate Oldest date possible for the Astreinte__c
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllByContactBetweenDates(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'ORDER BY Date_de_debut__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves the Astreinte__c for a given contact and set of dates
       * @param contactId Id of the Astreinte__c owner
       * @param startDate Earliest date possible for the Astreinte__c
       * @param endDate Oldest date possible for the Astreinte__c
       * @param fields   List of fields' API name
       *
       * @return List<Astreinte__c>
       */
      webService static List<Astreinte__c> getAllByContactBetweenDatesForFields(String contactId, Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'ORDER BY Date_de_debut__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Astreinte__c from its Id
       * @param constraintId Id of the Astreinte__c
       *
       * @return Astreinte__c
       */
      webService static Astreinte__c getById(String constraintId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Astreinte__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c WHERE Id = :constraintId ORDER BY Date_de_debut__c DESC Limit 1';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Astreinte__c from its Id
       * @param constraintId Id of the Astreinte__c
       * @param fields   List of fields' API name
       *
       * @return Astreinte__c
       */
      webService static Astreinte__c getByIdForFields(String constraintId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Astreinte__c WHERE Id = :constraintId ORDER BY Date_de_debut__c DESC Limit 1';

            return Database.query(sObjectSOQL);
      }
}