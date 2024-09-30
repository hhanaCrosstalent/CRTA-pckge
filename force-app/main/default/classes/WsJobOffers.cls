/**
 * @WsJobOffers.cls
 *
 * Retrieves Job Offers depending of custom setting criteria
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
@RestResource(urlMapping='/HrFlowGetJobOffers/*')
global class WsJobOffers {  
    @httpGet
    webservice static  List<crta__Offre_d_emploi__c> getJobOffersWS()
    {
        WsEngine.Logger logger = new WsEngine.Logger();
        WebServiceObjectsV2.JobOffers jo = new WebServiceObjectsV2.JobOffers();
        List<crta__Offre_d_emploi__c> jobOffers = new List<crta__Offre_d_emploi__c>();  
        try {                      
            jobOffers = jo.getJobOffers();
        } catch (Exception e) {
            logger.createLog( e.getMessage(),e.getMessage());
        }finally {
            logger.flush();            
        }
        return jobOffers;
    } 
}