@IsTest
private class CollectiveAgreementHelperTest {

    private static Id agreementId;
    private static Id contractId;
    private static Id ruleId;

    @TestSetup
    static void setup() {
        // Préparation d'un accord collectif
        crta__Collective_Agreement__c agreement = new crta__Collective_Agreement__c(Name = 'Test Agreement');
        insert agreement;
        agreementId = agreement.Id;

        // Préparation d'une règle d'accord collectif
        crta__Collective_Agreement_Rule__c rule = new crta__Collective_Agreement_Rule__c(
            crta__Collective_Agreement__c = agreementId,
            crta__Contract_Type__c = 'Permanent contract',
            crta__Contract_Status__c = '5',
            crta__Zone_Value_1__c = 'Zone1Value',
            crta__Zone_Value_2__c = 'Zone2Value',
            crta__Zone_Value_3__c = 'Zone3Value',
            crta__Zone_Value_4__c = 'Zone4Value',
            crta__Trial_Period_Duration_Months__c=2,
            crta__Renewal_Period_Months__c=3
            
            
        );
        insert rule;
        
        
        crta__Collective_Agreement_Rule__c rule1 = new crta__Collective_Agreement_Rule__c(
            crta__Collective_Agreement__c = agreementId,
            crta__Contract_Type__c = 'Fixed-term contract',
            crta__Contract_Status__c = '5',
            crta__Zone_Value_1__c = 'Zone1Value',
            crta__Zone_Value_2__c = 'Zone2Value',
            crta__Zone_Value_3__c = 'Zone3Value',
            crta__Zone_Value_4__c = 'Zone4Value',
            crta__Trial_Period_Duration_Months__c=2,
            crta__Renewal_Period_Months__c=3
        );
        insert rule1;
        
        
         Date startDate = Date.today();
         crta__Labor_contract__c contractFixedTerm = new crta__Labor_contract__c(
            crta__Start_Date__c = startDate,
            crta__End_Date__c = startDate.addDays(100),
            crta__Scheduled_End_Date__c = startDate.addDays(120),
            crta__Contract_Type__c = 'Fixed-term contract',
            crta__Status__c = '5',
            crta__Collective_Agreement__c = agreementId,
            crta__Zone_Value_1__c = 'Zone1Value',
            crta__Zone_Value_2__c = 'Zone2Value',
            crta__Zone_Value_3__c = 'Zone3Value',
            crta__Zone_Value_4__c = 'Zone4Value'
            // Ajoutez ici d'autres champs nécessaires
        );
        insert contractFixedTerm;
        
        
         crta__Labor_contract__c contractPermanent = new crta__Labor_contract__c(
            crta__Start_Date__c = startDate,
            crta__End_Date__c = startDate.addDays(365),
            crta__Scheduled_End_Date__c = startDate.addDays(380),
            crta__Contract_Type__c = 'Permanent contract',
            crta__Status__c = '5',
            crta__Collective_Agreement__c = agreementId,
            crta__Zone_Value_1__c = 'Zone1Value',
            crta__Zone_Value_2__c = 'Zone2Value',
            crta__Zone_Value_3__c = 'Zone3Value',
            crta__Zone_Value_4__c = 'Zone4Value'
            // Ajoutez ici d'autres champs nécessaires
        );
        insert contractPermanent;

    }

  /*  private static crta__Labor_contract__c createTestLaborContract(String contractType) {
        Date startDate = Date.today();

        crta__Labor_contract__c contract = new crta__Labor_contract__c(
            crta__Start_Date__c = startDate,
            crta__End_Date__c = startDate.addDays(365),
            crta__Scheduled_End_Date__c = startDate.addDays(380),
            crta__Contract_Type__c = contractType,
            crta__Status__c = '5',
            crta__Collective_Agreement__c = agreementId,
            crta__Zone_Value_1__c = 'Zone1Value',
            crta__Zone_Value_2__c = 'Zone2Value',
            crta__Zone_Value_3__c = 'Zone3Value',
            crta__Zone_Value_4__c = 'Zone4Value'
            // Ajoutez ici d'autres champs nécessaires
        );
        insert contract;
        contractId = contract.Id;
        return contract;
    }*/


