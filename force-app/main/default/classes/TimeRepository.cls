//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Temps__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TimeRepository {
    
      /**
       * Retrieves all the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c before the given date (included)
       * @param eventDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBeforeDate(Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c <= :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields and before the given date (included)
       * @param eventDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBeforeDateForFields(Date eventDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c <= :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c after the given date (included)
       * @param eventDate Earliest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllAfterDate(Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c >= :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields and after the given date (included)
       * @param eventDate Earliest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllAfterDateForFields(Date eventDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c >= :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c between the given date (included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
    webService static List<Temps__c> getAllBetweenDate(Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Temps__c '
             + 'WHERE Date__c >=: startDate '
             + 'AND Date__c <=: endDate '
             + 'ORDER BY Date__c DESC';
        return Database.query(sObjectSOQL);
    }

      /**
       * Retrieves all the Temps__c for the given fields and between the given date (included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBetweenDateForFields(Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Date__c >=: startDate '
                        + 'AND Date__c <=: endDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c before the given date (not included)
       * @param eventDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBeforeDateStrict(Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c < :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields and before the given date (not included)
       * @param eventDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBeforeDateStrictForFields(Date eventDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c < :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c after the given date (not included)
       * @param eventDate Earliest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllAfterDateStrict(Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c > :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields and after the given date (not included)
       * @param eventDate Earliest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllAfterDateStrictForFields(Date eventDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c > :eventDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c between the given date (not included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBetweenDateStrict(Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c >: startDate AND Date__c <: endDate ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for the given fields and between the given date (not included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllBetweenDateStrictForFields(Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Date__c >: startDate AND Date__c <: endDate ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, 
                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact
       * @param contactId Id of the Temps__c owner
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Feuille_hebdo__r.Salarie__c = :contactId ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and fields
       * @param contactId Id of the Temps__c owner
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Feuille_hebdo__r.Salarie__c = :contactId ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and before the given date (included)
       * @param eventDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBeforeDate(String contactId, Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c =: contactId '
                        + 'AND Date__c <=: eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact, fields and before the given date (included)
       * @param eventDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBeforeDateForFields(String contactId, Date eventDate, 
                                                                                List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c <= :eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact after the given date (included)
       * @param eventDate Earliest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAfterDate(String contactId, Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >= :eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and fields after the given date (included)
       * @param eventDate Earliest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAfterDateForFields(String contactId, Date eventDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >= :eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact between the given date (included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBetweenDate(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >=: startDate AND Date__c <=: endDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for given contact and fields between the given date (included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
    webService static List<Temps__c> getAllByContactBetweenDateForFields(String contactId, Date startDate, 
                                                                    Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >= :startDate '
                        + 'AND Date__c <= :endDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Counts all the Temps__c for a given contact between the given date (included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<AggregateResult>
       */
    webService static List<AggregateResult> countAllByContactBetweenDate(String contactId, Date startDate, 
                                                                                            Date endDate) {
        List<AggregateResult> l = [SELECT COUNT(Id) 
                                   FROM Temps__c 
                                   WHERE Feuille_hebdo__r.Salarie__c =: contactId 
                                   AND Date__c >=: startDate 
                                   AND Date__c <=: endDate
                                   GROUP BY Date__c 
                                   ORDER BY Date__c DESC];
        return l;
    }

      /**
       * Retrieves all the Temps__c for a given contact before the given date (not included)
       * @param eventDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBeforeDateStrict(String contactId, Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c < :eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and fields before the given date (not included)
       * @param eventDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
    webService static List<Temps__c> getAllByContactBeforeDateStrictForFields(String contactId, Date eventDate, 
                                                                                List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c =: contactId '
                        + 'AND Date__c <: eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact after the given date (not included)
       * @param eventDate Earliest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAfterDateStrict(String contactId, Date eventDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >: eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and fields after the given date (not included)
       * @param eventDate Earliest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAfterDateStrictForFields(String contactId, Date eventDate, 
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c > :eventDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact between the given date (not included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBetweenDateStrict(String contactId, Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c >: startDate '
                        + 'AND Date__c <: endDate '
                        + 'ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and fields between the given date (not included)
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactBetweenDateStrictForFields(String contactId, Date startDate, 
                                                                                 Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND Date__c > :startDate AND Date__c < :endDate '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact and timesheet or date
       * @param contactId Id of the Temps__c owner
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAndWeekOrDate(String contactId, String timesheetId, 
                                                                    Date startDate, Date endDate) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND (Feuille_hebdo__c = :timesheetId OR (Date__c >= :startDate AND Date__c <= :endDate)) '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact, timesheet or date and fields
       * @param contactId Id of the Temps__c owner
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByContactAndWeekOrDateForFields(String contactId, String timesheetId, 
                                                                Date startDate, Date endDate, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'AND (Feuille_hebdo__c = :timesheetId OR (Date__c >= :startDate AND Date__c <= :endDate)) '
                        + 'ORDER BY Date__c DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Counts all the Temps__c for a given contact and timesheet or date
       * @param contactId Id of the Temps__c owner
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param startDate Earliest date possible for the Temps__c
       * @param endDate Oldest date possible for the Temps__c
       *
       * @return List<AggregateResult>
       */
      webService static List<AggregateResult> countByContactAndWeekOrDate(String contactId, String timesheetId, 
                                                                                Date startDate, Date endDate) {
            List<AggregateResult> l = [SELECT COUNT(Id) 
                                       FROM Temps__c 
                                       WHERE Feuille_hebdo__r.Salarie__c = :contactId 
                                       AND (Feuille_hebdo__c = :timesheetId 
                                            OR (Date__c >= :startDate AND Date__c <= :endDate)) 
                                       GROUP BY Date__c 
                                       ORDER BY Date__c DESC]; 
            return l;
      }


      /**
       * Retrieves all the Temps__c for a given contact, limit and offset
       * @param contactId Id of the Temps__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, 
                                                                            Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact, limit, offset and fields
       * @param contactId Id of the Temps__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, 
                                                                        Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given timesheet
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByWeek(String timesheetId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Feuille_hebdo__c = :timesheetId ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given timesheet and fields
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllByWeekForFields(String timesheetId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Feuille_hebdo__c = :timesheetId ORDER BY Date__c DESC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact, limit and offset
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffsetByWeek(String timesheetId, Integer offsetNumber, 
                                                                                Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__c = :timesheetId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Temps__c for a given contact, limit, offset and fields
       * @param timesheetId Id of the parent Feuille_Temps_Hebdo__c
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Temps__c>
       */
      webService static List<Temps__c> getAllWithOffsetByWeekForFields(String timesheetId, Integer offsetNumber, 
                                                                    Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c '
                        + 'WHERE Feuille_hebdo__c = :timesheetId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Temps__c from its Id
       * @param timeId Id of the Temps__c
       *
       * @return Temps__c
       */
      webService static Temps__c getById(String timeId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Temps__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Id = :timeId ORDER BY Date__c DESC LIMIT 1';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Temps__c for a given Id and fields
       * @param timeId Id of the Temps__c
       * @param fields   List of fields' API name
       * @return Temps__c
       */
      webService static Temps__c getByIdForFields(String timeId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Temps__c WHERE Id = :timeId ORDER BY Date__c DESC LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}