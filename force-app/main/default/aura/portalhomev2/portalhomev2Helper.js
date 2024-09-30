({
	getCmpsHelper: function (component, helper) {
                 		console.log('in helper home ');
console.log(component.get("v.appId"));
        let action = component.get("c.getComponentsCtrl");  
        action.setParams({
            "appId" : component.get("v.appId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let cmpList = response.getReturnValue();

                component.set("v.cmpList", cmpList);
                console.log('cmp list ');
                console.log(cmpList);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading Components : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    }

	
})