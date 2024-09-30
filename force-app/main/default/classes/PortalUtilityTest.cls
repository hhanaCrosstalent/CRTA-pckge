@isTest
private without sharing class PortalUtilityTest {
    @isTest
    private static void itShould() {
        Set<String> idsSet = new Set<String>();
        
        Account m0 = new Account(Name = 'TEST1');
        insert m0;

        idsSet.add(m0.Id);
        Account m1 = new Account(Name = 'TEST2', ParentId = m0.Id);
        insert m1;
        m1.Parent = m0;

        idsSet.add(m1.Id);
        Account m2 = new Account(Name = 'TEST3', ParentId = m1.Id);
        insert m2;
        m2.Parent = m1;

        idsSet.add(m2.Id);
        Account m3 = new Account(Name = 'TEST4', ParentId = m2.Id);
        insert m3;
        m3.Parent = m2;

        idsSet.add(m3.Id);
        Account m4 = new Account(Name = 'TEST5', ParentId = m3.Id);
        insert m4;
        m4.Parent = m3;

        idsSet.add(m4.Id);
        Account m5 = new Account(Name = 'TEST6', ParentId = m4.Id);
        insert m5;
        m5.Parent = m4;


        idsSet.add(m5.Id);
        Account c = new Account(Name = 'TEST7', ParentId = m5.Id);
        insert c;
        c.Parent = m5;


        String accountNameM1 = PortalUtility.get(c, 'Parent.Name');
        System.assertEquals('TEST6', accountNameM1);
        String accountNameM2 = PortalUtility.get(c, 'Parent.Parent.Name');
        System.assertEquals('TEST5', accountNameM2);
        String accountNameM3 = PortalUtility.get(c, 'Parent.Parent.Parent.Name');
        System.assertEquals('TEST4', accountNameM3);
        String accountNameM4 = PortalUtility.get(c, 'Parent.Parent.Parent.Parent.Name');
        System.assertEquals('TEST3', accountNameM4);
        String accountNameM5 = PortalUtility.get(c, 'Parent.Parent.Parent.Parent.Parent.Name');
        System.assertEquals('TEST2', accountNameM5);

        Map<String, Schema.SObjectField> mapTypes = Schema.SObjectType.Contact.fields.getMap();
        PortalUtility.getFieldType(mapTypes, 'Firstname');
        PortalUtility.getFieldType(mapTypes, 'Account.Name');

        try {
            String highManagerAccountName = PortalUtility.get(c, 'Parent.Parent.Parent.Parent.Parent.Parent.Name');
            System.assert(false);
        }
        catch(PortalUtility.FieldTooDeepException e) {
            System.assert(true);
        }
        
        Map<String, Map<String, String>> m = new Map<String, Map<String, String>>();

        Map<String, String> trans = PortalUtility.getTranslationMap(Contact.SObjectType, new String[] {'Lastname'});
        System.assertEquals(3, trans.size(), 'Did not return translation for LastName field of Contact.');

        try {
            PortalUtility.getTranslationMap(Contact.SObjectType, new String[] {'DoesNotExist'});
            System.assert(false, 'Did not throw an exception when requesting non-existent field of Contact.');
        } catch(Exception e) {
            // expected
        }
        
        Object t1 = PortalUtility.setFieldValue('test', 'string');
		System.assertEquals('test', t1);
        
        Object t2 = PortalUtility.setFieldValue(String.valueOf(system.today()), 'date');
        Object t3 = PortalUtility.setFieldValue(String.valueOf(system.today()), 'date');
        Object t4 = PortalUtility.setFieldValue(String.valueOf(system.now()), 'datetime');
        Object t5 = PortalUtility.setFieldValue(String.valueOf(system.now()), 'datetime');
        Object t6 = PortalUtility.setFieldValue('Web', 'picklist');
        Object t7 = PortalUtility.setFieldValue('true', 'boolean');
        Object t8 = PortalUtility.setFieldValue('false', 'boolean');
        Object t9 = PortalUtility.setFieldValue('test', 'test');
        Object t10 = PortalUtility.setFieldValue('test.com', 'url');
        Object t11 = PortalUtility.setFieldValue('1000', 'currency');
    }
}