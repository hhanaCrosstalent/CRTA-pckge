public with sharing class ProfilePictureDisplayController {
        //get profilePicture from component
        @AuraEnabled
        public static ContentVersion getProfilePictureComposant(Id parentId) {
 
             // Attachment permissions are set in parent object (Contact)
            if (!Schema.sObjectType.Contact.isAccessible()) {
                throw new System.NoAccessException();
                //return null;
            }
            List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId=:parentId 
                                                //AND Description = 'Profile_Picture'
                                                AND crta__Type__c = 'profilPicture'
                                                ORDER BY LastModifiedDate DESC LIMIT 1];
            System.debug(pictureList);
            return (pictureList.size() > 0) ? pictureList.get(0) : null;
        } 


        @AuraEnabled
        public static string getInitialsCtrl(Id recordId){
            try {
              Contact c = [select FirstName, LastName from Contact where Id = :recordId];
              String fn = !String.isBlank(c.FirstName) ? c.FirstName.left(1) : '';
              String ln = !String.isBlank(c.LastName) ? c.LastName.left(1) : '';
              return fn+ln;
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

    	//get last profil picture from ContentDocumentLink
    	@AuraEnabled
        public static ContentVersion getProfilePicture(Id parentId){
            // Attachment permissions are set in parent object (Contact)
            if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.NoAccessException();
            //return null;
            }
            /*list <ContentDocumentLink> cdl = [SELECT Id, ContentDocumentId, LinkedEntityId 
                                              FROM ContentDocumentLink 
                                              WHERE LinkedEntityId =: parentId 
                                              AND ContentDocumentId 
                                              IN (SELECT ContentDocumentID 
                                                  FROM ContentVersion
                                                  WHERE crta__Type__c = 'profilPicture')
                                              ORDER BY SystemModstamp DESC LIMIT 1
                                             ];
            	list <ContentVersion> cv = [SELECT Id, Title, LastModifiedDate, crta__Type__c, FirstPublishLocationId  
                                           FROM ContentVersion 
                                           WHERE crta__Type__c = 'profilPicture'] ;
               for(ContentDocumentLink cdl1 : cdl){
               cv = [SELECT Id, Title, LastModifiedDate, crta__Type__c, FirstPublishLocationId  
                                           FROM ContentVersion 
                                           WHERE crta__Type__c = 'profilPicture' 
                                           AND ContentDocumentId =: cdl1.ContentDocumentId];
            }*/
             List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId=:parentId 
                                                //AND Description = 'Profile_Picture'
                                                AND crta__Type__c = 'profilPicture'
                                                ORDER BY LastModifiedDate DESC LIMIT 1];
            return (pictureList.size() > 0) ? pictureList.get(0) : null;
           // return (cv.size() > 0) ? cv.get(0) : null ;
        }
        //save the picture
        @AuraEnabled
         public static Id saveTheFile(Id parentId, String fileName, String base64Data) { 
            ContentVersion contentVersion = new ContentVersion();
                contentVersion.versionData = EncodingUtil.base64Decode(base64Data);
                contentVersion.title = fileName;
                contentVersion.pathOnClient =  '/' + fileName;
                contentVersion.FirstPublishLocationId = parentId;
                contentVersion.Description = 'Profile_Picture';
                contentVersion.crta__Type__c = 'profilPicture';
            insert contentVersion; 
            return contentVersion.Id;
        }  
        //save the picture with type=profilPicture
        @AuraEnabled
         public static Id saveTheFileAsProfilPicture(Id parentId, String fileName, String base64Data) { 
            ContentVersion contentVersion = new ContentVersion();
                contentVersion.versionData = EncodingUtil.base64Decode(base64Data);
                contentVersion.title = fileName;
                contentVersion.pathOnClient =  '/' + fileName;
                contentVersion.FirstPublishLocationId = parentId;
                contentVersion.crta__Type__c = 'profilPicture';
            insert contentVersion; 
            return contentVersion.Id;
        }  

 
 
}