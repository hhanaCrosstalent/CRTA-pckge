/*
 * @Author Hana.H
 */ 
@IsTest
public class WelcomeToControllerTest {
    


    @TestSetup
    static void makeData(){
        Account account = BrainHRDataFactory.newAccount();
        insert account;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();

        Contact contact = BrainHRDataFactory.newContact(account);
        contact.crta__CT_Date_of_entry_to_the_society__c=System.today();
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


    @IsTest
    static void getNewContactsTest() {
        WelcomeToController.getNewContacts11(100,-300,'AccountId');
    }




     @IsTest
    static void getTodayIncommingContacts1Test() {
        WelcomeToController.getIncommingContacts(100,-300,'','AccountId');
    }
}