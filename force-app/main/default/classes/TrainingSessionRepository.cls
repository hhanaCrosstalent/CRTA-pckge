//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the FO_Session_collective__c object
 * @author Crosstalent
 * @group SIRH-Repository
 */
global with sharing class TrainingSessionRepository {
    /**
     * Retrieves all the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAll() {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c ORDER BY FO_Date_et_heure_de_debut__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllForFields(List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c ORDER BY FO_Date_et_heure_de_debut__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c before the given date (included)
     * @param sessionDate Oldest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBeforeDate(DateTime sessionDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_fin__c <= :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and before the given date (included)
     * @param sessionDate Oldest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBeforeDateForFields(DateTime sessionDate, 
                                                                    List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_fin__c <= :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c after the given date (included)
     * @param sessionDate Earliest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllAfterDate(DateTime sessionDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c >= :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and after the given date (included)
     * @param sessionDate Earliest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllAfterDateForFields(DateTime sessionDate, 
                                                                    List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c >= :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c between the given date (included)
     * @param startDate Earliest date possible for the FO_Session_collective__c
     * @param endDate Oldest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBetweenDates(DateTime startDate, DateTime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c <= :endDate '
                + 'AND FO_Date_et_heure_de_fin__c >= :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and between the given date (included)
     * @param startDate Earliest date possible for the FO_Session_collective__c
     * @param endDate Oldest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBetweenDatesForFields(DateTime startDate, DateTime endDate, 
                                                                                List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c <= :endDate '
                + 'AND FO_Date_et_heure_de_fin__c >= :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c before the given date (not included)
     * @param sessionDate Oldest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBeforeDateStrict(DateTime sessionDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_fin__c < :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and before the given date (not included)
     * @param sessionDate Oldest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBeforeDateStrictForFields(DateTime sessionDate, 
                                                                            List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_fin__c < :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_fin__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c after the given date (not included)
     * @param sessionDate Earliest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllAfterDateStrict(DateTime sessionDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c > :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and after the given date (not included)
     * @param sessionDate Earliest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllAfterDateStrictForFields(DateTime sessionDate, 
                                                                                List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c > :sessionDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c between the given date (not included)
     * @param startDate Earliest date possible for the FO_Session_collective__c
     * @param endDate Oldest date possible for the FO_Session_collective__c
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBetweenDatesStrict(DateTime startDate, DateTime endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c < :endDate '
                + 'AND FO_Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for the given fields and between the given date (not included)
     * @param startDate Earliest date possible for the FO_Session_collective__c
     * @param endDate Oldest date possible for the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllBetweenDatesStrictForFields(DateTime startDate, 
                                                            DateTime endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE FO_Date_et_heure_de_debut__c < :endDate '
                + 'AND FO_Date_et_heure_de_fin__c > :startDate '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given offset and limit
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given offset, limit and fields
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllWithOffsetForFields(Integer offsetNumber, 
                                                            Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given module
     * @param moduleId Id of the parent training module
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllByModule(String moduleId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given module and fields
     * @param moduleId Id of the parent training module
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllByModuleForFields(String moduleId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given module, limit and offset
     * @param moduleId Id of the parent training module
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllWithOffsetByModule(String moduleId, Integer offsetNumber, 
                                                                                Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the FO_Session_collective__c for a given module, limit, offset and fields
     * @param moduleId Id of the parent training module
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<FO_Session_collective__c>
     */
    webService static List<FO_Session_collective__c> getAllWithOffsetByModuleForFields(String moduleId, 
                                        Integer offsetNumber, Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Catalogue_de_formation__c = :moduleId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves a FO_Session_collective__c from its Id
     * @param sessionId Id of the FO_Session_collective__c
     *
     * @return FO_Session_collective__c
     */
    webService static FO_Session_collective__c getById(String sessionId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(FO_Session_collective__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Id = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC LIMIT 1';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves a FO_Session_collective__c for a given Id and fields
     * @param sessionId Id of the FO_Session_collective__c
     * @param fields   List of fields' API name
     * @return FO_Session_collective__c
     */
    webService static FO_Session_collective__c getByIdForFields(String sessionId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM FO_Session_collective__c '
                + 'WHERE Id = :sessionId '
                + 'ORDER BY FO_Date_et_heure_de_debut__c DESC '
                + 'LIMIT 1';
        return Database.query(sObjectSOQL);
    }
}