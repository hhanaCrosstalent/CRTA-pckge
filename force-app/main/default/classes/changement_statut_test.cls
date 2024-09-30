@IsTest
public class changement_statut_test {

    @IsTest
    private static void test() {

        Contact c = new Contact(Lastname='zaza') ;
        insert c;

        Skill__c co = new Skill__c(Name='comp');
        insert co;

        EI_Modele_d_entretien__c me1 = new EI_Modele_d_entretien__c(Name='me1');
        insert me1;

        EI_Modele_d_entretien__c me2 = new EI_Modele_d_entretien__c(Name='me2');
        insert me2;

        EI_competence_a_evaluer__c ce1 
            = new EI_competence_a_evaluer__c(GS_Competence__c=co.id, EI_Modele_entretien__c= me1.id);
        insert ce1 ;

        EI_competence_a_evaluer__c ce2 
            = new EI_competence_a_evaluer__c(GS_Competence__c=co.id, EI_Modele_entretien__c= me2.id);
        insert ce2 ;

        EI_entretien__c e 
            = new EI_entretien__c(EI_salarie_qui_passe_l_entretien__c=c.Id,
                                EI_statut__c='20 Programmé',
                                EI_Modele_d_entretien__c= me1.Id);
        insert e;

        e.EI_statut__c = '50 Réalisé';
        e.EI_Modele_d_entretien__c = me2.Id;
        update e;

        e.EI_statut__c = '20 Programmé';
        e.EI_Modele_d_entretien__c = me1.Id;
        update e;

        update e;
        
        System.assertEquals(e.EI_statut__c, '20 Programmé');
        System.assert(e != null);
    }
}