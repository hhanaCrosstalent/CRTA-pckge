@IsTest
private class VisualisationTimelineController_test {

    @IsTest 
    private static void VisualisationTimelineController() {
        Contact contact1 = new contact(
                Lastname='BAYER',
                Firstname = 'Valérie'
                );
        insert contact1;

        VisualisationTimelineController_test.insertInterview(contact1);
        VisualisationTimelineController_test.insertTraining(contact1);
        VisualisationTimelineController_test.insertTrainingActions(contact1);
        VisualisationTimelineController_test.insertExpenses(contact1);
        VisualisationTimelineController_test.insertTimesheets(contact1);
        Sirh__c options = new sirh__c(
                ShowInterviews__c = true, 
                ShowTrainings__c = true, 
                ShowTimes__c = true,
                ShowExpenses__c = true
                );
        insert options;

        //instantiate a page     
        PageReference pg = Page.VisualisationTimeline;
        Test.setCurrentPage(pg);

        // instantiate the controller
        VisualisationTimelineController controller = new VisualisationTimelineController();
        VisualisationTimelineController.finishJoyride();

        System.assertEquals(2, controller.entretiens.size());
      	//  System.assertEquals(2, controller.registrations.size());
        System.assertEquals(1, controller.formations.size());
        System.assertEquals(1, controller.weeks.size());
        System.assertEquals(1, controller.expenses.size());
      //  System.assertEquals(7, controller.dateToObject.size());
    }

    private static void insertInterview(Contact contact1) {
        Skill__c competence1 = new Skill__c(name='comp');
        insert competence1 ; 

        EI_Modele_d_entretien__c modele1 = new EI_Modele_d_entretien__c(name='modele1');
        insert modele1 ; 

        EI_Modele_d_entretien__c modele2 = new EI_Modele_d_entretien__c(name='modele2');
        insert modele2 ; 

        EI_competence_a_evaluer__c skillEval1 = new EI_competence_a_evaluer__c(
                GS_Competence__c=competence1.Id, 
                EI_Modele_entretien__c= modele1.Id
                );
        insert skillEval1 ; 

        EI_competence_a_evaluer__c skillEval2 = new EI_competence_a_evaluer__c(
                GS_Competence__c=competence1.Id, 
                EI_Modele_entretien__c= modele2.Id
                );  
        insert skillEval2 ; 

        Date today = System.today();

        // On insert un entretien
        EI_entretien__c entretien1 = new EI_entretien__c (
                EI_salarie_qui_passe_l_entretien__c=contact1.Id,
                EI_statut__c='20 Programmé',
                EI_Modele_d_entretien__c= modele1.Id,
                EI_Date_de_l_entretien__c = today-1
                );
        insert entretien1;
        EI_ligne_objectif__c objectif1 = new EI_ligne_objectif__c (
                EI_entretien__C=entretien1.Id, 
                EI_Ponderation_d_objectifs__c=50
                );
        insert objectif1;

        // On insert un entretien
        EI_entretien__c entretien2 = new EI_entretien__c (
                EI_salarie_qui_passe_l_entretien__c=contact1.Id,
                EI_statut__c='20 Programmé',
                EI_Modele_d_entretien__c= modele1.Id,
                EI_Date_de_l_entretien__c = today+7
                );
        insert entretien2;
        entretien2.EI_statut__c='50 réalisé';
        update entretien2;

        EI_ligne_objectif__c objectif2 = new EI_ligne_objectif__c (
                EI_entretien__C=entretien2.Id, 
                EI_Ponderation_d_objectifs__c=50
                );
        insert objectif2;
    }

    private static void insertTrainingActions(Contact contact1) {
        Organisme_de_formation__c org = new Organisme_de_formation__c(
                FO_Contact__c = 'Collab'
                );
        insert org;

        FO_catalogue_de_formation__c m = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Test 1',
                FO_Lieu__c = 'Lieu 1',
                FO_Type__c = 'Technique',
                FO_Formateur__c = contact1.Id,
                FO_Organisme_de_formation__c = org.Id,
            	crta__Active__c = true
                );
        insert m;

        Action_de_formation__c a = new Action_de_formation__c(
                Contact__c = contact1.Id,
                Catalogue_de_formation__c = m.Id
                );
        insert a;

        FO_Session_collective__c s = new FO_Session_collective__c(
                Catalogue_de_formation__c = m.Id,
                FO_Date_et_heure_de_debut__c = System.now(),
                FO_Date_et_heure_de_fin__c = System.now().addHours(1)
                );
        insert s;
        FO_Session_collective__c s2 = new FO_Session_collective__c(
                Catalogue_de_formation__c = m.Id,
                FO_Date_et_heure_de_debut__c = System.now().addDays(1),
                FO_Date_et_heure_de_fin__c = System.now().addDays(1).addHours(1)
                );
        insert s2;

        Participation_session_formation__c p = new Participation_session_formation__c(
                Action_de_formation__c = a.Id,
                Session_de_formation__c = s.Id
                );
        insert p;
        Participation_session_formation__c p2 = new Participation_session_formation__c(
                Action_de_formation__c = a.Id,
                Session_de_formation__c = s2.Id
                );
        insert p2;
    }


    private static void insertTimesheets(Contact contact1) {
        Date today = System.today();
        Feuille_Temps_Hebdo__c week1 = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = today-14,
                Date_de_fin__c = today-8,
                Numero_de_semaine__c = 48,
                Salarie__c = contact1.Id,
                Statut__c = '10 Déclaration en cours'
                );
        insert week1;
    }

    private static void insertTraining(Contact contact1) {
        Date today = System.today();
        FO_catalogue_de_formation__c module1 = new FO_catalogue_de_formation__c(
                FO_Nom_de_la_formation__c = 'Déploiement Salesforce',
                FO_Type__c = 'Technique',
                FO_Duree__c = '6h',
                FO_Lieu__c = 'Paris',
                FO_Diplomante__c = true
                );
        insert module1;

        Formation__c form1 = new Formation__c(
                CT_Candidate__c = contact1.Id,
                CT_Start_date__c = today - 20,
                FO_Catalogue_de_formation__c = module1.Id
                );
        insert form1;
    }

    private static void insertExpenses(Contact contact1) {
        Date today = System.today();
        Note_de_frais__c expenses = new Note_de_frais__c(
                Date_de_debut__c = today,
                Date_de_fin__c = today.addDays(1),
                Salarie__c = contact1.Id
                );
        insert expenses;

        Frais__c expenseLine = new Frais__c(
                Note_de_frais__c = expenses.Id,
                Salarie__c = contact1.Id,
                Date__c = today,
                Montant__c = 25.02,
                Type__c = 'Transport'
                );
        insert expenseLine;
    }
}