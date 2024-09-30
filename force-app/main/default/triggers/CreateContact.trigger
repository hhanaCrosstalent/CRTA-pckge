//Security isCreateable() isUpdateable() isDeletable() checked
// Jeff handover (19/01/17): This should be edited, so it accommodates the logic that is actually in use
// on customer sites in different triggers. This one is otherwise obsolete.
trigger CreateContact on User(after insert) {
    Boolean isActive = false;
    try {
        isActive = SIRH__c.getInstance().newContactFromUser__c;
    } catch(Exception e) {
        System.debug(e.getMessage());
    }

    if(isActive) {
        RecordType type = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salarie' LIMIT 1];
        List<Contact> contactToInsert = new List<Contact>();
        List<User> userToUpdate = new List<User>();
        Map<Id, User> userByUserId = new Map<Id, User>([
            SELECT FirstName, LastName, Contact__c
            FROM User 
            WHERE Id IN: trigger.newMap.keySet()
        ]);
        for(String userId: trigger.newMap.keySet()) {
            User newUser = userByUserId.get(userId);
            if(String.isBlank(newUser.Contact__c)) {
                Contact newContact = new Contact(
                    FirstName = newUser.FirstName,
                    LastName = newUser.LastName,
                    RecordType = type
                );
                contactToInsert.add(newContact);
                newUser.Contact__c = newContact.Id;
                userToUpdate.add(newUser);
            } else {
                System.debug('User is already linked to a Contact.');
            }
        }

        if(
            contactToInsert.size() > 0
            && Schema.sObjectType.Contact.isCreateable()
            && Schema.sObjectType.Contact.fields.FirstName.isCreateable()
            && Schema.sObjectType.Contact.fields.LastName.isCreateable()
            && Schema.sObjectType.Contact.fields.RecordTypeId.isCreateable()
        ) {
            insert contactToInsert;
        }

        if(
            userToUpdate.size() < 0
            && Schema.sObjectType.User.isUpdateable()
            && Schema.sObjectType.User.fields.Contact__c.isUpdateable()
        ) {
            update userToUpdate;
        }
    }
}