/*
@Author Hana.H
*/
@IsTest
public class CelebrationControllerTest {


    @TestSetup
    static void makeData(){
         Account account = BrainHRDataFactory.newAccount();
        insert account;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();

        Contact contact = BrainHRDataFactory.newContact(account);
        insert contact;
		        
        User testUser = new User(LastName = 'test user 1', 
                                Username = 'test.user.1@example.com', 
                                Email = 'test.1@example.com', 
                                Alias = 'testu1', 
                                TimeZoneSidKey = 'GMT', 
                                LocaleSidKey = 'en_GB', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                ProfileId = testProfile.Id,
                                crta__Contact__c = contact.Id,
                                LanguageLocaleKey = 'en_US',
                                isActive = true);  
        
        insert testUser;
        
        
    }


    @isTest
    static void testgetContactsByBirthday() {
        try {
            CelebrationController.getContactsByBirthday(300,300, new List<String>());
        }catch(Exception e) {
            
        }
    }
    
}