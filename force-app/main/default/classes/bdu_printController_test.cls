@IsTest
private class bdu_printController_test {

    @IsTest
    private static void bduPrintController() {
        insertData();
        
        PageReference pg = Page.bdu_print;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id', 'emploi');
        ApexPages.currentPage().getParameters().put('year', '2014');
        Bdu_printController controller= new Bdu_printController();
        System.assert(ApexPages.currentPage().getParameters().get('id') == 'emploi');
        System.assert(ApexPages.currentPage().getParameters().get('year') == '2014');
    }

    @IsTest
    private static void bdu_printBilanController() {
        insertData();
        
        PageReference pg = Page.bdu_exportBilan;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('document', 'Bilan Social');
        ApexPages.currentPage().getParameters().put('BU1', null);
        ApexPages.currentPage().getParameters().put('BU2', null);
        ApexPages.currentPage().getParameters().put('BU3', null);
        ApexPages.currentPage().getParameters().put('BU4', null);
        ApexPages.currentPage().getParameters().put('BU5', null);
        ApexPages.currentPage().getParameters().put('year', '2014');
        Bdu_exportBilanController controller= new Bdu_exportBilanController();
        System.assert(ApexPages.currentPage().getParameters().get('document') == 'Bilan Social');
        System.assert(ApexPages.currentPage().getParameters().get('BU1') == null);
    }

    @IsTest
    private static void bduExportBilanController() {
        insertData();
        
        PageReference pg = Page.bdu_printBilan;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('document', 'Bilan Social');
        ApexPages.currentPage().getParameters().put('BU1', null);
        ApexPages.currentPage().getParameters().put('BU2', null);
        ApexPages.currentPage().getParameters().put('BU3', null);
        ApexPages.currentPage().getParameters().put('BU4', null);
        ApexPages.currentPage().getParameters().put('BU5', null);
        ApexPages.currentPage().getParameters().put('year', '2014');
        Bdu_printBilanController controller= new Bdu_printBilanController();
        System.assert(ApexPages.currentPage().getParameters().get('document') == 'Bilan Social');
        System.assert(ApexPages.currentPage().getParameters().get('BU1') == null);
    }

    private static void insertData() {
        showOptions__c options = new showOptions__c(
            showBU1__c = true,
            showBU2__c = true,
            showBU3__c = true,
            showBU4__c = true,
            showBU5__c = true
        );
        insert options;

        override__c branding = new override__c(filigrane__c='bduFiligrane');
        insert branding;

        BDU_Chapitre__c chapitre = new BDU_Chapitre__c(
            Name='Données sociales',
            CT_Order__c = 1
        );
        insert chapitre; 
        
        BDU_Domaine__c domaine = new BDU_Domaine__c(
            Name='Emploi',
            CT_BDU_Chapitre__c = chapitre.id,
            CT_Affiche__c = true,
            CT_Slug__c = 'emploi'
        );
        BDU_Domaine__c domaine2 = new BDU_Domaine__c(
            Name='Social',
            CT_BDU_Chapitre__c = chapitre.id,
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
        
        BDU_Valeur__c  val1 = new BDU_Valeur__c(
            CT_Annee__c = '2014',
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic.id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = System.today(),
            CT_Valeur__c = 'Lorem Ipsum'
        );
        BDU_Valeur__c  val2 = new BDU_Valeur__c(
            CT_Annee__c = '2012',
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic.id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = System.today(),
            CT_Valeur__c = 'Lorem Ipsum'
        );
        BDU_Valeur__c  val3 = new BDU_Valeur__c(
            CT_Annee__c = '2014',
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic2.id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = System.today(),
            CT_Valeur__c = 'Lorem Ipsum'
        );
        BDU_Valeur__c  val4 = new BDU_Valeur__c(
            CT_Annee__c = '2013',
            CT_A_publier__c = true,
            CT_BDU_Indicateur__c = indic2.id,
            CT_Commentaire__c = 'Test',
            CT_Date_de_publication__c = System.today(),
            CT_Valeur__c = 'Lorem Ipsum'
        );
        insert val1;
        insert val2;
        insert val3;
        insert val4;
        system.assertEquals(val1.CT_Commentaire__c, 'Test');
        system.assertEquals(val2.CT_Commentaire__c, 'Test');
        system.assertEquals(val3.CT_Commentaire__c, 'Test');
        system.assertEquals(val4.CT_Commentaire__c, 'Test');
    }
}