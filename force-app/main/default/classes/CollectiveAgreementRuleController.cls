public without sharing class CollectiveAgreementRuleController {

    // Méthode principale pour calculer et mettre à jour les dates du contrat basées sur l'accord collectif
    @AuraEnabled
    public static String calculDates(String recordId) {
        String result = '';
        try {
            crta__Labor_contract__c currentSituation = CollectiveAgreementHelper.getCurrentSituation(recordId);
            CollectiveAgreementHelper.validateRequiredFields(currentSituation);

            String collectiveAgreementId = currentSituation.crta__Collective_Agreement__c;

            
            crta__Collective_Agreement_Rule__c agreementRule = CollectiveAgreementHelper.getAgreementRule(collectiveAgreementId, currentSituation);
            CollectiveAgreementHelper.applyAgreementRuleToContract(agreementRule, currentSituation);
            
            
            CollectiveAgreementHelper.performContractCalculations(currentSituation);
            CollectiveAgreementHelper.updateContract(currentSituation);

            return '1';} catch (CollectiveAgreementHelper.CustomException e) { return e.getMessage();} catch (Exception e) { return System.Label.System_Error;
        }
    }
    
}