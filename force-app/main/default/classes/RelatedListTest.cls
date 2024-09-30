@IsTest
public class RelatedListTest {
	@IsTest
    private static void testAll() {
        Test.startTest();
        crta__Automation_Settings__c setting2 = new crta__Automation_Settings__c();
        setting2.crta__Activate_Triggers__c = true;
        insert setting2; 
        Map<String,Id> recordTypeByDeveloperName = new Map<String,Id>();
        for(RecordType currentRecordType : 
            [
                SELECT
                    Id,
                    DeveloperName
                FROM RecordType
                WHERE sObjectType = 'crta__Field__c'
            ]
        ) {
            recordTypeByDeveloperName.put(currentRecordType.DeveloperName,currentRecordType.Id);
        }
        
        crta__EI_Modele_d_entretien__c template = 
            new crta__EI_Modele_d_entretien__c(
                crta__EI_Actif__c = true,
                Name = 'Model Test'
            );
        insert template;

        Part__c part = new Part__c(
            Template__c = template.Id,
            Name = 'Part',
            Order__c = 1,
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60'
        );
        insert part;

        Section__c sectionTab = new Section__c(
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60',
            Label__c = 'Section',
            Part__c = part.Id,
            Order__c = 1,
            Name = 'Section'
        );
        insert sectionTab;

        Related_List__c rl = new Related_List__c (
            Object_API_Name__c = 'Contact',
            Section__c = sectionTab.Id
        );
        insert rl;

        List<Field__c> fields = new List<Field__c>();

        Field__c fieldRL = new Field__c(
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60',
            Name = 'test',
            Employee_Writing_Access__c = '10,20,40,50,60',
            Manager_Writing_Access__c = '10,20,40,50,60',
            Related_List__c = rl.Id,
            Api_Name__c = 'Name',
            RecordTypeId = recordTypeByDeveloperName.get('Related_List_Field')
        );
        fields.add(fieldRL);

        Field__c fieldTab = new Field__c(
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60',
            Name = 'test',
            Employee_Writing_Access__c = '10,20,40,50,60',
            Manager_Writing_Access__c = '10,20,40,50,60',
            Section__c = sectionTab.Id,
            Api_Name__c = 'crta__EI_Statut__c',
            RecordTypeId = recordTypeByDeveloperName.get('Section_Field')
        );
        fields.add(fieldTab);

        Field__c fieldTab2 = new Field__c(
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60',
            Name = 'test',
            Employee_Writing_Access__c = '10,20,40,50,60',
            Manager_Writing_Access__c = '10,20,40,50,60',
            Section__c = sectionTab.Id,
            Api_Name__c = 'RecordType.Name',
            RecordTypeId = recordTypeByDeveloperName.get('Section_Field')
        );
        fields.add(fieldTab2);

        Field__c fieldTab3 = new Field__c(
            Employee_Reading_Access__c = '10,20,40,50,60',
            Manager_Reading_Access__c = '10,20,40,50,60',
            Name = 'test',
            Employee_Writing_Access__c = '10,20,40,50,60',
            Manager_Writing_Access__c = '10,20,40,50,60',
            Section__c = sectionTab.Id,
            Api_Name__c = 'crta__EI_Salarie_qui_passe_l_entretien__r.Name',
            RecordTypeId = recordTypeByDeveloperName.get('Section_Field')
        );
        fields.add(fieldTab3);

        insert fields;

        try{
            Field__c fieldTab4 = new Field__c(
                Employee_Reading_Access__c = '10,20,40,50,60',
                Manager_Reading_Access__c = '10,20,40,50,60',
                Name = 'test',
                Employee_Writing_Access__c = '10,20,40,50,60',
                Manager_Writing_Access__c = '10,20,40,50,60',
                Section__c = sectionTab.Id,
                Api_Name__c = 'titi',
                RecordTypeId = recordTypeByDeveloperName.get('Section_Field')
            );
            insert fieldTab4;
        } catch(Exception e) {

        }

        try{
            Field__c fieldTab5 = new Field__c(
                Employee_Reading_Access__c = '10,20,40,50,60',
                Manager_Reading_Access__c = '10,20,40,50,60',
                Name = 'test',
                Employee_Writing_Access__c = '10,20,40,50,60',
                Manager_Writing_Access__c = '10,20,40,50,60',
                Section__c = sectionTab.Id,
                Api_Name__c = 'titi__r.toto',
                RecordTypeId = recordTypeByDeveloperName.get('Section_Field')
            );
            insert fieldTab5;
        } catch(Exception e) {

        }
        Test.stopTest();
    }
}