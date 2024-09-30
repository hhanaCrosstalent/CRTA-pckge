({
	getTranslationsHelper1: function(component){
        let action = component.get("c.getTranslationsCtrl1");
        action.setCallback(this, function(response) {
            if(component.isValid() && response.getState() === "SUCCESS") {
                let labelsMap = response.getReturnValue();
                component.set("v.labelsMap", labelsMap);
            } else {
                console.error('Failed to load translations.');
            }
        });
        $A.enqueueAction(action);
    }
})