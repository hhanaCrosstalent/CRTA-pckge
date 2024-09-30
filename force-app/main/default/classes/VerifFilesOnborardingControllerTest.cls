@isTest
public class VerifFilesOnborardingControllerTest {
   
    
      @isTest 
    static void testClass() {
        
       	Account a = BrainHRDataFactory.newAccount();
        insert a;
        Contact c = BrainHRDataFactory.newContact(a);
        insert c;
        
        crta__Dossier_documentaire__c d = new crta__Dossier_documentaire__c(crta__Salarie__c =c.id , Name = 'Hello' , crta__Unique_Name__c ='Hmid doc', crta__is_Onboarding_Folder__c = true ); 
        insert d; 
        //insert dossier docuumentaire
        
        ContentVersion cv = new Contentversion();
        cv.Title = c.Id + '-CV';
        cv.crta__Type__c = 'CV';
        cv.PathOnClient ='test';
        cv.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert cv;
        
        //insert file 
    	ContentVersion fileB = new Contentversion();
        fileB.title= 'test-file';
       // fileB.crta__Type__c= 'test-file';
        fileB.crta__Commentaire__c= 'test-file';
        fileB.PathOnClient ='test';
        fileB.versiondata = EncodingUtil.base64Decode('Unit Test File Body');
        insert fileB;
        List<ContentVersion> documents = New List<ContentVersion>();
        documents.add(cv);
        documents.add(fileB);

        ContentVersion version1 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.LinkedEntityId = d.Id;
        fileLink.ContentDocumentId = version1.ContentDocumentId;
        fileLink.Sharetype = 'I';
        fileLink.Visibility = 'AllUsers';
        insert fileLink;
        
        VerifFilesOnborardingController.showFileCandidature(fileLink.Id);
		VerifFilesOnborardingController.updateDocument(documents);
		VerifFilesOnborardingController.updateAndSendMail(c.id, documents);
		VerifFilesOnborardingController.getAllFiles(c.id);
        VerifFilesOnborardingController.getselectOptions(version1,'crta__Etat__c');

    }
    
}