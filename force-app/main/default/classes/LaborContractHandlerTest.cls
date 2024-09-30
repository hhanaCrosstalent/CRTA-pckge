/*
 * @Author: Nouha Maddeh	
 * @CreatedDate: 27/02/2024
 * 
 * */
@IsTest
public class LaborContractHandlerTest {
    
    
     @testSetup
    private static void createTestData() {
        crta__ADP_Trigger_activation__c adp_trigger = new crta__ADP_Trigger_activation__c();
        adp_trigger.crta__ActivateTriggerADP__c = true;
        insert adp_trigger;
    }
    
    
    
    @IsTest
    private static void testAll() {
        Contact contact = BrainHRDataFactory.newContact();
        insert contact;
        
        
        Account legal = BrainHRDataFactory.newAccount('Legal');
        insert legal;
        crta__Labor_contract__c contract = BrainHRDataFactory.newContract(legal, contact);
        insert contract;
        
        
        contract.crta__End_Date__c=Date.newInstance(2024,12,30);
        update contract;
        
        
        contract.crta__End_Date__c=Date.newInstance(2024,12,25);
        update contract;
        
        contract.crta__End_Date__c=null;
        update contract;
        
        
        
        
    }

}