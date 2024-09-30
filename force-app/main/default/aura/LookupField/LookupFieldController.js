({
    doInit : function(component, event, helper) {
        helper.getRecordsHelper(component);
        component.set('v.fieldDisabled', component.get('v.isDisabled'));
    },
    refresh : function(component, event, helper) {
        component.set('v.currentSearch','');
        component.set('v.filteredObjects', component.get('v.objects').slice(0, 5));
        let childInput = component.find('lookupField');
        $A.util.removeClass(childInput, 'has-value');
    },
    setDisabled : function(component, event) {
        let params = event.getParam('arguments');
        if (params) {
            if(!component.get('v.isDisabled')) {
                component.set('v.fieldDisabled', params.isDisabled);
            } else {
                component.set('v.fieldDisabled', true);
            }
            
        }
    },
    onFocus: function (component, event) {
         console.log('onFocus');
        //let target = event.target.name;
         var target;
        if(document.querySelector('.slds-button[name="clearBtn"]')!=null){
            let button =document.querySelector('.slds-button[name="clearBtn"]');
            target = button.getAttribute('name');
        }     
        console.log('targettarget '+target);
        if (!component.get('v.fieldDisabled')) {
            let parentElement = component.find('dropdownTrigger').getElement();
            $A.util.addClass(parentElement, 'slds-is-open');
            parentElement.setAttribute('aria-expanded', true);
            let childInput = component.find('lookupField');
            childInput.focus();
            if (target == 'clearBtn' || component.get('v.BypassLookupRemoveValue')) {
               
                $A.util.removeClass(childInput, 'has-value');
                component.set('v.currentSearch', '');
                component.set('v.selectedObjectId', null);
                component.set('v.filteredObjects', component.get('v.objects').slice(0, 5));
            }
        }
    },
    onBlur : function(component, event, helper) {
        let parentElement = component.find('dropdownTrigger').getElement();
        parentElement.setAttribute('aria-expanded', false);
        $A.util.removeClass(parentElement, 'slds-is-open');
    },
    onKeyDown: function(component, event, helper) {
        helper.searchHelper(component, event);
    },
    setValue: function (component, event, helper) {
        let params = event.getParam('arguments');
        if (params) {
            let obj = params.newVal;
            let fieldSplit = component.get('v.nameField')
                                .substr(component.get('v.nameField').indexOf('.') + 1, 
                                    //component.get('v.nameField').length - 1)
                                    component.get('v.nameField').length)
                                .split('.');

            if (obj[fieldSplit[0]] != undefined) {
                let name = fieldSplit.reduce((a, v) => a[v], obj);
                component.set('v.currentSearch', name);
                component.set('v.selectedObjectName', name);
                let childInput = component.find('lookupField');
                $A.util.addClass(childInput, 'has-value');
            }
        }
    },
    refreshObject: function (component) {
        component.set('v.filteredObjects', component.get('v.objectsTmp'));
    },
    selectAnObject: function(component, event, helper) {
        let objectId = event.currentTarget.getAttribute("data-id");
        let objectName = event.currentTarget.getAttribute("data-Name");
        component.find('lookupField').setCustomValidity('');

        if (objectId != null && objectName != null) {
            console.log('objectNameobjectNameobjectName '+objectId);
            let childInput = component.find('lookupField');
            $A.util.addClass(childInput, 'has-value');
            component.set('v.currentSearch', objectName);
            component.set('v.selectedObjectId', objectId);
            component.set('v.selectedObjectName', objectName);
        } else {
            component.set('v.hasError', true);
            component.set('v.selectedObjectId', null);
            component.find('lookupField').setCustomValidity('Vous avez choisi une option non valide.');
        }
    },

    afterRender: function (component, event, helper) {
        let eleSelected = component.get('v.selectedObjectId');
        if (eleSelected != '') {
            let objectsList = JSON.parse(JSON.stringify(component.get('v.objects')));
            let obj = objectsList.find(item => item.Id === eleSelected);
            if (obj != undefined) {
                let fieldSplit = component.get('v.nameField')
                    .substr(component.get('v.nameField').indexOf('.') + 1,
                        component.get('v.nameField').length - 1)
                    .split('.');
                if (obj[fieldSplit[0]] != undefined) {
                    let name = fieldSplit.reduce((a, v) => a[v], obj);
                    component.set('v.currentSearch', name);
                    component.set('v.selectedObjectName', name);
                    let childInput = component.find('lookupField');
                    $A.util.addClass(childInput, 'has-value');
                }
            }
        }
    },
})