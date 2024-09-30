@IsTest
private class VisualisationEntretienController_Test {

    @IsTest
    private static void visualisationEntretienControllerTest() {
        EI__c options = new EI__c(ReviewBlocksOrder__c ='1|2|3|5|6|4|7|8');
        insert options;

        contact c = new contact(lastname='zaza') ;
        insert c;

        Skill__c co = new Skill__c(name='comp');
        insert co ;

        EI_Modele_d_entretien__c me1 = new EI_Modele_d_entretien__c(name='me1');
        insert me1 ;

        EI_Modele_d_entretien__c me2 = new EI_Modele_d_entretien__c(name='me2');
        insert me2 ;

        EI_competence_a_evaluer__c ce1 = new EI_competence_a_evaluer__c(GS_Competence__c=co.Id, 
                EI_Modele_entretien__c= me1.Id);
        insert ce1 ;

        EI_competence_a_evaluer__c ce2 = new EI_competence_a_evaluer__c(GS_Competence__c=co.Id, 
                EI_Modele_entretien__c= me2.Id);
        insert ce2 ;


        // On insert un entretien
        EI_entretien__c e = new EI_entretien__c(EI_salarie_qui_passe_l_entretien__c=c.Id,
                EI_statut__c='20 Programmé',EI_Modele_d_entretien__c= me1.Id);
        insert e;
        EI_ligne_objectif__c o1 = new EI_ligne_objectif__c (EI_entretien__C=e.Id, EI_Ponderation_d_objectifs__c=50);
        insert o1;
        EI_ligne_competence__c lc1 = new EI_ligne_competence__c(IE_Modele_d_entretiens_Item__c=ce1.Id, 
                IE_Entretien__c=e.Id);
        insert lc1;

        // On insert un entretien
        EI_entretien__c e1 = new EI_entretien__c(EI_salarie_qui_passe_l_entretien__c=c.Id, 
                EI_statut__c='20 Programmé', EI_Modele_d_entretien__c= me1.Id);
        insert e1;
        System.assertEquals('20 Programmé', e1.EI_statut__c);
        e1.EI_statut__c='50 réalisé';
        System.assertEquals('50 réalisé', e1.EI_statut__c);
        update e1;
        EI_ligne_objectif__c o2 = new EI_ligne_objectif__c(EI_entretien__C = e1.Id, 
                EI_Ponderation_d_objectifs__c = 50);
        insert o2;
		System.assertEquals(50, o2.EI_Ponderation_d_objectifs__c);
        String order = '1|2|3|5|6|4|7|8';
        String skillUpdate = '{"id":"'+lc1.Id+'", "eval":"Acquise", "comment":"", "isManager":"0"}';
        String skillUpdate2 = '{"id":"'+lc1.Id+'", "eval":"Acquise", "comment":"", "isManager":"1"}';
        String pastUpdate = '{"id":"'+o1.Id+'", "eval":"Acquise", "comment":"", "isManager":"0"}';
        String pastUpdate2 = '{"id":"'+o1.Id+'", "eval":"Acquise", "comment":"", "isManager":"1"}';
        String futureUpdate = '{"id":"'+o1.Id+'", "weighting":"50", "description":"Test", "description":"none"}';

        PageReference pg = Page.VisualisationEntretien;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', e.Id);
        pg.getParameters().put('apercu', '1');

        VisualisationEntretienController.updateOrder(order);
        VisualisationEntretienController.updateSkill(skillUpdate);
        VisualisationEntretienController.updateSkill(skillUpdate2);
        VisualisationEntretienController.updatePastObjective(pastUpdate);
        VisualisationEntretienController.updatePastObjective(pastUpdate2);
        VisualisationEntretienController.updateFutureObjective(futureUpdate);

        VisualisationEntretienController controller=new VisualisationEntretienController();
        controller.objIdToDel = o1.Id;
        controller.skillIdToDel = lc1.Id;

        controller.addObjective()  ;
        controller.upload();

        controller.delAttachment(); 
        controller.delSkill();
        controller.delObjective();
    }
}