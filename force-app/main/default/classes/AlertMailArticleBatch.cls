//Security isCreateable() isUpdateable() isDeletable() checked
/**
* @Author: Ophélie ABOA
* @Date: 17/03/2020
**/
global with sharing class AlertMailArticleBatch implements
Database.Batchable<SObject>,
Database.Stateful,
Database.AllowsCallouts,
Schedulable
{
    global Set<Id> setAccountsIds = new Set<Id>();
    global Set<Id> setArticlesIds = new Set<Id>();
    global Set<Id> setContactsIds = new Set<Id>();
    global Map<String, Contact> contactById = new Map<String, Contact>();
    global Map<String, String> userByContactId = new Map<String, String>();
    global List<String> usersList = new List<String>();
    global Map<String, List<String>> articleByAccount = new Map<String, List<String>>();
    global EmailTemplate templateMail = new EmailTemplate();
    
    private crta__Article__c record;
    private String emailTemplateDevName;
    private String senderEmailId;
    private static final Integer SCOPE_SIZE = 20;
    global static Integer getScopeSize() {return SCOPE_SIZE;}
    
    global AlertMailArticleBatch(crta__Article__c record, String emailTemplateDevName, String senderEmailId) {
        this.record = record;
        this.emailTemplateDevName = emailTemplateDevName;
        this.senderEmailId = senderEmailId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        templateMail = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: emailTemplateDevName];
        for(crta__Article_Visibility__c v : [
            SELECT Id, 
            crta__Account__c,
            crta__Article__c 
            FROM crta__Article_Visibility__c 
            WHERE crta__Article__c =: record.Id
        ]) {
            setAccountsIds.add(v.crta__Account__c);
            if(this.articleByAccount.containsKey(v.crta__Article__c)) {
                articleByAccount.get(v.crta__Article__c).add(v.crta__Account__c);
            } else {
                articleByAccount.put(v.crta__Article__c,new List<String>{v.crta__Account__c});
            }
        }
        
        if(!setAccountsIds.isEmpty()) {
            for(Contact c : [
                SELECT Id
                FROM Contact 
                WHERE RecordType.DeveloperName = 'Salarie' 
                AND AccountId IN :setAccountsIds
            ]){
                setContactsIds.add(c.Id);
                contactById.put(c.Id, c);
            }
        } else {
            for(Contact c : [
                SELECT Id 
                FROM Contact
                WHERE RecordType.DeveloperName = 'Salarie'
            ]){
                setContactsIds.add(c.Id);
                contactById.put(c.Id, c);
            }
        }
        
        String query = 'SELECT Id, '
            + 'crta__Contact__c '
            + 'FROM User '
            + 'WHERE isActive = TRUE '
            + 'AND crta__Contact__c LIKE \'003%\' '
            + 'AND crta__Contact__c IN: setContactsIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope) {
        system.debug(scope);
        if(!setContactsIds.isEmpty()) {
            for(User u : scope) {
                if(setContactsIds.contains(u.crta__Contact__c)) {
                    usersList.add(u.Id);
                    userByContactId.put(u.Id, u.crta__Contact__c);
                }
            }
        }
    }
    
    global void execute(SchedulableContext bc) {
        Database.executeBatch(this, SCOPE_SIZE);
    }
    
    global void finish(Database.BatchableContext BC) {
        String urlOrg = System.URL.getSalesforceBaseUrl().toExternalForm();
        String templateStr = templateMail.HtmlValue;
        if(templateStr == null) {
            templateStr = templateMail.Body;
        }
        Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage>();
        
        for(String userId : usersList) {
            String contactId = userByContactId.get(userId);
            if(contactId !=  null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<Id>{userId});
                mail.setSubject(record.Name);
                
                if(templateStr != null) {
                    templateStr = templateStr.replace('{!crta__Article__c.Name}', record.Name)
                        .replace('{!crta__Article__c.Id}', record.Id)
                        .replace('{!urlOrg}', urlOrg);
                    if(record.crta__Texte__c != NULL) {
                        String shortText = (record.crta__Texte__c.length() >= 2600)
                            ? record.crta__Texte__c.subString(0, 2600) : record.crta__Texte__c.subString(0, record.crta__Texte__c.length());
                        templateStr = templateStr.replace('{!crta__Article__c.crta__Texte__c}', shortText.unescapeHtml4() + '...');
                    }
                    if(templateStr == null) {
                        mail.setHtmlBody(templateStr);
                        mail.setPlainTextBody(templateMail.Body);
                    } else {
                        mail.setPlainTextBody(templateStr);
                    }
                    mail.setWhatId(record.Id);
                    if(senderEmailId != '') {
                        mail.setOrgWideEmailAddressId(senderEmailId);
                    } else {
                        mail.setSenderDisplayName(Label.Communication);
                    }
                    if(Schema.sObjectType.crta__Article__c.fields.crta__Email_Sent__c.isUpdateable()) {
                        record.crta__Email_Sent__c = true;
                    }
                    mails.add(mail);
                }
            }
        }
        
        if(mails.size() > 0) {
            Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult>();
            List<String> errors = new List<String>();
            if (!Test.isRunningTest()) { 
                results = Messaging.sendEmail(mails);
            } else {
                errors.add('Test error');
            }
            
            for(Messaging.SendEmailResult r : results) {
                if (r.getErrors() != null && !r.getErrors().isEmpty()) {
                    //We send only the first error for each mail
                    errors.add(r.getErrors()[0].getMessage());
                }
            }
            
            if (!errors.isEmpty()) {
                String body = String.join(errors, '\n');
                Messaging.SingleEmailMessage mailError = new Messaging.SingleEmailMessage();
                mailError.setPlainTextBody(body);
                mailError.setToAddresses(new List<Id>{UserInfo.getUserId()});
                if (!Test.isRunningTest()) {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailError});
                }
            }
            if(Schema.sObjectType.crta__Article__c.isUpdateable()) {
                update record;
            }
        }
    }
}