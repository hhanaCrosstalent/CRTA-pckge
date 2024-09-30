@IsTest
private class recruitmentListController_test {
    
    @IsTest
    private static void recruitmentListControllerTest() {
        Contact contact = new Contact(LastName='test');
        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        
        PageReference pg = Page.recruitmentList;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id', contact.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contact);
        recruitmentListController controller 
            = new recruitmentListController(new ApexPages.StandardSetController(contacts));
        System.assert(ApexPages.currentPage().getParameters().get('id') == contact.Id);
    }
}