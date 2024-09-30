({
	getCmpsHelper: function (component, helper) {
                 		console.log('in helper cmp dyamic  ');
console.log(component.get("v.filter"));
        let action = component.get("c.getComponentsCtrl");  
        action.setParams({
            "filter": component.get("v.filter"),
            "lim": (component.get("v.cmpLimitNbr")+1)
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