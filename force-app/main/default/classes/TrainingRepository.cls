//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Formation__c object
 * @author Crosstalent
 * @group SIRH-Repository
 */
global with sharing class TrainingRepository {
    /**
     * Retrieves all the Formation__c
     *
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAll() {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c ORDER BY CT_Start_date__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for the given fields
     * @param fields   List of fields' API name
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllForFields(List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c ORDER BY CT_Start_date__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given offset and limit
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c ORDER BY CT_Start_date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given offset, limit and fields
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, 
                                                                                List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c ORDER BY CT_Start_date__c DESC LIMIT :limitNumber OFFSET :offsetNumber';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact
     * @param contactId Id of the Formation__c owner
     *
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllByContact(String contactId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c WHERE CT_Candidate__c = :contactId ORDER BY CT_Start_date__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact and fields
     * @param contactId Id of the Formation__c owner
     * @param fields   List of fields' API name
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllByContactForFields(String contactId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c WHERE CT_Candidate__c = :contactId ORDER BY CT_Start_date__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact between given dates
     * @param contactId Id of the Formation__c owner
     * @param startDate Earliest date possible for the training
     * @param endDate Oldest date possible for the training
     *
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllByContactBetweenDate(String contactId, Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c '
                + 'WHERE CT_Candidate__c = :contactId '
                + 'AND CT_Start_date__c >= :startDate '
                + 'AND CT_Start_date__c <= :endDate '
                + 'ORDER BY CT_Start_date__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact and fields between given dates
     * @param contactId Id of the Formation__c owner
     * @param startDate Earliest date possible for the training
     * @param endDate Oldest date possible for the training
     * @param fields   List of fields' API name
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllByContactBetweenDateForFields(String contactId, Date startDate, 
                                                                    Date endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c '
                + 'WHERE CT_Candidate__c = :contactId '
                + 'AND CT_Start_date__c >= :startDate '
                + 'AND CT_Start_date__c <= :endDate '
                + 'ORDER BY CT_Start_date__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact, limit and offset
     * @param contactId Id of the Formation__c owner
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, 
                                                                            Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c '
                + 'WHERE CT_Candidate__c = :contactId '
                + 'ORDER BY CT_Start_date__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Formation__c for a given contact, limit, offset and fields
     * @param contactId Id of the Formation__c owner
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<Formation__c>
     */
    webService static List<Formation__c> getAllWithOffsetByContactForFields(String contactId, Integer offsetNumber, 
                                                                    Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c '
                + 'WHERE CT_Candidate__c = :contactId '
                + 'ORDER BY CT_Start_date__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves a Formation__c from its Id
     * @param trainingId Id of the Formation__c
     *
     * @return Formation__c
     */
    webService static Formation__c getById(String trainingId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Formation__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c WHERE Id = :trainingId ORDER BY CT_Start_date__c DESC LIMIT 1';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves a Formation__c for a given Id and fields
     * @param trainingId Id of the Formation__c
     * @param fields   List of fields' API name
     * @return Formation__c
     */
    webService static Formation__c getByIdForFields(String trainingId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Formation__c WHERE Id = :trainingId ORDER BY CT_Start_date__c DESC LIMIT 1';
        return Database.query(sObjectSOQL);
    }
}