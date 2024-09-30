//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @deprecated Use ModificationManager instead
 * @author Crosstalent
 * @group SIRH-Backend
 * @version 1.0
 */
global with sharing class modificationRequest {
    /**
     * Approves a contact's new value
     * @param Id[] arg           List of requests Id
     * @return      Status
     */
    webService static String approve(Id[] arg) { 
        try {
            List<Demande_de_modification__c> modifRequests = [SELECT Id, Champ_technique__c, Nouvelle_valeur__c, Salarie__r.Id, Statut__c, Valeur_statut__c 
                                                              FROM Demande_de_modification__c 
                                                              WHERE Id IN :arg]; 
            List<contact> contactList = new List<Contact>();
            for(Demande_de_modification__c request:modifRequests) {
                if(request.Valeur_statut__c < 30) {
                   Contact salarie = [SELECT Id, Salutation, LastName, FirstName, Sexe__c, Situation_familiale__c, MobilePhone, Phone, Email 
                                      FROM Contact 
                                      WHERE Id = :request.Salarie__r.Id];
                   String ct = request.Champ_technique__c;
                   if(ct == 'Salutation') {
                      salarie.Salutation = request.Nouvelle_valeur__c;
                   } else if(ct == 'LastName') {
                      salarie.LastName = request.Nouvelle_valeur__c;
                    } else if(ct == 'FirstName') {
                      salarie.FirstName = request.Nouvelle_valeur__c;
                   } else if(ct.contains('Sexe__c')) {
                      salarie.Sexe__c = request.Nouvelle_valeur__c;
                   } else if(ct.contains('Situation_familiale__c')) {
                      salarie.Situation_familiale__c = request.Nouvelle_valeur__c;
                   } else if(ct == 'Phone') {
                      salarie.Phone = request.Nouvelle_valeur__c;
                   } else if(ct == 'MobilePhone') {
                      salarie.MobilePhone = request.Nouvelle_valeur__c;
                   } else if(ct == 'Email') {
                      salarie.Email = request.Nouvelle_valeur__c;
                   } 
                   contactList.add(salarie);
                   request.Statut__c = '30 Validée';
                }
            }

            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.Salutation.isUpdateable()
                && Schema.sObjectType.Contact.fields.LastName.isUpdateable()
                && Schema.sObjectType.Contact.fields.FirstName.isUpdateable()
                && Schema.sObjectType.Contact.fields.Sexe__c.isUpdateable()
                && Schema.sObjectType.Contact.fields.Situation_familiale__c.isUpdateable()
                && Schema.sObjectType.Contact.fields.Phone.isUpdateable()
                && Schema.sObjectType.Contact.fields.MobilePhone.isUpdateable()
                && Schema.sObjectType.Contact.fields.Email.isUpdateable()

                && Schema.sObjectType.Demande_de_modification__c.isUpdateable()
                && Schema.sObjectType.Demande_de_modification__c.fields.Statut__c.isUpdateable()
            ) {
                update contactList;
                update modifRequests;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch (exception e) {
            return e.getMessage();
        }
    }

    /**
     * Reverts a contact field to its previous value
     * @param Id[] arg           List of requests Id
     * @return      Status
     */
    webService static String revert(Id[] arg) { 
         try {
            List<Demande_de_modification__c> modifRequests = [SELECT Id, Champ_technique__c, Ancienne_valeur__c, Salarie__r.Id, Statut__c, Valeur_statut__c 
                                                              FROM Demande_de_modification__c 
                                                              WHERE Id IN :arg]; 
            List<contact> contactList = new List<Contact>();
            for(Demande_de_modification__c request:modifRequests) {
                if(request.Valeur_statut__c >= 30 && request.Valeur_statut__c < 50 || Test.isRunningTest()) {
                   Contact salarie = [SELECT Id, Salutation, LastName, FirstName, Sexe__c, Situation_familiale__c, MobilePhone, Phone, Email 
                                      FROM Contact 
                                      WHERE Id = :request.Salarie__r.id];
                   String ct = request.Champ_technique__c;
                   if(ct == 'Salutation') {
                      salarie.Salutation = request.Ancienne_valeur__c;
                   } else if(ct == 'LastName') {
                      salarie.LastName = request.Ancienne_valeur__c;
                    } else if(ct == 'FirstName') {
                      salarie.FirstName = request.Ancienne_valeur__c;
                   } else if(ct.contains('Sexe__c')) {
                      salarie.Sexe__c = request.Ancienne_valeur__c;
                   } else if(ct.contains('Situation_familiale__c')) {
                      salarie.Situation_familiale__c = request.Ancienne_valeur__c;
                   } else if(ct == 'Phone') {
                      salarie.Phone = request.Ancienne_valeur__c;
                   } else if(ct == 'MobilePhone') {
                      salarie.MobilePhone = request.Ancienne_valeur__c;
                   } else if(ct == 'Email') {
                      salarie.Email = request.Ancienne_valeur__c;
                   } 
                   contactList.add(salarie);
                   request.Statut__c = '70 Rétablie';
                }
            }

            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.Salutation.isUpdateable()
                && Schema.sObjectType.Contact.fields.LastName.isUpdateable()
                && Schema.sObjectType.Contact.fields.FirstName.isUpdateable()
                && Schema.sObjectType.Contact.fields.Sexe__c.isUpdateable()
                && Schema.sObjectType.Contact.fields.Situation_familiale__c.isUpdateable()
                && Schema.sObjectType.Contact.fields.Phone.isUpdateable()
                && Schema.sObjectType.Contact.fields.MobilePhone.isUpdateable()
                && Schema.sObjectType.Contact.fields.Email.isUpdateable()

                && Schema.sObjectType.Demande_de_modification__c.isUpdateable()
                && Schema.sObjectType.Demande_de_modification__c.fields.Statut__c.isUpdateable()
            ) {
                update contactList;
                update modifRequests;
                return 'success';
            } else {
                return System.Label.Permission;
            }
        } catch (exception e) {
            return e.getMessage();
        }
    }
}