/**
 * @WsEngine.cls
 *
 * Expose the web service to be called by HrFlow (For the Hr flow asynchrone creation) 
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
@RestResource(urlMapping='/HrFlowCreateProfile/*')
global class WsEngine {

    @httpPost
    webservice static void upsertHrFlowProfile() { 
        String s;
        WsEngine.Logger logger = new WsEngine.Logger();
        try {
            s = RestContext.request.requestBody.toString();
            logger.write('Request body', s, null);
            MasterV2 myMaster = (MasterV2) JSON.deserialize(s, MasterV2.class);
            //MasterLWC myMasterLWC = (MasterLWC) JSON.deserialize(s, MasterLWC.class);
            CtEngineV2 myEngine = new CtEngineV2();
            myEngine.upsertProfile(myMaster);
        } catch(Exception e) {
            logger.write('General problem with request format: ' + e.getMessage(), s, null);
            // logger.flush();
        } finally {
            logger.flush();
        }
    }

    public class Logger {
    
        private final Boolean CLEAN_REGULARLY = true;
        private List<Web_Service_Log__c> logs = new List<Web_Service_Log__c>();
    
        public void write(String message, String body, Integer httpStatus) {
            message = message.trim();
            if(message.length()>255) {
                message = message.substring(0, 255);
            }
            Web_Service_Log__c log = new Web_Service_Log__c(
                Status_Code__c = httpStatus,
                Message__c = message,
                Response_Body__c = body,
                Type__c = 'UPSERT_CANDIDATE'
            );
            logs.add(log);
            System.debug('Added log: ' + log);
        }

        public void createLog(String message,String body){
            message = message.trim();
            if(message.length()>255) {
                message = message.substring(0, 255);
            }
            Web_Service_Log__c log = new Web_Service_Log__c(
                //Status_Code__c = httpStatus,
                Message__c = message,
                Response_Body__c = body,
                Type__c = 'GET JOB OFFERS'
            );
            logs.add(log);
            System.debug('Added log: ' + log);
        }
        
    
        public void flush() {
            Database.insert(logs, false);
            if(CLEAN_REGULARLY) cleanBefore(System.today().addMonths(-3));
        }
    
        private void cleanBefore(Date d) {
            List<Web_Service_Log__c> logsList = [SELECT Id FROM Web_Service_Log__c WHERE CreatedDate <: d limit 10000];
            if(logsList.size() >0) delete logsList;
        } 
    }
    
}