//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Trigger to update job offers coordinates field
 * @author Crosstalent
 * @version 1.1
 */
trigger JobPosting on Offre_d_emploi__c(after insert, after update) {
    Boolean isActive = false;
    Set<Id> offerToUpdate = new Set<Id>();
    try {
        isActive = Geolocation__c.getInstance().jobOfferTrigger__c;
    } catch(Exception e) {
        System.debug(e.getMessage());
    }
    
    if(!System.isFuture() && isActive) {
        for(Offre_d_emploi__c c: trigger.new) {
            if(Trigger.isInsert) {
                offerToUpdate.add(c.Id);
            } else {
                if(
                    Trigger.oldMap.get(c.Id).CT_City__c != c.CT_City__c
                    || Trigger.oldMap.get(c.Id).CT_Postal_code__c != c.CT_Postal_code__c
                    || Trigger.oldMap.get(c.Id).CT_Country__c != c.CT_Country__c
                ) {
                    offerToUpdate.add(c.Id);
                }
            }
        }
         
        //geoLocationHelper.getJobOfferLocation(offerToUpdate); => commented By Hana.H on 21/05/24 to prevent prevent API requests limits (in org) from being exceeded

   }
}