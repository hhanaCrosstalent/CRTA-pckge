({
     doInit: function(component, event, helper) {
         		console.log('on init home');
                component.set('v.now' , Date.now());
        helper.getCmpsHelper(component, helper);
    },
	 addContent: function (component, event, helper) {
        let tab = event.getSource();  
        console.log('tab ');
         console.log(tab);
                  console.log( tab.name);

        //let item = component.get("v.tabsList").find(i => i.id === tab.get('v.id'));
                         // console.log( cmpList.name);
        let c = component.get("v.cmpList").find(i => i.identifier === tab.get('v.id')); //the cmp  get the id of cmp from cmps(loaded)

        let elements = [];
        //item.componentList.forEach(function (c) {
         let parameters = c.parameters;
            $A.createComponent(c.prefix + ':' + c.name, parameters
                , function (newContent, status, error) {
                    if (status === "SUCCESS") {
                        elements.push(newContent);
                        tab.set('v.body', elements);
                        console.log('is loaaded ')
                        /*if (tab.getLocalId() == 'top-tab') {
                            component.set('v.componentsList', elements); 
                        } else {
                            tab.set('v.body', elements);
                            
                        }*/
                        
                    } else {
                        console.log(error);
                        //throw new Error(error);
                    }
                });
           
        //});
    }
})