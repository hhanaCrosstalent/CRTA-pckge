({// @author: Felix van Hove
	sendToVFData: function (component, helper, loadGoogleMap) {
		if (!component.find('selectedContactType')) {
			// this happens while using the appBuilder - and component.find('vfFrame') would later fail too
			return;
		}
		const formData = {
			address: component.get('v.address'),
			searchText: component.get('v.searchText'),
			selectedType: component.find('selectedContactType').get('v.value'),
			distance: component.get('v.distance'),
			mockContact: component.get('v.contact'),
			mockJobPosting: component.get('v.jobPosting')
		};
		const message = {
			loadGoogleMap: loadGoogleMap,
			mapKey: component.get('v.mapKey'),
			mapData: component.get('v.mapData'),
			mapOptions: component.get('v.mapOptions'),
			mapOptionsCenter: component.get('v.mapOptionsCenter'),
			formData: formData,
			columnsContact: component.get('v.columnsContact'),
			columnscrta__Offre_d_emploi__c: component.get('v.columnscrta__Offre_d_emploi__c')
		};
		this.sendMessage(component, helper, message);
	},
	sendMessage: function (component, helper, message) {
		message.origin = window.location.hostname;
		const iframe = component.find('vfFrame');
		const vfWindow = iframe.getElement().contentWindow;
		const theHost = component.get('v.vfHost');
		message = JSON.parse(JSON.stringify(message));
		vfWindow.postMessage(message, theHost);
	},
	initPicklists: function (component, helper, message) {
		const a = component.get('c.getPicklists');
		a.setCallback(this, function (r) {
			if (r.getState() == 'SUCCESS') {
				let result = r.getReturnValue();
				result = JSON.parse(result);
				for (let prop in result) {
					if(prop == 'situations') {
						const ar = [];
						ar.push({ value: result[prop][0], text: result[prop][0] });
						for(let i=1; i<result[prop].length; i++) {
							const s = result[prop][i];
							const v = s.substring(3, s.length);
							ar.push({ value: result[prop][i], text: v});
						}
						component.set('v.situations', ar);
					} else {
						component.set('v.' + prop, result[prop]);
					}
				}
			} else {
				console.error('Problem loading picklists: ' + r.getError()[0]);
			}
		});
		$A.enqueueAction(a);
	},
	initTranslate: function (component, event, helper) {
		const a = component.get('c.getTranslations');
		a.setParams({
			contactFields: component.get('v.columnsContact'),
			jobPostingFields: component.get('v.columnscrta__Offre_d_emploi__c')
		});
		a.setCallback(this, function (r) {
			if (r.getState() === 'SUCCESS') {
				const res = r.getReturnValue();
				component.set('v.translate', res);
				helper.initTable(component, event, helper);
			} else {
				console.error('Problem loading translations: ' + r.getError()[0].message);
			}
		});
		$A.enqueueAction(a);
	},
	initTable: function (component, event, helper) {
		const t = component.get('v.translate');
		const tableTypes = ['Contact', 'crta__Offre_d_emploi__c'];
		for(let j=0; j<tableTypes.length; j++) {
			let confColumns = component.get('v.columns' + tableTypes[j]);
			if(confColumns.trim()) {
				confColumns = confColumns.split(',');
				let columns = [];
				columns.push({
					label: t[tableTypes[j]][confColumns[0].trim()],
					fieldName: 'UrlId',
					type: 'url',
					typeAttributes: { label: { fieldName: confColumns[0].trim() } },
					sortable: true
				});
				for (let i = 1; i < confColumns.length; i++) {
					columns.push({
						label: t[tableTypes[j]][confColumns[i].trim()],
						fieldName: confColumns[i].trim(),
						type: 'text',
						sortable: true
					});
				}
				component.set('v.columns' + tableTypes[j] + '1', columns);
			}
		}
	},
	getPosition: function (component, helper, message) {
		let address = component.get('v.address');
		let geocoder = new google.maps.Geocoder();
		geocoder.geocode({ 'address': address }, function (results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				// TODO: should be done somewhere else
				//map.setCenter(results[0].geometry.location);
				let marker = new google.maps.Marker({
					map: map,
					position: results[0].geometry.location
				})
				return results[0].geometry.location;
			} else {
				console.error('Geocode was not successful for the following reason: ' + status);
			}
		});
	},
	sort: function (component, fieldName, sortDirection, firstField, fieldList) {
		let items = component.get(fieldList);
		const reverse = sortDirection !== 'asc';
		items.sort(this.sortBy(fieldName, reverse, /*null, */ firstField));
		component.set(fieldList, items);
	},
	sortBy: function (field, reverse, /*primer, */ firstField) {
		if (field == 'UrlId') {
			field = firstField;
		}
		// let key = primer ?
		// 	function (x) { return primer(x[field]) } :
		// 	function (x) { return x[field] };
		let key = function(x) {return x[field]};

		reverse = !reverse ? 1 : -1;
		return function (a, b) {
			return a = key(a) ? key(a) : '', b = key(b) ? key(b) : '', reverse * ((a > b) - (b > a));
		}
	},
	download: function(component, data, columns, translate) {
		function encodeURI() {
			let s = '';
			const cols = columns.split(',');
			for (let i=0; i<cols.length; i++) {
				s += translate[cols[i].trim()] + ',';
			}
			s = s.slice(0, -1) + '\n';
			for (let i=0; i<data.length; i++) {
				let item = data[i];
				for (let j = 0; j < cols.length; j++) {
					s += (item[cols[j]] ? item[cols[j]]:'') + ',';
				}
				s = s.slice(0, -1) + '\n';
			}
			return s;
		}
		const e = document.createElement('a');
		e.href = 'data:text/csv;charset=utf-8,' + encodeURI();
		e.target = '_self';
		e.download = 'export.csv';
		document.body.appendChild(e); // required for Firefox
		e.click();
	}
})