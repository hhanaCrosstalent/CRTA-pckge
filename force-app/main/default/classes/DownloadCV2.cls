public with sharing class DownloadCV2 {
    
    @Future(Callout=true)
    public static void downloadCV(String url, Id candidatureId, String pathOnClient, String title) {
        String LastName;
        String FirstName;
        crta__Positionnement__c candidature = [SELECT Id, crta__CT_Candidate__c FROM crta__Positionnement__c WHERE Id =:candidatureId LIMIT 1];
        for(Contact con:[select id, LastName,FirstName from Contact where Id=: candidature.crta__CT_Candidate__c]){
            LastName=con.LastName;
            FirstName=con.FirstName;
        }
        Id cvId = saveContentVersion(url, pathOnClient, title,LastName,FirstName);
        saveContentDocumentLink(cvId, candidatureId);
    }

    private static void saveContentDocumentLink(Id cvId, Id candidatureId) {
        
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : cvId];
        ContentDocumentLink cdl = new ContentDocumentLink ();
        cdl.LinkedEntityId = candidatureId;
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.ShareType = 'I';
        cdl.Visibility = 'AllUsers';
        try{
            insert cdl;
        }catch (DMLException e) {
                if (activateLogs()){
                    String message = e.getDmlMessage(0);
                    logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' file.\n Details : \n'+message);
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
        cv.Title = title; 
        cv.ContentLocation = 's';
        cv.PathOnClient = '/' + pathOnClient;
        cv.VersionData = getBlob(url);
        try{
            insert cv;
        }catch (DMLException e) {
            if (activateLogs()){
                String message = e.getDmlMessage(0);
                logMessage('Web service failed', 'Error when inserting '+e.getNumDml()+' cv.\n Details : \n'+message);
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
    public static void logMessage(String message, String body)
    {WsEngine.Logger logger = new WsEngine.Logger();
        logger.write(
                message,
                body,
                null
        );
        logger.flush();
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
}