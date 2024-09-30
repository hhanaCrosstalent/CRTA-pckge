({
    doInit: function (component, event, helper) {
       /* const isPhone = $A.get('$Browser.isPhone');
        if (isPhone){
            component.set('v.scroll','slds-scrollable_x');
        }*/
        let accountFieldName = component.get('v.accountFieldName');
        let accountField = (accountFieldName.endsWith('Id') ? accountFieldName.replace('Id', '') : (accountFieldName.endsWith('__c') ? accountFieldName.replace('__c', '__r') : accountFieldName));
        if(accountFieldName == undefined) {
            accountField = 'Account';
        }
        component.set('v.GDPRText', component.get('v.contact.' + accountField + '.crta__Onboarding_GPDR_Text__c'));
        component.set('v.welcomeMessage', component.get('v.contact.'  + accountField + '.crta__Onboarding_Welcome_Message__c'));
        helper.getOnboardingSettingsHelper(component);
    },
    
	handlerTabs: function (component, event) {
        if (!!component.get('v.contact.crta__GDPR__c') || !!component.get('v.contact.crta__GDPR_Date__c')) {
            let idTab = event.currentTarget.id;
            let idContentTab = event.currentTarget.dataset.contentid;
            let items = component.find('tab-item');
            if (!!items) {
                if (!Array.isArray(items)) items = [items];
                items.forEach(function (e) {
                    $A.util.removeClass(e.getElement(), 'slds-active');
                    $A.util.removeClass(e.getElement(), 'slds-current-active');
                });

                let currentTab = document.getElementById(idTab);
                let parentLi = currentTab.parentElement;
                parentLi.classList.add('slds-active');
                parentLi.classList.add('slds-current-active');

                let itemsContent = component.find('tab-item-content');
                if (!!itemsContent) {
                    if (!Array.isArray(itemsContent)) itemsContent = [itemsContent];
                    itemsContent.forEach(function (e) {
                        $A.util.removeClass(e.getElement(), 'slds-show');
                        $A.util.addClass(e.getElement(), 'slds-hide');
                    });
                }

                let currentTabContent = document.getElementById(idContentTab);
                if (!!currentTabContent) {
                    currentTabContent.classList.add('slds-show');
                    currentTabContent.classList.remove('slds-hide');
                }
            }
        }
    },
    
    handleSave: function (component, event, helper) {
        let nameButton = event.getSource().get("v.name");
        let toValidate = false;
        let allValid = [];
        if(nameButton == 'validate') {
            toValidate = true;
        }
        if (toValidate) {
            component.set('v.hasFileError', false);
            let mandatoryFields = component.find("field");
            mandatoryFields.push(component.find("address"));
            let lookupHasError = helper.checkLookupError(component);

            let mandatoryLists = component.find("relatedList");
            if(mandatoryLists) {
                if (!Array.isArray(mandatoryLists)) mandatoryLists = [mandatoryLists];
                let allListValid = mandatoryLists.reduce(function (validlist, listCmp) {
                    if (!!listCmp) {
                        try {listCmp.showHelpMessageIfInvalid();} catch(e){return true;}
                        let tmpListValid = (validlist && ((listCmp.getNumberRecords() != 0 && listCmp.get('v.required'))
                        || !listCmp.get('v.required')));
                        return tmpListValid;
                    } else {
                        return validlist;
                    }
                }, true);
                if(!allListValid) {
                    allValid.push(1);
                    helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.Required_Related_Lists'), 'error', 'dismissible');
                }
            }
            if (mandatoryFields) {
                if (!Array.isArray(mandatoryFields)) mandatoryFields = [mandatoryFields];
                let allFieldsValid = mandatoryFields.reduce(function (validFields, inputCmp) {
                    //if (typeof inputCmp.showHelpMessageIfInvalid !== "undefined") {
                    if (inputCmp && inputCmp.get('v.validity')) {
                        //inputCmp.showHelpMessageIfInvalid();
                        try {inputCmp.showHelpMessageIfInvalid();} catch(e){return true;}
                        let tmpValid = (validFields
                            && !(inputCmp.get('v.validity').valueMissing && inputCmp.get('v.required'))
                            && !(inputCmp.get('v.validity').typeMismatch));
                        return tmpValid;
                    } else {
                        let isValid = true;
                        if (inputCmp && inputCmp.get('v.class').includes('isRequired')) {
                            if (inputCmp.get('v.value') == undefined || inputCmp.get('v.value') == '') {
                                inputCmp.set('v.valid', false);
                                isValid = false;
                            } else {
                                inputCmp.set('v.valid', true);
                                isValid = true;
                            }
                        }
                        return isValid && validFields; 
                    }
                }, true);

                if (!allFieldsValid || lookupHasError.length > 0) {
                    allValid.push(1);
                    helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.Required_Fields'), 'error', 'dismissible');
                }
            } 
            if (allValid.length == 0) {
                helper.checkFilesHelper(component, helper, toValidate);
            }
        } else {
            helper.checkFilesHelper(component, helper, false);
        }
    },

    /* Check Data */
    handleBlur: function (component, event, helper) {
        helper.recalculateFormulaHelper(component, helper);
    },
})