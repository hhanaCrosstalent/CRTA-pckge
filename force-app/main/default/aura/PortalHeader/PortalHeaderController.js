({
    //$Label.c.Banner_Height
    //$Label.c.Banner_Position
    //$Label.c.Mobile_Version
    doInit: function (component, event, helper) {
        const sr = component.get('v.staticResource');
		const src = $A.get('$Resource.' + sr);
        component.set('v.src', src);
        
        helper.getCurrentContact(component);
        helper.getHeader(component);

    },
})