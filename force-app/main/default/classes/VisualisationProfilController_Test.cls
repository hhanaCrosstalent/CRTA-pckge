@IsTest
private class VisualisationProfilController_Test {

    @IsTest
    private static void VisualisationProfilController() {
        Contact c = new Contact(Lastname='zaza');
        insert c;

        contact c2 = new contact(Lastname='toto', Responsable_RH__c = c.Id, ReportsToId = c.Id);
        insert c2;

        Skill__c co = new Skill__c(name='comp');
        insert co;

        EI_Modele_d_entretien__c me1 = new EI_Modele_d_entretien__c(Name='me1');
        insert me1;

        EI_Modele_d_entretien__c me2 = new EI_Modele_d_entretien__c(Name='me2');
        insert me2;

        EI_competence_a_evaluer__c ce1 = new EI_competence_a_evaluer__c(GS_Competence__c=co.id, 
                EI_Modele_entretien__c= me1.Id);
        insert ce1 ; 

        EI_competence_a_evaluer__c ce2 = new EI_competence_a_evaluer__c(GS_Competence__c = co.Id, 
                EI_Modele_entretien__c = me2.Id);
        insert ce2;

        // On insert un entretien
        EI_entretien__c e = new EI_entretien__c (EI_salarie_qui_passe_l_entretien__c=c.Id, 
                EI_salarie_qui_fait_passer_l_entretien__c = c2.Id,
                EI_statut__c = '20 Programmé',
                EI_Modele_d_entretien__c = me1.Id);
        insert e;
        System.assertEquals('20 Programmé', e.EI_statut__c);
        EI_ligne_objectif__c o1 = new EI_ligne_objectif__c(EI_entretien__C=e.Id, EI_Ponderation_d_objectifs__c=50);
        insert o1;
        System.assertEquals(50, o1.EI_Ponderation_d_objectifs__c);
        Demande_de_conges__c leave = new Demande_de_conges__c(Salarie__c=c2.Id, Date_de_debut__c=System.now(), 
                Date_de_fin__c = System.now().addDays(1));
        insert leave;

        PageReference pg = Page.VisualisationProfil;
        pg.getParameters().put('id', c2.Id);
        Test.setCurrentPage(pg);

        VisualisationProfilController controller=new VisualisationProfilController();
        controller.getLeaveTypes();
        controller.getLeavePeriods();
    }
}