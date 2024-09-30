/**
*** @Author : Hamid BENCHIKH
*** @Date : 07/08/2023 
*** @Modified by :
*** @Last Modified Date : 
**/

public without sharing class VerifFilesOnborardingController {
    
    // récuperer les picklist
    public class OptionWrapper{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
    }
    
    @AuraEnabled 
    public static List<OptionWrapper> getselectOptions(sObject objObject, String field) { 
        List<OptionWrapper> allOpts = new List<OptionWrapper>(); 
        Schema.sObjectType objType = objObject.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> values = fieldMap.get(field).getDescribe().getPickListValues(); 
        for(Schema.PicklistEntry a : values) {
            OptionWrapper pickist = new OptionWrapper(); 
            pickist.label = a.getLabel();
            pickist.value = a.getValue();
            allOpts.add(pickist); 
        } 
        // allOpts.sort(); 
        return allOpts; 
    }
    
    
    @AuraEnabled
    Public static List<ContentVersion> getAllFiles(String contactIdParam){
        String dossierDocumentaire =[SELECT Id FROM crta__Dossier_documentaire__c 
                                     WHERE (crta__Salarie__c=:contactIdParam AND crta__is_Onboarding_Folder__c=true )
                                     ORDER BY CreatedDate ASC].Id;
        
        system.debug('contactIdParacrta__Dossier_documentaire__cm contactIdParam ' + contactIdParam);
       
        
        List<ContentVersion> listeFiles = new List<ContentVersion>();
        set<id> iddoc = new set<id>();
        for(ContentDocumentLink cdl : [SELECT id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: dossierDocumentaire]) {
            iddoc.add(cdl.ContentDocumentId);
        }
        for(ContentVersion c:[SELECT Id, title, crta__Etat__c,CreatedDate , ContentDocumentId, crta__Commentaire__c, PathOnClient,
                              crta__Tags__c , toLabel(crta__Type__c) 
                              FROM ContentVersion 
                              WHERE islatest=true 
                              AND ContentDocumentId IN :iddoc]) {
                                  listeFiles.add(c);
                              }
        
        system.debug('list listeFiles ' + listeFiles);
        system.debug('list listeFiles ' + listeFiles.size());
        return listeFiles;
    } 
    
    //show CV document
    @AuraEnabled
    public static Id showFileCandidature(Id PositionId){
        Id DocumentId;
        system.debug('je suis dans showFileCandidature PositionId ' + PositionId); 
        
        List<ContentDocumentLink> DocumentList=[SELECT ContentDocumentId FROM ContentDocumentLink 
                                                WHERE ContentDocumentId=: PositionId]; // order by ContentDocument.CreatedDate limit 1
        for (ContentDocumentLink doc:DocumentList){
            DocumentId=doc.ContentDocumentId;
        }
        system.debug('je suis dans showFileCandidature DocumentId ' + DocumentId); 
        
        return DocumentId;
        
    }
    
    @AuraEnabled
    public static String updateDocument(List<ContentVersion> documents) {
        Set<Id> cv_Ids=new Set<Id>();
        Map<Id,ContentVersion> MapCVById=new Map<Id,ContentVersion>();
        for(ContentVersion c:documents){
            cv_Ids.add(c.Id);
        }
        for(ContentVersion cv:documents){
            MapCVById.put(cv.Id,cv);
        }
        List<ContentVersion> cvList=[select id, title,crta__Etat__c,crta__Commentaire__c from ContentVersion where Id IN:cv_Ids ];
        List<ContentVersion> cvToUpdate=new List<ContentVersion>();
        
        for(ContentVersion cv:cvList){
            cv.crta__Etat__c=MapCVById.get(cv.Id).crta__Etat__c;
            cv.crta__commentaire__c=MapCVById.get(cv.Id).crta__Commentaire__c;
            cvToUpdate.add(cv);             
        }
        
        update cvToUpdate;
        
        return 'SUCCESS';
    }
    
    
    @AuraEnabled
    public static String updateAndSendMail(String contactId, List<ContentVersion> documents) { 
        Boolean isCompliant = false;
        Contact c =[Select id, crta__CT_Status_of_employee__c, crta__Onboarding_Errors__c FROM Contact WHERE Id=:contactId];  
        String err_msg ='';
        // crta__Dossiers_documentaires__r
        for (ContentVersion cv : documents) {
            if (cv.crta__Etat__c =='Non-compliant') {
                isCompliant=true; 
                if (cv.Commentaire__c !=null) {
                    err_msg += cv.crta__Type__c +': ' + cv.crta__Commentaire__c +'.\n';
                    c.crta__Onboarding_Errors__c =  err_msg;
                }
                //break;              
            }
        }
        if (isCompliant) {
            c.crta__CT_Status_of_employee__c =  '80 Modification employee';
            update c;	
        }
        return 'Succes';
    }
    
    
    
    
}