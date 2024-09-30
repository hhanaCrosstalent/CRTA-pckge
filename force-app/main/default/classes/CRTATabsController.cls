/*
 * Nouha MADDEH 03/06/2024 
 * Récupérer le composant TAMTabs depuis demov3ct et le copier dans TAM suite à une demande de abdelkader
 * 
 * */
public class CRTATabsController {

    
      @AuraEnabled
    public static Map<String, Map<String, String>> getTranslationsCtrl1() {
        Map<String, Map<String, String>> labelsMap = new Map<String, Map<String, String>>();
        List<String> initList = new List<String>();

        labelsMap.put('crta__GS_Fiche_de_poste__c', LightningHelperbis.getTranslationMap(crta__GS_Fiche_de_poste__c.SObjectType, initList));
        labelsMap.put('crta__GS_Affectation_poste__c', LightningHelperbis.getTranslationMap(crta__GS_Affectation_poste__c.SObjectType, initList));
        labelsMap.put('crta__Collective_Agreement__c', LightningHelperbis.getTranslationMap(crta__Collective_Agreement__c.SObjectType, initList));
        labelsMap.put('crta__Collective_Agreement_Rule__c', LightningHelperbis.getTranslationMap(crta__Collective_Agreement_Rule__c.SObjectType, initList));
        labelsMap.put('crta__Medical_Examination_Center__c', LightningHelperbis.getTranslationMap(crta__Medical_Examination_Center__c.SObjectType, initList));
        labelsMap.put('crta__Equipment_Catalogue__c', LightningHelperbis.getTranslationMap(crta__Equipment_Catalogue__c.SObjectType, initList));
        labelsMap.put('crta__Article__c', LightningHelperbis.getTranslationMap(crta__Article__c.SObjectType, initList));
        labelsMap.put('crta__Dossier_documentaire__c', LightningHelperbis.getTranslationMap(crta__Dossier_documentaire__c.SObjectType, initList));
        labelsMap.put('crta__BDU_Data_Accidents_du_travail__c', LightningHelperbis.getTranslationMap(crta__BDU_Data_Accidents_du_travail__c.SObjectType, initList));
        labelsMap.put('crta__BDU_Data_Accidents_du_travail__c', LightningHelperbis.getTranslationMap(crta__BDU_Data_Accidents_du_travail__c.SObjectType, initList));
        labelsMap.put('crta__BDU_Data_M_decine_du_travail__c', LightningHelperbis.getTranslationMap(crta__BDU_Data_M_decine_du_travail__c.SObjectType, initList));	
		labelsMap.put('crta__Bank_Account__c', LightningHelperbis.getTranslationMap(crta__Bank_Account__c.SObjectType, initList));
        labelsMap.put('crta__Vehicle__c', LightningHelperbis.getTranslationMap(crta__Vehicle__c.SObjectType, initList));
        labelsMap.put('crta__Equipment__c', LightningHelperbis.getTranslationMap(crta__Equipment__c.SObjectType, initList));
        
        labelsMap.put('crta__Habilitation__c', LightningHelperbis.getTranslationMap(crta__Habilitation__c.SObjectType, initList));
        labelsMap.put('crta__Employee_Number_Generator__c', LightningHelperbis.getTranslationMap(crta__Employee_Number_Generator__c.SObjectType, initList));


        return labelsMap;
    }
    
}