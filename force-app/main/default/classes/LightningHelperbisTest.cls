@IsTest
private with sharing class LightningHelperbisTest {
    
    @IsTest
    private static void getTranslationMap() {
        Map<String, Map<String, String>> m = new Map<String, Map<String, String>>();

        Map<String, String> trans = LightningHelperbis.getTranslationMap(Contact.SObjectType, new String[] {'Lastname'});
        System.assertEquals(3, trans.size(), 'Did not return translation for LastName field of Contact.');

        try {
            LightningHelperbis.getTranslationMap(Contact.SObjectType, new String[] {'DoesNotExist'});
            System.assert(false, 'Did not throw an exception when requesting non-existent field of Contact.');
        } catch(Exception e) {
            // expected
        }
    }
}