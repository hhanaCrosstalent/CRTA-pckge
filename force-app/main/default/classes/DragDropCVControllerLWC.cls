public with sharing class DragDropCVControllerLWC
{         public class SuperDuper {
        public Data data;
    }

    public class Data {
        public MasterLWC profile;
    }
 
 

    @AuraEnabled
    public static String uploadFile(String fileName, Id fileId) {
        System.debug('Received file: ' + fileName);
        crta__SynchronousParsing__mdt sp = [SELECT X_USER_EMAIL__c, X_API_KEY__c,endpoint__c,source_key__c,sync_parsing__c FROM crta__SynchronousParsing__mdt where crta__Active__c = True limit 1][0];
        String xUserEmail = sp.X_USER_EMAIL__c;
        String xApiKey = sp.X_API_KEY__c;
        String endpoint = sp.endpoint__c;
        String sourceKey = sp.source_key__c;
        Decimal syncParsing = sp.sync_parsing__c;

        Integer iSyncParsing = Integer.valueOf(syncParsing);
        HttpResponse response = FileDispatcherLWC.dispatch(fileId, fileName, endpoint, sourceKey, '' + iSyncParsing,
                xApiKey, xUserEmail);
        String body = response.getBody();
       if (activateLogs()){logMessage('DragDropCVControllerLWC body response-',String.valueOf(body));}
        SuperDuper sd = (SuperDuper) JSON.deserialize(body, SuperDuper.class);
       if (activateLogs()){logMessage('DragDropCVControllerLWC SuperDuper-',String.valueOf(sd));}
        MasterLWC myMaster = sd.data.profile;
       if (activateLogs()){logMessage('DragDropCVControllerLWC myMaster-',String.valueOf(myMaster));}
        CtEngineLWC myEngine = new CtEngineLWC();
        String message = myEngine.upsertProfile(myMaster);
      if (activateLogs()){logMessage('DragDropCVControllerLWC message-',message);}

        return message;
    }
 
		public  static Boolean activateLogs(){
      Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
        if (logactive) {
          return true;
        }
        else {
            return false;
        }
  
    } 
    
    
     private static void logMessage(String message,String body)
    {    WsEngine.Logger logger = new WsEngine.Logger();
        logger.write(
                message,
                body,
                null
        );
        logger.flush();
    }

}