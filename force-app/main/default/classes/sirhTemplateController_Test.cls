@IsTest
private class sirhTemplateController_Test {

    @IsTest
    private static void sirhTemplateController() {
        Contact c = new Contact(Lastname = 'test');
        insert c;
		
        System.assert(c != null);
        
        Attachment a = new Attachment(
                Name = sirhMenuController.CONTACT_PIC,
                Body = Blob.valueOf('test'),
                ParentId = c.Id
                );
        insert a;
		
        System.assert(a != null);
        Demande_de_conges__c request = new Demande_de_conges__c(
                Salarie__c = c.Id,
                Date_de_debut__c = Datetime.now(),
                Date_de_fin__c = Datetime.now().addDays(2),
                Type__c = 'Congés payés'
                );
        insert request;
		System.assert(request.Type__c == 'Congés payés');
        
        String className = Schema.sObjectType.Demande_de_conges__c.getName();
        SIRH_Notification__c notif = new SIRH_Notification__c(
                Id_de_l_objet__c = request.Id,
                Objet__c = className,
                Salarie__c = c.Id,
                Texte__c = 'Test',
                Type__c = 'Création'
                );
        insert notif;
		System.assert(notif.Type__c == 'Création');
        
        PageReference pg = Page.sirhTemplate;
        Test.setCurrentPage(pg);

        sirhTemplateController.getIsLogged();
        sirhTemplateController controller=new sirhTemplateController();
        controller.getIsManager();
        controller.getSubCount(); 
        controller.getPageLabel();
        sirhTemplateController.readNotification(notif.Id);
        sirhTemplateController.webReadNotification(notif.Id);
    }
}