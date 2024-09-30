@isTest
private class ContactSkillProfileLineTest {
	@isTest
    private static void test() {
        crta__Trigger_Settings__c setting = new crta__Trigger_Settings__c();
        setting.crta__Activate_on_Contact_Skill_Profile_Line__c = true;
        insert setting;

        crta__Automation_Settings__c autoSetting = new crta__Automation_Settings__c();
        autoSetting.crta__Activate_Triggers__c = true;
        insert autoSetting;

        Account account = new Account(Name = 'AccountTest');
        insert account;
        
        Id recordTypeEmployee = Schema.SObjectType.Contact
            .getRecordTypeInfosByDeveloperName()
            .get('Salarie').getRecordTypeId();

        Contact contact = new Contact(AccountId = account.Id, 
                                      LastName = 'Test', 
                                      //crta__Contract_Type__c = 'CDI',
                                      crta__CT_Date_of_entry_to_the_society__c = Date.today().addYears(-2),
                                      RecordTypeId = recordTypeEmployee
                                      );
        insert contact;
        
         crta__Skill__c skillOne = new crta__Skill__c(Name = 'Test', crta__Active__c = true);
        insert skillOne;
        crta__Skill__c skillTwo = new crta__Skill__c(Name = 'Try', crta__Active__c = true);
        insert skillTwo;
        crta__Skill__c skillThree = new crta__Skill__c(Name = 'Three', crta__Active__c = true);
        insert skillThree;
		
        String skillProfileLineRT = 
            Schema.SObjectType.crta__Contact_Skill_Profile_Line__c
            .getRecordTypeInfosByDeveloperName()
            .get('Basic').getRecordTypeId();
        
        crta__Contact_Skill_Profile_Line__c assessmentOne = new crta__Contact_Skill_Profile_Line__c(crta__Skill__c = skillOne.Id,
                                                                    crta__Contact__c = contact.Id,
                                                                    crta__Assessor__c = contact.Id,
                                                                    crta__Active__c = true,
                                                                    crta__Status__c = '30 Approved',
                                                                    RecordTypeId = skillProfileLineRT);
        insert assessmentOne;

        crta__Contact_Skill_Profile_Line__c assessmentTwo = new crta__Contact_Skill_Profile_Line__c(crta__Skill__c = skillTwo.Id,
                                                                    crta__Contact__c = contact.Id,
                                                                    crta__Assessor__c = contact.Id,
                                                                    crta__Active__c = true,
                                                                    crta__Status__c = '30 Approved',
                                                                    RecordTypeId = skillProfileLineRT);
        insert assessmentTwo;

        crta__Contact_Skill_Profile_Line__c assessmentThree = new crta__Contact_Skill_Profile_Line__c(crta__Skill__c = skillOne.Id,
                                                                    crta__Contact__c = contact.Id,
                                                                    crta__Assessor__c = contact.Id,
                                                                    crta__Active__c = true,
                                                                    crta__Status__c = '30 Approved',
                                                                    RecordTypeId = skillProfileLineRT);
        insert assessmentThree;
        
        assessmentThree.crta__Status__c = '40 Rejected';
        update assessmentThree;
        assessmentThree.crta__Status__c = '90 Canceled';
        update assessmentThree;
        assessmentThree.crta__Status__c = '30 Approved';
        update assessmentThree;
        
        delete assessmentThree;
    }
}