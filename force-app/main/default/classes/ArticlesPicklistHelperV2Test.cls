@isTest
private class ArticlesPicklistHelperV2Test {
	@isTest
	private static void testMethodOne() {
        Test.startTest();
        ArticlesPicklistHelperV2 ctrl = new ArticlesPicklistHelperV2();
        ctrl.getDefaultValue();
        ctrl.getValues();
        ctrl.getDefaultValue();
        ctrl.getValues();
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(Label.None, '');
        
        ArticlesPicklistHelperV2 ctrl2 = new ArticlesPicklistHelperV2();
        
        ctrl2.getDefaultValue();
        system.assertEquals(ctrl2.getValues().size(), 3);
        ctrl2.getValues();
        
        Test.StopTest();
    }
}