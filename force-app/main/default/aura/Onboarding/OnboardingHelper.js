({
	saveContactHelper: function (component, helper, isValidate) {
        let contactId = component.get('v.contactId');
        let contactUpdated = { sobjectType: 'Contact', Id: contactId };
        
        let currentContact = component.get('v.contact');
        let sections = component.get('v.sectionsList');
         console.log('sections '+JSON.stringify(sections));
        if ((component.get('v.contact.crta__GDPR__c') && component.get('v.contact.crta__GDPR_Date__c') == null)) {
            contactUpdated['crta__GDPR__c'] = true;
            contactUpdated['crta__GDPR_Date__c'] = new Date();
        } else {
            contactUpdated['crta__GDPR__c'] = true;
        }
        contactUpdated['crta__CT_Status_of_employee__c'] = component.get('v.contact.crta__CT_Status_of_employee__c');

        sections.forEach(function(s) {
            s.fieldGroupsList.forEach(function(f) {
                f.fieldsList.forEach(function (e) {
                    if (e.fieldType == 'boolean' && !e.fieldValue) {
                        e.fieldValue = false;
                    }
                    if (e.fieldType == 'double' || e.fieldType == 'integer' || e.fieldType == 'long') {
                        e.fieldValue = Number.parseInt(e.fieldValue);
                    }
                    
                    if (e.fieldType == 'currency') {
                        e.fieldValue = Number.parseFloat(e.fieldValue);
                    }
                    
                    if (e.fieldType == 'reference') {
                        console.log('refereeence '+e.apiName+' ---> '+e.fieldValue);
                        e.fieldValue = e.idValue;
                        /*CT-202109#003647 Debut de commentaire par FME 2021-10-04
                         * 
                        e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                        e.apiName = (e.apiName.endsWith('__r') ?
                                     e.apiName.replace('__r', '__c') : (e.apiName.endsWith('__c') ?
                                                                        e.apiName : e.apiName + 'Id')
                                    );
                       *CT-202109#003647 Fin de commentaire par FME 2021-10-04
                       */
                       //=> Debut de Modification par Fallou 2021-11-24
                       // On vérifie si nous sommes sur un champs de référence custom
                       if(e.apiName.substr(-3) != '__c' 
                            && e.apiName.substr(-3) != '__C' 
                            && !e.apiName.endsWith('id') 
                            && !e.apiName.endsWith('Id')
                            && !e.apiName.endsWith('ID')){
                           if(e.apiName.indexOf('__r.') !=-1) {
                               e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                               e.apiName = e.apiName.replace('__r', '__c');
                           } else {
                               e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                               e.apiName = e.apiName + 'Id';
   
                           }
                       }
                       //=> Fin de Modification par Fallou 2021-11-24
                    }
                    if (e.fieldType == 'multipicklist') {
                        if(!!e.selectedValues) {
                            e.fieldValue = e.selectedValues.join(';');
                        }
                    }
                    
                    if (e.apiName == 'MailingAddress') {
                        contactUpdated['MailingStreet'] = helper.handleValueIfIsNull(component.find('address').get('v.street'));
                        contactUpdated['MailingCity'] = helper.handleValueIfIsNull(component.find('address').get('v.city'));
                        contactUpdated['MailingCountry'] = helper.handleValueIfIsNull(component.find('address').get('v.country'));
                        contactUpdated['MailingState'] = helper.handleValueIfIsNull(component.find('address').get('v.province'));
                        contactUpdated['MailingPostalCode'] = helper.handleValueIfIsNull(component.find('address').get('v.postalCode'));
                    } else {
                        contactUpdated[e.apiName] = e.fieldValue;
                    }
                });
            });
            if (s.conditionalField != undefined) {
                contactUpdated[s.conditionalField] = currentContact[s.conditionalField];
            } 
        });
        console.log('+++ '+JSON.stringify(contactUpdated));
        let action = component.get('c.updateContactCtrl');
        contactUpdated['Id'] = component.get('v.contact.Id');
            action.setParams({
                'so': contactUpdated,
                'isValidate': isValidate
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.contact', response.getReturnValue());
                    helper.changeSectionDisplay(component);
                    helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Edit_Success'), 'success', 'dismissible');
                    if(isValidate) {
                        helper.getOnboardingSettingsHelper(component);
                    }
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    let message = '';
                    if (errors) {
                        for (var i = 0; i < errors.length; i++) {
                            for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                                message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                            }
                            if (errors[i].fieldErrors) {
                                for (var fieldError in errors[i].fieldErrors) {
                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                    for (var j = 0; j < thisFieldError.length; j++) {
                                        message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                    }
                                }
                            }
                            if (errors[i].message) {
                                message += (message.length > 0 ? '\n' : '') + errors[i].message;
                            }
                        }
                    } else {
                        message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                    }
                    helper.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
                }
            });
            $A.enqueueAction(action);
    },

    checkFilesHelper: function (component, helper, isValidate) {
        if(isValidate) {
            let action = component.get("c.checkFilesCtrl");
            action.setParams({
                "contactId": component.get('v.contact.Id')
            });
            action.setCallback(this, function (response) {
                if (response.getState() == 'SUCCESS') {
                    let filesMissed = response.getReturnValue();
                    if (filesMissed.length > 0) {
                        let files = '';
                        filesMissed.forEach(function (f) {
                            files +=  '\n - ' + f;
                        });
                        helper.showToast(
                          $A.get("$Label.c.Error"),
                          $A.get("$Label.c.Onboarding_Files_Error") + files,
                          "error",
                          "dismissible"
                        );
                        component.set('v.hasFileError', true);
                    }
                    helper.checkRelatedListFilesHelper(component, helper, isValidate);
                } else {
                    let errs = response.getError();
                    for (let i = 0; i < errs.length; i++) {
                        console.error('Failed to check file : ' + errs[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.saveContactHelper(component, helper, isValidate);
        }
    },

     checkRelatedListFilesHelper: function (component, helper, isValidate) {
        let action = component.get("c.checkRelatedListFilesCtrl");
        action.setParams({
            "contactId": component.get('v.contact.Id')
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let result = response.getReturnValue();
                if (result.length > 0) {
                    let files = '';
                    result.forEach(function (f) {
                        files +=  '\n - ' + f;
                    });
                    helper.showToast(
                        $A.get("$Label.c.Error"),
                        $A.get("$Label.c.Related_List_Files_Error") + files,
                        "error",
                        "dismissible"
                    );
                    helper.saveContactHelper(component, helper, false);
                } else {
                    if(!component.get('v.hasFileError')) {
                        helper.saveContactHelper(component, helper, isValidate);
                    } else {
                        helper.saveContactHelper(component, helper, false);
                    }
                }
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to check related lists files : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getOnboardingSettingsHelper: function (component) {
        console.log('++++ getOnboardingSettingsHelper');
        let action = component.get("c.getOnboardingSettingsCtrl");
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let settings = response.getReturnValue();
                let status = '';
                let validationStatus = '';
                if (!!settings.crta__Modification_Status__c) {
                    status = settings.crta__Modification_Status__c;
                } else {
                    status = '80 Modification employee';
                }
                component.set('v.modificationStatus', status);
                if (!!settings.crta__Validation_Status__c) {
                    validationStatus = settings.crta__Validation_Status__c;
                } else {
                    validationStatus = '80 Modification employee';
                }
                component.set('v.validationStatus', validationStatus);
                component.set('v.isReady', true);
                console.log('status '+status);
                console.log('status contact '+component.get('v.contact').crta__CT_Status_of_employee__c);
                if (status != component.get('v.contact').crta__CT_Status_of_employee__c) {
                    component.set('v.isReadOnly', true);
                } else {
                    component.set('v.isReadOnly', false);
                }
                if(component.get('v.isReadOnly')) {
                    this.setLookupDisabled(component);
                }
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to get onboarding setting : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    recalculateFormulaHelper: function(component, helper) {
        console.log('recalculateFormulaHelper');
        let contactId = component.get('v.contactId');
        console.log('contactId '+contactId);
        let contactUpdated = { sobjectType: 'Contact', Id: contactId };
        
        let tabsList = component.get('v.tabsList');
        let sectionsList = component.get('v.sectionsList');

        sectionsList.forEach(function(s) {
            s.fieldGroupsList.forEach(function(f) {
                f.fieldsList.forEach(function (e) {
                    if (e.fieldType == 'boolean' && !e.fieldValue) {
                        e.fieldValue = false;
                    }
                    if (e.fieldType == 'double' || e.fieldType == 'integer' || e.fieldType == 'long') {
                        e.fieldValue = Number.parseInt(e.fieldValue);
                    }
                    
                    if (e.fieldType == 'currency') {
                        e.fieldValue = Number.parseFloat(e.fieldValue);
                    }
                    
                    if (e.fieldType == 'reference') {
                        e.fieldValue = e.idValue;
                        // e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                        // e.apiName = (e.apiName.endsWith('__r') ?
                        //              e.apiName.replace('__r', '__c') : (e.apiName.endsWith('__c') ?
                        //                                                 e.apiName : e.apiName + 'Id')
                        //             );
                        if(e.apiName.substr(-3) != '__c' 
                                && e.apiName.substr(-3) != '__C' 
                                && !e.apiName.endsWith('id') 
                                && !e.apiName.endsWith('Id')
                                && !e.apiName.endsWith('ID')){
                            if(e.apiName.indexOf('__r.') !=-1) {
                                e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                                e.apiName = e.apiName.replace('__r', '__c');
                            } else {
                                e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                                e.apiName = e.apiName + 'Id';
        
                            }
                        }
                    }
                    
                    if (e.apiName == 'MailingAddress') {
                        contactUpdated['MailingStreet'] = helper.handleValueIfIsNull(component.find('address').get('v.street'));
                        contactUpdated['MailingCity'] = helper.handleValueIfIsNull(component.find('address').get('v.city'));
                        contactUpdated['MailingCountry'] = helper.handleValueIfIsNull(component.find('address').get('v.country'));
                        contactUpdated['MailingState'] = helper.handleValueIfIsNull(component.find('address').get('v.province'));
                        contactUpdated['MailingPostalCode'] = helper.handleValueIfIsNull(component.find('address').get('v.postalCode'));
                    } else {
                        contactUpdated[e.apiName] = e.fieldValue;
                    }
                    if(!!e.conditionalField) {
                    contactUpdated[e.conditionalField] = e.conditionalField;
                }
                });
            });
            if (!!s.conditionalField) {
                contactUpdated[s.conditionalField] = contactUpdated[s.conditionalField];
            }
        });
        contactUpdated['Id'] = component.get('v.contact.Id');

        let action = component.get("c.recalculateFormulaCtrl");
        action.setParams({
            "contactUpdated": contactUpdated,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('resultresultresult '+JSON.stringify(result));
                let tabsToUpdate = [];
                let sectionsToUpdate = [];
                tabsList.forEach(function (t) {
                    if(!!t.conditionalField) {
                        if(result[t.conditionalField]) {
                            t.isDisplayed = true;
                        } else {
                            t.isDisplayed = false;
                        }
                    }
                    t.relatedLists.forEach(function (r) {
                        if(!!r.conditionalField) {
                            if(result[r.conditionalField]) {
                                r.isDisplayed = true;
                            } else {
                                r.isDisplayed = false;
                            }
                        }
                    });
                    tabsToUpdate.push(t);
                });

               sectionsList.forEach(function (e) {
                    if(!!e.conditionalField) {
                        if(result[e.conditionalField]) {
                            e.isDisplayed = true;
                        } else {
                            e.isDisplayed = false;
                        }
                    }
                    e.fieldGroupsList.forEach(function (f) {
                        f.fieldsList.forEach(function (l) {
                            if(l.fieldType == 'reference') {
                                l.apiName = f.uniqueName;
                            }
                            if (l.fieldValue != undefined) {
                                if (l.fieldType == 'datetime') {
                                    l.fieldValue = $A.localizationService.formatDateTime(l.fieldValue, "YYYY-MM-DDThh:mm:ss.SZ");
                                }
                                if (l.fieldType == 'time') {
                                    l.fieldValue = $A.localizationService.formatTimeUTC(l.fieldValue);
                                }
                            }
                        });
                    });
                    sectionsToUpdate.push(e);
                });
       
                component.set('v.tabsList', tabsToUpdate);
                component.set('v.sectionsList', sectionsToUpdate);
            } else {
                let errs = response.getError();
                for(let i = 0; i < errs.length; i++) {
                    console.error('Failed to recalculate formulas : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    changeSectionDisplay: function (component) {
        console.log('changeSectionDisplay');
        let object = component.get('v.sectionsList');
          console.log('object '+JSON.stringify(object));
        let contact = component.get('v.contact');
        object.forEach(function (i) {
            console.log('iiiiiiiiiiiii '+JSON.stringify(i));
            if (i.conditionalField != undefined) {
                if (contact[i.conditionalField]) {
                    i.isDisplayed = true;
                } else {
                    i.isDisplayed = false;
                }
            }
        });
        component.set('v.sectionsList', object);
    },

    checkLookupError: function (component) {
        let lookupFields = component.find('refField');
        let lookupHasError = [];
        if (lookupFields != undefined) {
            if (!Array.isArray(lookupFields)) lookupFields = [lookupFields];
            lookupFields.forEach(function (searchbox) {
                let required = searchbox.get('v.required');
                let valueInvalid = searchbox.get('v.hasError');
                if (required) {
                    let inputSearch = searchbox.find('lookupField');
                    if (!!inputSearch && inputSearch.get('v.validity').valueMissing) {
                        lookupHasError.push(searchbox.get('v.refField'));
                        //inputSearch.showHelpMessageIfInvalid();
                        try {inputSearch.showHelpMessageIfInvalid();} catch(e){return true;}
                    }
                    if (valueInvalid) {
                        lookupHasError.push(searchbox.get('v.refField'));
                    }
                }
            });
        }
        return lookupHasError;
    },

    setLookupDisabled: function (component) {
        let lookupFields = component.find('refField');
        if (lookupFields != undefined) {
            if (!Array.isArray(lookupFields)) lookupFields = [lookupFields];
            lookupFields.forEach(function (searchbox) {
                searchbox.setDisabled(true);
            });
        }
    },

	handleValueIfIsNull: function (s) {
		return (!!s) ? s : "";
	},

	showToast: function (title, message, type, mode) {
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			mode: mode,
			title: title,
			message: message,
			type: type,
			duration: '2000'
		});
		toastEvent.fire();
	},
})