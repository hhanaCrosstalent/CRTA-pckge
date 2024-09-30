public with sharing class DragDropCVController {

    public class SuperDuper {
        public Data data;
    }
    
    public class Data {
        public MasterV2 profile;
    }

    @AuraEnabled
    public static String uploadFile(String fileName, String base64Data) {
        System.debug('Received file: ' + fileName);        

        crta__SynchronousParsing__mdt mySP = [SELECT X_USER_EMAIL__c, X_API_KEY__c,endpoint__c,source_key__c,sync_parsing__c FROM crta__SynchronousParsing__mdt where crta__Active__c = True limit 1][0];
        system.debug(mySP.X_USER_EMAIL__c);

        String xUserEmail = mySP.X_USER_EMAIL__c;
        String xApiKey = mySP.X_API_KEY__c;
        String endpoint = mySP.endpoint__c;
        String sourceKey = mySP.source_key__c;
        Decimal syncParsing = mySP.sync_parsing__c;
/*
        SynchronousParsing__mdt sp = SynchronousParsing__mdt.getInstance('SynchronousParsing');
        String xUserEmail = sp.X_USER_EMAIL__c;
        String xApiKey = sp.X_API_KEY__c;
        String endpoint = sp.endpoint__c;
        String sourceKey = sp.source_key__c;
        Decimal syncParsing = sp.sync_parsing__c;
*/
        Integer iSyncParsing = Integer.valueOf(syncParsing);
        WsEngine.Logger logger = new WsEngine.Logger();//To log result
        HttpResponse response = FileDispatcher.dispatch(base64Data, fileName, endpoint, sourceKey, '' + iSyncParsing,
            xApiKey, xUserEmail);

        String body = response.getBody();
        logger.write('Request body', body, null);
        logger.flush();
        SuperDuper sd = (SuperDuper) JSON.deserialize(body, SuperDuper.class);
        MasterV2 myMaster = sd.data.profile;
        CtEngineV2 myEngine = new CtEngineV2();
        myEngine.upsertProfile(myMaster);

        return body;
    }

}