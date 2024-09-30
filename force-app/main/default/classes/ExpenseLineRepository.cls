//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Frais__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class ExpenseLineRepository {
      /**
       * Retrieves all the Frais__c
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c ORDER BY Date__c DESC';
            System.debug(sObjectSOQL);
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c ORDER BY Date__c DESC';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachment() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for the given fields
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate Desc LIMIT 1) '
                        + 'FROM Frais__c ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c ORDER BY Date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given contact
       * @param contactId Id of the Frais__c owner
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Note_de_frais__r.Salarie__c = :contactId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given contact and fields
       * @param contactId Id of the Frais__c owner
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Note_de_frais__r.Salarie__c = :contactId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given contact
       * @param contactId Id of the Frais__c owner
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentByContact(String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given contact
       * @param contactId Id of the Frais__c owner
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentByContactForFields(String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given Expenses
       * @param expensesId Id of the parent Note_de_frais__c
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllByExpenses(String expensesId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Note_de_frais__c =: expensesId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given Expenses and fields
       * @param expensesId Id of the parent Note_de_frais__c
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllByExpensesForFields(String expensesId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Note_de_frais__c = :expensesId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

       /**
       * Retrieves all the Frais__c and their attachment for a given Expenses
       * @param expensesId Id of the parent Note_de_frais__c
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentByExpenses(String expensesId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given Expenses
       * @param expensesId Id of the parent Note_de_frais__c
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentByExpensesForFields(String expensesId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate Desc LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId ORDER BY Date__c DESC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given contact, limit and offset
       * @param contactId Id of the Frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given contact, limit and offset
       * @param contactId Id of the Frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given contact, limit and offset
       * @param contactId Id of the Frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given contact, limit and offset
       * @param contactId Id of the Frais__c owner
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__r.Salarie__c = :contactId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given expenses, limit and offset
       * @param expensesId Id of the parent Note_de_frais__c
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffsetByExpenses(String expensesId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c for a given expenses, limit and offset
       * @param expensesId Id of the parent Note_de_frais__c
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllWithOffsetByExpensesForFields(String expensesId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given expenses, limit and offset
       * @param expensesId Id of the parent Note_de_frais__c
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffsetByExpenses(String expensesId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the Frais__c and their attachment for a given expenses, limit and offset
       * @param expensesId Id of the parent Note_de_frais__c
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Frais__c>
       */
      webService static List<Frais__c> getAllAndAttachmentWithOffsetByExpensesForFields(String expensesId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Note_de_frais__c = :expensesId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a Frais__c from its Id
       * @param contactId Id of the Frais__c owner
       *
       * @return Frais__c
       */
      webService static Frais__c getById(String expenseLineId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Id = :expenseLineId ORDER BY Date__c DESC LIMIT 1';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a Frais__c from its Id
       * @param contactId Id of the Frais__c owner
       * @param fields   List of fields' API name
       * @return Frais__c
       */
      webService static Frais__c getByIdForFields(String expenseLineId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Frais__c WHERE Id = :expenseLineId ORDER BY Date__c DESC LIMIT 1';

            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a Frais__c and its attachment from its Id
       * @param contactId Id of the Frais__c owner
       *
       * @return Frais__c
       */
      webService static Frais__c getByIdAndAttachment(String expenseLineId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Frais__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Id = :expenseLineId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT 1';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a Frais__c and its attachment from its Id
       * @param contactId Id of the Frais__c owner
       * @param fields   List of fields' API name
       * @return Frais__c
       */
      webService static Frais__c getByIdAndAttachmentForFields(String expenseLineId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, ContentType, Name FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) '
                        + 'FROM Frais__c '
                        + 'WHERE Id = :expenseLineId '
                        + 'ORDER BY Date__c DESC '
                        + 'LIMIT 1';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Sums all the Frais__c amount for a given contact
       * @param contactId Id of the Frais__c owner
       *
       * @return Double
       */
      webService static Double countAmountByContact(String contactId) {
            AggregateResult count = [SELECT SUM(Montant__c) 
                                     FROM Frais__c 
                                     WHERE Note_de_frais__r.Salarie__c = :contactId];
            return Double.valueOf(count.get('expr0'));
      }

      /**
       * Sums all the Frais__c amount for a given contact group by Note_de_frais__c
       * @param contactId Id of the Frais__c owner
       *
       * @return List<AggregateResult> 
       */
      webService static List<AggregateResult> countAmountByContactGroupByExpenses(String contactId) {
            List<AggregateResult> count = [SELECT SUM(Montant__c), Note_de_frais__c 
                                           FROM Frais__c 
                                           WHERE Note_de_frais__r.Salarie__c = :contactId 
                                           GROUP BY Note_de_frais__c];
            return count;
      }

      /**
       * Sums all the Frais__c total for a given contact
       * @param contactId Id of the Frais__c owner
       *
       * @return Double
       */
      webService static Double countTotalByContact(String contactId) {
            AggregateResult count = [SELECT SUM(Total__c) 
                                     FROM Frais__c 
                                     WHERE Note_de_frais__r.Salarie__c = :contactId];
            return Double.valueOf(count.get('expr0'));
      }

            /**
       * Sums all the Frais__c amount for a given expenses
       * @param contactId Id of the Frais__c owner
       *
       * @return Double
       */
      webService static Double countAmountByExpenses(String expensesId) {
            AggregateResult count = [SELECT SUM(Montant__c) FROM Frais__c WHERE Note_de_frais__c = :expensesId];

            return Double.valueOf(count.get('expr0'));
      }

      /**
       * Sums all the Frais__c total for a given expenses
       * @param expensesId Id of the Frais__c owner
       *
       * @return Double
       */
      webService static Double countTotalByExpenses(String expensesId) {
            AggregateResult count = [SELECT SUM(Total__c) FROM Frais__c WHERE Note_de_frais__c = :expensesId];

            return Double.valueOf(count.get('expr0'));
      }

      /**
       * Sums all the Frais__c total for a given contact group by Note_de_frais__c
       * @param contactId Id of the Frais__c owner
       *
       * @return List<AggregateResult> 
       */
      webService static List<AggregateResult> countTotalByContactGroupByExpenses(String contactId) {
            List<AggregateResult> count = [SELECT SUM(Total__c), Note_de_frais__c 
                                           FROM Frais__c 
                                           WHERE Note_de_frais__r.Salarie__c = :contactId 
                                           GROUP BY Note_de_frais__c];
            return count;
      }
}