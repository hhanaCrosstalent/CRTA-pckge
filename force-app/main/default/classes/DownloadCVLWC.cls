/**
 * Created by Saad on 03/02/2022.
 */

public with sharing class DownloadCVLWC {

    
    @Future(Callout=true)
    public static void downloadCV(String url, Id profilId, String pathOnClient, String title,String LastName,String FirstName) {
      
        Id cvId = saveContentVersion(url, pathOnClient, title,LastName,FirstName);

        saveContentDocumentLink(cvId, profilId);
    }

    private static void saveContentDocumentLink(Id cvId, Id profilId) {
        try{
            
            ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : cvId];
            if (activateLogs()){
                logMessage('DownloadCVLWC saveContentDocumentLink'+cv.Id);
            }
            ContentDocumentLink cdl = new ContentDocumentLink ();
            cdl.LinkedEntityId = profilId;
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.ShareType = 'I';
            cdl.Visibility = 'AllUsers';
            try{
                insert cdl; 
            } catch (DMLException e) {
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' file.\n Details : \n'+message);
                }
            }
            
        }Catch(Exception e){
            
            if (activateLogs()){
                String message = e.getDmlMessage(0);
                logMessage('Web service failed','Error in saveContentDocumentLink method. \n Details : \n'+message);
            }
        }
    }


    private static Id saveContentVersion(String url, String pathOnClient, String title,String LastName,String FirstName) {
       
        Datetime UTC = System.now(); 
        Organization orgDetails = [SELECT Id, TimeZoneSidKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()]; 
        String orgTime = UTC.format('yyyy-MM-dd HH:mm:ss', orgDetails.TimeZoneSidKey); 
        if (title=='resume' || title=='original' ){
            title='CV'+LastName+FirstName+orgTime;
        }
        
        ContentVersion cv = new ContentVersion();
        try{
            cv.Title = title;
            cv.crta__Type__c='CV';
            cv.ContentLocation = 's';
            cv.PathOnClient = '/' + pathOnClient;
            cv.VersionData = getBlob(url);
            try{
                insert cv;
            }catch (DMLException e) {
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' Cv.\n Details : \n'+message);
                }
            }
        }Catch(Exception e){
            
            if (activateLogs()){
                String message = e.getDmlMessage(0);
                logMessage('Web service failed','Error in saveContentVersion method. \n Details : \n'+message);
            }
        }
        return cv.Id;
        
        
    }

    private static Blob getBlob(String url) {
        HttpRequest req = new HttpRequest();
        req.setTimeout(60000);
        url = url.replace(' ', '%20');
        req.setEndpoint(url);
        req.setCompressed(true);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res.getBodyAsBlob();
    }
    
    public static Boolean activateLogs(){
      Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
        if (logactive) {
          return true;
        }
        else {
            return false;
        }
  
    } 
    
    
     private static void logMessage(String message)
    { WsEngine.Logger logger = new WsEngine.Logger();
        logger.write(
                message,
                null,
                null
        );
        logger.flush();
    }
    public static void logMessage(String message, String body)
    {WsEngine.Logger logger = new WsEngine.Logger();
        logger.write(
                message,
                body,
                null
        );
        logger.flush();
    }
}