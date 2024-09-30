@isTest
private class LookupFieldControllerTest {
	@IsTest
    private static void testAll() {
        Account account = BrainHRDataFactory.newAccount();
        insert account;
		Id recordTypeAccountHierarchical = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Hierarchical').getRecordTypeId();
        Account accountHierarchical = BrainHRDataFactory.newAccount();
        accountHierarchical.RecordtypeId = recordTypeAccountHierarchical;
        insert accountHierarchical;
        
        Contact manager = new Contact(AccountId = account.Id, LastName = 'Manager');
        insert manager;

        Contact employee = new Contact(AccountId = account.Id, LastName = 'employee');
        insert employee;
        
        System.assertEquals(manager.LastName, 'Manager');
        System.assertEquals(employee.LastName, 'employee');
        System.assertEquals(account.Name, 'AccountTest');

        crta__GS_Fiche_de_poste__c fiche = new crta__GS_Fiche_de_poste__c(Name = 'test');
        insert fiche;
        
        crta__GS_Poste_Competence__c jobSkill1 = new crta__GS_Poste_Competence__c(crta__GS_Fiche_de_poste__c = fiche.Id);
        insert jobSkill1;
        crta__GS_Poste_Competence__c jobSkill2 = new crta__GS_Poste_Competence__c(crta__GS_Fiche_de_poste__c = fiche.Id);
        insert jobSkill2;
        
        crta__GS_Affectation_poste__c affectation = new crta__GS_Affectation_poste__c(crta__GS_Fiche_de_poste__c = fiche.Id,
                                                                                     crta__GS_Salarie__c = employee.Id,
                                                                                     crta__GS_Date_de_debut__c = system.today(),
                                                                                     crta__Hierarchical_Account__c = accountHierarchical.Id);
        insert affectation;
        
        crta__EI_Modele_d_entretien__c model = new crta__EI_Modele_d_entretien__c(Name ='TESTING');
        insert model;
        
        crta__EI_competence_a_evaluer__c skillToEvl1 = new crta__EI_competence_a_evaluer__c(crta__EI_Modele_entretien__c = model.Id);
        insert skillToEvl1;
        crta__EI_competence_a_evaluer__c skillToEvl2 = new crta__EI_competence_a_evaluer__c(crta__EI_Modele_entretien__c = model.Id);
        insert skillToEvl2;
        
         crta__EI_Entretien__c perfReview = new crta__EI_Entretien__c(
            crta__EI_Salarie_qui_passe_l_entretien__c = employee.Id,
            crta__EI_Salarie_qui_fait_passer_l_entretien__c = manager.Id,
            crta__EI_Modele_d_entretien__c = model.Id,
            crta__EI_Date_de_l_entretien__c = system.today()
        );
        insert perfReview;
        
       
        LookupFieldController.getSobjectList('Contact', 'AccountId', 'Name', null, null, '');
        LookupFieldController.getRecordAutocomplete('Cros','AccountId','Contact','Name', null,false);
        LookupFieldController.getJobDescription(perfReview.crta__EI_Salarie_qui_passe_l_entretien__c, perfReview.crta__EI_Date_de_l_entretien__c);
        LookupFieldController.getReview(perfReview.Id);
        LookupFieldController.getSobjectList('crta__EI_ligne_competence__c', 'crta__IE_Modele_d_entretiens_Item__r.Name', 'crta__IE_Modele_d_entretiens_Item__r.Name', '', perfReview.Id,'');
        LookupFieldController.getSobjectList('crta__GS_Poste_Competence__c', 'crta__GS_Competence__r.Name', 'crta__GS_Competence__r.Name', '', perfReview.Id,'');
    }
}