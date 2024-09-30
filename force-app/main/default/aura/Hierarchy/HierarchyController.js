({
	doInit : function(component, event, helper) {
		helper.init(component, helper);
	},
	submit: function(component, event, helper) {
		helper.changeHierarchy(component, helper);
	},
	// two contact search fields
	onfocus: function (component, event, helper) {
		const items = helper.searchHelper(component, event, '');
		component.set('v.contactsOld', items);
		component.set('v.searchedContactOld', '');
		component.set('v.selectedContactOld', null);
	},
	onfocus2: function (component, event, helper) {
		const items = helper.searchHelper(component, event, '');
		component.set('v.contactsNew', items);
		component.set('v.searchedContactNew', '');
		component.set('v.selectedContactNew', null);
	},
	onkeyup: function (component, event, helper) {
		let s = component.get('v.searchedContactOld');
		const items = helper.searchHelper(component, event, s);
		component.set('v.contactsOld', items);
	},
	onkeyup2: function (component, event, helper) {
		let s = component.get('v.searchedContactNew');
		const items = helper.searchHelper(component, event, s);
		component.set('v.contactsNew', items);
	},
	selectRecord: function (component, event, helper) {
		let selectedId = event.currentTarget.getAttribute('data-id');
		let items = component.get('v.contactsOld');
		const selectedItem = items.filter(function(el) {
			return el.Id == selectedId;
		})[0];
		component.set('v.selectedContactOld', selectedItem);
		component.set('v.searchedContactOld', selectedItem.Name);
		component.set('v.contactsOld', []);
	},
	selectRecord2: function (component, event, helper) {
		let selectedId = event.currentTarget.getAttribute('data-id');
		let items = component.get('v.contactsNew');
		const selectedItem = items.filter(function (el) {
			return el.Id == selectedId;
		})[0];
		component.set('v.selectedContactNew', selectedItem);
		component.set('v.searchedContactNew', selectedItem.Name);
		component.set('v.contactsNew', []);
	},
	removeRecord: function (component, event, helper) {
		component.set('v.selectedContactsOld', null);
	},
	removeRecord2: function (component, event, helper) {
		component.set('v.selectedContactsNew', null);
	}
})