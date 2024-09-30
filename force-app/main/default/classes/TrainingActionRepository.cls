//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Action_de_formation__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TrainingActionRepository {
    
  /**
   * Retrieves all the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAll() {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c ORDER BY Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllForFields(List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c ORDER BY Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c before the given date (included)
   * @param actionDate Oldest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBeforeDate(Datetime actionDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_fin__c <= :actionDate '
                + 'ORDER BY Date_et_heure_de_fin__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and before the given date (included)
   * @param actionDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBeforeDateForFields(Datetime actionDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_fin__c <= :actionDate '
                + 'ORDER BY Date_et_heure_de_fin__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c after the given date (included)
   * @param actionDate Earliest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllAfterDate(Datetime actionDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c >= :actionDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and after the given date (included)
   * @param actionDate Earliest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllAfterDateForFields(Datetime actionDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c >= :actionDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c between the given date (included)
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBetweenDates(Datetime startDate, Datetime endDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c <= :endDate '
                + 'AND Date_et_heure_de_fin__c >= :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and between the given date (included)
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBetweenDatesForFields(Datetime startDate, Datetime endDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c <= :endDate '
                + 'AND Date_et_heure_de_fin__c >= :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c before the given date (not included)
   * @param actionDate Oldest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBeforeDateStrict(Datetime actionDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_fin__c < :actionDate '
                + 'ORDER BY Date_et_heure_de_fin__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and before the given date (not included)
   * @param actionDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBeforeDateStrictForFields(Datetime actionDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_fin__c < :actionDate '
                + 'ORDER BY Date_et_heure_de_fin__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c after the given date (not included)
   * @param actionDate Earliest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllAfterDateStrict(Datetime actionDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c > :actionDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and after the given date (not included)
   * @param actionDate Earliest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllAfterDateStrictForFields(Datetime actionDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c > :actionDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c between the given date (not included)
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBetweenDatesStrict(Datetime startDate, Datetime endDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for the given fields and between the given date (not included)
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllBetweenDatesStrictForFields(Datetime startDate, Datetime endDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given offset and limit
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given offset, limit and fields
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given module
   * @param moduleId Id of the parent training module
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllByModule(String moduleId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given module and fields
   * @param moduleId Id of the parent training module
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllByModuleForFields(String moduleId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given module
   * @param moduleId Id of the parent training module
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * 
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllByModuleBetweenDates(String moduleId, 
                                                        Datetime startDate, Datetime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'AND Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given module and fields
   * @param moduleId Id of the parent training module
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * 
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllByModuleBetweenDatesForFields(String moduleId, 
                                            Datetime startDate, Datetime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'AND Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Action_de_formation__c for a given module, limit and offset
   * @param moduleId Id of the parent training module
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllWithOffsetByModule(String moduleId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given module, limit, offset and fields
   * @param moduleId Id of the parent training module
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllWithOffsetByModuleForFields(String moduleId, 
                                    Integer offsetNumber, Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Action_de_formation__c for a given contact
   * @param contactId Id of the registered contact
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllByContact(String contactId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(String.escapeSingleQuotes(sObjectSOQL));
  }

  /**
   * Retrieves all the Action_de_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllByContactForFields(String contactId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given contact
   * @param contactId Id of the registered contact
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * 
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllByContactBetweenDates(String contactId, 
                                                        Datetime startDate, Datetime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'AND Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Action_de_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param startDate Earliest date possible for the Action_de_formation__c
   * @param endDate Oldest date possible for the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllByContactBetweenDatesForFields(String contactId, 
                                            Datetime startDate, Datetime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'AND Date_et_heure_de_debut__c < :endDate '
                + 'AND Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Action_de_formation__c for a given contact, limit and offset
   * @param contactId Id of the registered contact
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Action_de_formation__c for a given contact, limit, offset and fields
   * @param contactId Id of the registered contact
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the pending Action_de_formation__c for a given contact and module
   * @param contactId Id of the registered contact
   * @param moduleId Id of the parent training module
   * @return List<Action_de_formation__c>
   */
    webService static List<Action_de_formation__c> getAllPendingByContactAndModule(String contactId, String moduleId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'AND Catalogue_de_formation__c = :moduleId '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the pending Action_de_formation__c for a given contact, module and fields
   * @param contactId Id of the registered contact
   * @param moduleId Id of the parent training module
   * @param fields   List of fields' API name
   * @return List<Action_de_formation__c>
   */
  webService static List<Action_de_formation__c> getAllPendingByContactAndModuleForFields(String contactId, String moduleId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
      sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Contact__c = :contactId '
                + 'AND Catalogue_de_formation__c = :moduleId '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves a Action_de_formation__c from its Id
   * @param actionId Id of the Action_de_formation__c
   *
   * @return Action_de_formation__c
   */
  webService static Action_de_formation__c getById(String actionId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Action_de_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Action_de_formation__c '
                + 'WHERE Id = :actionId '
                + 'ORDER BY Date_et_heure_de_debut__c DESC '
                + 'LIMIT 1';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves a Action_de_formation__c for a given Id and fields
   * @param actionId Id of the Action_de_formation__c
   * @param fields   List of fields' API name
   * @return Action_de_formation__c
   */
    webService static Action_de_formation__c getByIdForFields(String actionId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Action_de_formation__c '
                    + 'WHERE Id = :actionId '
                    + 'ORDER BY Date_et_heure_de_debut__c DESC '
                    + 'LIMIT 1';
    return Database.query(sObjectSOQL);
  }
}