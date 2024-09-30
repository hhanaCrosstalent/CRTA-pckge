@IsTest
private class bdu_templateController_test {
    
    @IsTest
    private static void bduTemplateController() {
        Override__c branding = new Override__c();
        branding.css__c = 'overrideCSS';
        branding.CT_SplashTime__c = -1;
        branding.CT_splash__c = true;
        branding.CT_exitUrl__c = 'http://www.google.fr';
        insert branding;

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

        PageReference pg = Page.BDU_template;
        Test.setCurrentPage(pg);
        bdu_templateController controller= new bdu_templateController();
        controller.selectedChoice = false;
        controller.acceptSplash();
        bdu_templateController controller2 = new bdu_templateController();
        controller2.selectedChoice = true;
        controller2.acceptSplash();
        
        bdu_templateController.getHasConfidentialCookie();
        bdu_templateController.setBuCookie('Test1', 'Test2', 'Test3', 'Test4', 'Test5');
        bdu_templateController.getSelectedBu('BU1');
        //Testing the number of BDU_Chapitre__c retrieved
        System.assertEquals(controller.chapitres.size(), 1);

        //Testing if the number of BDU_domaine__c retrieved for the BDU_Chapitre__c inserted
        List<BDU_Domaine__c> domaines = controller.chapitreToDomaines.get(chapitre.Id);
        System.assertEquals(domaines.size(), 2);
    }
}