@IsTest
private class BduController_test {

    @IsTest
    private static void all() {
        
        Override__c over = new Override__c(CT_nbIndic__c = 5);
        insert over;

        ShowOptions__c opt = new ShowOptions__c(ShowEmptyIndicateur__c = true);
        insert opt;

        BDU_Chapitre__c chapitre = new BDU_Chapitre__c(
            Name='Données sociales',
            CT_Order__c = 1
        );
        insert chapitre;

        BDU_Domaine__c domaine = new BDU_Domaine__c(
            Name='Emploi',
            CT_BDU_Chapitre__c = chapitre.Id,
            CT_Affiche__c = true,
            CT_Slug__c = 'emploi'
        );
        BDU_Domaine__c domaine2 = new BDU_Domaine__c(
            Name='Social',
            CT_BDU_Chapitre__c = chapitre.Id,
            CT_Affiche__c = true,
            CT_Slug__c = 'social'
        );
        insert domaine;
        insert domaine2;

        BDU_Indicateur__c indic = new BDU_Indicateur__c(
            Name = 'Effectif total au 31/12 (tous salariés)',
            CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
            CT_Article__c = 'Art.R.2323-17',
            CT_BDU_Domaine__c = domaine.Id,
            CT_Code__c = 'IND01101',
            CT_Code_Applicable__c = 'Code du travail',
            CT_Description__c = 'Par catégorie et par sexe.             1 salarié compte 1, quel que soit son temps de travail.          CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
            CT_Emplacement__c = 'Bilan Social',
            CT_Affiche__c = true
        );
        BDU_Indicateur__c indic2 = new BDU_Indicateur__c(
            Name = 'Effectif total au 31/12 (Uniqument CDD)',
            CT_Libelle__c = 'Effectif total au 31/12 (Uniqument CDD)',
            CT_Article__c = 'Art.R.2323-27',
            CT_BDU_Domaine__c = domaine2.Id,
            CT_Code__c = 'IND02202',
            CT_Code_Applicable__c = 'Code du travail',
            CT_Description__c = 'Par catégorie et par sexe.             1 salarié compte 1, quel que soit son temps de travail.          CDD)',
            CT_Emplacement__c = 'Bilan Social',
            CT_Affiche__c = true
        );
        insert indic;
        insert indic2;
        
        Date today = System.today();
        BDU_Valeur__c  val1 = new BDU_Valeur__c(
            CT_Annee__c = String.valueOf(today.year()),
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic.Id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = today,
            CT_Valeur__c = 'Lorem Ipsum',
            CT_Entite__c = 'Première'
        );
        BDU_Valeur__c  val2 = new BDU_Valeur__c(
            CT_Annee__c = String.valueOf(today.year()-2),
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic.Id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = today,
            CT_Valeur__c = 'Lorem Ipsum',
            CT_Entite__c = 'Première'
        );
        BDU_Valeur__c  val3 = new BDU_Valeur__c(
            CT_Annee__c = String.valueOf(today.year()),
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic2.Id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = today,
            CT_Valeur__c = 'Lorem Ipsum',
            CT_Entite__c = 'Deuxième'
        );
        BDU_Valeur__c  val4 = new BDU_Valeur__c(
            CT_Annee__c = '2013',
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic2.Id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = today,
            CT_Valeur__c = 'Lorem Ipsum',
            CT_Entite__c = 'Deuxième'
        );
        insert val1;
        insert val2;
        insert val3;
        insert val4;

        //instantiate a page
        PageReference pg = Page.bdu_page;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id', 'emploi');
        ApexPages.currentPage().getParameters().put('entity', 'Première');
        ApexPages.currentPage().getParameters().put('year', String.valueOf(today.year()));
        bduController controller= new bduController();
        //Testing the number of indicateur__c and valeur retrieved
        System.assertEquals(controller.indicateurs.size(), 1);
        System.assertEquals(controller.indicateursToValeurs.size(), 1);

        //Testing if the indicateur__c retrieved is the right one
        BDU_Indicateur__c tmpIndic = controller.indicateurs.get(0);
        System.assertEquals(tmpIndic.CT_Description__c,  indic.CT_Description__c);

        //Testing functions
        controller.getAvailablePeriods();
        bduController.getHistory('annees', indic.Id, String.valueOf(today.year()), null, null, null, null, null);
        bduController.getHistory('semestres', indic.Id, String.valueOf(today.year()), null, null, null, null, null);
        bduController.getHistory('trimestres', indic.Id, String.valueOf(today.year()), null, null, null, null, null);
        bduController.getHistory('bimestres', indic.Id, String.valueOf(today.year()), null, null, null, null, null);
        bduController.getHistory('mois', indic.Id, String.valueOf(today.year()), null, null, null, null, null);
        bduController.finishJoyride();
    }
}