    @IsTest
    static void testGetCurrentSituation() {
        // Création directe d'un contrat de travail de test
        /*crta__Labor_contract__c testContract = new crta__Labor_contract__c(
            crta__Start_Date__c = Date.today(),
            crta__End_Date__c = Date.today().addDays(30),
            crta__Scheduled_End_Date__c = Date.today().addDays(45),
            crta__Contract_Type__c = 'Permanent contract',
            crta__Status__c = testPerformContractCalculations'5',
            crta__Collective_Agreement__c = agreementId,
            crta__Collective_Agreement_Rule__c = ruleId
        );
        insert testContract;*/
         crta__Labor_contract__c  testContract =[SELECT Id,crta__Start_Date__c,crta__End_Date__c,crta__Contract_Type__c,crta__Status__c
                                                 FROM crta__Labor_contract__c WHERE crta__Contract_Type__c = 'Permanent contract'];      
        // Appel de la méthode à tester
        crta__Labor_contract__c result = CollectiveAgreementHelper.getCurrentSituation(testContract.Id);

        // Vérification que le résultat n'est pas null
        System.assertNotEquals(null, result, 'Le contrat retourné ne devrait pas être null.');

        // Vérification que l'identifiant du contrat retourné correspond à celui du contrat de test
        System.assertEquals(testContract.Id, result.Id, 'L\'identifiant du contrat retourné devrait correspondre à celui du contrat de test.');

        // Vérifications supplémentaires pour les autres champs si nécessaire
        System.assertEquals(testContract.crta__Start_Date__c, result.crta__Start_Date__c, 'La date de début devrait correspondre.');
        System.assertEquals(testContract.crta__End_Date__c, result.crta__End_Date__c, 'La date de fin devrait correspondre.');
        System.assertEquals(testContract.crta__Contract_Type__c, result.crta__Contract_Type__c, 'Le type de contrat devrait correspondre.');
        System.assertEquals(testContract.crta__Status__c, result.crta__Status__c, 'Le statut du contrat devrait correspondre.');

    }



    // Méthode de test pour getStatusPicklistValues
    @IsTest static void testGetStatusPicklistValues() {
        Map<String, String> picklistValues = CollectiveAgreementHelper.getStatusPicklistValues();
        System.assertNotEquals(null, picklistValues, 'Les valeurs picklist ne devraient pas être null.');
        // Assurez-vous que les valeurs attendues sont dans la map retournée
    }

    // Teste la validation avec tous les champs requis présents
    /*@IsTest static void testValidateRequiredFieldsWithAllFieldsPresent() {
        crta__Labor_contract__c contract = new crta__Labor_contract__c(
            crta__Start_Date__c = Date.today(),
            crta__Status__c = '5',
            crta__Contract_Type__c = 'Permanent contract',
            crta__Collective_Agreement__c = agreementId // Supposons que ceci est un ID valide
            // Assurez-vous que tous les autres champs requis par votre logique métier sont également initialisés
        );

        try {
            Test.startTest();
            CollectiveAgreementHelper.validateRequiredFields(contract);
            Test.stopTest();
            // Si aucune exception n'est levée, le test réussit pour ce scénario
        } catch (Exception e) {
            System.assert(false, 'Aucune exception ne devrait être levée lorsque tous les champs requis sont présents.');
        }
    }*/

