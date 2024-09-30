//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Controller for the search page
* @author Crosstalent
* @version 1.4
*/
public with sharing class bdu_searchController {
    public String searchInput {get;set;} //Text to search
    public Integer nbElements  {get;set;} //Number of results
    //public List<BDU_Indicateur__c> indicateurList {get; set;} //List of the retrieved indicateur
    public List<BDU_valeur__c> valuesList {get; set;} //List of the retrieved values
    public List<BDU_Contenu__c> contentList {get; set;} //List of the retrieved content

    /**
    * Initialize the page
    */
    public bdu_searchController() {
        nbElements = -1;
    }

    /**
    * Processes the text entered and retrieves the results
    * @return PageReference null
    */
    public pageReference search() {
        String input = String.escapeSingleQuotes(searchInput)+'*';
        if(input.length()<3) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,
                                                        'La recherche ne peut faire moins de 3 signes'));
        } else {
            List<List<SObject>> searchList = [FIND :input
                                              IN ALL FIELDS RETURNING BDU_Valeur__c, BDU_Contenu__c];
            searchValues(searchList[0]);
            searchContent(searchList[1]);
        }
        nbElements = valuesList.size() + contentList.size();
        return null;
    }

    /**
    * Searches the indicateurs
    * @param List<SObject> objects A list of indicateurs
    * @return void
    */
    /*
    private void searchIndicateur(List<SObject> objects) {
        List<Id> ids = new List<Id>();
        for(SObject obj : objects){
            ids.add(obj.id);
        }
        indicateurList = [SELECT Id, CT_Libelle__c, CT_Domaine__c, CT_BDU_Domaine__r.CT_BDU_chapitre__r.Name, CT_BDU_Domaine__r.Name, CT_Description__c FROM BDU_Indicateur__c WHERE Id IN :ids and CT_Affiche__c=true];
    }
    */

    /**
    * Searches the values
    * @param List<SObject> objects A list of values
    * @return void
    */
    private void searchValues(List<SObject> objects) {
        List<Id> ids = new List<Id>();
        for(SObject obj : objects){
            ids.add(obj.id);
        }
        String pInput = '%' + String.escapeSingleQuotes(searchInput) + '%';
        valuesList = [SELECT Id, Name, CT_Annee__c, CT_Trimestre__c, CT_Mois__c,
                             CT_BU__c, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c,
                             CT_BDU_Indicateur__r.Name, CT_BDU_Indicateur__r.CT_Domaine__c
                      FROM BDU_Valeur__c
                      WHERE (Id IN :ids
                        AND CT_BDU_Indicateur__r.CT_Affiche__c=true
                        AND CT_A_publier__c=true
                        AND CT_Date_de_publication__c <= TODAY
                        AND (CT_Date_de_fin_de_publication__c = null OR CT_Date_de_fin_de_publication__c > TODAY))
                      OR (CT_BDU_Indicateur__r.Name LIKE: pInput)
                      OR (CT_BDU_Indicateur__r.CT_Article__c LIKE: pInput)
                     ];
    }

    /**
    * Searches the contents
    * @param List<SObject> objects A list of contents
    * @return void
    */
    private void searchContent(List<SObject> objects) {
        List<ID> ids = new List<ID>();
        for( SObject obj : objects ){
            ids.add(obj.id);
        }
        contentList = [SELECT Id, Name, CT_Type_de_donnee__c, CT_Annee__c, CT_Categorie__c, CT_entite__c, CT_URL__c,
                              Autoriser_le_telechargement__c,
                              (SELECT Id, Name, ContentType FROM Attachments ORDER BY LastModifiedDate LIMIT 12),
                              (SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title
                               FROM AttachedContentDocuments LIMIT 12)
                       FROM BDU_contenu__c
                       WHERE Id IN: ids
                       AND CT_publish_date__c <= TODAY];
    }

    /**
    * Searches the attachments
    * @param List<SObject> objects A list of attachments
    * @return void
    */
    /*private void searchAttachment(List<SObject> objects) {
    //--- trouver le texte à l'intérieur du fichier attaché à BDU_contenu
    Map<String,Attachment> att = new Map<String,Attachment>();
    for( Attachment a : [SELECT Id, Body, Parentid, Name from Attachment WHERE Parentid IN (SELECT Id FROM Bdu_contenu__c)]) {
    try {
    String hex = EncodingUtil.convertToHex(a.body);
    String txt = EncodingUtil.convertToHex(blob.valueof(searchInput));
    if ( hex.contains(txt) ){
    att.put( a.parentId, a );
}
} catch (Exception e) {
system.debug('Exception ligne:'+e.getLineNumber()+' msg:'+e.getMessage());
}
}
for( BDU_contenu__c c : [SELECT Id, Name, CT_Type_de_donnee__c, CT_Annee__c, CT_Categorie__c, CT_entite__c FROM BDU_contenu__c WHERE Id IN :att.keySet()])
{
contentList.add( new Contenu( c, null, '/servlet/servlet.FileDownload?file='+att.get(c.id).Id, c.name+' (dans le fichier '+att.get(c.id).name+')') );
}

List<ID> ids = new List<ID>();
for( SObject obj : objects ){
ids.add(obj.id);
}
List<Attachment> ids_contenu_in_attach = [SELECT Id, Parentid, Name FROM Attachment WHERE Id IN :ids AND Parentid IN (SELECT Id FROM BDU_contenu__c)];
for( Attachment a2 : ids_contenu_in_attach ) {
att.put( a2.parentId, a2 );
}
for( BDU_contenu__c c : [SELECT Id, Name, CT_Type_de_donnee__c, CT_Annee__c, CT_Categorie__c, CT_entite__c FROM BDU_contenu__c WHERE Id IN :att.keySet()]) {
contentList.add( new Contenu( c, null, '/servlet/servlet.FileDownload?file='+att.get(c.id).Id, c.name+' ('+att.get(c.id).name+')') );
}
}
*/
}