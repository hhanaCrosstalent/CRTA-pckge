//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the base template of the BDU app
 * @author Crosstalent
 * @group BDU-Frontend
 * @version 1.5
 */
public with sharing class bdu_templateController {
    public Boolean hasJoyride {set; get;}
    public List<BDU_Chapitre__c> chapitres { set; get; }
    public Map<Id, List<BDU_Domaine__c>> chapitreToDomaines { set; get; }
    public Boolean selectedChoice {set; get; }
    public String splashScreenPage {set; get; }
    public String customCSS {set; get; }
    public String customLogo {set; get; }

    /**
     * We populate the lateral menu
     * We first retrieve the BDU_Chapitre__c
     * We then loop on them and retrieve their children BDU_Domaine__c
     */
    public bdu_templateController() {
        try {
            Override__c options = override__c.getInstance();
            splashScreenPage = options.CT_SplashScreen__c;
            customCSS = bdu_templateController.getResourceURL(options.css__c);
            customLogo = bdu_templateController.getResourceURL(options.Logo__c);
            hasJoyride = [SELECT hasJoyrideBDU__c 
                          FROM User 
                          WHERE Id =: UserInfo.getUserId()].hasJoyrideBDU__c;
        } catch(System.QueryException e) {
            System.debug(e);
        }
        //Menu management
        chapitreToDomaines = new Map<Id, List<BDU_Domaine__c>>();
        chapitres = [SELECT Id, Name, CT_Order__c, CT_Affiche__c
                     FROM BDU_Chapitre__c 
                     WHERE CT_Affiche__c = true
                     ORDER BY CT_Order__c];

        for(BDU_Chapitre__c chapitre: chapitres) {
            List<BDU_Domaine__c> domaines = [SELECT Id, Name, CT_slug__c, CT_Order__c, CT_BDU_Chapitre__c
                                             FROM BDU_Domaine__c
                                             WHERE CT_BDU_Chapitre__c = :chapitre.Id
                                             AND CT_Affiche__c = true
                                             ORDER BY CT_Order__c];
            chapitreToDomaines.put(chapitre.id, domaines);
        }
    }

      /**
       * If the user accepted the splash screen we authenticate him
       *     -> If the splash screen is set as permanent we create a cookie with the defined longevity
       *     -> Else we update the user to mark him as accepted
       * If the user refused the splash screen we redirect him top the specified location
       * @return¨PageReference The current page unblocked or a specified url
       */
      public PageReference acceptSplash() {
           Boolean repeatSplash = Override__c.getInstance().CT_Splash__c;
           String orgName = Userinfo.getOrganizationName();

            if(selectedChoice) {
                  if(repeatSplash && !Bdu_templateController.getHasConfidentialCookie()) {
                        Integer repeatTime = (Integer) Override__c.getInstance().CT_SplashTime__c;
                        Cookie hasConfidential = new Cookie('hasConfidential_'+orgName, '1',null, repeatTime, false);
                        ApexPages.currentPage().setCookies(new Cookie[]{hasConfidential});
                  } else {
                      if(!Schema.sObjectType.User.fields.CT_hasConfidential__c.isUpdateable()) {
                          System.debug('User does not have sufficient rights.');
                          return null;
                      }
                        Id userId=userinfo.getUserId();
                        User currentUser = [SELECT Id, Name, CT_hasConfidential__c FROM User WHERE Id=:userId];
                        currentUser.CT_hasConfidential__c = true;
                        update currentUser;
                  }
                  PageReference current = ApexPages.currentPage();
                  current.setRedirect(true);
                  return current;
            } else {
                 String exitUrl = (String) Override__c.getInstance().CT_exitUrl__c;
                 PageReference exitPage = new PageReference(exitUrl);
                 exitPage.setRedirect(true);
                 return exitPage;
          }
      }

      /**
       * This method is used by the Visualforce action {!hasConfidentialCookie} to display the splash screen
       * @return Boolean
       */
      public static Boolean getHasConfidentialCookie() {
            String orgName = userinfo.getOrganizationName();
            Cookie hasConfidential = ApexPages.currentPage().getCookies().get('hasConfidential_'+orgName);

            if(hasConfidential == null) return false;
            return true;
      }

    /**
     * Creates a cookie with the selected BUs values
     * @param BU1 Value of BU1
     * @param BU2 Value of BU2
     * @param BU3 Value of BU3
     * @param BU4 Value of BU4
     * @param BU5 Value of BU5
     */
    public static void setBuCookie(String BU1, String BU2, String BU3, String BU4, String BU5 ) {
        if(BU1 == null) BU1 = 'null';
        if(BU2 == null) BU2 = 'null';
        if(BU3 == null) BU3 = 'null';
        if(BU4 == null) BU4 = 'null';
        if(BU5 == null) BU5 = 'null';
        Cookie selectedBUs = new Cookie('selectedBUs', 'BU1:' + BU1 + ';' + 'BU2:' + BU2 + ';' + 'BU3:' + BU3 + ';' 
                                            + 'BU4:' + BU4 + ';' + 'BU5:' + BU5, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{selectedBUs});
      }

    /**
     * Retrieves the value of a BU
     * @param  BU Value to retrieve (e.g. 'BU1')
     * @return    String Value of the selected BU
     */
    public static String getSelectedBU(String BU) {
            Cookie selectedBUs;
            try {
                  selectedBUs =  ApexPages.currentPage().getCookies().get('selectedBUs');
            } catch(Exception e) {
                  System.debug(e.getMessage());
            }
            if(selectedBUs != null) {
                  List<String> BUs = selectedBUs.getValue().split(';');
                  for(String selectedBu: BUs) {
                        if(selectedBu.contains(BU)) {
                              List<String> buValue = selectedBu.split(':');
                              if(buValue.size() > 1) {
                                    if(buValue[1] == 'null') {
                                          return null;
                                    } else {
                                          return buValue[1];
                                    }
                              } else {
                                    return null;
                              }
                        }
                  }
            }

            return null;
      }

      @RemoteAction
      public static void checkNamespace() {}

      /**
       * Remote action to reset the joyride plugin
       * @return String Status of the update or an error message
       */
      public PageReference resetJoyride() {
            try {
                  if(!Schema.sObjectType.User.fields.hasJoyrideBDU__c.isUpdateable()) {
                      System.debug('User does not have sufficient rights.');
                      return null;
                  }
                  User currentUser = [SELECT Id, hasJoyrideBDU__c FROM User WHERE Id = :UserInfo.getUserId()];
                  currentUser.hasJoyrideBDU__c = false;
                  update currentUser;
            } catch(Exception e) {
                  System.debug(e.getMessage());
            }

            PageReference redirect = ApexPages.currentPage();
            redirect.setRedirect(true);
            return redirect;
      }

    /**
     * Prints the url for a resource
     * @param String Name of the wanted resource
     * @return String A relative url
     */
    public static String GetResourceURL(String resourceName) {

        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp
                                            FROM StaticResource
                                            WHERE Name =: resourceName];
        if(resourceList.size() == 1) {
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            if(namespace != null && namespace != '') {
                return URL.getSalesforceBaseUrl().toExternalForm()+'/resource/' 
                    + resourceList[0].SystemModStamp.getTime() 
                    + '/' + namespace + '__' + resourceName;
            } else {
                return URL.getSalesforceBaseUrl().toExternalForm().replace('crta', 'c')+'/resource/' 
                        + resourceList[0].SystemModStamp.getTime() + '/' + resourceName;
            }
        } else {
            return '';
        }
    }
}