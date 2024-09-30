({ // @author: Felix van Hove
	doInit: function (component, event, helper) {
		// send LC host as parameter to VF page so VF page can send message to LC
		component.set('v.lcHost', window.location.hostname);
		window.addEventListener('message', function (event) {

			function displayItems(itemType) {
				const items = encodeURI(event.data.payload);
				for (let i = 0; i < items.length; i++) {
					items[i].UrlId = '/' + items[i].Id;
				}
				component.set('v.'+itemType, items);
			}

			// TODO: The following check is not straightforward, as the event.origin is a Visualforce page and comes
			// therefore from a different domain. Compare:
			// event.origin: https://tonnerre-dev-ed--c.eu11.visual.force.com
			// current container: https://tonnerre-dev-ed.lightning.force.com
			//let vfOrigin = 'https://' + window.location.hostname;
			//if (event.origin != vfOrigin) {
			//    console.log('Not from the expected origin. Rejecting request.');
			//    return;
			//}

			if (event.data.state == 'LOADED') {
				component.set('v.vfHost', event.data.vfHost);
				helper.sendToVFData(component, helper, true);
				displayItems('contacts');
				displayItems('jobPostings');
			} else if (event.data.state == 'Contact') {
				displayItems('contacts');
			} else if (event.data.state == 'crta__Offre_d_emploi__c') {
				displayItems('jobPostings');
			}
		}, false);

		helper.initPicklists(component, event, helper);
		helper.initTranslate(component, event, helper);
	},
	submitInput: function(component, event, helper) {
		clearTimeout(window._delay);
		window._delay = setTimeout(function () {
			const section = component.find('accordion').get('v.activeSectionName');
			if(section == 'A') {
				component.set('v.searchText', null);
			} else {
				if(!component.get('v.searchText')) return false;
			}
			helper.sendToVFData(component, helper, false);
		}, 1000);
	},
	submit: function (component, event, helper) {
		component.set('v.searchText', null);
		helper.sendToVFData(component, helper, false);
	},
	submitText: function(component, event, helper) {
		if (component.get('v.searchText'))
			helper.sendToVFData(component, helper, false);
	},
	sortContacts: function (component, event, helper) {
		const fieldName = event.getParam('fieldName');
		const sortDirection = event.getParam('sortDirection');
		component.set('v.sortedByContact', fieldName);
		component.set('v.sortedDirectionContact', sortDirection);
		const firstField = component.get('v.columnsContact').split(',')[0].trim();
		helper.sort(component, fieldName, sortDirection, firstField, 'v.contacts');
	},
	sortJobPostings: function (component, event, helper) {
		const fieldName = event.getParam('fieldName');
		const sortDirection = event.getParam('sortDirection');
		component.set('v.sortedByJobPosting', fieldName);
		component.set('v.sortedDirectionJobPosting', sortDirection);
		const firstField = component.get('v.columnscrta__Offre_d_emploi__c').split(',')[0].trim();
		helper.sort(component, fieldName, sortDirection, firstField, 'v.jobPostings');
	},
	downloadContacts: function(component, event, helper) {
		const columns = component.get('v.columnsContact');
		const data = component.get('v.contacts');
		const t = component.get('v.translate').Contact;
		helper.download(component, data, columns, t);
	},
	downloadJobPostings: function(component, event, helper) {
		const columns = component.get('v.columnscrta__Offre_d_emploi__c');
		const data = component.get('v.jobPostings');
		const t = component.get('v.translate').crta__Offre_d_emploi__c;
		helper.download(component, data, columns, t);
	}
})