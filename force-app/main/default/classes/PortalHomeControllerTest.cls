@IsTest
public with sharing class PortalHomeControllerTest {
    
    @IsTest
    static void getComponentsCtrlTest() {

        List<crta__Team_Component_Setting__mdt> cmp = [select crta__RH_application__c from crta__Team_Component_Setting__mdt 
        where crta__RH_application__c!=null LIMIT 1];
        if(cmp!=null&& !cmp.isEmpty()){
            PortalHomeController.getComponentsCtrl(cmp.get(0).crta__RH_application__c, null,null);
        }
    } 
}