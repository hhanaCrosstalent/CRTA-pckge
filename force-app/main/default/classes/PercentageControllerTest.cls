@isTest
public with sharing class PercentageControllerTest {
    @isTest
    static void PercentageControllerTest() {
        crta__EI_Entretien__c entr = [select Id from crta__EI_Entretien__c LIMIT 1];
        PercentageController.findOrderPercentage('crta__EI_Entretien__c', 'crta__EI_Statut__c', entr.Id);

    }


    @TestSetup
    static void makeData(){
          Contact c = new Contact(LastName = 'Collab');
        insert c;
        crta__EI_Entretien__c entr = new crta__EI_Entretien__c(crta__EI_Salarie_qui_fait_passer_l_entretien__c=c.Id,
        crta__EI_Salarie_qui_passe_l_entretien__c=c.Id, crta__EI_Date_de_l_entretien__c=DateTime.newInstance(2006, 3, 16, 12, 6, 13),
                                                               crta__EI_Statut__c='40 En cours');
        insert entr;
    }
}