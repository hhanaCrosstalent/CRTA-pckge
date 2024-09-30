public without sharing class PortalHomeController {
   static final string standard= 'slds-col';
   static final string half= STANDARD+ ' slds-size_1-of-2';
   static final string all= STANDARD+ ' slds-size_2-of-2';

   public Enum CMPSIZE{STANDARD, HALF, ALL}
   


    
    public class ComponentWrapper {
    

   private Map<PortalHomeController.CMPSIZE, String> CMPSIZEValues = new Map<PortalHomeController.CMPSIZE, String> {
    PortalHomeController.CMPSIZE.STANDARD => 'slds-col slds-size_1-of-3',
    PortalHomeController.CMPSIZE.HALF => PortalHomeController.half,
    PortalHomeController.CMPSIZE.ALL => PortalHomeController.all
   };
        
       @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String identifier { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String prefix { get; set; }
        @AuraEnabled
        public Map<String, Object> parameters { get; set; }
        @AuraEnabled
        public String taille;
        
        public ComponentWrapper(String label, String identifier , String name, String prefix, Map<String, Object> parameters, String size) {
            this.label=label;
            this.name=name;
            this.prefix=prefix;
            this.parameters=parameters;
            this.identifier=identifier;
            if (!String.isBlank(size)) {
            this.taille = this.CMPSIZEValues.get(PortalHomeController.CMPSIZE.valueOf(size));
            }
        }
        
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<ComponentWrapper> getComponentsCtrl(String appId, STring filter, Integer lim) {
        System.debug('the app Id');
        System.debug(appId);
        List<ComponentWrapper> cmps = new List<ComponentWrapper>();

        String cmpQuery = 'select Id , label ,  crta__Component_Name__c , NamespacePrefix  , crta__Namespace__c ,  crta__Size__c , crta__Order__c ,'
          +'(SELECT Id,   crta__Component__c, crta__Parameter_Name__c,  crta__Parameter_Type__c, crta__Parameter_Value__c FROM Team_Components_Parameters_Settings__r '
          +'  WHERE crta__Component__c != NULL AND crta__Disable__c = false) '
           +' from 	crta__Team_Component_Setting__mdt where  crta__Disable__c = false ';
           if (!String.isBlank(appId)) {
            cmpQuery += ' and crta__RH_application__c = :appId ';
           }
           if (!String.isBlank(filter)) {
                        cmpQuery += (' and ' + filter);
           }
           cmpQuery += ' ORDER BY crta__Order__c ASC ';
           if( lim != null && lim >0 ){
            cmpQuery += (' LIMIT '+lim);
           }
           System.debug(cmpQuery);
     
        for(crta__Team_Component_Setting__mdt c : Database.query(cmpQuery))  {
                                                       Map<String,Object> parametersList = new Map<String,Object>();
              for(crta__Team_Component_Parameter_Setting__mdt  p : c.Team_Components_Parameters_Settings__r) {
                        Object paramValue = null;
                        if(p.crta__Parameter_Value__c != null) {
                            if(p.crta__Parameter_Type__c == 'Integer') {
                                paramValue = Integer.valueOf(p.crta__Parameter_Value__c);
                            } else if (p.crta__Parameter_Type__c == 'Boolean') {
                                paramValue = Boolean.valueOf(p.crta__Parameter_Value__c);
                            } else {
                                paramValue = p.crta__Parameter_Value__c;
                            }
                        }
                                parametersList.put(p.crta__Parameter_Name__c, paramValue);
                                                       }
                                                       
                                cmps.add(new ComponentWrapper(c.label, c.Id, c.crta__Component_Name__c , c.crta__Namespace__c ,  parametersList, c.crta__Size__c));
                                                   }
                                                       
                                                       
        
         return cmps;
        
    }

}