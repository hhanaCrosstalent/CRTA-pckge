@IsTest
public class BaseTest {

   // @IsTest
    private static void baseRepositoryTest() {
     /*   List<String> fields = new List<String>{'Date__c', 'Type__c'};
        List<String> fieldOperations = new List<String>{'=', '!='};
        List<String> fieldValues = new List<String>{'Test', 'Test 2'};

        String className = String.valueOf(Temps__c.sObjectType);

        List<sObject>  objectList = BaseRepository.getAllForObject(className);
        System.assertEquals(2, objectList.size());

        objectList = BaseRepository.getAllForObjectOrderedBy(className, 'Date__c', 'ASC');
        System.assertEquals(2, objectList.size());

        objectList = BaseRepository.getAllForObjectUntranslated(className);
        System.assertEquals(2, objectList.size());

        objectList = BaseRepository.getAllForObjectUntranslatedOrderedBy(className, 'Date__c', 'ASC');
        System.assertEquals(2, objectList.size());

        objectList = BaseRepository.getAllForObjectAndFields(className, fields);
        System.assertEquals(2, objectList.size());

        objectList = BaseRepository.getAllForObjectAndFieldsOrderedBy(className, fields, 'Date__c', 'ASC');
        System.assertEquals(2, objectList.size());

        Temps__c t = [SELECT Id FROM Temps__c WHERE Type__c = '10 Présence'][0];
        Temps__c objet = (Temps__c)BaseRepository.getByIdForObject(t.Id, className);
        System.assertEquals(System.today(), objet.Date__c);

        objet = (Temps__c)BaseRepository.getByIdForObjectUntranslated(t.Id, className);
        System.assertEquals('10 Présence', objet.Type__c);

        objet = (Temps__c)BaseRepository.getByIdForObjectAndFields(t.Id, className, fields);
        System.assertEquals(System.today(), objet.Date__c);

        String filters = BaseRepository.addFilter(fields, new List<String>(), fieldValues);
        System.assertEquals(' WHERE Id != null AND Date__c = \'Test\' AND Type__c = \'Test 2\'', filters);

        filters = BaseRepository.addFilter(fields, fieldOperations, fieldValues);
        System.assertEquals(' WHERE Id != null AND Date__c = \'Test\' AND Type__c != \'Test 2\'', filters);
    }

    @TestSetup
    private static void testSetup() {
        Contact c = new Contact(LastName = 'Collab');
        insert c;

        Feuille_Temps_Hebdo__c f = new Feuille_Temps_Hebdo__c(
                Date_debut_semaine__c = System.today(),
                Date_de_fin__c = System.today().addDays(6),
                Salarie__c = c.Id
                );
        insert f;

        Temps__c t = new Temps__c(
                Date__c = System.today(),
                Heure_de_debut__c = '08:00',
                Heure_de_fin__c = '17:00',
                Type__c = '10 Présence',
                Feuille_hebdo__c = f.Id
                );
        insert t;
        Temps__c t2 = new Temps__c(
                Date__c = System.today().addDays(1),
                Heure_de_debut__c = '08:00',
                Heure_de_fin__c = '17:00',
                Type__c = '70 Astreinte',
                Feuille_hebdo__c = f.Id
                );
        insert t2;*/
    }
}