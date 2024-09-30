@isTest
private class ArticlesPicklistHelperTest {
	@isTest
	private static void testMethodOne() {
        Test.startTest();
        ArticlesPicklistHelper ctrl = new ArticlesPicklistHelper();
        ctrl.getDefaultValue();
        ctrl.getValues();
        ctrl.getDefaultValue();
        ctrl.getValues();
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(Label.None, '');
        
        ArticlesPicklistHelper ctrl2 = new ArticlesPicklistHelper();
        
        ctrl2.getDefaultValue();
        system.assertEquals(ctrl2.getValues().size(), 3);
        ctrl2.getValues();
        
        Test.StopTest();
    }
}