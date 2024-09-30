//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the Offre_d_emploi__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class JobOfferRepository {
      /**
       * Retrieves all the Offre_d_emploi__c
       *
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Offre_d_emploi__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c '
                        + 'FROM Offre_d_emploi__c '
                        + 'ORDER BY CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for the given fields
       * @param fields   List of fields' API name
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Offre_d_emploi__c ORDER BY CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c filtered by the given lists
       * @param  filterFields     List of fields' API name to filter
       * @param  filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param  filterValues     List of values to be filtered
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllFiltered(List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Offre_d_emploi__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c '
                        + 'FROM Offre_d_emploi__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for the given fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param fields   List of fields' API name
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllFilteredForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues,
                                                                        List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Offre_d_emploi__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY CreatedDate DESC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Offre_d_emploi__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c '
                        + 'FROM Offre_d_emploi__c '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Offre_d_emploi__c ORDER BY CreatedDate DESC LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for a given offset, limit filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllFilteredWithOffset(List<String> filterFields, List<String> filterOperations, List<String> filterValues, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Offre_d_emploi__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c '
                        + 'FROM Offre_d_emploi__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the Offre_d_emploi__c for a given offset, limit and fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<Offre_d_emploi__c>
       */
      webService static List<Offre_d_emploi__c> getAllFilteredWithOffsetForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues, 
                                                                          Integer offsetNumber, Integer limitNumber,
                                                                          List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Offre_d_emploi__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY CreatedDate DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Offre_d_emploi__c from its Id
       * @param offerId Id of the Offre_d_emploi__c
       *
       * @return Offre_d_emploi__c
       */
      webService static Offre_d_emploi__c getById(String offerId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(Offre_d_emploi__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', Fiche_de_poste__r.Name, Fiche_de_poste__r.GS_Description__c '
                        + 'FROM Offre_d_emploi__c '
                        + 'WHERE Id = :offerId '
                        + 'ORDER BY CreatedDate DESC LIMIT 1';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a Offre_d_emploi__c for a given Id and fields
       * @param offerId Id of the Offre_d_emploi__c
       * @param fields   List of fields' API name
       * @return Offre_d_emploi__c
       */
      webService static Offre_d_emploi__c getByIdForFields(String offerId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM Offre_d_emploi__c WHERE Id = :offerId ORDER BY CreatedDate DESC LIMIT 1';
            return Database.query(sObjectSOQL);
      }
}