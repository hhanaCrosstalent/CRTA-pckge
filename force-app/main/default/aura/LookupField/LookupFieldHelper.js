({
    getRecordsHelper: function (component, event, helper) {
        console.log('getRecordsHelper');
        let action = component.get('c.getSobjectList');
        let baseKeyName = component.get('v.nameField');
        let baseKeyFilteredName = component.get('v.filteredField');
        
        action.setParams({
            'childObjectApi': component.get('v.childObjectApiName'),
            'refFieldName' : component.get('v.refField'),
            'fieldDisplayName': baseKeyName,
            'lookupFilter': component.get('v.lookupFilter'),
            'reviewId': component.get('v.reviewId'),
            'selectedObjectId': component.get('v.selectedObjectId')
        }); 
        action.setCallback(this, function(response) {
            if(component.isValid() && response.getState() === "SUCCESS") {
                let result = response.getReturnValue().records;
                let objectApiName = response.getReturnValue().sObjectApiName;
                component.set('v.icon', response.getReturnValue().objectIcon);

                baseKeyName = baseKeyName.substr(baseKeyName.indexOf('.') + 1, baseKeyName.length - 1);
                baseKeyFilteredName = baseKeyFilteredName.substr(baseKeyFilteredName.indexOf('.') + 1, baseKeyFilteredName.length - 1);

                result.forEach((e)=> {
                    let keyName = baseKeyName.split('.').reduce((a, v) => a[v], e);
                    let keyFilteredName = baseKeyFilteredName.split('.').reduce((a, v) => a[v], e);
                    e.nameField = !!keyName ? keyName : '';
                    e.FilteredField = !!keyFilteredName ? keyFilteredName : '';
                    e.ToLower = e.FilteredField != '' ? e.FilteredField.toLowerCase().replace( /[^A-Za-z0-9\u00C0-\u017F]+/g, '') : '';
                });
                component.set('v.objectApiName', objectApiName);
                component.set('v.objectTypelabel', response.getReturnValue().sObjectTypeName);
                component.set('v.objects', result);
                component.set('v.objectsTmp', result);
                component.set('v.filteredObjects', result.slice(0, 5));
                component.set("v.isNotDisplayedField", baseKeyName != baseKeyFilteredName);
                component.set('v.isReady', true);
                
            } else {
                let errs = response.getError();
                for(let i = 0; i < errs.length; i++) {
                    console.error('Failed to load ' + component.get('v.childObjectApiName') +  ' records : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
	searchHelper: function (component, event) {
        let filteredByEmployee=component.get('v.filteredByEmployee');
        $A.util.removeClass(component.find('lookupField'), 'has-value');
        let currentSearch = component.find('lookupField').get('v.value');
        let objects = component.get("v.objects");
        let lower = currentSearch.toLowerCase().replace( /[^A-Za-z0-9\u00C0-\u017F]+/g, '');
        let max = component.get('v.numberOfResult');
        let cpt = 0;
        let includesList = [];
        let startsWithList = [];
        startsWithList = objects.filter((e) => {
            if(cpt < max) {
                if(e.ToLower.startsWith(lower)) {
                    cpt++;
                    return true;
                } else {return false;}
            } else {
                return false;
            }
        });
        if(cpt < max) {
            includesList = objects.filter((e) => {
                if(cpt < max) {
                    if(e.ToLower.includes(lower) && (startsWithList.lenght == 0 || !startsWithList.includes(e))) {
                        cpt++;
                        return true;
                    } else {return false;}
                } else {
                    return false;
                }
            });
        }
        let filteredObjects = startsWithList.concat(includesList);
        if(currentSearch != '' && filteredObjects.length == 0){
            
            let baseKeyName = component.get('v.nameField');
            let baseKeyFilteredName = component.get('v.filteredField');
            let action = component.get('c.getRecordAutocomplete');
            console.log('currentSearch '+component.get("v.currentSearch"));
            action.setParams({
                'StringSearch': currentSearch ,
                'refFieldName' : component.get('v.refField'),
                'objectName': component.get('v.childObjectApiName') ,
                'fieldDisplayName': baseKeyName,
                'filterByEmployee':filteredByEmployee
                
            }); 
            action.setCallback(this, function(response) {
                if(component.isValid() && response.getState() === "SUCCESS") {
                    includesList = response.getReturnValue().records;
                    baseKeyName = baseKeyName.substr(baseKeyName.indexOf('.') + 1, baseKeyName.length - 1);
                    baseKeyFilteredName = baseKeyFilteredName.substr(baseKeyFilteredName.indexOf('.') + 1, baseKeyFilteredName.length - 1);
                    
                    includesList.forEach((e)=> {
                        let keyName = baseKeyName.split('.').reduce((a, v) => a[v], e);
                        let keyFilteredName = baseKeyFilteredName.split('.').reduce((a, v) => a[v], e);
                        e.nameField = !!keyName ? keyName : '';
                        e.FilteredField = !!keyFilteredName ? keyFilteredName : '';
                        e.ToLower = e.FilteredField != '' ? e.FilteredField.toLowerCase().replace( /[^A-Za-z0-9\u00C0-\u017F]+/g, '') : '';
                    });
                    filteredObjects = startsWithList.concat(includesList)
                    component.set("v.filteredObjects", filteredObjects);
                    component.set('v.selectedObjectId', null);
                    component.set('v.selectedObjectName', null);
                    
                } else {
                    let errs = response.getError();
                    for(let i = 0; i < errs.length; i++) {
                        console.error('Failed to load ' + component.get('v.childObjectApiName') +  ' records : ' + errs[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
    },
})