    // Teste la validation avec des champs requis manquants
    @IsTest static void testValidateRequiredFieldsWithMissingFields() {
        crta__Labor_contract__c contract = new crta__Labor_contract__c(
            // Initialisation intentionnellement incomplète pour simuler des champs manquants
            crta__Status__c = '5'
            // Les champs crta__Start_Date__c, crta__Contract_Type__c, et crta__Collective_Agreement__c sont manquants
        );

        Boolean didThrowCorrectException = false;

        try {
            Test.startTest();
            CollectiveAgreementHelper.validateRequiredFields(contract);
            Test.stopTest();
        } catch (CollectiveAgreementHelper.CustomException e) {
            didThrowCorrectException = true;
            // Vérifiez que le message d'exception contient les informations attendues sur les champs manquants
            String expectedErrorMessage = 'Champs requis manquants'; // Adaptez ceci selon le message exact que vous attendez
            //System.assert(e.getMessage().contains(expectedErrorMessage), 'Le message d\'exception devrait indiquer les champs manquants.');
        }

        System.assert(didThrowCorrectException, 'Une CustomException devrait être levée en raison de champs manquants.');
    }

    @IsTest
    static void testApplyAgreementRuleToContract() {
        // Récupération de la règle d'accord collectif et du contrat de travail créés dans @TestSetup
        crta__Labor_contract__c contractSoql = [SELECT Id,crta__Status__c,crta__Contract_Type__c,crta__Zone_Value_1__c,
                                                      crta__Zone_Value_2__c,crta__Zone_Value_3__c,crta__Zone_Value_4__c
                                                From crta__Labor_contract__c WHERE  crta__Status__c = '5' AND crta__Zone_Value_1__c = 'Zone1Value' LIMIT 1];
        System.debug('le contrat ' + contractSoql);
        crta__Collective_Agreement__c collectiveagreement=[SELECT Id FROM crta__Collective_Agreement__c WHERE Name = 'Test Agreement' ];
        
        crta__Labor_contract__c contract = CollectiveAgreementHelper.getCurrentSituation(contractSoql.Id);
        crta__Collective_Agreement_Rule__c agreementRule = CollectiveAgreementHelper.getAgreementRule(collectiveagreement.Id, contractSoql);
        

        // Vérification préalable : la règle d'accord collectif n'est pas déjà appliquée au contrat
        System.assertNotEquals(agreementRule.Id, contract.crta__Collective_Agreement_Rule__c, 'La règle d\'accord collectif ne devrait pas être déjà appliquée.');

        // Application de la règle d'accord collectif au contrat
        Test.startTest();
        CollectiveAgreementHelper.applyAgreementRuleToContract(agreementRule, contract);
        Test.stopTest();

        // Mettre à jour le contrat dans la base de données pour enregistrer les modifications
        update contract;

        // Rechargement du contrat pour vérifier la mise à jour
        crta__Labor_contract__c updatedContract = [SELECT crta__Collective_Agreement_Rule__c FROM crta__Labor_contract__c WHERE Id = :contract.Id];
        
        // Vérification que la règle d'accord collectif a été correctement appliquée
        System.assertEquals(agreementRule.Id, updatedContract.crta__Collective_Agreement_Rule__c, 'La règle d\'accord collectif devrait être appliquée au contrat.');
    }




    @IsTest
    static void testPerformContractCalculations() {
        // Supposons que performContractCalculations appelle isCDD, calculateForCDD ou calculateForOtherContracts basé sur le type de contrat.
        // Créer un contrat CDD pour tester
        crta__Labor_contract__c cddContract =[SELECT Id,crta__Contract_Type__c,crta__Start_Date__c,crta__Scheduled_End_Date__c FROM crta__Labor_contract__c Where crta__Contract_Type__c='Fixed-term contract'];
        
        // Exécuter la méthode de calcul sur le contrat CDD
        Test.startTest();
        CollectiveAgreementHelper.performContractCalculations(cddContract);
        Test.stopTest();
        
        // Recharger le contrat de la base pour vérifier les résultats des calculs
        crta__Labor_contract__c updatedCDD = [SELECT Id, crta__End_Date_of_1st_Theoretical_Trial_Period__c FROM crta__Labor_contract__c WHERE Id = :cddContract.Id];
        
        // Vérifier les résultats des calculs
        System.assertNotEquals(null, updatedCDD.crta__End_Date_of_1st_Theoretical_Trial_Period__c, 'La date de fin de la première période d\'essai théorique pour un CDD devrait être calculée.');
        
        // Répétez pour d'autres types de contrats si nécessaire
    }


