/**
 * Classe de gestion d'auto-incrémentation de champs texte
 * @author NAJI Abdel
 * @version 2.0
 * NMA 27/09/2021---> Récupérer le code qui existe dans Soderne et le mettre dans cette org +MAJ des noms des champs et 
 * le nom de l'objet
 */

public class GenerateAutoNumber {

    private class AutoNumberGenerationException extends Exception {}
    private class InvalidTypeException extends Exception {}
    private class SyntaxAutoNumberException extends Exception {}

    // AutoNumberConfig 
    // By Criteria Field Value              ie : String = 'Paris'
    // By Criteria Field                    ie : String = 'BillingAddress'
    // By Criteria Object Reference         ie : String = 'AccountId'
    // By Field to Fill API Name            ie : String = 'Address'
    // By Object to treat API Name          ie : String = 'Contact'
    private static 
    Map<String,
        Map<String,
            Map<String,
                Map<String,
                    Map<String,
                        crta__Employee_Number_Generator__c>>>>> autonumberConfigs;

    static {
        autonumberConfigs = 
            new Map<String,Map<String,Map<String,Map<String,Map<String,crta__Employee_Number_Generator__c>>>>>();
        for(crta__Employee_Number_Generator__c autoNumberConfig:  
                [
                    SELECT 
                        crta__Object_API_Name__c,
                        crta__Field_API_Name__c,
                        crta__Criteria_Object_Reference__c,
                        crta__Criteria_Field_Name__c,
                        crta__Criteria_Field_Value__c,
                        crta__Pattern__c,
                        crta__Last_Created_Index__c,
                        crta__Is_Active__c,
                        crta__Is_Active_For_Update__c
                    FROM crta__Employee_Number_Generator__c
                ]
        )   
        {
            //We fill the map level by level

            if(!autonumberConfigs.containsKey(autoNumberConfig.crta__Object_API_Name__c)) {
                autonumberConfigs.put(
                    autoNumberConfig.crta__Object_API_Name__c, 
                    new Map<String,Map<String,Map<String,Map<String,crta__Employee_Number_Generator__c>>>>()
                );
            }

            Map<String,Map<String,Map<String,Map<String,crta__Employee_Number_Generator__c>>>> levelFour;
            levelFour = autonumberConfigs.get(autoNumberConfig.crta__Object_API_Name__c);
            if(!levelFour.containsKey(autoNumberConfig.crta__Field_API_Name__c)) {
                levelFour.put(
                    autoNumberConfig.crta__Field_API_Name__c, 
                    new Map<String,Map<String,Map<String,crta__Employee_Number_Generator__c>>>()
                );
            }
            
            Map<String,Map<String,Map<String,crta__Employee_Number_Generator__c>>> levelThree;
            levelThree = levelFour.get(autoNumberConfig.crta__Field_API_Name__c);
            if(!levelThree.containsKey(autoNumberConfig.crta__Criteria_Object_Reference__c)) {
                levelThree.put(
                    autoNumberConfig.crta__Criteria_Object_Reference__c, 
                    new Map<String,Map<String,crta__Employee_Number_Generator__c>>()
                );
            }

            Map<String,Map<String,crta__Employee_Number_Generator__c>> levelTwo;
            levelTwo = levelThree.get(autoNumberConfig.crta__Criteria_Object_Reference__c);
            if(!levelTwo.containsKey(autoNumberConfig.crta__Criteria_Field_Name__c)) {
                levelTwo.put(
                    autoNumberConfig.crta__Criteria_Field_Name__c, 
                    new Map<String,crta__Employee_Number_Generator__c>()
                );
            }

            Map<String,crta__Employee_Number_Generator__c> levelOne;
            levelOne = levelTwo.get(autoNumberConfig.crta__Criteria_Field_Name__c);
            if(autoNumberConfig.crta__Criteria_Field_Value__c.contains(',')) {
                List<String> criteriaList = autoNumberConfig.crta__Criteria_Field_Value__c.split(',');
                for(String criteria : criteriaList) {
                    levelOne.put(criteria, autoNumberConfig);
                }
            } else {
                levelOne.put(autoNumberConfig.crta__Criteria_Field_Value__c, autoNumberConfig);
            }
        }
    }


/**
 * generate()
 * Generate the registrations for each record.

 * @param targetObjectsList : Object to treat (<SObject>)
 * @param fieldName : Field to fill (API Name)
 * @param referenceFieldName : Reference to parent object which used for registration settings

 * @param criteriaParentObjectName : Parent object name
 * @param criteriaFieldName : field name

 * @param isUpdate : It's available for update or insert ?
 */

