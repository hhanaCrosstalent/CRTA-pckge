@IsTest
public class BduBatchSplitterTest {

    @IsTest
     static void testAll() {
        Date d = Date.newInstance(2017, 1, 1);
        BduBatchSplitter bbs = new bduBatchSplitter(d);
        Iterable<BduBatchParam> iter = bbs.start(null);
        Database.BatchableContext info = null;
        system.assertEquals(info, null);
        List<BduBatchParam> params = (List<BduBatchParam>) iter; //new List<BduBatchParam>();
        bbs.execute(info, params);
        bbs.finish(null);
        List<BduBatchSplitter.Period> l = bbs.periodSearch();
        
    }

    @TestSetup
     static void testSetup() {
        Param_calc_auto__c param = new Param_calc_auto__c(Reports_limit_calc__c = 10.0);
        insert param;
        crta__BDU_Domaine__c domaine = new crta__BDU_Domaine__c(crta__CT_slug__c = 'test');
        insert domaine;
        List<BDU_Indicateur__c> indicators = new List<BDU_Indicateur__c>
        {
            new BDU_Indicateur__c(CT_Code__c = 'IND01348', CT_Annuel__c = true, crta__CT_BDU_Domaine__c = domaine.Id, crta__CT_Libelle__c = 'my label')
        };
        insert indicators;
        Account acc = new Account(Name = 'Hamburger Hafen');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, FirstName = 'Francois', LastName = 'Muller');
        insert con;
        
        Id recordTypeAccountHierarchical = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Hierarchical').getRecordTypeId();
        Account accountHierarchical = BrainHRDataFactory.newAccount();
        accountHierarchical.RecordtypeId = recordTypeAccountHierarchical;
        insert accountHierarchical;
        GS_Affectation_poste__c aff = new GS_Affectation_poste__c(crta__GS_Salarie__c = con.Id, crta__Hierarchical_Account__c = accountHierarchical.Id);
        insert aff;
    }
}