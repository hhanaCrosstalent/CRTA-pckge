/*
 * @Author Hana.H
 * 
 */
@IsTest
public class ContactPhotoControllerTest {
   @TestSetup
   static void makeData(){
     Account account = BrainHRDataFactory.newAccount();
        insert account;
        
        Profile testProfile = BrainHRDataFactory.getAdminProfile();

        Contact c = BrainHRDataFactory.newContact(account);
        insert c;
		        
        ContentVersion photo = new Contentversion();
        photo.title= c.Id + '-profilPicture';
        photo.Type__c = 'profilPicture';
        photo.PathOnClient ='test';
        Blob b = Blob.valueOf('Unit Test File Body');
        photo.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert photo;

        User testUser = new User(LastName = 'test user 1', 
                                Username = 'test.user.1@example.com', 
                                Email = 'test.1@example.com', 
                                Alias = 'testu1', 
                                TimeZoneSidKey = 'GMT', 
                                LocaleSidKey = 'en_GB', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                ProfileId = testProfile.Id,
                                crta__Contact__c = c.Id,
                                LanguageLocaleKey = 'en_US',
                                isActive = true);  
        
        insert testUser;
   }

   @IsTest
   static void getContactPhotoTest(){
    ContactPhotoController.getContactPhoto([select Id from Contact LIMIT 1].Id);
   }
}