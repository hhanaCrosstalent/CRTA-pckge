public without sharing class PortalMenuController {
  
    public class ApplicationWrapper {
    @AuraEnabled
    public Id id { get; set; }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String icon { get; set; }
    @AuraEnabled
    public String cmp { get; set; }
     @AuraEnabled
    public Boolean selected { get; set; }
        @AuraEnabled
    public Boolean isHome { get; set; }

     public ApplicationWrapper(Id id, String label, String icon, String cmp, Boolean isHome) {
        this.id=id;
        this.label=label;
        this.icon= 'utility:'+ icon;
        this.cmp=cmp;
        this.selected=isHome;
        this.isHome=isHome;
     }

    }

    @AuraEnabled//(cacheable=true)
  public static List<ApplicationWrapper> getAppsListFromCustomSettingCtrl() {
    List<ApplicationWrapper> appsWrapperList = new List<ApplicationWrapper>();

    String userLocale = UserInfo.getLanguage();

    for (crta__application_RH__mdt app : [
      SELECT Id,
        MasterLabel, crta__French_label__c, 
        Dutch_Label__c , English_Label__c, German_Label__c, Portuguese_Label__c, Spanish_Label__c, Italian_Label__c ,
        crta__Component__c,
        crta__Icon__c , crta__Ordre__c , crta__IsHome__c
      FROM crta__application_RH__mdt
      WHERE crta__Is_Active__c =  TRUE
      ORDER BY crta__Ordre__c ASC 
    ]) {
      String appLabel = app.crta__French_label__c;

            if(userLocale == 'nl_NL') {
                appLabel = (!String.isBlank(app.Dutch_Label__c) ? app.Dutch_Label__c : app.MasterLabel);
            }
            if(userLocale == 'en_US') {
                appLabel = (!String.isBlank(app.English_Label__c) ? app.English_Label__c : app.MasterLabel);
            }
            if(userLocale == 'de') {
                appLabel = (!String.isBlank(app.German_Label__c) ? app.German_Label__c : app.MasterLabel);
            }
            if(userLocale == 'pt_BR') {
                appLabel = (!String.isBlank(app.Portuguese_Label__c) ? app.Portuguese_Label__c : app.MasterLabel);
            }
            if(userLocale == 'es') {
                appLabel = (!String.isBlank(app.Spanish_Label__c) ? app.Spanish_Label__c : app.MasterLabel);
            }
             if(userLocale == 'it') {
                appLabel = (!String.isBlank(app.Italian_Label__c) ? app.Italian_Label__c : app.MasterLabel);
            }
            
        appsWrapperList.add(new ApplicationWrapper(app.Id, appLabel, app.crta__Icon__c, app.crta__Component__c , 
        app.crta__IsHome__c));
    }

    return appsWrapperList;
  }

}