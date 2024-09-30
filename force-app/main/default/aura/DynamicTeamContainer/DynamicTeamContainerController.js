({
    doInit: function(component, event, helper) {
        helper.getTabs(component, helper);
    },
    addContent: function (component, event, helper) {
        let tab = event.getSource();
        let item = component.get("v.tabsList").find(i => i.id === tab.get('v.id'));
        if (tab.getLocalId() != 'top-tab') {
            let idsArray = tab.get('v.id').split('-');
            let parentId = idsArray[0];
            let tabId = idsArray[1];
            let parent = component.get("v.tabsList").find(i => i.id === parentId);
            item = parent.subTabsList.find(i => i.id === tabId);
        } else {
            if(item.componentList.length == 0) {
                component.set('v.componentsList', null);
            }
        }

        let elements = [];
        item.componentList.forEach(function (c) {
            let parameters = c.parameters;
            $A.createComponent(c.namespace + ':' + c.componentName, parameters
                , function (newContent, status, error) {
                    if (status === "SUCCESS") {
                        elements.push(newContent);
                        tab.set('v.body', elements);
                        // Modified By Tenhinene BENMESSAOUD ==> 26/10/2021
                        /*if (tab.getLocalId() == 'top-tab') {
                            component.set('v.componentsList', elements); 
                        } else {
                            tab.set('v.body', elements);
                            
                        }*/
                        // Modified By Tenhinene BENMESSAOUD ==> 26/10/2021
                        
                    } else {
                        console.log(error);
                        //throw new Error(error);
                    }
                });
           
        });
    },
  
    //$Label.c.Record_Types
    //$Label.c.Separator_Record_Types
    //$Label.c.Brand_Color
    //$Label.c.Display_Team_Tab
    //$Label.c.Display_Attachement_Level
    //$Label.c.Display_Search_Employee
})