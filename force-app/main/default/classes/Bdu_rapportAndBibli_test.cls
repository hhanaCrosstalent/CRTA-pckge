@IsTest
private class Bdu_rapportAndBibli_test {

    @IsTest
    private static void bduRapportController() {
        dataInsert();
        bdu_rapportController controller= new bdu_rapportController();
        bdu_rapportController.finishJoyride();

        //Checking if the returned sizes are the one expected
        System.assertEquals(controller.rapports.size(), 2);
        System.assertEquals(controller.donnees.size(), 1);

        //Checking if we added the right number of donn_e__c
        System.assertEquals(controller.donnees.get('2012').size(), 2);
    }

    @IsTest
    private static void bduBibliController() {
        dataInsert();
        bdu_bibliController controller= new bdu_bibliController();

        //Checking if the returned sizes are the one expected
        System.assertEquals(controller.rapports.size(), 2);
        System.assertEquals(controller.donnees.size(), 1);

        //Checking if we added the right number of donn_e__c
        System.assertEquals(controller.donnees.get('Convention collective').size(), 2);
    }

    @IsTest
    private static void bduAttachController() {
        BDU_Contenu__c rapport = new BDU_Contenu__c(
                Name = 'Test',
                CT_Type_de_donnee__c = 'Rapport',
                CT_Annee__c = '2012',
                CT_URl__c = 'www.test.com'
        );
        insert rapport;

        Id x = null;
        x = insertContentDocument(rapport.id);
        PageReference pg = Page.attachmentViewer;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id', x);
        System.assert(ApexPages.currentPage().getParameters().get('id') == x);
        AttachmentViewerController controller= new AttachmentViewerController();
    }

    private static void dataInsert() {

        BDU_Contenu__c rapport = new BDU_Contenu__c(
                        Name = 'Test',
                        CT_Type_de_donnee__c = 'Rapport',
                        CT_Annee__c = '2012',
                        CT_URl__c = 'www.test.com'
        );
        BDU_Contenu__c rapport2 = new BDU_Contenu__c(
                        Name = 'Test2',
                        CT_Type_de_donnee__c = 'Rapport',
                        CT_Annee__c = '2012',
                        CT_URl__c = 'www.test.com'
        );
        insert rapport;
        insert rapport2;

        BDU_Contenu__c bibli = new BDU_Contenu__c(
                        Name = 'Test',
                        CT_Type_de_donnee__c = 'Bibliothèque',
                        CT_Categorie__c = 'Convention collective',
                        CT_URl__c = 'www.test.com'
        );
         BDU_Contenu__c bibli2 = new BDU_Contenu__c(
                        Name = 'Test2',
                        CT_Type_de_donnee__c = 'Bibliothèque',
                        CT_Categorie__c = 'Convention collective',
                        CT_URl__c = 'www.test.com'
        );
         insert bibli2;
         insert bibli;

        insertContentDocument(rapport.id);
        insertContentDocument(bibli2.id);
    }

    private static Id insertContentDocument(Id linkedEntityId) {
        ContentVersion cv = new ContentVersion();
        String base64Data = 'foobar';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = 'foobar';
        cv.PathOnClient = 'foobar.ext';
        //cv.PublishStatus = 'P'; read only
        cv.FirstPublishLocationId = linkedEntityId;
        insert cv;

        List<ContentVersion> l = [SELECT ContentDocumentId, PublishStatus FROM ContentVersion WHERE Id =: cv.Id];
        cv = l.get(0);
        System.debug('PublishStatus: ' + cv.PublishStatus);
        /*
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = linkedEntityId;
        cdl.ShareType = 'V'; // I works neither when packaging
        cdl.Visibility = 'AllUsers';
        insert cdl;
        return cdl.Id;
        */
        return cv.Id;
    }
}