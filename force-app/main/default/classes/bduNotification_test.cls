@IsTest
private class bduNotification_test {

    @IsTest
    private static void testScheduledMonthly() {
        insertData();
        Test.startTest();

        String jobId = System.schedule(
                '_unittest_scheduled_: 001',
                BduNotification.CRON_EXP,
                new BduNotification()
                );

        CronTrigger ct = fetchCronTrigger(jobId);

        System.assertEquals(bduNotification.CRON_EXP, ct.CronExpression, 'Did not get the same Cron Expression back');
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');

        List<BDU_Notification__c> myObjs = fetchMyObjects();
        System.assert(myObjs.isEmpty(), 'Should have gotten no objects back');

        Test.stopTest();

        BDU_Notification__c myObj = fetchMyObj('Toutes');
        System.assertEquals('10 Préparé', myObj.Statut__c, 'Wrong status');
        myObj.Entite__c = 'ChatterTest';
        update myObj;

        bduNotification.postChatter(myObj.Id);
        bduNotification.scheduleIt();

        List<Task> tasks = [SELECT Id FROM Task];
        System.assert(tasks.size()>0);
    }
    
    private static void insertData() {
        Notification__c notifOpt = new Notification__c(
                Afficher_le_nom_des_indicateurs__c = true,
                Nom_du_template__c = 'bdu_notification',
                Notifier_pour_les_indicateurs__c = true,
                Notifier_pour_les_contenus__c = true,
                Adresse_de_l_envoyeur__c = 'Actu BDU'
                );
        insert notifOpt;

        
        CollaborationGroup chatterGroup = new CollaborationGroup(
            name='ChatterTest',
            CollaborationType = 'Public'
        );
        insert chatterGroup;
        
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
        insert domaine;

        BDU_Indicateur__c indic = new BDU_Indicateur__c(
                Name = 'Effectif total au 31/12 (tous salariés)',
                CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                CT_Article__c = 'Art.R.2323-17',
                CT_BDU_Domaine__c = domaine.Id,
                CT_Code__c = 'IND01101',
                CT_Code_Applicable__c = 'Code du travail',
                CT_Description__c = 'Par catégorie et par sexe.             1 salarié compte 1, quel que soit son temps de travail.          CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                CT_Emplacement__c = 'Bilan Social'
                );
        insert indic;

        BDU_Valeur__c val1 = new BDU_Valeur__c(
                CT_Annee__c = '2014',
                CT_A_publier__c = true,
                CT_BDU_Indicateur__c = indic.id,
                CT_Commentaire__c = 'Test',
                CT_Date_de_publication__c = System.today(),
                CT_Valeur__c = 'Lorem Ipsum',
                CT_Entite__c = 'ChatterTest'
                );
        BDU_Valeur__c val2 = new BDU_Valeur__c(
                CT_Annee__c = '2012',
                CT_A_publier__c = true,
                CT_BDU_Indicateur__c = indic.id,
                CT_Commentaire__c = 'Test',
                CT_Date_de_publication__c = System.today(),
                CT_Valeur__c = 'Lorem Ipsum',
                CT_Entite__c = 'Deuxième'
                );
        insert val1;
        insert val2;

    }

    private static CronTrigger fetchCronTrigger(String jobId) {
        return [
                SELECT CronExpression,
                    TimesTriggered,
                    NextFireTime
                FROM CronTrigger
                WHERE Id = :jobId
                ];
    }

    private static List<BDU_Notification__c> fetchMyObjects() {
        List<BDU_Notification__c> result = new List<BDU_Notification__c>();
        result = [SELECT Corps_du_message__c, Date_et_heure_d_envoi__c, Statut__c, Entite__c 
                    FROM BDU_Notification__c];
        return result;
    }

    private static BDU_Notification__c fetchMyObj(String entite) {
        BDU_Notification__c result = new BDU_Notification__c();
        result = [SELECT Corps_du_message__c, Date_et_heure_d_envoi__c, Statut__c, Entite__c 
                    FROM BDU_Notification__c 
                    WHERE Entite__c = :entite 
                    LIMIT 1];
        return result;
    }
}