({
	doInit: function(component, event, helper) {
		const sr = component.get('v.staticResource');
		const src = $A.get('$Resource.' + sr);
		component.set('v.src', src);
	}
})