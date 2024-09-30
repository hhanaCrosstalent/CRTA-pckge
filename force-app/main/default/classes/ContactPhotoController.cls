public without sharing class ContactPhotoController {


    public class PhotoWrapper {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String url {get; set;}
        @AuraEnabled
        public String initials {get; set;}
        public PhotoWrapper(String name, String url, String initials) {
            this.name=name;
            this.url=url;
            this.initials=initials;
        }

    }

    @AuraEnabled
    public static photoWrapper getContactPhoto(String contactId){

    Contact c = [select Name, FirstName, LastName from Contact where Id = :contactId];


     List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId=:contactId AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC LIMIT 1];


   if (pictureList!=null && !pictureList.isEmpty())  {
    return  new PhotoWrapper(c.Name,'/sfc/servlet.shepherd/version/download/' + pictureList.get(0).Id, null) ;
   }

    List<User> u = [select crta__Contact__c, MediumPhotoUrl from User where crta__Contact__c = :contactId and IsActive  = true 
     LIMIT 1];

    
    return u!=null && !u.isEmpty() && u.get(0).MediumPhotoUrl.lastIndexOf('/profilephoto/005/M')==-1 ? new PhotoWrapper(c.Name,u.get(0).MediumPhotoUrl, null) : new PhotoWrapper(c.Name,null, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase()) ;
    }
}