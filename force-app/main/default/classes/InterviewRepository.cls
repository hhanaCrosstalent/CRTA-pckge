//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the EI_Entretien__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class InterviewRepository {
    
    /**
       * Retrieves all the EI_Entretien__c
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for the given fields
       * @param fields   List of fields' API name
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpened() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for the given fields
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given contact
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given contact and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given contact
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given contact and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByManager(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByManagerForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByManagerBetweenDate(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager and fields between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByManagerBetweenDateForFields(String contactId, Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);  
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByManager(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByManagerForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByManagerBetweenDate(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager and fields between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByManagerBetweenDateForFields(String contactId, Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByEmployee(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByEmployeeForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByEmployeeBetweenDate(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee and fields between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllByEmployeeBetweenDateForFields(String contactId, Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee
       * @param contactId Id of the EI_Entretien__c owner
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByEmployee(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByEmployeeForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByEmployeeBetweenDate(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee and fields between given dates
       * @param contactId Id of the EI_Entretien__c owner
       * @param startDate Earliest date possible for the interview
       * @param endDate Oldest date possible for the interview
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedByEmployeeBetweenDateForFields(String contactId, Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + ' WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'AND EI_Date_de_l_entretien__c >= :startDate '
                        + 'AND EI_Date_de_l_entretien__c <= :endDate '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given contact, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given contact, limit, offset and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given contact, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given contact, limit, offset and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE (EI_Salarie_qui_passe_l_entretien__c = :contactId OR EI_Salarie_qui_fait_passer_l_entretien__c = :contactId) '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByManager(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given manager, limit, offset and fields
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByManagerForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByManager(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given manager, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByManagerForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_fait_passer_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByEmployee(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the EI_Entretien__c for a given employee, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllWithOffsetByEmployeeForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByEmployee(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the opened EI_Entretien__c for a given employee, limit and offset
       * @param contactId Id of the EI_Entretien__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<EI_Entretien__c>
       */
      webService static List<EI_Entretien__c> getAllOpenedWithOffsetByEmployeeForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE EI_Salarie_qui_passe_l_entretien__c = :contactId '
                        + 'AND Date_d_ouverture__c <= TODAY '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a EI_Entretien__c from its Id
       * @param interviewId Id of the EI_Entretien__c
       *
       * @return EI_Entretien__c
       */
      webService static EI_Entretien__c getById(String interviewId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(EI_Entretien__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', RecordType.DeveloperName, EI_Modele_d_entretien__r.Name, EI_Salarie_qui_passe_l_entretien__r.Name '
            + 'FROM EI_Entretien__c '
            + 'WHERE Id = :interviewId '
            + 'ORDER BY EI_Date_de_l_entretien__c DESC '
            + 'LIMIT 1 ';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a EI_Entretien__c from its Id
       * @param interviewId Id of the EI_Entretien__c
       * @param fields   List of fields' API name
       * @return EI_Entretien__c
       */
      webService static EI_Entretien__c getByIdForFields(String interviewId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM EI_Entretien__c '
                        + 'WHERE Id = :interviewId '
                        + 'ORDER BY EI_Date_de_l_entretien__c DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}