//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Demande_de_modification__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class ModificationRepository {
      /**
       * Retrieves all the Demande_de_modification__c
       *
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_modification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       * 
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_modification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given contact
       * @param contactId Id of the Demande_de_modification__c owner
       *
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_modification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c WHERE Salarie__c = :contactId ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given contact and fields
       * @param contactId Id of the Demande_de_modification__c owner
       * @param fields   List of fields' API name
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c WHERE Salarie__c = :contactId ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given contact, offset and limit
       * @param contactId Id of the Demande_de_modification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * 
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_modification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Demande_de_modification__c for a given contact, offset, limit and fields
       * @param contactId Id of the Demande_de_modification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Demande_de_modification__c>
       */
      webService static List<Demande_de_modification__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Demande_de_modification__c for a given Id
       * @param modifId Id of the Demande_de_modification__c
       *
       * @return Demande_de_modification__c
       */
      webService static Demande_de_modification__c getById(String modifId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Demande_de_modification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c '
                        + 'WHERE Id = :modifId '
                        + 'ORDER BY CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Demande_de_modification__c for a given Id and fields
       * @param modifId Id of the Demande_de_modification__c
       * @param fields   List of fields' API name
       * @return Demande_de_modification__c
       */
      webService static Demande_de_modification__c getByIdForFields(String modifId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Demande_de_modification__c WHERE Id = :modifId ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }
}