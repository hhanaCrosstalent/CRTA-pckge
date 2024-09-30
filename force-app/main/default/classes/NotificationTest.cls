@IsTest
private class NotificationTest {

    @IsTest 
    private static void notificationManagerTest() {
        Contact c = new Contact(LastName = 'Collab');
        insert c;

        NotificationManager.createNotification(c.Id, 'Test', 'Information', 'Contact', c.Id); //Real test
        NotificationManager.createNotification('003', 'Test', 'Information', 'Contact', c.Id); //Failing test
        List<SIRH_Notification__c> notifs = [SELECT Id, Type__c FROM SIRH_Notification__c];
        System.assertEquals(1, notifs.size());
        System.assertEquals('Information', notifs[0].Type__c);

        NotificationManager.editNotification('Test 2', 'Rappel', 'Contact', c.Id, notifs[0].Id); //Real test
        NotificationManager.editNotification('Test 2', 'Rappel', 'Contact', c.Id, '003'); //Failing test
        notifs = [SELECT Id, Type__c FROM SIRH_Notification__c];
        System.assertEquals(1, notifs.size());
        System.assertEquals('Rappel', notifs[0].Type__c);

        NotificationManager.markAsRead(notifs[0].Id); //Real test
        NotificationManager.markAsRead('003'); //Failing test
        notifs = [SELECT Id, Lu__c FROM SIRH_Notification__c];
        System.assertEquals(true, notifs[0].Lu__c);

        NotificationManager.markAsUnread(notifs[0].Id); //Real test
        NotificationManager.markAsUnread('003'); //Failing test
        notifs = [SELECT Id, Lu__c FROM SIRH_Notification__c];
        System.assertEquals(false, notifs[0].Lu__c);

        NotificationManager.deleteNotification(notifs[0].Id); //Real test
        NotificationManager.deleteNotification(notifs[0].Id); //Failing test
        notifs = [SELECT Id, Lu__c FROM SIRH_Notification__c];
        System.assertEquals(0, notifs.size());
    }

    @IsTest
    private static void NotificationRepository_Test() {
        Contact c = new Contact(LastName = 'Collab');
        insert c;

        SIRH_Notification__c n = new SIRH_Notification__c(
                Salarie__c = c.Id,
                Texte__c = 'Test',
                Type__c = 'Information'
                );
        insert n;

        SIRH_Notification__c n2 = new SIRH_Notification__c(
                Salarie__c = c.Id,
                Texte__c = 'Test 2',
                Type__c = 'Rappel'
                );
        insert n2;

        List<String> fields = new List<String>{'Type__c', 'Texte__c'};
        List<SIRH_Notification__c> notifs = NotificationRepository.getAll();
        notifs = NotificationRepository.getAllForFields(fields);
        System.assertEquals(2, notifs.size());

        notifs = NotificationRepository.getAllByContact(c.Id);
        notifs = NotificationRepository.getAllByContactForFields(c.Id, fields);
        System.assertEquals(2, notifs.size());

        notifs = NotificationRepository.getAllUnread();
        notifs = NotificationRepository.getAllUnreadForFields(fields);
        System.assertEquals(2, notifs.size());

        notifs = NotificationRepository.getAllUnreadByContact(c.Id);
        notifs = NotificationRepository.getAllUnreadByContactForFields(c.Id, fields);
        System.assertEquals(2, notifs.size());

        notifs = NotificationRepository.getAllUnreadWithOffset(0, 1);
        notifs = NotificationRepository.getAllUnreadWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, notifs.size());

        notifs = NotificationRepository.getAllUnreadWithOffsetByContact(c.Id, 0, 1);
        notifs = NotificationRepository.getAllUnreadWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, notifs.size());

        notifs = NotificationRepository.getAllWithOffset(0, 1);
        notifs = NotificationRepository.getAllWithOffsetForFields(0, 1, fields);
        System.assertEquals(1, notifs.size());

        notifs = NotificationRepository.getAllWithOffsetByContact(c.Id, 0, 1);
        notifs = NotificationRepository.getAllWithOffsetByContactForFields(c.Id, 0, 1, fields);
        System.assertEquals(1, notifs.size());

        SIRH_Notification__c notif = NotificationRepository.getById(n.Id);
        notif = NotificationRepository.getByIdForFields(n.Id, fields);
        System.assertEquals('Information', notif.Type__c);
    }
}