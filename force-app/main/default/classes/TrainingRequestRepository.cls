//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Demande_de_formation__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TrainingRequestRepository {
  /**
   * Retrieves all the Demande_de_formation__c
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAll() {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c ORDER BY CreatedDate DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for the given fields
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllForFields(List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c ORDER BY CreatedDate DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPending() {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c WHERE Valeur_statut__c < 30 ORDER BY CreatedDate DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c for the given fields
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingForFields(List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c WHERE Valeur_statut__c < 30 ORDER BY CreatedDate DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given offset and limit
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c ORDER BY CreatedDate DESC LIMIT :limitNumber OFFSET :offsetNumber';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given offset, limit and fields
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c ORDER BY CreatedDate DESC LIMIT :limitNumber OFFSET :offsetNumber';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c for a given offset and limit
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingWithOffset(Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c for a given offset, limit and fields
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given contact
   * @param contactId Id of the Demande_de_formation__c owner
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllByContact(String contactId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(String.escapeSingleQuotes(sObjectSOQL));
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given contact and fields
   * @param contactId Id of the Demande_de_formation__c owner
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllByContactForFields(String contactId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c for a given contact
   * @param contactId Id of the Demande_de_formation__c owner
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingByContact(String contactId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Demande_de_formation__c for a given contact and fields
   * @param contactId Id of the Demande_de_formation__c owner
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingByContactForFields(String contactId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given contact, limit and offset
   * @param contactId Id of the Demande_de_formation__c owner
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given contact, limit, offset and fields
   * @param contactId Id of the Demande_de_formation__c owner
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all pending the Demande_de_formation__c for a given contact, limit and offset
   * @param contactId Id of the Demande_de_formation__c owner
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all pending the Demande_de_formation__c for a given contact, limit, offset and fields
   * @param contactId Id of the Demande_de_formation__c owner
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllPendingWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Valeur_statut__c < 30 '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module
   * @param moduleId Id of the parent action
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllByModule(String moduleId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module and fields
   * @param moduleId Id of the parent action
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllByModuleForFields(String moduleId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module, limit and offset
   * @param moduleId Id of the parent action
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetByModule(String moduleId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module, limit, offset and fields
   * @param moduleId Id of the parent action
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetByModuleForFields(String moduleId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module
   * @param sessionId Id of the parent session
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllBySession(String sessionId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module and fields
   * @param sessionId Id of the parent session
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllBySessionForFields(String sessionId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY CreatedDate DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module, limit and offset
   * @param sessionId Id of the parent session
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetBySession(String sessionId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Demande_de_formation__c for a given training module, limit, offset and fields
   * @param sessionId Id of the parent session
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Demande_de_formation__c>
   */
  webService static List<Demande_de_formation__c> getAllWithOffsetBySessionForFields(String sessionId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY CreatedDate DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Counts the number of pending training requests for the given contact and training module
   * @param  contactId Id of the contact to check
   * @param  moduleId  Id of the training module to check
   * @return Integer
   */
  webService static Integer countPendingRequestByContactAndModule(String contactId, String moduleId) {
    AggregateResult count = [SELECT COUNT(Id) 
                             FROM Demande_de_formation__c 
                             WHERE Catalogue_de_formation__c = :moduleId 
                             AND Salarie__c = :contactId 
                             AND Valeur_statut__c < 30];
    return Integer.valueOf(count.get('expr0'));
  }

  /**
   * Retrieves a Demande_de_formation__c from its Id
   * @param requestId Id of the Demande_de_formation__c
   *
   * @return Demande_de_formation__c
   */
  webService static Demande_de_formation__c getById(String requestId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Demande_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c WHERE Id = :requestId ORDER BY CreatedDate DESC LIMIT 1';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves a Demande_de_formation__c for a given Id and fields
   * @param requestId Id of the Demande_de_formation__c
   * @param fields   List of fields' API name
   * @return Demande_de_formation__c
   */
  webService static Demande_de_formation__c getByIdForFields(String requestId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Demande_de_formation__c WHERE Id = :requestId ORDER BY CreatedDate DESC LIMIT 1';
    return Database.query(sObjectSOQL);
  }
}