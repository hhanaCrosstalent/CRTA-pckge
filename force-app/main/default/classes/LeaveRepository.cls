//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Demande_de_conges__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class LeaveRepository {
      
      /**
       * Retrieves all the Demande_de_conges__c
       *
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_conges__c for the given fields
       * @param  fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the active Demande_de_conges__c
       * @param maxStatus Number of the last active status
       *
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllActive(Integer maxStatus) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Valeur_statut__c < :maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the active Demande_de_conges__c for the given fields
       * @param maxStatus Number of the last active status
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllActiveForFields(Integer maxStatus, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Valeur_statut__c < :maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given contact
       * @param contactId Id of the Demande_de_conges__c owner
       *
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given contact and fields
       * @param contactId Id of the Demande_de_conges__c owner
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the active Demande_de_conges__c for a given contact
       * @param contactId Id of the Demande_de_conges__c owner
       * @param maxStatus Number of the last active status
       *
       * @return List<Demande_de_conges__c>
       */
      webService static List<Demande_de_conges__c> getAllActiveByContact(String contactId, Integer maxStatus) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Valeur_statut__c < :maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the active Demande_de_conges__c for a given contact
       * @param contactId Id of the Demande_de_conges__c owner
       * @param maxStatus Number of the last active status
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
    webService static List<Demande_de_conges__c> getAllActiveByContactForFields(String contactId, Integer maxStatus, 
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Valeur_statut__c < :maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

    /**
     * Retrieves all the Demande_de_conges__c for a given contact and between the given dates
     * @param contactId Id of the Demande_de_conges__c owner
     * @param startDate Earliest date possible for the Demande_de_conges__c
     * @param endDate Oldest date possible for the Demande_de_conges__c
     *
     * @return List<Demande_de_conges__c>
     */
    webService static List<Demande_de_conges__c> getAllByContactBetweenDate(String contactId, 
                                                            Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Demande_de_conges__c '
            + 'WHERE Salarie__c = :contactId '
            + 'AND Date_de_debut__c <=: endDate '
            + 'AND Date_de_fin__c >=: startDate '
            + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
        return Database.query(sObjectSOQL);  
    }

    /**
     * Retrieves all the Demande_de_conges__c for a given contact, fields and between the given dates
     * @param contactId Id of the Demande_de_conges__c owner
     * @param startDate Earliest date possible for the Demande_de_conges__c
     * @param endDate Oldest date possible for the Demande_de_conges__c
     * @param fields   List of fields' API name
     * @return List<Demande_de_conges__c>
     */
    webService static List<Demande_de_conges__c> getAllByContactBetweenDateForFields(String contactId, 
                                                Date startDate, Date endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Demande_de_conges__c '
            + 'WHERE Salarie__c = :contactId '
            + 'AND Date_de_debut__c <=: endDate '
            + 'AND Date_de_fin__c >=: startDate '
            + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';
        return Database.query(sObjectSOQL);  
    }

      /**
       * Retrieves all the active Demande_de_conges__c for a given contact and between the given dates
       * @param contactId Id of the Demande_de_conges__c owner
       * @param startDate Earliest date possible for the Demande_de_conges__c
       * @param endDate Oldest date possible for the Demande_de_conges__c
       * @param maxStatus Number of the last active status
       *
       * @return List<Demande_de_conges__c>
       */
    webService static List<Demande_de_conges__c> getAllActiveByContactBetweenDate(String contactId, 
                                                Date startDate, Date endDate, Integer maxStatus) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'AND Valeur_statut__c <: maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the active Demande_de_conges__c for a given contact, fields and between the given dates
       * @param contactId Id of the Demande_de_conges__c owner
       * @param startDate Earliest date possible for the Demande_de_conges__c
       * @param endDate Oldest date possible for the Demande_de_conges__c
       * @param maxStatus Number of the last active status
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
    webService static List<Demande_de_conges__c> getAllActiveByContactBetweenDateForFields(String contactId, 
                                    Date startDate, Date endDate, Integer maxStatus, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Date_de_debut__c <=: endDate '
                        + 'AND Date_de_fin__c >=: startDate '
                        + 'AND Valeur_statut__c < :maxStatus '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given contact, limit and offset
       * @param contactId Id of the Demande_de_conges__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Demande_de_conges__c>
       */
    webService static List<Demande_de_conges__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, 
                                                                            Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the Demande_de_conges__c for a given contact, limit, offset and fields
       * @param contactId Id of the Demande_de_conges__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande_de_conges__c>
       */
    webService static List<Demande_de_conges__c> getAllWithOffsetByContactForFields(String contactId, 
                                    Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves a Demande_de_conges__c from its Id
       * @param leaveId Id of the Demande_de_conges__c
       *
       * @return Demande_de_conges__c
       */
      webService static Demande_de_conges__c getById(String leaveId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Id = :leaveId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT 1';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves a Demande_de_conges__c from its Id and fields
       * @param leaveId Id of the Demande_de_conges__c
       * @param fields   List of fields' API name
       * @return Demande_de_conges__c
       */
      webService static Demande_de_conges__c getByIdForFields(String leaveId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Id = :leaveId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT 1';

            return Database.query(sObjectSOQL);  
      }

       /**
       * Retrieves a Demande_de_conges__c from its Id without status translations
       * @param leaveId Id of the Demande_de_conges__c
       *
       * @return Demande_de_conges__c
       */
      webService static Demande_de_conges__c getUntranslatedById(String leaveId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFieldsUntranslated(Demande_de_conges__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_conges__c '
                        + 'WHERE Id = :leaveId '
                        + 'ORDER BY Date_de_debut__c DESC, Date_de_fin__c DESC '
                        + 'LIMIT 1';

            return Database.query(sObjectSOQL);
      }

}