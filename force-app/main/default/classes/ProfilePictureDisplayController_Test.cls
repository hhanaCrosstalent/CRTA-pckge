@IsTest
private class ProfilePictureDisplayController_Test {
 
    @IsTest
    static void testAll() {
 
 
  Contact contact = new contact (lastname ='tot');
  insert contact ;
 
  ContentVersion filePhoto = new contentVersion ( title='toto', firstPublishLocationId=contact.id, versionData=blob.valueof('toto'), pathOnClient='/toto');
  insert filePhoto;
  ContentVersion composantPhoto = new contentVersion ( title='titi', firstPublishLocationId=contact.id, versionData=blob.valueof('titi'), pathOnClient='/titi');
  insert composantPhoto;
  ProfilePictureDisplayController.getProfilePicture(contact.id);
  ProfilePictureDisplayController.getInitialsCtrl(contact.id);
  ProfilePictureDisplayController.saveTheFile(contact.Id, 'toto', 'toto') ;
  ProfilePictureDisplayController.getProfilePictureComposant(contact.id);
  ProfilePictureDisplayController.saveTheFileAsProfilPicture(contact.Id, 'titi', 'titi');    
 
}
}