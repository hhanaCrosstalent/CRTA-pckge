//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the 'rapport' page
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.9
 */
public with sharing class bdu_rapportController {
      public Map<Id, BDU_Contenu__c> rapports { set; get; }
      public Map<String, List<BDU_Contenu__c>> donnees{ set; get; }
      public List<String> listAnnees{ set; get; }
      public BDU_Contenu__c mockContent { get; set; }

      /**
       * Retrieves all the donn_e__c which are 'Bibliothèque'
       * The iterates on them and fetch the corresponding attachment
       * Finally we group the donn_e_c by cat_gorie__c
       */
      public bdu_rapportController() {
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
        listAnnees = new List<String>();
        rapports = new Map<Id, BDU_Contenu__c>(
            [SELECT Id, Name, CT_URL__c, CT_Type_de_donnee__c, CT_Annee__c, CT_Comite__c, CT_publish_date__c,
                Autoriser_le_telechargement__c, CT_isConfidential__c, CT_confidentialityDate__c,
                (SELECT Id, Name, ContentType
                 FROM Attachments
                 ORDER BY LastModifiedDate
                 LIMIT 12),
                (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title
                 FROM AttachedContentDocuments
                 LIMIT 12)
             FROM BDU_Contenu__c
             WHERE CT_Type_de_donnee__c = 'Rapport'
             AND CT_publish_date__c <= TODAY
             AND CT_BU1__c = :mockContent.CT_BU1__c
             AND CT_BU2__c = :mockContent.CT_BU2__c
             AND CT_BU3__c = :mockContent.CT_BU3__c
             AND CT_BU4__c = :mockContent.CT_BU4__c
             AND CT_BU5__c = :mockContent.CT_BU5__c
             ORDER BY Id]);

        for(BDU_Contenu__c rapport: rapports.values()) {
            if( donnees.containsKey(rapport.CT_Annee__c)) {
                List<BDU_Contenu__c> temp = donnees.get(rapport.CT_Annee__c);
                temp.add(rapport);
                temp.sort();
                donnees.put(rapport.CT_Annee__c,temp);
            } else {
                List<BDU_Contenu__c> temp = new List<BDU_Contenu__c>();
                temp.add(rapport);
                temp.sort();
                donnees.put(rapport.CT_Annee__c,temp);
            }
        }

        if(donnees.size() > 0){
            Schema.DescribeFieldResult fieldResult = BDU_Contenu__c.CT_Annee__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry c : ple) {
                if (donnees.containsKey(c.getValue())) {
                    listAnnees.add(c.getValue());
                }
            }
        }


        bdu_templateController.setBuCookie(mockContent.CT_BU1__c, mockContent.CT_BU2__c, mockContent.CT_BU3__c,
            mockContent.CT_BU4__c, mockContent.CT_BU5__c);
    }

      /**
       * Remote action to mark the joyride plugin as finished
       * @return String Status of the update or an error message
       */
      @RemoteAction
      public static String finishJoyride() {
            try {
                if(!Schema.sObjectType.User.fields.hasJoyrideBDU__c.isUpdateable()) {
                    return System.Label.SI_Error_joyride_finish.replace('{0}', 'User does not have sufficient rights.');
                }
                  User currentUser = [SELECT Id, hasJoyrideBDU__c FROM User WHERE Id = :UserInfo.getUserId()];
                  currentUser.hasJoyrideBDU__c = true;
                  update currentUser;

                  return 'success';
            } catch(Exception e) {
                  System.debug(e.getMessage());
                  if(e.getTypeName() == 'System.DmlException') {
                        return System.Label.SI_Error_joyride_finish.replace('{0}', e.getDmlMessage(0));
                  }
                  return System.Label.SI_Error_joyride_finish.replace('{0}', e.getMessage());
            }
      }

}