//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Repository class for the FO_catalogue_de_formation__c object
 * @author Crosstalent
 * @group SIRH-Repository
 * @version 1.0
 */
global with sharing class TrainingModuleRepository {
      /**
       * Retrieves all the FO_catalogue_de_formation__c
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAll() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c ORDER BY FO_Nom_de_la_formation__c ASC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for the given fields
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c ORDER BY FO_Nom_de_la_formation__c ASC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActive() {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for the given fields
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveForFields(List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllFiltered(List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';

            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for the given fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllFilteredForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues,
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveFiltered(List<String> filterFields, List<String> filterOperations, List<String> filterValues) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for the given fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveFilteredForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues,
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given offset and limit
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffset(Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given offset, limit and fields
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffsetForFields(Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given offset, limit filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllFilteredWithOffset(List<String> filterFields, List<String> filterOperations, List<String> filterValues, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given offset, limit and fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllFilteredWithOffsetForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues, Integer offsetNumber, Integer limitNumber,
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues)  + ' '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given offset, limit filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveFilteredWithOffset(List<String> filterFields, List<String> filterOperations, List<String> filterValues, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given offset, limit and fields filtered by the given lists
       * @param filterFields     List of fields' API name to filter
       * @param filterOperations List of filter operations (e.g. =, !=, etc.)
       * @param filterValues     List of values to be filtered
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveFilteredWithOffsetForFields(List<String> filterFields, List<String> filterOperations, List<String> filterValues, Integer offsetNumber, Integer limitNumber,
                                                                                    List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + BaseRepository.addFilter(filterFields, filterOperations, filterValues) + ' '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllByTrainer(String trainerId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer and fields
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllByTrainerForFields(String trainerId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveByTrainer(String trainerId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer and fields
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveByTrainerForFields(String trainerId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer, limit and offset
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffsetByTrainer(String trainerId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer, limit, offset and fields
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffsetByTrainerForFields(String trainerId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer, limit and offset
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffsetByTrainer(String trainerId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer, limit, offset and fields
       * @param trainerId Id of the FO_catalogue_de_formation__c trainer
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffsetByTrainerForFields(String trainerId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Formateur__c = :trainerId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllByOrg(String orgId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer and fields
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllByOrgForFields(String orgId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveByOrg(String orgId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer and fields
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveByOrgForFields(String orgId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer, limit and offset
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffsetByOrg(String orgId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the FO_catalogue_de_formation__c for a given trainer, limit, offset and fields
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllWithOffsetByOrgForFields(String orgId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer, limit and offset
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param offset offset position for the query
       * @param limit limit for the query
       *
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffsetByOrg(String orgId, Integer offsetNumber, Integer limitNumber) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves all the active FO_catalogue_de_formation__c for a given trainer, limit, offset and fields
       * @param orgId Id of the FO_catalogue_de_formation__c training organization
       * @param offset offset position for the query
       * @param limit limit for the query
       * @param fields   List of fields' API name
       * @return List<FO_catalogue_de_formation__c>
       */
      webService static List<FO_catalogue_de_formation__c> getAllActiveWithOffsetByOrgForFields(String orgId, Integer offsetNumber, Integer limitNumber, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE FO_Organisme_de_formation__c = :orgId '
                        + 'AND A_publier__c = true '
                        + 'ORDER BY FO_Nom_de_la_formation__c ASC '
                        + 'LIMIT :limitNumber OFFSET :offsetNumber';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a FO_catalogue_de_formation__c from its Id
       * @param moduleId Id of the FO_catalogue_de_formation__c
       *
       * @return FO_catalogue_de_formation__c
       */
      webService static FO_catalogue_de_formation__c getById(String moduleId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE Id = :moduleId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a FO_catalogue_de_formation__c for a given Id and fields
       * @param moduleId Id of the FO_catalogue_de_formation__c
       * @param fields   List of fields' API name
       * @return FO_catalogue_de_formation__c
       */
      webService static FO_catalogue_de_formation__c getByIdForFields(String moduleId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ' FROM FO_catalogue_de_formation__c '
                        + 'WHERE Id = :moduleId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT 1';
            return Database.query(sObjectSOQL);
      }

      /**
       * Retrieves a FO_catalogue_de_formation__c from its Id
       * @param moduleId Id of the FO_catalogue_de_formation__c
       * @param contactId Id of the Demande_de_formation__c owner
       *
       * @return FO_catalogue_de_formation__c
       */
      webService static FO_catalogue_de_formation__c getWithRequestsById(String moduleId, String contactId) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: BaseRepository.getObjectFields(FO_catalogue_de_formation__c.sObjectType)) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, Name, CreatedDate '
                                    + 'FROM Demandes_de_formation__r '
                                    + 'WHERE Salarie__c = :contactId '
                                    + 'ORDER BY CreatedDate DESC) '
                        + 'FROM FO_catalogue_de_formation__c '
                        + 'WHERE Id = :moduleId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT 1';
            return Database.query(String.escapeSingleQuotes(sObjectSOQL));
      }

      /**
       * Retrieves a FO_catalogue_de_formation__c from its Id
       * @param moduleId Id of the FO_catalogue_de_formation__c
       * @param contactId Id of the Demande_de_formation__c owner
       * @param fields   List of fields' API name
       * @return FO_catalogue_de_formation__c
       */
      webService static FO_catalogue_de_formation__c getWithRequestsByIdForFields(String moduleId, String contactId, List<String> fields) {
            String sObjectSOQL = 'SELECT Id, Name';
            for(String field: fields) {
                  sObjectSOQL += ', '+field;
            }
            sObjectSOQL += ', (SELECT Id, Name, CreatedDate '
                                    + 'FROM Demandes_de_formation__r '
                                    + 'WHERE Salarie__c = :contactId '
                                    + 'ORDER BY CreatedDate DESC) '
                        + 'FROM FO_catalogue_de_formation__c '
                        + 'WHERE Id = :moduleId '
                        + 'ORDER BY FO_Nom_de_la_formation__c DESC '
                        + 'LIMIT 1';

            return Database.query(sObjectSOQL);
      }
}