    @IsTest
    static void testIsCDD() {
        // Créer un contrat CDD
        crta__Labor_contract__c cddContract =[SELECT Id,crta__Contract_Type__c FROM crta__Labor_contract__c Where crta__Contract_Type__c='Fixed-term contract'];

        
        // Vérifier que isCDD retourne vrai pour un contrat CDD
        Boolean isCddResult = CollectiveAgreementHelper.isCDD(cddContract);
        System.assertEquals(true, isCddResult, 'isCDD devrait retourner vrai pour un contrat CDD.');
        
        // Créer un contrat CDI et répéter le test pour vérifier que isCDD retourne faux
         crta__Labor_contract__c cdiContract =[SELECT Id,crta__Contract_Type__c FROM crta__Labor_contract__c Where crta__Contract_Type__c='Permanent contract'];

        isCddResult = CollectiveAgreementHelper.isCDD(cdiContract);
        System.assertEquals(false, isCddResult, 'isCDD devrait retourner faux pour un contrat CDI.');
    }


    @IsTest
    static void testCalculateForCDD() {
        crta__Labor_contract__c cddContract =[SELECT Id,crta__Start_Date__c,crta__Scheduled_End_Date__c FROM crta__Labor_contract__c Where crta__Contract_Type__c='Fixed-term contract'];
  
        // Simuler des données spécifiques au CDD si nécessaire
        
        Test.startTest();
        CollectiveAgreementHelper.calculateForCDD(cddContract);
        Test.stopTest();
        
        // Assurez-vous que les champs calculés sont mis à jour comme attendu
    }
    
    
    @IsTest
    static void testCalculateForCDD2() {
        
        Contact testContact = new Contact(
        LastName = 'Test',
        FirstName = 'Employee'
        );
        insert testContact;
        
        crta__Labor_contract__c cddContract = new crta__Labor_contract__c();
        cddContract.crta__Start_Date__c = Date.newInstance(2024, 1, 1);
    	cddContract.crta__Scheduled_End_Date__c = Date.newInstance(2024, 7, 1);
        cddContract.crta__Employee__c = testContact.Id;
        insert cddContract;
  
        // Simuler des données spécifiques au CDD si nécessaire
        
        Test.startTest();
        CollectiveAgreementHelper.calculateForCDD(cddContract);
        Test.stopTest();

    }

    @IsTest
    static void testCalculateForOtherContracts() {
     crta__Labor_contract__c cdiContract =[SELECT Id,crta__Collective_Agreement__c,crta__Status__c,crta__Contract_Type__c,
                                           crta__Zone_Value_1__c,crta__Zone_Value_2__c,crta__Zone_Value_3__c,crta__Zone_Value_4__c,crta__Start_Date__c
                                           FROM crta__Labor_contract__c Where crta__Contract_Type__c='Permanent contract'];

        // Simuler des données spécifiques au CDI si nécessaire
        
        Test.startTest();
        CollectiveAgreementHelper.calculateForOtherContracts(cdiContract);
        Test.stopTest();
        
        // Assurez-vous que les champs calculés sont mis à jour comme attendu
    }


    @IsTest
    static void testUpdateContract() {
       crta__Labor_contract__c contractToUpdate =[SELECT Id FROM crta__Labor_contract__c Where crta__Contract_Type__c='Permanent contract'];

        // Modifier le contrat pour simuler un changement
        
        Test.startTest();
        CollectiveAgreementHelper.updateContract(contractToUpdate);
        Test.stopTest();
        
        // Recharger le contrat de la base pour vérifier la mise à jour
        crta__Labor_contract__c updatedContract = [SELECT Id, crta__Status__c FROM crta__Labor_contract__c WHERE Id = :contractToUpdate.Id];
        
        // Vérifier que la mise à jour a été effectuée correctement
    }

}