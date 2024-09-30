/*
 * @Author: Nouha Maddeh
 * Classe de Test
 * */     
@isTest
public class BATCHContactAnonymizationTest {
    
    
    @isTest
    public static void TestMethodOne(){
        Id recordType=[SELECT Id FROM Recordtype WHERE developerName='Anonymization'].Id;
        Account acc=new Account(Name='Account Test');
        insert acc;
        
        Contact con=new Contact(FirstName='Test',LastName='Contact',recordtypeId=recordType);
        insert con;
        
        
        Contact conAnonymization=new Contact(FirstName='Test',LastName='Anonymization',crta__To_anonymize__c=true, crta__CT_Matricule__c='TN001');
        insert conAnonymization;
        
        Test.startTest();
        Database.executeBatch(new BATCHContactAnonymization());
        Test.stopTest();
        
    }

}