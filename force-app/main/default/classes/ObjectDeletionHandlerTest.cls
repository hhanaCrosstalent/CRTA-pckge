@isTest
public class ObjectDeletionHandlerTest {

    @isTest
    static void testDeleteRelatedObjects() {
        // Créer des données de test (Contact et objets enfants liés)
        Contact testContact = new Contact(LastName = 'TestContact');
        insert testContact;

        // Définir les métadonnées personnalisées nécessaires
      /*  crta__Anony_Objet_Asso_Contact__mdt metadataRecord = new crta__Anony_Objet_Asso_Contact__mdt(
            MasterLabel = 'TestMetadataRecord'
        );
        insert metadataRecord;*/

        // Appeler la méthode deleteRelatedObjects de ObjectDeletionHandler avec les données de test
        Set<String> contactIds = new Set<String>{testContact.Id};
        Test.startTest();
        ObjectDeletionHandler.deleteRelatedObjects(contactIds);
        Test.stopTest();

        // Vérifier si les objets enfants ont été supprimés correctement (par exemple, en effectuant des requêtes SOQL)
        // Ajoutez des assertions ici selon vos besoins
    }

    @isTest
    static void testIsValidChildObject() {
        // Tester la méthode isValidChildObject avec différents cas
        // Assurez-vous de couvrir tous les scénarios possibles
        Boolean isValid = ObjectDeletionHandler.isValidChildObject('CustomObject__c', new Set<String>{'CustomObject__c'});
        System.assertEquals(true, isValid, 'La méthode isValidChildObject devrait renvoyer true pour un objet enfant valide');

        
    }
}