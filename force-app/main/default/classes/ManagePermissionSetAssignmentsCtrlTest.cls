@isTest
private class ManagePermissionSetAssignmentsCtrlTest {
	@isTest
    private static void testMethod1() {
        User u = new User(
            Username = 'userNameTesta1b2c3d4e5@test.fr',
            Email = 'userNameTesta1b2c3d4e5@test.fr',
            Alias = 'zyxwvu',
            CommunityNickname = 'userNameTesta1b2c3d4e5',
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%dmin%' AND Name LIKE '%sys%' LIMIT 1].Id,
            LastName = 'userNameTesta1b2c3d4e5',
            EmailEncodingKey= 'ISO-8859-1', 
            LanguageLocaleKey= 'fr',
            TimeZoneSidKey = 'Europe/Paris', 
            LocaleSidKey = 'fr_FR_EURO'
        );
        insert u;
		System.assert(u != null);
        List<List<User>> ul = new List<List<User>>{new List<User>{u}};
        ManagePermissionSetAssignmentsController.manageAssignments(ul);
    }
}