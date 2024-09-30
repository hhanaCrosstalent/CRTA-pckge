//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Helper class for the BDU
* 
* @author Crosstalent
* @group BDU-Backend
* @version 1.0
*/
global class indicateurHelper {
    
    /**
* Retrieves a report's Id from its name
* @param  code String Name of the report
* @return   Report's id or an error message if no reports are found
*/
    webservice static String ShowReport(String code) {
        String reportId;
        try {
            reportId = [SELECT Id FROM Report WHERE name =:code ORDER BY CreatedDate DESC LIMIT 1].Id;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return ': '+e.getMessage();
        }
        return reportId;
    }
}