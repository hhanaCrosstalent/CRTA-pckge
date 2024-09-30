//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date :  05/10/2020
*** @Modified by : MBAYE Fallou
*** @Last Modified Date : 27/10/2021
*** added the possibility to deactivate metadata
**/
public without sharing class TeamContainerController {
    public class TabWrapper implements Comparable {
        @AuraEnabled 
        public String label {get; set;}
        @AuraEnabled
        public List<TabWrapper> subTabsList {get;set;}
        @AuraEnabled
        public List<ComponentWrapper> componentList {get;set;}
        @AuraEnabled
        public Integer order {get;set;}
        
        public TabWrapper(String label, List<TabWrapper> subTabsList, List<ComponentWrapper> componentList, Decimal order) {
            this.label = label;
            this.subTabsList = subTabsList;
            this.componentList = componentList;
            this.order = Integer.valueOf(order);
        }
        
        public Integer compareTo(Object o) {
            TabWrapper to = (TabWrapper)o;
            
            if (order == null || order > to.order) {
                return 1;
            } else if (order < to.order) {
                return -1;
            }
            return 0;
        }
    }

    public class ComponentWrapper implements Comparable {
        @AuraEnabled 
        public String componentName {get; set;}
        @AuraEnabled 
        public String namespace {get; set;}
        @AuraEnabled
        public Map<String, Object> parameters {get;set;}
        @AuraEnabled
        public Integer order {get;set;}
        
        public ComponentWrapper(
            String componentName, String namespace, Map<String, Object> parameters, Decimal order) {
            this.componentName = componentName;
            this.namespace = namespace;
            this.parameters = parameters;
            this.order = Integer.valueOf(order);
        }
        
        public Integer compareTo(Object o) {
            ComponentWrapper to = (ComponentWrapper)o;
            
            if (order == null || order > to.order) {
                return 1;
            } else if (order < to.order) {
                return -1;
            }
            return 0;
        }
    }

    @AuraEnabled
    public static List<TabWrapper> getTabsCtrl() {
        List<crta__Team_Tab_Setting__mdt> tabSettings = new List<crta__Team_Tab_Setting__mdt>();
        for(crta__Team_Tab_Setting__mdt t : [
            SELECT Id, 
            crta__Dutch_Label__c,
            crta__English_Label__c,
            crta__German_Label__c,
            crta__Order__c,
            crta__Portuguese_Label__c,
            crta__Spanish_Label__c,
            crta__Italian_Label__c , 
            MasterLabel,
            (
                SELECT Id, 
                    crta__Component_Name__c,
                    crta__Namespace__c,
                    crta__Order__c,
                    crta__Tab__c 
                FROM Team_Components_Settings__r 
                WHERE Disable__c=false
                ORDER BY crta__Order__c ASC NULLS LAST
            )
            FROM crta__Team_Tab_Setting__mdt 
            WHERE Disable__c=false
            ORDER BY crta__Order__c ASC NULLS LAST
        ]) {
            tabSettings.add(t);
        }

        List<TabWrapper> tabList = new List<TabWrapper>();
        List<crta__Team_Sub_Tab_Setting__mdt> subTabSettings = getSubTabsCtrl();
        List<crta__Team_Component_Parameter_Setting__mdt> componentParamSettings = getComponentParamCtrl();

        for(crta__Team_Tab_Setting__mdt t : tabSettings) {
            String userLocale = UserInfo.getLanguage();
            String tablabel = t.MasterLabel;

            if(userLocale == 'nl_NL') {
                tablabel = (t.Dutch_Label__c != null ? t.Dutch_Label__c : t.MasterLabel);
            }
            if(userLocale == 'en_US') {
                tablabel = (t.English_Label__c != null ? t.English_Label__c : t.MasterLabel);
            }
            if(userLocale == 'de') {
                tablabel = (t.German_Label__c != null ? t.German_Label__c : t.MasterLabel);
            }
            if(userLocale == 'pt_BR') {
                tablabel = (t.Portuguese_Label__c != null ? t.Portuguese_Label__c : t.MasterLabel);
            }
            if(userLocale == 'es') {
                tablabel = (t.Spanish_Label__c != null ? t.Spanish_Label__c : t.MasterLabel);
            }
             if(userLocale == 'it') {
                tablabel = (t.Italian_Label__c != null ? t.Italian_Label__c : t.MasterLabel);
            }
            List<ComponentWrapper> componentList = new List<ComponentWrapper>();
            Map<String, Object> parametersList = new Map<String, Object>();
            for(crta__Team_Component_Setting__mdt c : t.Team_Components_Settings__r) {
                for(crta__Team_Component_Parameter_Setting__mdt p : componentParamSettings) {
                    if(p.crta__Component__c == c.Id) {
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
                }
                if(c.crta__Tab__c == t.Id) {
                    componentList.add(new ComponentWrapper(
                        c.crta__Component_Name__c,
                        c.crta__Namespace__c,
                        parametersList,
                        c.crta__Order__c
                    ));
                }
            } 
            List<TabWrapper> subTabList = new List<TabWrapper>();
            for(crta__Team_Sub_Tab_Setting__mdt s: subTabSettings) {
                if(s.crta__Tab__c == t.Id) {
                    String subtablabel = s.MasterLabel;

                    if(userLocale == 'nl_NL') {
                        subtablabel = (s.Dutch_Label__c != null ? s.Dutch_Label__c : s.MasterLabel);
                    }
                    if(userLocale == 'en_US') {
                        subtablabel = (s.English_Label__c != null ? s.English_Label__c : s.MasterLabel);
                    }
                    if(userLocale == 'de') {
                        subtablabel = (s.German_Label__c != null ? s.German_Label__c : s.MasterLabel);
                    }
                    if(userLocale == 'pt_BR') {
                        subtablabel = (s.Portuguese_Label__c != null ? s.Portuguese_Label__c : s.MasterLabel);
                    }
                    if(userLocale == 'es') {
                        subtablabel = (s.Spanish_Label__c != null ? s.Spanish_Label__c : s.MasterLabel);
                    }
                    List<ComponentWrapper> subComponentList = new List<ComponentWrapper>();
                    Map<String, Object> subParametersList = new  Map<String, Object>();
                    for(crta__Team_Component_Setting__mdt c : s.Team_Components_Settings__r) {
                        for(crta__Team_Component_Parameter_Setting__mdt p : componentParamSettings) {
                            if(p.crta__Component__c == c.Id) {
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
                                subParametersList.put(p.crta__Parameter_Name__c, paramValue);
                            }
                        }
                        if(c.crta__Sub_Tab__c == s.Id) {
                            subComponentList.add(new ComponentWrapper(
                                c.crta__Component_Name__c,
                                c.crta__Namespace__c,
                                subParametersList,
                                c.crta__Order__c
                            ));
                        }
                    }
                    system.debug(subComponentList);

                    subTabList.add(new TabWrapper(
                        subtablabel,
                        null,
                        subComponentList,
                        s.crta__Order__c
                    ));
                }
            }
            tabList.add(new TabWrapper(
                tablabel,
                subTabList,
                componentList,
                t.crta__Order__c
            ));
        }
        return tabList;
    }

    @AuraEnabled
    public static List<crta__Team_Sub_Tab_Setting__mdt> getSubTabsCtrl() {
        List<crta__Team_Sub_Tab_Setting__mdt> subTabSettings = new List<crta__Team_Sub_Tab_Setting__mdt>();
        for(crta__Team_Sub_Tab_Setting__mdt t : [
            SELECT Id, 
            crta__Dutch_Label__c,
            crta__English_Label__c,
            crta__German_Label__c,
            crta__Order__c,
            crta__Portuguese_Label__c,
            crta__Spanish_Label__c,
            MasterLabel,
            crta__Tab__c,
            (
                SELECT Id, 
                    crta__Component_Name__c,
                    crta__Namespace__c,
                    crta__Order__c,
                    crta__Tab__c,
                    crta__Sub_Tab__c 
                FROM Team_Components_Settings__r 
                WHERE Disable__c=false
                ORDER BY crta__Order__c ASC NULLS LAST
                
            )
            FROM crta__Team_Sub_Tab_Setting__mdt
            WHERE crta__Tab__c != NULL AND Disable__c=false
            ORDER BY crta__Order__c ASC NULLS LAST
        ]) {
            subTabSettings.add(t);
        }
        return subTabSettings;
    }

    @AuraEnabled
    public static List<crta__Team_Component_Parameter_Setting__mdt> getComponentParamCtrl() {
        List<crta__Team_Component_Parameter_Setting__mdt> componentParamSettings = new List<crta__Team_Component_Parameter_Setting__mdt>();
        for(crta__Team_Component_Parameter_Setting__mdt p : [
            SELECT Id, 
            crta__Component__c,
            crta__Parameter_Name__c,
            crta__Parameter_Type__c,
            crta__Parameter_Value__c
            FROM crta__Team_Component_Parameter_Setting__mdt
            WHERE crta__Component__c != NULL AND Disable__c=false
        ]) {
            componentParamSettings.add(p);
        }
        return componentParamSettings;
    }
    
}