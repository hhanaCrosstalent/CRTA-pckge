//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Feuille_Temps_Hebdo__c object
 * @author Crosstalent
 * @group SIRH-Repository
 */
global with sharing class TimesheetRepository {

    /**
     * Retrieves all Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAll() {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'ORDER BY Date_debut_semaine__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for the given fields
     * @param  fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllForFields(List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'ORDER BY Date_debut_semaine__c DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given offset and limit
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given offset, limit and fields
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllWithOffsetForFields(Integer offsetNumber, 
                                Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given contact
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContact(String contactId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY Date_debut_semaine__c DESC';
        return Database.query(String.escapeSingleQuotes(sObjectSOQL));
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given contact and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContactForFields(String contactId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY Date_debut_semaine__c DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given contact, limit and offset
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param offset offset position for the query
     * @param limit limit for the query
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllWithOffsetByContact(String contactId, Integer offsetNumber, 
                                                        Integer limitNumber) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves all the Feuille_Temps_Hebdo__c for a given contact, limit, offset and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param offset offset position for the query
     * @param limit limit for the query
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllWithOffsetByContactforFields(String contactId, 
                                    Integer offsetNumber, Integer limitNumber, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT :limitNumber OFFSET :offsetNumber';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the Feuille_Temps_Hebdo__c for a given contact and set of dates
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContactBetweenDates(String contactId, Date startDate, 
                                                    Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c =: contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the Feuille_Temps_Hebdo__c for a given contact, set of dates and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContactBetweenDatesForFields(String contactId, 
                                                        Date startDate, Date endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the Feuille_Temps_Hebdo__c for a given contact and for a date
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContactForDate(String contactId, Date startDate) {
        Date d = startDate.toStartOfWeek();
        return getAllByContactBetweenDates(contactId, d, d);
        
        //String sObjectSOQL = 'SELECT Id, Name';
        //for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
        //    sObjectSOQL += ', '+field;
        //}
        //sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
        //        + 'FROM Feuille_Temps_Hebdo__c '
        //        + 'WHERE Salarie__c = :contactId '
        //        + 'AND (Date_debut_semaine__c =: startDate OR Date_de_fin__c =: startDate) '
        //        + 'ORDER BY CreatedDate DESC';
        //return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the Feuille_Temps_Hebdo__c for a given contact, date ad fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllByContactForDateForFields(String contactId, Date startDate, 
                                                                    List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c =: contactId '
                + 'AND (Date_debut_semaine__c =: startDate OR Date_de_fin__c =: startDate) '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the pending Feuille_Temps_Hebdo__c for a given contact and set of dates
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllPendingByContactBetweenDates(String contactId, 
            Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the pending Feuille_Temps_Hebdo__c for a given contact, set of dates and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllPendingByContactBetweenDatesForFields(String contactId, 
            Date startDate, Date endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the pending Feuille_Temps_Hebdo__c for a given contact and for a date
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllPendingByContactForDate(String contactId, Date startDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND (Date_debut_semaine__c = :startDate OR Date_de_fin__c = :startDate) '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the pending Feuille_Temps_Hebdo__c for a given contact, date and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllPendingByContactForDateForFields(String contactId, 
                                                            Date startDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND (Date_debut_semaine__c = :startDate OR Date_de_fin__c = :startDate) '
                + 'AND Valeur_statut__c < 20 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the validated Feuille_Temps_Hebdo__c for a given contact and set of dates
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllValidatedByContactBetweenDates(String contactId, 
            Date startDate, Date endDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'AND Valeur_statut__c >= 20 '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the validated Feuille_Temps_Hebdo__c for a given contact, set of dates and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Earliest date possible for the Feuille_Temps_Hebdo__c
     * @param endDate Oldest date possible for the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllValidatedByContactBetweenDatesForFields(String contactId, 
            Date startDate, Date endDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND Date_debut_semaine__c <=: endDate '
                + 'AND Date_de_fin__c >=: startDate '
                + 'AND Valeur_statut__c >= 20 '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the validated Feuille_Temps_Hebdo__c for a given contact and for a date
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     *
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllValidatedByContactForDate(String contactId, Date startDate) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND (Date_debut_semaine__c = :startDate OR Date_de_fin__c = :startDate) '
                + 'AND Valeur_statut__c >= 20 '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY CreatedDate DESC';

        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves the validated Feuille_Temps_Hebdo__c for a given contact, date and fields
     * @param contactId Id of the Feuille_Temps_Hebdo__c owner
     * @param startDate Date to be included in the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return List<Feuille_Temps_Hebdo__c>
     */
    webService static List<Feuille_Temps_Hebdo__c> getAllValidatedByContactForDateForFields(String contactId, 
                                                    Date startDate, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Salarie__c = :contactId '
                + 'AND (Date_debut_semaine__c = :startDate OR Date_de_fin__c = :startDate) '
                + 'AND Valeur_statut__c >= 20 '
                + 'AND Valeur_statut__c < 90 '
                + 'ORDER BY CreatedDate DESC';
        return Database.query(sObjectSOQL);
    }

    /**
     * Retrieves a Feuille_Temps_Hebdo__c from its Id
     * @param weekId Id of the Feuille_Temps_Hebdo__c
     *
     * @return Feuille_Temps_Hebdo__c
     */
    webService static Feuille_Temps_Hebdo__c getById(String weekId) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: BaseRepository.getObjectFields(Feuille_Temps_Hebdo__c.sObjectType)) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ', Salarie__r.ReportsToId, Salarie__r.Name '
                + 'FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Id = :weekId '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT 1';
        return Database.query(String.escapeSingleQuotes(sObjectSOQL));
    }

    /**
     * Retrieves a Feuille_Temps_Hebdo__c for a given Id and fields
     * @param weekId Id of the Feuille_Temps_Hebdo__c
     * @param fields   List of fields' API name
     * @return Feuille_Temps_Hebdo__c
     */
    webService static Feuille_Temps_Hebdo__c getByIdForFields(String weekId, List<String> fields) {
        String sObjectSOQL = 'SELECT Id, Name';
        for(String field: fields) {
            sObjectSOQL += ', '+field;
        }
        sObjectSOQL += ' FROM Feuille_Temps_Hebdo__c '
                + 'WHERE Id = :weekId '
                + 'ORDER BY Date_debut_semaine__c DESC '
                + 'LIMIT 1';
        return Database.query(sObjectSOQL);
    }
}