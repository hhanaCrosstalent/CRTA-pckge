@IsTest
private class RecruitmentMapControllerTest {
    
    
    @IsTest
    static void getPicklistsTest() {
        try {
        RecruitmentMapController.getPicklists();
        RecruitmentMapController.getContactTypes();
        RecruitmentMapController.getPicklist(null);            
            
        }catch(Exception e) {
            
        }
    }
    
    
    

}