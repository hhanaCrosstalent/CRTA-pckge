({
	handleModuleSelect : function(component, event, helper) {
                component.set('v.selectedId',undefined);
		console.log('handeled in aura');
        console.log(event.getParam('appId'));
                console.log(event.getParam('isHome'));
        component.set('v.selectedId',event.getParam('appId'));
        component.set('v.isHome',event.getParam('isHome'));
                component.set('v.appLabel',event.getParam('appLabel'));
	},
    changeSize: function(component, event, helper) {
        		console.log('size is changed');

                component.set('v.menuSize',event.getParam('size'));
    }
})