/**
 * @DragDropFactory.cls
 *
 * Used to retriev metadata parameters and call synchronous parsing Service 
 * @author Abdelkader Morjan 
 *HrFlow synchronous Connector @version 2.0 2021/10/24
 */

public class DragDropFactory implements Queueable, Database.AllowsCallouts {

    String fileName;
    String base64Data;

    public DragDropFactory(Blob blParamFile, string fileName) {
        this.base64Data = EncodingUtil.base64Encode(blParamFile);
        this.fileName = fileName;
    }

    public void execute(QueueableContext qc) {

        SynchronousParsing__mdt sp = SynchronousParsing__mdt.getInstance('SynchronousParsing');
        String xUserEmail = sp.X_USER_EMAIL__c;
        String xApiKey = sp.X_API_KEY__c;
        String endpoint = sp.endpoint__c;
        String sourceKey = sp.source_key__c;
        Decimal syncParsing = sp.sync_parsing__c;

        Integer iSyncParsing = Integer.valueOf(syncParsing);

        HttpResponse response = FileDispatcher.dispatch(base64Data, fileName, endpoint, sourceKey, '' + iSyncParsing,
            xApiKey, xUserEmail);

        String body = response.getBody();
        DragDropCVController.SuperDuper sd = (DragDropCVController.SuperDuper) JSON.deserialize(body, 
            DragDropCVController.SuperDuper.class);
        MasterV2 myMaster = sd.data.profile;
        CtEngineV2 myEngine = new CtEngineV2();
        myEngine.upsertProfile(myMaster);
    }
}