@IsTest
private class employeeSearchController_test {

    @IsTest
    private static void employeeSearchControllerTest() {
        //instantiate a page
        PageReference pg = Page.employeeSearch;
        Test.setCurrentPage(pg);
        EmployeeSearchController controller= new EmployeeSearchController();
        controller.searchText = 'Test';
        controller.search();
        controller.toggleSort();
        controller.searchText = '';
        controller.search();
         system.assert(controller.searchtext == '');
    }
}