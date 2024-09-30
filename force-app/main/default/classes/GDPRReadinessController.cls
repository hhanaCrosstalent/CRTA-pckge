//Security isCreateable() isUpdateable() isDeletable() checked
public with sharing class GDPRReadinessController {

    /* Salesforce Lightning */
    
    @AuraEnabled
    public static void save(String button) {
        Id uid = UserInfo.getUserId();
        String email = UserInfo.getUserEmail();
        Integer i = Integer.valueOf(button);
        List<GDPR__c> l = [SELECT Id 
                            FROM GDPR__c 
                            WHERE User__c =: uid 
                            AND Request__c =: i];
        if(l.size()==0) {
            if (
                Schema.sObjectType.GDPR__c.isCreateable()
                && Schema.sObjectType.GDPR__c.fields.User__c.isCreateable()
                && Schema.sObjectType.GDPR__c.fields.Email__c.isCreateable()
                && Schema.sObjectType.GDPR__c.fields.Request__c.isCreateable()
            ) {
                GDPR__c g = new GDPR__c( 
                    User__c = uid,
                    Email__c = email,
                    Request__c = i
                );
                insert g;
            } else {
            	System.debug(System.Label.Permission);
            }
        } else {
            System.debug('We do nothing. User ' + uid + ' and request ' + i + ' are already in the system.');
        }
    }
    
    /* Salesforce Classic */
    
    class Table {
        public String one {set;get;}
        public String two {set;get;}
        public String three {set;get;}
        public String four {set;get;}
        public String five {set;get;}
    }

    private List<Table> table1 = new List<Table>();
    private List<Table> table2 = new List<Table>();
    private List<Table> table3 = new List<Table>();
    private String word = '';

    @TestVisible
    private static List<Table> buildTable(String s, Boolean includeFive) {
            String[] lines = s.split('\\|');
            List<Table> tab = new List<Table>();
            for(String line:lines) {
                String[] cells = line.split(',');
                Table t = new Table();
                t.one = cells[0];
                t.two = cells[1];
                t.three = cells[2];
                t.four = cells[3];
                if(includeFive) t.five = cells[4];
                tab.add(t);
            }
            return tab;
    }
    
    public GDPRReadinessController() {
        try {
            String soql = 'SELECT Tableau_1__c, Tableau_2__c, Tableau_3__c , Word__c ' 
                          + 'FROM GDPR_Readiness__mdt '
                          + 'LIMIT 1 ';
            sObject[] obs = Database.query(soql);
            if(obs.size()==1) {
                String s = String.valueOf(obs[0].get('Tableau_1__c'));
                table1 = buildTable(s, false);
                
                s = String.valueOf(obs[0].get('Tableau_2__c'));
                table2 = buildTable(s, true);
                
                s = String.valueOf(obs[0].get('Tableau_3__c'));
                table3 = buildTable(s, true);
                
                word = String.valueOf(obs[0].get('Word__c'));
            } else {
                System.debug(System.LoggingLevel.Warn, 'Could not find configured GDPR_Readiness__mdt.');
            }
        } catch(Exception e) {
            System.debug(System.LoggingLevel.Error, 
                'Could not find metadata setting GDPR_Readiness__mdt at all or invalid formatted content.');
        }
    }
    
    public PageReference handleClick1() {
        save('1');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Enregistré avec succès.'));
        return null;
    }
    public PageReference handleClick2() {
        save('2');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Enregistré avec succès.'));
        return null;
    }
    public PageReference handleClick3() {
        save('3');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Enregistré avec succès.'));
        return null;
    }
    public PageReference handleClick4() {
        save('4');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Enregistré avec succès.'));
        return null;
    }
    public List<Table> getTable1csv() {
        return table1;
    }
    public List<Table> getTable2csv() {
        return table2;
    }
    public List<Table> getTable3csv() {
        return table3;
    }
    public String getWord() {
        return word;
    }
}