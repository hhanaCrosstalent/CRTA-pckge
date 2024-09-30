//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the 'bibliotheque' page
 *
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.9
 */
public with sharing class bdu_bibliController {
      public Map<Id, BDU_Contenu__c> rapports { set; get; }
      public Map<String, List<BDU_Contenu__c>> donnees{ set; get; }
      public List<String> listCategories{ set; get; }
      public BDU_Contenu__c mockContent { get; set; }

      /**
       * Retrieves all the donn_e__c which are 'Bibliothèque'
       * The iterates on them and fetch the corresponding attachment
       * Finally we group the donn_e_c by cat_gorie__c
       */
      public bdu_bibliController() {
            mockContent = new BDU_Contenu__c(
                  CT_BU1__c = bdu_templateController.getSelectedBu('BU1'), 
                  CT_BU2__c = bdu_templateController.getSelectedBu('BU2'),
                  CT_BU3__c = bdu_templateController.getSelectedBu('BU3'),
                  CT_BU4__c = bdu_templateController.getSelectedBu('BU4'),
                  CT_BU5__c = bdu_templateController.getSelectedBu('BU5')
            );

            changeEntity();
      }

      /**
       * Retrieves the documents based on the selected entity
       * @return void
       */
      public void changeEntity() {
            donnees = new Map<String, List<BDU_Contenu__c>>();
            listCategories = new List<String>();
            rapports = new Map<Id, BDU_Contenu__c>(
                [SELECT Id, Name, CT_URL__c, CT_Type_de_donnee__c, CT_categorie__c, CT_Comite__c, CT_publish_date__c,
                    Autoriser_le_telechargement__c, CT_isConfidential__c, CT_confidentialityDate__c,
                    (SELECT Id, Name, ContentType
                        FROM Attachments
                        ORDER BY LastModifiedDate
                        LIMIT 12),
                    (Select ContentDocument.LatestPublishedVersionId, ContentDocument.Title
                        FROM AttachedContentDocuments
                        LIMIT 12)
                FROM BDU_Contenu__c
                WHERE CT_Type_de_donnee__c = 'Bibliothèque'
                AND CT_publish_date__c <= TODAY
                AND CT_BU1__c = :mockContent.CT_BU1__c
                AND CT_BU2__c = :mockContent.CT_BU2__c
                AND CT_BU3__c = :mockContent.CT_BU3__c
                AND CT_BU4__c = :mockContent.CT_BU4__c
                AND CT_BU5__c = :mockContent.CT_BU5__c
                ORDER BY Id]);

            for(BDU_Contenu__c rapport: rapports.values()) {
                  if( donnees.containsKey(rapport.CT_categorie__c)) {
                        List<BDU_Contenu__c> temp = donnees.get(rapport.CT_categorie__c);
                        temp.add(rapport);
                        temp.sort();
                        donnees.put(rapport.CT_categorie__c,temp);
                  } else {
                        List<BDU_Contenu__c> temp = new List<BDU_Contenu__c>();
                        temp.add(rapport);
                        temp.sort();
                        donnees.put(rapport.CT_categorie__c,temp);
                  }
            }

            if(donnees.size() > 0){
                  Schema.DescribeFieldResult fieldResult = BDU_Contenu__c.CT_Categorie__c.getDescribe();
                  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                  for( Schema.PicklistEntry c : ple) {
                        if (donnees.containsKey(c.getValue())) {
                              listCategories.add(c.getValue());
                        }
                  }
            }

            bdu_templateController.setBuCookie(mockContent.CT_BU1__c, mockContent.CT_BU2__c, mockContent.CT_BU3__c,
                mockContent.CT_BU4__c, mockContent.CT_BU5__c);

      }

}