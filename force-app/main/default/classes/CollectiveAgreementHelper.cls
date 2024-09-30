public class CollectiveAgreementHelper {
    // Récupère les détails d'un contrat spécifique en utilisant son ID
    public static crta__Labor_contract__c getCurrentSituation(String recordId) {
        // Requête SOQL pour récupérer les détails du contrat
        return [
            SELECT Id,
                crta__Company__c,
                crta__Company__r.crta__Collective_Agreement__c,
                crta__Start_Date__c,
                crta__End_Date__c,
                crta__Scheduled_End_Date__c,
                crta__Collective_Agreement__c,
                crta__Collective_Agreement_Rule__c,
                crta__Actual_End_Date_of_1st_Trial_Period__c,
                crta__End_Date_of_1st_Revised_Trial_Period__c,
                crta__End_Date_of_1st_Theoretical_Trial_Period__c,
                crta__End_Date_of_2nd_Theoretical_Trial_Period__c,
                crta__Contract_Type__c,
                crta__Status__c,
                crta__Zone_Value_1__c,
                crta__Zone_Value_2__c,
                crta__Zone_Value_3__c,
                crta__Zone_Value_4__c
            FROM crta__Labor_contract__c
            WHERE Id =: recordId
            LIMIT 1
        ];
    }

    // Récupère une règle d'accord collectif basée sur l'ID de l'accord et des critères spécifiques au contrat
    public static crta__Collective_Agreement_Rule__c getAgreementRule(
        String collectiveAgreementId,
        crta__Labor_contract__c contract
    ) {
        if (String.isBlank(collectiveAgreementId)) {
            throw new AuraHandledException(System.Label.No_Collective_Agreement);
        }

        // Obtenez le nom de la convention collective à partir de son ID
        crta__Collective_Agreement__c collectiveAgreement = [SELECT Name FROM crta__Collective_Agreement__c WHERE Id = :collectiveAgreementId LIMIT 1];
        
        // Préparation de la requête SOQL pour trouver une règle d'accord correspondant aux critères
        List<crta__Collective_Agreement_Rule__c> agreementRules = [
            SELECT Id, 
                crta__Contract_Status__c,
                crta__Collective_Agreement__c,
                crta__Trial_Period_Duration_Months__c, 
                crta__Renewal_Period_Months__c
            FROM crta__Collective_Agreement_Rule__c 
            WHERE crta__Collective_Agreement__c =: collectiveAgreementId
            AND crta__Contract_Status__c =: contract.crta__Status__c
            AND crta__Contract_Type__c =: contract.crta__Contract_Type__c
            AND crta__Zone_Value_1__c =: contract.crta__Zone_Value_1__c
            AND crta__Zone_Value_2__c =: contract.crta__Zone_Value_2__c
            AND crta__Zone_Value_3__c =: contract.crta__Zone_Value_3__c
            AND crta__Zone_Value_4__c =: contract.crta__Zone_Value_4__c
            LIMIT 1
        ];

        if (agreementRules.isEmpty() && !isCDD(contract)) {
            // Utilisation des métadonnées pour récupérer le libellé du statut du contrat
            Map<String, String> statusLabels = getStatusPicklistValues();
            String statusLabel = statusLabels.get(contract.crta__Status__c); // Obtenez le libellé du statut du contrat

            String errorMessage = System.Label.Aucune_regle_d_accord_trouvee+ ' ' +
                System.Label.Status + ': ' + (statusLabel != null ? statusLabel : 'Unknown') + ', ' +
                System.Label.Type_de_contrat + ': ' + contract.crta__Contract_Type__c + ', ' +
                'Zone 1: ' + contract.crta__Zone_Value_1__c + ', ' +
                'Zone 2: ' + contract.crta__Zone_Value_2__c + ', ' +
                'Zone 3: ' + contract.crta__Zone_Value_3__c + ', ' +
                'Zone 4: ' + contract.crta__Zone_Value_4__c;
            System.debug(errorMessage);
            throw new CustomException(errorMessage);
        } else if (!agreementRules.isEmpty()) {
            return agreementRules[0];
        }

        return null;
    }

    // Méthode pour récupérer la valeur de la picklist status du contrat pour l'affichage dans l'exception de la méthode getAgreementRule()
    public static Map<String, String> getStatusPicklistValues() {
        Map<String, String> statusValues = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = crta__Labor_contract__c.crta__Status__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            statusValues.put(entry.getValue(), entry.getLabel());
        }
        return statusValues;
    }


    // Vérifie que tous les champs requis sont présents avant de procéder aux calculs
    public static void validateRequiredFields(crta__Labor_contract__c contract) {
        List<String> missingFields = new List<String>();
        
        // Vérification des champs obligatoires pour tous types de contrats.
        if (contract.crta__Collective_Agreement__c == null) missingFields.add(System.Label.Accord_collectif);
        if (contract.crta__Start_Date__c == null) missingFields.add(System.Label.Date_de_d_but);
        if (contract.crta__Status__c == null) missingFields.add(System.Label.Status);
        
        if (contract.crta__Contract_Type__c == null) {
            missingFields.add(System.Label.Type_de_contrat);
        } else {
            // Conditions supplémentaires pour les contrats CDD.
            //if ('Fixed-term contract'.equals(contract.crta__Contract_Type__c) && contract.crta__Scheduled_End_Date__c == null) {
            if (isCDD(contract) && contract.crta__Scheduled_End_Date__c == null) {
                missingFields.add(System.Label.Date_de_fin_previsionnelle);
            }
        }
        
        if (!missingFields.isEmpty()) {
            throw new CustomException(System.Label.Champs_requis_manquants + ' ' + String.join(missingFields, ', '));
        }
    }
    
    // Affecte la règle d'accord collectif sélectionnée au contrat
    public static void applyAgreementRuleToContract(crta__Collective_Agreement_Rule__c agreementRule, crta__Labor_contract__c contract) {
        if(agreementRule != null) {
        	contract.crta__Collective_Agreement_Rule__c = agreementRule.Id;    
        }
    }
    
    // Effectue des calculs spécifiques en fonction du type de contrat
    public static void performContractCalculations(crta__Labor_contract__c contract) {
        if (isCDD(contract)) {
            calculateForCDD(contract);
        } else {
            calculateForOtherContracts(contract);
        }
    }
    
    // Détermine si le contrat est un CDD en se basant sur les paramètres de l'organisation
    public static boolean isCDD(crta__Labor_contract__c contract) {
        Contract_Type_CDD_Setting__c cddSettings = Contract_Type_CDD_Setting__c.getOrgDefaults();
        String cddTypeValue = String.isNotBlank(cddSettings.CDD_API_Name__c) ? cddSettings.CDD_API_Name__c : 'Fixed-term contract';
        return contract.crta__Contract_Type__c.equals(cddTypeValue);
    }

    /*public static void calculateForCDD(crta__Labor_contract__c contract) {
        Integer periodInMonths = contract.crta__Start_Date__c.monthsBetween(contract.crta__Scheduled_End_Date__c); 
        periodInMonths = 6
        if (periodInMonths <= 6) {
            Integer numberOfWeeks = contract.crta__Start_Date__c.daysBetween(contract.crta__Scheduled_End_Date__c) / 7;
            // Ajoute une semaine si le reste de la division est supérieur à zéro
            if (Math.mod(contract.crta__Start_Date__c.daysBetween(contract.crta__Scheduled_End_Date__c), 7) > 0) {
                numberOfWeeks += 1; 
            }
            // Limite le nombre de semaines à 14 pour la période d'essai
            if (numberOfWeeks > 14) {
                numberOfWeeks = 14;
            }
            // Calcule et affecte la date de fin de la première période d'essai théorique
            contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = contract.crta__Start_Date__c.addDays(numberOfWeeks).addDays(-1);
        } else {
            // Pour les CDD de plus de 6 mois, fixe une période d'essai théorique à un mois
            contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = contract.crta__Start_Date__c.addMonths(1).addDays(-1);
        }
        updateContract(contract);
    }*/

    public static void calculateForCDD(crta__Labor_contract__c contract) {
    Date startDate = contract.crta__Start_Date__c;
    Date endDate = contract.crta__Scheduled_End_Date__c;

    // Calcule la différence en mois et en jours
    Integer periodInMonths = startDate.monthsBetween(endDate);
    Date dateAfterPeriodInMonths = startDate.addMonths(periodInMonths);
    Integer daysAfterPeriodInMonths = dateAfterPeriodInMonths.daysBetween(endDate);

    // Ajuste la période en fonction de la durée totale
    if (periodInMonths > 6 || (periodInMonths == 6 && daysAfterPeriodInMonths > 0)) {
        // Pour les périodes supérieures à 6 mois, fixe la période d'essai à 1 mois - 1 jour
        contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = startDate.addMonths(1).addDays(-1);
    } else {
        Integer daysBetween = startDate.daysBetween(endDate) + 1 ;
        System.debug('ls jours entre les deux' + daysBetween);
        Integer numberOfWeeks = daysBetween / 7;
        System.debug('le nombre de semaine' + numberOfWeeks);

        // Calcule la date de fin de la période d'essai en fonction du nombre de semaines
        if (numberOfWeeks > 14) {
            // Limite à 14 semaines
            System.debug('je suis la ');
            contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = startDate.addDays(13);
        } else {
            // Utilise le nombre de semaines réel
            contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = startDate.addDays(numberOfWeeks - 1);
        }
    }

    // Mise à jour du contrat avec la période d'essai théorique calculée
    updateContract(contract);
}








    
    // Calcule les dates pour les autres types de contrats en utilisant les règles d'accord collectif
    public static void calculateForOtherContracts(crta__Labor_contract__c contract){
        crta__Collective_Agreement_Rule__c agreementRule = getAgreementRule(
            contract.crta__Collective_Agreement__c, contract
        );
    
        if (agreementRule != null && contract.crta__Start_Date__c != null) {
            Integer firstDuration;
            if (agreementRule.crta__Trial_Period_Duration_Months__c != null) {
                firstDuration = Integer.valueOf(agreementRule.crta__Trial_Period_Duration_Months__c);
                contract.crta__End_Date_of_1st_Theoretical_Trial_Period__c = contract.crta__Start_Date__c.addMonths(firstDuration).addDays(-1);
            } else {
                throw new CustomException(System.Label.Trial_Period_Duration_is_required);
                //throw new CustomException('Veuillez saisir une valeur durée période d\'essai initiale sur la régle de convention à partir de 0');
            }
            
            if(agreementRule.crta__Renewal_Period_Months__c != null) {
                Integer secondDuration = Integer.valueOf(agreementRule.crta__Renewal_Period_Months__c);
                contract.crta__End_Date_of_2nd_Theoretical_Trial_Period__c = contract.crta__Start_Date__c.addMonths(firstDuration + secondDuration).addDays(-1);
            } else {
                throw new CustomException(System.Label.Renewal_Period_is_required);
                //throw new CustomException('Veuillez saisir une valeur sur la régle de convention durée période d\'essai renouvelée à partir de 0');
            }

    
            updateContract(contract);
        } else {
            throw new CustomException(System.Label.ContractDateCalculationError);
        }
    }

    // Met à jour le contrat avec les nouvelles valeurs calculées
    public static void updateContract(crta__Labor_contract__c contract) {
        try {
            update contract;
        } catch (DmlException e) {
            throw new CustomException(System.Label.Erreur_mise_jour_contrat + ' ' + e.getMessage());
        }
    }
    
    // Classe d'exception personnalisée pour gérer les erreurs spécifiques
    public class CustomException extends Exception {}
}