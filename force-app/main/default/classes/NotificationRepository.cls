//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the SIRH_Notification__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class NotificationRepository {

      /**
       * Retrieves all the SIRH_Notification__c
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the SIRH_Notification__c for the given fields
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the unread SIRH_Notification__c
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllUnread() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Lu__c = false ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the unread SIRH_Notification__c for the given fields
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllUnreadForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Lu__c = false ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the SIRH_Notification__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the SIRH_Notification__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM SIRH_Notification__c ORDER BY CreatedDate DESC LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllUnreadWithOffset(Integer offsetNumber, Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM SIRH_Notification__c '
                    + 'WHERE Lu__c = false '
                    + 'ORDER BY CreatedDate DESC '
                    + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllUnreadWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'WHERE Lu__c = false '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the SIRH_Notification__c for a given contact
       * @param contactId Id of the SIRH_Notification__c owner
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Salarie__c = :contactId ORDER BY CreatedDate DESC';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the SIRH_Notification__c for a given contact and fields
       * @param contactId Id of the SIRH_Notification__c owner
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Salarie__c = :contactId ORDER BY CreatedDate DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given contact
       * @param contactId Id of the SIRH_Notification__c owner
       *
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllUnreadByContact(String contactId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM SIRH_Notification__c '
                    + 'WHERE Salarie__c = :contactId '
                    + 'AND Lu__c = false '
                    + 'ORDER BY CreatedDate DESC';
        return Database.query(String.escapeSingleQuotes(sObjectSOQL));
    }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given contact and fields
       * @param contactId Id of the SIRH_Notification__c owner
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllUnreadByContactForFields(String contactId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM SIRH_Notification__c '
                    + 'WHERE Salarie__c = :contactId '
                    + 'AND Lu__c = false '
                    + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

      /**
       * Retrieves all the SIRH_Notification__c for a given contact, limit and offset
       * @param contactId Id of the SIRH_Notification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY CreatedDate '
                        + 'DESC LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the SIRH_Notification__c for a given contact, limit, offset and fields
       * @param contactId Id of the SIRH_Notification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllWithOffsetByContactForFields(String contactId, 
                                                Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given contact, limit and offset
       * @param contactId Id of the SIRH_Notification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<SIRH_Notification__c>
       */
      webService static List<SIRH_Notification__c> getAllUnreadWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Lu__c = false '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the unread SIRH_Notification__c for a given contact, limit, offset and fields
       * @param contactId Id of the SIRH_Notification__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<SIRH_Notification__c>
       */
    webService static List<SIRH_Notification__c> getAllUnreadWithOffsetByContactForFields(String contactId, 
                                            Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c '
                        + 'WHERE Salarie__c = :contactId '
                        + 'AND Lu__c = false '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a SIRH_Notification__c for a given Id
       * @param notifId Id of the SIRH_Notification__c
       *
       * @return SIRH_Notification__c
       */
      webService static SIRH_Notification__c getById(String notifId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(SIRH_Notification__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Id = :notifId ORDER BY CreatedDate DESC LIMIT 1';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a SIRH_Notification__c for a given Id and fields
       * @param notifId Id of the SIRH_Notification__c
       * @param fields   List of fields' API name
       * @return SIRH_Notification__c
       */
      webService static SIRH_Notification__c getByIdForFields(String notifId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM SIRH_Notification__c WHERE Id = :notifId ORDER BY CreatedDate DESC LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}