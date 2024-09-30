//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Class managing notifications
 *
 * Un batch tourne toutes les nuits :
 * - On vérifie si il y a déjà un mail préparé en statut 10 ou 20
 * - Si il y en a pas, on en créée un
 * - Le batch de nuit prend toutes les modifs du JOUR d'après le champ "Date de publication" et les ajoute dans le
 *   mail, à l'endroit où il y a la balise  {@listadded}
 */
global with sharing class bduNotification implements Schedulable {

    public static String CRON_EXP = '0 45 23 * * ? *'; //Runs every day at 23:45
    public Notification__c notifOptions { get; set; } //Custom setting

    global class BduNotificationException extends Exception {}

    /**
     * Static method used to schedule the default reconciliation
     *
     * @return The jobId from the scheduled run
     */
    global static String scheduleIt() {
        BduNotification bn = new BduNotification();
        return System.schedule('Daily notification', CRON_EXP, bn);
    }

    /**
     * Scheduled function
     * Browse previous unsent notification and append the newest modifications
     * Or create a new notification and append the newest modifications
     *
     * @param SchedulableContext
     * @return void
     */
    global void execute(SchedulableContext sc) {
        notifOptions = [SELECT Nom_du_template__c, Nom_de_l_envoyeur__c, Afficher_le_nom_des_indicateurs__c,
                            Notifier_pour_les_contenus__c, Notifier_pour_les_indicateurs__c 
                        FROM Notification__c
                        LIMIT 10000];
        ApexPage template;
        List<BDU_Notification__c> previousNotifications = [SELECT Corps_du_message__c, Date_et_heure_d_envoi__c,
                                                                Statut__c, Entite__c 
                                                           FROM BDU_Notification__c 
                                                           WHERE Statut__c != '90 Envoyé'];

        if(previousNotifications.size() > 0) {
            if(!Schema.sObjectType.BDU_Notification__c.fields.Corps_du_message__c.isUpdateable()
                || !Schema.sObjectType.BDU_Notification__c.fields.Statut__c.isUpdateable()) {
                System.debug('User does not have sufficient rights.');
                return;
            }
            for(BDU_Notification__c notification: previousNotifications) {
                notification.Corps_du_message__c = this.processBody(notification.Corps_du_message__c);
                notification.Statut__c = '20 Complété';
                update notification;
            }
        } else if(notifOptions.Nom_du_template__c != null && notifOptions.Nom_du_template__c != '') {
            try {
                template = [SELECT Id, Markup FROM ApexPage WHERE Name = :notifOptions.Nom_du_template__c];
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            BDU_Notification__c notif = new BDU_Notification__c(
                Corps_du_message__c=this.processBody(template.markup),
                Entite__c='Toutes',
                Statut__c = '10 Préparé'
            );
            insert notif;
            this.createTask(notif.Id);
        }
    }

    /**
     * Webservice used in a button to trigger the sending of a notification to the corresponding Chatter group
     *
     * @param String Id of the notification
     * @return The status of the sending. True if correctly sent, an error mesage otherwise
     */
    webService static String postChatter(String notifId) {
      
        BDU_Notification__c notif = new BDU_Notification__c();
        ID orgWideAddressId;
        Notification__c notifOptions = [SELECT Adresse_de_l_envoyeur__c, Recevoir_copie__c, Sujet_du_mail__c 
                                        FROM Notification__c];
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();

        try {
            notif = [SELECT Corps_du_message__c, Date_et_heure_d_envoi__c, Statut__c, Entite__c 
                    FROM BDU_Notification__c 
                    WHERE Id = :notifId];
            ID groupId = [SELECT Id FROM CollaborationGroup WHERE Name = :notif.Entite__c].Id;
            if(!Test.isRunningTest()) {
                orgWideAddressId = [SELECT Id 
                                    FROM OrgWideEmailAddress 
                                    WHERE DisplayName = :notifOptions.Adresse_de_l_envoyeur__c].Id;
            }
            List<CollaborationGroupMember> cmembers = [SELECT MemberId 
                                                       FROM CollaborationGroupMember 
                                                       WHERE CollaborationGroupId = :groupID];

            //Cleaning the post
            String body = notif.Corps_du_message__c;
            body = body.replace('{@listAdded}', '');
            body = body.replace('{@listUpdated}', '');

            for(CollaborationGroupMember cmember: cmembers) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(cmember.MemberId);
                If(!Test.isRunningTest()) { mail.setOrgWideEmailAddressId(orgWideAddressId); }
                mail.setPlainTextBody(body);
                mail.setBccSender(notifOptions.Recevoir_copie__c);
                mail.setSubject(notifOptions.Sujet_du_mail__c);
                mail.setSaveAsActivity(false);
                allMails.add(mail);
            }

            try {
                Messaging.reserveSingleEmailCapacity(allMails.size());
            } catch (Exception e) {
                System.debug('You have used up your daily allowance of mails');
            }
            Messaging.sendEmail(allMails);

            notif.Statut__c = '90 Envoyé';
            notif.Date_et_heure_d_envoi__c = Datetime.now();
            if (
                Schema.sObjectType.BDU_Notification__c.isUpdateable()
                && Schema.sObjectType.BDU_Notification__c.fields.Statut__c.isUpdateable()
                && Schema.sObjectType.BDU_Notification__c.fields.Date_et_heure_d_envoi__c.isUpdateable()
                && Schema.sObjectType.BDU_Notification__c.fields.Corps_du_message__c.isUpdateable()
            ) {
            	update notif;
            	return 'true';
            } else {
                System.debug(System.Label.Permission + ' bduNotification line 132');
                return System.Label.Permission + ' bduNotification line 132';
            }
        } catch(Exception e) {
          System.debug(e.getMessage());
          return e.getMessage();
        }
    }

    /**
     * Processes a given template to add the newest data
     *
     * @param String The template
     * @return String The processed template
     */
    private String processBody(String body) {
        Map<String, List<BDU_Valeur__c>> entiteToCreatedVal = new Map<String, List<BDU_Valeur__c>>();
        Map<String, List<BDU_Contenu__c>> entiteToCreatedContent = new Map<String, List<BDU_Contenu__c>>();
        List<BDU_Valeur__c> created = new List<BDU_Valeur__c>();
        List<BDU_Contenu__c> createdContent = new List<BDU_Contenu__c>();
        String listAdded = '';

        if(notifOptions.Notifier_pour_les_indicateurs__c) {
            created = [SELECT Id, CT_Annee__c, CT_BU__c, CT_Valeur__c, CT_BDU_Indicateur__r.Name, 
                          CT_BDU_Indicateur__r.CT_Libelle__c, CT_BDU_Indicateur__r.Id, CreatedDate 
                    FROM BDU_Valeur__c 
                    WHERE CT_Date_de_publication__c = TODAY 
                    AND CT_A_publier__c = true];
        }
        for(BDU_Valeur__c valeur: created) {
            if(entiteToCreatedVal.containsKey(valeur.CT_BU__c)) {
                List<BDU_Valeur__c> oldList = entiteToCreatedVal.get(valeur.CT_BU__c);
                oldList.add(valeur);
                entiteToCreatedVal.put(valeur.CT_BU__c, oldList);
            } else {
                List<BDU_Valeur__c> newList = new List<BDU_Valeur__c>();
                newList.add(valeur);
                entiteToCreatedVal.put(valeur.CT_BU__c, newList);
            }
        }
        if(notifOptions.Notifier_pour_les_contenus__c) {
            createdContent = [SELECT Id, Name, CT_Annee__c, CT_Type_de_donnee__c, CT_Categorie__c, CT_BU__c, 
                                    CreatedDate 
                              FROM BDU_Contenu__c 
                              WHERE CT_publish_date__c = TODAY];
        }
        for(BDU_Contenu__c content: createdContent) {
            if(entiteToCreatedContent.containsKey(content.CT_BU__c)) {
                List<BDU_Contenu__c> oldList = entiteToCreatedContent.get(content.CT_BU__c);
                oldList.add(content);
                entiteToCreatedContent.put(content.CT_BU__c, oldList);
            } else {
                List<BDU_Contenu__c> newList = new List<BDU_Contenu__c>();
                newList.add(content);
                entiteToCreatedContent.put(content.CT_BU__c, newList);
            }
        }

        for(String entity : entiteToCreatedVal.keySet()) { //Creating listing for the newly created BDU_Valeur__c
            String entityName = entity;
            if(entityName == null || entityName == 'null') {
                entityName = 'globale';
            }
            listAdded += '\nLes éléments suivants ont été ajoutés pour l\'entité '+ entityName +' : \n';
            for(BDU_Valeur__c valeur: entiteToCreatedVal.get(entity)) {
                if(notifOptions.Afficher_le_nom_des_indicateurs__c) listAdded += '• '+valeur.CT_BDU_Indicateur__r.CT_Libelle__c+' pour l\'année '+valeur.CT_Annee__c+'.\n';
                //if(notifOptions.Afficher_la_nouvelle_valeur__c) listAdded += 'La nouvelle valeur est : '+valeur.CT_Valeur__c+'\n';
            }
        }
        for(String entity : entiteToCreatedContent.keySet()) { //Creating listing for the newly created BDU_Contenu__c
            String entityName = entity;
            if(entityName == null || entityName == 'null') entityName = 'globale';
            listAdded += '\nLes rapport suivants ont été ajoutés pour l\'entité '+entityName+' : \n';
            for(BDU_Contenu__c content: entiteToCreatedContent.get(entity)) {
                if(content.CT_Type_de_donnee__c == 'Rapport') {
                    listAdded += '• '+content.Name+' pour l\'année '+content.CT_Annee__c+'.\n';
                } else {
                    listAdded += '• '+content.Name+' pour la catégorie '+content.CT_Categorie__c+'.\n';
                }
            }
        }
        listAdded += '{@listAdded}';

        //Inserting listing in templates
        body = body.replace('{@listAdded}', listAdded);
        body = body.replace('<apex:page>', '');
        body = body.replace('<apex:page >', '');
        body = body.replace('</apex:page>', '');

        return body;
    }

    /**
     * Create a task associated to the given notification
     * @param String Id of the notification
     */
    private void createTask(String notifId) {
      String ownerId = '';
      try {
          ownerId = [SELECT Id FROM User WHERE name =: notifOptions.Nom_de_l_envoyeur__c].Id;
      } catch(Exception e) {
          ownerId = UserInfo.getUserId();
      }
      Datetime now = Datetime.now();
      if(!Schema.sObjectType.Task.fields.WhatId.isCreateable()
            || !Schema.sObjectType.Task.fields.ActivityDate.isCreateable()
            || !Schema.sObjectType.Task.fields.Subject.isCreateable()
            || !Schema.sObjectType.Task.fields.OwnerId.isCreateable()) {
          //throw new BduNotificationException('User does not have necessary permissions to create tasks.');
          System.debug('User does not have necessary permissions to create tasks.');
          return;
      }
      Task t = new Task(
          WhatId=notifId,
          ActivityDate=Date.today().addDays(1),
          Subject='Notification',
          OwnerId=ownerId
      );
      insert t;
    }
}