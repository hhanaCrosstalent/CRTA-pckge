({ // @author Felix van Hove
	init : function(component, helper) {
		const action = component.get('c.getTree');
		action.setCallback(this, function (r) {
			if (r.getState() === 'SUCCESS') {
				const result = JSON.parse(r.getReturnValue());
				for (let i = 0; i < result.length; i++) {
					result[i].lowerCaseName = result[i].Name.toLowerCase();
				}
				component.set('v.allContacts', result);
				helper.buildTree(component, helper, result);
			} else {
				console.error('Problem loading contact types: ' + r.getError()[0]);
			}
		});
		$A.enqueueAction(action);
	},
	buildTree: function (component, helper, contacts) {
		const showAccounts = component.get('v.showAccounts');
		let references = {};
		let ceos = [];
		for (let i = 0; i < contacts.length; i++) {
			const c = contacts[i];
			const o = {
				id: c.Id, // needed below
				href: '/' + c.Id,
				label: c.Name + (showAccounts && c.Account ? '  (' + c.Account.Name + ')' : ''),
				name: c.Name,
				expanded: false,
				items: []
			};
			if (references[c.ReportsToId] == undefined) {
				references[c.ReportsToId] = [];
			}
			if(c.ReportsToId == undefined) {
				ceos.push(o);
			} else {
				references[c.ReportsToId].push(o);
			}
		}

		for(let i=0; i<ceos.length; i++) {
			this.buildTreeBranch(helper, ceos, references);
		}
		
		component.set('v.tree', ceos);
	},
	buildTreeBranch: function (helper, managers, references) {
		for (let i = 0; i < managers.length; i++) {
			let items = references[managers[i].id];
			if (items == undefined) {
				managers[i].items = [];
			} else {
				managers[i].items = items;
				helper.buildTreeBranch(helper, items, references);
			}
		}
	},
	changeHierarchy: function(component, helper) {
		const action = component.get('c.changeHierarchy');
		let selectedContactOld = component.get('v.selectedContactOld');
		let selectedContactNew = component.get('v.selectedContactNew');
		if(!selectedContactOld || !selectedContactNew) {
			console.error('Either old or new contact missing.');
			return;
		}
		action.setParams({
			managerUntilNow: selectedContactOld.Id, 
			managerInTheFuture: selectedContactNew.Id
		});
		action.setCallback(this, function (r) {
			if (r.getState() === 'SUCCESS') {
				$A.get('e.force:refreshView').fire();
			} else {
				if (r.getError()[0].message === 'CIRCULAR_DEPENDENCY') {
					console.error('Circular dependency');
				} else {
					console.error('Problem changing hierarchy: ' + r.getError()[0].message);
				}
			}
		});
		$A.enqueueAction(action);
	},
	searchHelper: function (component, event, s) {
		if (!s || s.length == 0) {
			return [];
		}
		let allItems = component.get('v.allContacts');
		let lower = s.toLowerCase();
		const len = s.length;
		let items = allItems.filter(function (element) {
			return element.lowerCaseName.substring(0, len) == lower;
		});
		return items;
	}
})