    public static void generate(
        List<SObject> targetObjectsList,  
        String fieldName,  
        String referenceFieldName,
        String criteriaParentObjectName,
        String criteriaFieldName, 
        Boolean isUpdate)
    {
        if(autonumberConfigs.size() == 0) {
            return;
        }

        List<String> recordsId = new List<String>();
        
        Id recordId;
        String query;
        Map<String,SObject> recordsById =  new Map<String,SObject>();
        if (referenceFieldName != 'Contact'){
            for(SObject record : targetObjectsList){
                recordsId.add((String)record.get(referenceFieldName));
            }
            
            recordId = Id.valueOf(recordsId[0]);
            query = 
                'SELECT'
                + ' Id,'
                + ' ' + criteriaFieldName
                + ' FROM'
                + ' ' + recordId.getSObjectType().getDescribe().getName()
                + ' WHERE'
                + ' Id IN :recordsId';
         
        //else {
        //     query = 
        //         'SELECT'
        //         + ' Id,'
        //         + ' ' + criteriaFieldName
        //         + ' FROM'
        //         + ' ' + 'Contact'
        //         + ' WHERE'
        //         + ' Id IN :recordsId';
        // }
       
        for(SObject record : Database.query(query)) {
            recordsById.put(record.Id,record);
        }
        System.debug('recordsId '+recordsId);
        System.debug('referenceFieldName '+referenceFieldName);
    }
        
        Map<Id,crta__Employee_Number_Generator__c> autoNumberConfigsToUpdate = new Map<Id,crta__Employee_Number_Generator__c>();
        for(SObject targetObject : targetObjectsList) {
            String criteriaFieldValue;
            if (referenceFieldName == 'Contact'){
                criteriaFieldValue = 
                    (String)targetObject.get(criteriaFieldName);
                System.debug('criteriaFieldValue-->'+criteriaFieldValue);
            }else {
                criteriaFieldValue = 
                    (String)recordsById.get((String)targetObject.get(referenceFieldName)).get(criteriaFieldName);
            }
            if(targetObject == null) {
                throw new AutoNumberGenerationException('The target SObject cannot be null.');
            }

            if(fieldName == null) {
                throw new AutoNumberGenerationException('The target field cannot be null.');
            }

            Map<String,Schema.sObjectField> sObjectFields = 
                targetObject.getSObjectType().getDescribe().fields.getMap();

            if(!sObjectFields.containsKey(fieldName)) {
                throw new AutoNumberGenerationException('The target field doesn\'t exist.');
            }

            if(sObjectFields.get(fieldName).getDescribe().getType() != Schema.DisplayType.String) {
                throw new InvalidTypeException('The type must be a string.'); 
            }

            String sObjectName = targetObject.getSObjectType().getDescribe().getName();
            System.debug('targetObject '+targetObject);
            Id idrecordType =((Contact)targetObject).RecordTypeId;
           // referenceFieldName = sObjectName;
            system.debug('idrecordType '+idrecordType);
            System.debug('sObjectName '+sObjectName);
            System.debug('fieldName '+fieldName);
            System.debug('criteriaFieldName '+ criteriaFieldName);
            System.debug('referenceFieldName '+ referenceFieldName);
            System.debug('criteriaFieldName '+ criteriaFieldName);
            //criteriaFieldName = criteriaFieldValue;
            System.debug('criteriaFieldValue '+ criteriaFieldValue);
            //System.debug('criteriaParentObjectName '+ criteriaParentObjectName);
            
     
            System.debug('autonumberConfigs '+ autonumberConfigs);
           
           /* System.debug('condition 4 '+ autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .get(referenceFieldName)
                    .containsKey(criteriaFieldName));
            
            System.debug('condition 5 '+ autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .get(referenceFieldName)
                    .get(criteriaFieldName)
                    .containsKey(criteriaFieldValue));*/
            
            if(
               !autonumberConfigs.containsKey(sObjectName)
               || !autoNumberConfigs
                    .get(sObjectName)
                    .containsKey(fieldName)
               || !autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .containsKey(referenceFieldName)
              || !autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .get(referenceFieldName)
                    .containsKey(criteriaFieldName)
               || !autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .get(referenceFieldName)
                    .get(criteriaFieldName)
                    .containsKey(criteriaFieldValue)
            ) {
                System.debug('The configuration data is missing for this record : ' + targetObject.Id);
                continue;
            }

            crta__Employee_Number_Generator__c autonumberConfiguration;
            autonumberConfiguration = 
                autonumberConfigs
                    .get(sObjectName)
                    .get(fieldName)
                    .get(referenceFieldName)
                    .get(criteriaFieldName)
                    .get(criteriaFieldValue);
            System.debug('autonumberConfiguration '+autonumberConfiguration);

            if(
                //(
                    autonumberConfiguration.crta__Is_Active__c
                    //&& !isUpdate
                //)
                // || 
                // (
                //     isUpdate
                //     && autonumberConfiguration.Is_Active__c
                //     && autonumberConfiguration.Is_Active_For_Update__c
                // )
            ) {
                String pattern = autonumberConfiguration.crta__Pattern__c;
                String patternNumber;

                if(
                 pattern.countMatches('{') == 1 
                 && pattern.countMatches('}') == 1
                ) { 
                    String checkSyntax = pattern.substringBefore('{');

                    if(
                        !String.isBlank(checkSyntax)
                        && checkSyntax.contains('}')
                    ) {
                        throw new SyntaxAutoNumberException ('The pattern syntax is wrong.');
                    }

                    patternNumber = pattern.substringBetween('{', '}');
                    if(
                        String.isBlank(patternNumber)
                        || !patternNumber.containsOnly('0')
                    ) {
                        throw new SyntaxAutoNumberException ('The pattern syntax is wrong.'); 
                    }
                } else {
                    throw new SyntaxAutoNumberException ('The pattern syntax is wrong.'); 
                }
                    if (!isUpdate || (isUpdate && (String)targetObject.get(fieldName) == null)){
                        autonumberConfiguration.crta__Last_Created_Index__c++;
                        autoNumberConfigsToUpdate.put(autonumberConfiguration.Id,autonumberConfiguration);
                        targetObject.put(
                            fieldName,
                            pattern.replace(
                                '{' + patternNumber + '}', 
                                getAutoNumber(
                                    autonumberConfiguration.crta__Last_Created_Index__c.intValue(), 
                                    patternNumber.length()
                                )
                            )
                        );
                    }
            }
        }
        update autoNumberConfigsToUpdate.values();
    }

    private static String getAutoNumber(Integer indexNumber, Integer size)
    {
        String numberString = String.valueOf(indexNumber);
        while(numberString.length() < size) {
            numberString = '0' + numberString;
        }
        return numberString;
    } 

}