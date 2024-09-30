//Security isCreateable() isUpdateable() isDeletable() checked
global without sharing class ManagePermissionSetAssignmentsController {
    @InvocableMethod(label='GetPermissionSetAssignments' description='Retrieve PermissionSetAssignments from given users.' category='')
    global static List<List<PermissionSetAssignment>> manageAssignments(List<List<User>> users) {
        Set<Id> userIds = new Set<Id>();
        for (List<User> ul : users) {
            for (User u : ul) {
            	userIds.add(u.Id);
            }
        }

        return new List<List<PermissionSetAssignment>>{[
            SELECT Id, AssigneeId, PermissionSetId
            FROM PermissionSetAssignment
            WHERE AssigneeId IN: userIds
        ]};
    }
}