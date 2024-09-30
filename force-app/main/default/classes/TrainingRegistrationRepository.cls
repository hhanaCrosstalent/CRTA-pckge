//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Participation_session_formation__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TrainingRegistrationRepository {
  /**
   * Retrieves all the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAll() {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllForFields(List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c before the given date (included)
   * @param registrationDate Oldest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBeforeDate(Datetime registrationDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_fin__c <= :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and before the given date (included)
   * @param registrationDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBeforeDateForFields(Datetime registrationDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_fin__c <= :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c after the given date (included)
   * @param registrationDate Earliest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllAfterDate(Datetime registrationDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
              sObjectSOQL += ', '+field;
}
        sObjectSOQL += ' FROM Participation_session_formation__c '
                      + 'WHERE FO_Date_et_heure_de_debut__c >= :registrationDate '
                      + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and after the given date (included)
   * @param registrationDate Earliest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllAfterDateForFields(Datetime registrationDate, 
                                                                                        List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c >= :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c between the given date (included)
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBetweenDates(Datetime startDate, Datetime endDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
            + 'WHERE FO_Date_et_heure_de_debut__c <= :endDate '
            + 'AND FO_Date_et_heure_de_fin__c >= :startDate '
            + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and between the given date (included)
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBetweenDatesForFields(Datetime startDate, Datetime endDate, 
                                                                                            List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c <= :endDate '
                + 'AND FO_Date_et_heure_de_fin__c >= :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c before the given date (not included)
   * @param registrationDate Oldest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBeforeDateStrict(Datetime registrationDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_fin__c < :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and before the given date (not included)
   * @param registrationDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBeforeDateStrictForFields(Datetime registrationDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_fin__c < :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c after the given date (not included)
   * @param registrationDate Earliest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllAfterDateStrict(Datetime registrationDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c > :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and after the given date (not included)
   * @param registrationDate Earliest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllAfterDateStrictForFields(Datetime registrationDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c > :registrationDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c between the given date (not included)
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBetweenDatesStrict(Datetime startDate, Datetime endDate) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c < :endDate '
                + 'AND FO_Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for the given fields and between the given date (not included)
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBetweenDatesStrictForFields(Datetime startDate, Datetime endDate, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE FO_Date_et_heure_de_debut__c < :endDate '
                + 'AND FO_Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given offset and limit
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given offset, limit and fields
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given module
   * @param moduleId Id of the parent training module
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByModule(String moduleId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given module and fields
   * @param moduleId Id of the parent training module
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByModuleForFields(String moduleId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given module
   * @param moduleId Id of the parent training module
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * 
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllByModuleBetweenDates(String moduleId, 
                                                                            Datetime startDate, Datetime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
            + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
            + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
            + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
            + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for a given module and fields
   * @param moduleId Id of the parent training module
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * 
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllByModuleBetweenDatesForFields(String moduleId, 
                                                          Datetime startDate, Datetime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
            + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
            + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
            + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
            + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for a given module, limit and offset
   * @param moduleId Id of the parent training module
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetByModule(String moduleId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given module, limit, offset and fields
   * @param moduleId Id of the parent training module
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllWithOffsetByModuleForFields(String moduleId, 
                                            Integer offsetNumber, Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__r.Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for a given contact
   * @param contactId Id of the registered contact
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByContact(String contactId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByContactForFields(String contactId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the active Participation_session_formation__c for a given contact
   * @param contactId Id of the registered contact
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllActiveByContact(String contactId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(String.escapeSingleQuotes(sObjectSOQL));
  }

  /**
   * Retrieves all the active Participation_session_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllActiveByContactForFields(String contactId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

    /**
     * Retrieves all the Participation_session_formation__c for a given contact
     * @param contactId Id of the registered contact
     * @param startDate Earliest date possible for the Participation_session_formation__c
     * @param endDate Oldest date possible for the Participation_session_formation__c
     * 
     * @return List<Participation_session_formation__c>
     */
    webService static List<Participation_session_formation__c> getAllByContactBetweenDates(String contactId, 
                                                                Datetime startDate, Datetime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
                + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the active Participation_session_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllByContactBetweenDatesForFields(String contactId, 
                                                    Datetime startDate, Datetime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'AND Valeur_statut__c < 90 '
                + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
                + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the active Participation_session_formation__c for a given contact
   * @param contactId Id of the registered contact
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * 
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllActiveByContactBetweenDates(String contactId, 
                                                                    Datetime startDate, Datetime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
            + 'WHERE Action_de_formation__r.Contact__c =: contactId '
            + 'AND Valeur_statut__c < 90 '
            + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
            + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
            + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for a given contact and fields
   * @param contactId Id of the registered contact
   * @param startDate Earliest date possible for the Participation_session_formation__c
   * @param endDate Oldest date possible for the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
    webService static List<Participation_session_formation__c> getAllActiveByContactBetweenDatesForFields(String contactId, Datetime startDate, Datetime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'AND FO_Date_et_heure_de_debut__c <=: endDate '
                + 'AND FO_Date_et_heure_de_fin__c >=: startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

  /**
   * Retrieves all the Participation_session_formation__c for a given contact, limit and offset
   * @param contactId Id of the registered contact
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given contact, limit, offset and fields
   * @param contactId Id of the registered contact
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__r.Contact__c = :contactId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given session
   * @param sessionId Id of the parent session
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBySession(String sessionId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given session and fields
   * @param sessionId Id of the parent session
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllBySessionForFields(String sessionId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given session, limit and offset
   * @param sessionId Id of the parent session
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetBySession(String sessionId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given session, limit, offset and fields
   * @param sessionId Id of the parent session
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetBySessionForFields(String sessionId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Session_de_formation__c = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given action
   * @param actionId Id of the parent action
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByAction(String actionId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';

    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given action and fields
   * @param actionId Id of the parent action
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllByActionForFields(String actionId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the active Participation_session_formation__c for a given action
   * @param actionId Id of the parent action
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllActiveByAction(String actionId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(String.escapeSingleQuotes(sObjectSOQL));
  }

  /**
   * Retrieves all the active Participation_session_formation__c for a given action and fields
   * @param actionId Id of the parent action
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllActiveByActionForFields(String actionId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given action, limit and offset
   * @param actionId Id of the parent action
   * @param offset offset position for the query
   * @param limit limit for the query
   *
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetByAction(String actionId, Integer offsetNumber, Integer limitNumber) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves all the Participation_session_formation__c for a given action, limit, offset and fields
   * @param actionId Id of the parent action
   * @param offset offset position for the query
   * @param limit limit for the query
   * @param fields   List of fields' API name
   * @return List<Participation_session_formation__c>
   */
  webService static List<Participation_session_formation__c> getAllWithOffsetByActionForFields(String actionId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Action_de_formation__c = :actionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves a Participation_session_formation__c from its Id
   * @param registrationId Id of the Participation_session_formation__c
   *
   * @return Participation_session_formation__c
   */
  webService static Participation_session_formation__c getById(String registrationId) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: BaseRepository.getObjectFields(Participation_session_formation__c.sObjectType)) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Id = :registrationId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT 1';
    return Database.query(sObjectSOQL);
  }

  /**
   * Retrieves a Participation_session_formation__c for a given Id and fields
   * @param registrationId Id of the Participation_session_formation__c
   * @param fields   List of fields' API name
   * @return Participation_session_formation__c
   */
  webService static Participation_session_formation__c getByIdForFields(String registrationId, List<String> fields) {
    String sObjectSOQL = 'SELECT Id, Name';
    for(String field: fields) {
          sObjectSOQL += ', '+field;
    }
    sObjectSOQL += ' FROM Participation_session_formation__c '
                + 'WHERE Id = :registrationId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT 1';
    return Database.query(sObjectSOQL);
  }
}