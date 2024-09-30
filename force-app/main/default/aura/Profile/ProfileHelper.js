({
    getContactPhotoHelper: function (component) {
        let action = component.get("c.getContactPhoto"); 
        let tmp = $A.get('$Resource.blankProfilePicture');
        action.setParams({
            'contactId': component.get("v.myContact.Id")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                if (res == null)
                    component.set("v.profilePicture", tmp);
                else {
                    component.set("v.profilePicture", res.ContentDownloadUrl);
                    component.set("v.photoFileId", res.ContentDocumentId);
                }
                this.checkFilesHelper(component, component.get("v.myContact.Id"), component.get("v.myContact.RecordTypeId"));
            } else {
                let errs = response.getError();
                component.set("v.profilePicture", tmp);
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading profile picture : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getCurrentContactIdHelper: function (component,helper) {
        let action = component.get("c.getConnectedContactIdCtrl");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.currentContactId", response.getReturnValue());
                helper.getContactHelper(component, helper);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading current contact id: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getContactHelper: function (component, helper) {
        let action = component.get("c.getContactCtrl");
       console.log('+++++'+ component.get("v.accountFieldName"));
        action.setParams({
            'receivedId': component.get("v.token"),
            'accountFieldName': component.get("v.accountFieldName")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                try {
                    console.log('---> '+JSON.stringify(JSON.parse(response.getReturnValue())));
                    component.set("v.myContact", JSON.parse(response.getReturnValue()));
                       

                } catch (e) {
                    component.set("v.isLoading", false);
                    if(response.getReturnValue() != '') {
                    	this.showToast($A.get('$Label.c.Error'), response.getReturnValue(), 'error', 'dismissible');
                    }
                }
                let managerId = [component.get("v.myContact.ReportsToId"),
                component.get("v.myContact.ReportsTo.ReportsToId"),
                component.get("v.myContact.ReportsTo.ReportsTo.ReportsToId")];

                let managerAccess = managerId.includes(component.get("v.currentContactId"));
                component.set("v.privateAccess", component.get("v.myContact.Id") == component.get("v.currentContactId"));

                component.set("v.managerAccess", managerAccess);
                
                if(component.get("v.myContact.RecordType.DeveloperName") == "Onboarding") {
                    component.set('v.isOnboarding', true);
                }
                helper.getTabsHelper(component,helper);
               /* this.getSectionsHelper(component, helper);
                this.getContactPhotoHelper(component);
                this.checkFilesHelper(component, component.get("v.myContact.Id"), component.get("v.myContact.RecordTypeId"));*/

            } else {
                component.set("v.isLoading", false);
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading contact: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getSectionsHelper: function (component, helper) {
        console.log('getSectionsHelper');
        let action = component.get("c.getSectionsCtrl");
        if(component.get("v.myContact") != null) {
            action.setParams({
                'receivedId': component.get("v.myContact").Id,
                'accountFieldName': component.get("v.accountFieldName")
            });
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    let fieldGroupsList = [];
                    let fieldsMissing = [];
                    if (response.getReturnValue().length == 0) component.set("v.isLoading", false);
                    console.log('les sections 2908 ');
                    console.log(JSON.stringify(response.getReturnValue()));
                    response.getReturnValue().forEach(function (e) {
                        console.log('la section #######" ');
                    console.log(e);
                        e.fieldGroupsList.forEach(function (f) {
                            f.fieldsList.forEach(function (l) {
                                if (l.fieldValue != undefined) {
                                    if (l.fieldType == 'datetime') {
                                        l.fieldValue = $A.localizationService.formatDateTime(l.fieldValue, "YYYY-MM-DDThh:mm:ss.SZ");
                                    }
                                    if (l.fieldType == 'time') {
                                        l.fieldValue = $A.localizationService.formatTimeUTC(l.fieldValue);
                                    }
                                    if (l.fieldType == 'percent') {
                                        l.fieldValue = l.fieldValue / 100;
                                    }
                                    if (l.fieldType == 'boolean') {
                                        l.fieldValue = l.fieldValue == "true";
                                    }
                                }
                                if (l.fieldType == 'picklist' || l.fieldType == 'multipicklist') {
                                    let picklist = [];
                                    for (let key in l.pickListValues) {
                                        picklist.push({
                                            label: l.pickListValues[key],
                                            value: key
                                        });
                                    }
                                    l.picklist = picklist;
                                }

                                if (l.fieldType == 'multipicklist') {
                                    if(l.fieldValue != undefined) {
                                        let selectedValues = l.fieldValue.split(';');
                                        l.selectedValues = selectedValues;
                                    }
                                }
                                if(l.required && l.fieldValue == undefined) {
                                    fieldsMissing.push(l.fieldLabel);
                                }
                            });
                            fieldGroupsList.push(f);
                        });
                    });
                    console.log('v.fieldGroupsList '+JSON.stringify(fieldGroupsList));
                    component.set("v.fieldGroupsList", fieldGroupsList);
                    component.set("v.sectionsList", response.getReturnValue());
                    component.set("v.fieldsMissing", fieldsMissing);
                    component.set("v.isLoading", false);
                    // if(component.get("v.myContact.RecordType.DeveloperName") == "Onboarding") {
                    //     component.set('v.isOnboarding', true);
                    // }
                    this.getContactPhotoHelper(component);
                } else {
                    let errs = response.getError();
                    for (let i = 0; i < errs.length; i++) {
                        console.error('Problem loading sections list : ' + errs[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    getTabsHelper: function (component,helper) {
        let action = component.get("c.getTabsCtrl");
        if (component.get("v.myContact") != null) {
            action.setParams({
                'receivedId': component.get("v.myContact").Id,
                'accountFieldName': component.get("v.accountFieldName")
            });
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    let tabs = response.getReturnValue();
                    if(tabs.length == 0) component.set("v.isLoading", false);
                    let tabsToAdd = [];
                    let tabDisplayed = 0;
                    console.log('tabs');
                    console.log(tabs);
                    tabs.forEach(function (t) {
                        if(t.isDisplayed) {
                            tabDisplayed++;
                        }
                        t.relatedLists.forEach(function (r) {
                           
                            let fieldsApiName = [];
                            let fieldsApiNamePhone=[];
                            r.fields.forEach(function (f) {
                                if (f.isManager && component.get("v.managerAccess")) {
                                    fieldsApiName.push(f.apiName);
                                } else if (f.isPrivate && component.get("v.privateAccess")) {
                                    fieldsApiName.push(f.apiName);
                                    
                                } else if (!f.isManager && !f.isPrivate) {
                                    fieldsApiName.push(f.apiName);
                                    
                                }
                                
                            });
                          
                           
                        });
                        if (t.isManager && component.get("v.managerAccess")) {
                            tabsToAdd.push(t);
                        } else if (t.isPrivate && component.get("v.privateAccess")) {
                            tabsToAdd.push(t);
                        } else if (!t.isManager && !t.isPrivate) {
                            tabsToAdd.push(t);
                        }
                    });


                    console.log('after');
                    console.log(JSON.stringify(tabsToAdd));
                    console.log(JSON.stringify(tabsToAdd));

                    component.set("v.tabsList", tabsToAdd); 
                    component.set("v.tabsListDisplayed",tabDisplayed); 
                    //FMEcomponent.set("v.isLoading", false);
                    helper.getSectionsHelper(component, helper);
                   // helper.getContactPhotoHelper(component);
                    // helper.checkFilesHelper(component, component.get("v.myContact.Id"), component.get("v.myContact.RecordTypeId"));
                } else {
                    let errs = response.getError();
                    for (let i = 0; i < errs.length; i++) {
                        console.error('Problem loading related list : ' + errs[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },


    updateFieldsHelper: function (component, event, helper) {
        let contactId = component.get('v.myContact.Id');
        let contactUpdated = { sobjectType: 'Contact', Id: contactId };
        let fieldGroup = component.get('v.fieldGroup');
        fieldGroup.fieldsList.forEach(function (e) {
            if (e.fieldType == 'boolean' && !e.newValue) {
                e.newValue = false;
            }
            if (e.fieldType == 'double' || e.fieldType == 'integer' || e.fieldType == 'long') {
                e.newValue = Number.parseInt(e.newValue);
            }

            if (e.fieldType == 'currency' || e.fieldType == 'percent') {
                e.newValue = Number.parseFloat(e.newValue);
            }

            if (e.fieldType == 'reference') {
                e.newValue = e.idValue;
                //=> Debut de Modification par Fallou 2021-11-24
                // On vérifie si nous sommes sur un champs de référence custom
                // e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                // e.apiName = (e.apiName.endsWith('__r') ?
                //     e.apiName.replace('__r', '__c') : (e.apiName.endsWith('__c') ?
                //         e.apiName : e.apiName + 'Id')
                // );
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
                    e.newValue = e.selectedValues.join(';');
                }
            }

            if (e.apiName == 'MailingAddress') {
                contactUpdated['MailingStreet'] = helper.handleValueIfIsNull(component.find('address').get('v.street'));
                contactUpdated['MailingCity'] = helper.handleValueIfIsNull(component.find('address').get('v.city'));
                contactUpdated['MailingCountry'] = helper.handleValueIfIsNull(component.find('address').get('v.country'));
                contactUpdated['MailingState'] = helper.handleValueIfIsNull(component.find('address').get('v.province'));
                contactUpdated['MailingPostalCode'] = helper.handleValueIfIsNull(component.find('address').get('v.postalCode'));
            } else {
                
                contactUpdated[e.apiName] = e.newValue;
            }
        });
        
        let action = component.get('c.updateContactCtrl');
        action.setParams({
            'so': contactUpdated
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.listIdLookup',[]);
                component.set('v.modalLoading', false);
                component.set('v.openModal', false);
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Edit_Success'), 'success', 'dismissible');
                helper.getContactHelper(component, helper);
                helper.getSectionsHelper(component);
            } else if (state === "ERROR") {
                component.set("v.isLoading", false);
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
    sendEditRequestHelper: function (component, event, helper) {
        let contactId = component.get('v.myContact.Id');
        let modificationList = [];
        let fieldType = [];
        let fieldGroup = component.get('v.fieldGroup');
        fieldGroup.fieldsList.forEach(function (e) {
            let oldValue = (e.fieldType == 'address')
                ? (
                    helper.handleValueIfIsNull(component.get("v.myContact.MailingStreet")) + ' - '
                    + helper.handleValueIfIsNull(component.get("v.myContact.MailingPostalCode")) + ' - '
                    + helper.handleValueIfIsNull(component.get("v.myContact.MailingCity")) + ' - '
                    + helper.handleValueIfIsNull(component.get("v.myContact.MailingState")) + ' - '
                    + helper.handleValueIfIsNull(component.get("v.myContact.MailingCountry"))
                ) : component.get('v.myContact.' + e.apiName);
            if (oldValue != undefined) {
                oldValue = oldValue.toString();
            } else {
                oldValue = '';
            }
            let newValue = e.newValue;
            if (e.fieldType == 'address') {
                let street = helper.handleValueIfIsNull(component.find('address').get('v.street'));
                let city = helper.handleValueIfIsNull(component.find('address').get('v.city'));
                let country = helper.handleValueIfIsNull(component.find('address').get('v.country'));
                let state = helper.handleValueIfIsNull(component.find('address').get('v.province'));
                let postalCode = helper.handleValueIfIsNull(component.find('address').get('v.postalCode'));
                newValue = street + ' - ' + postalCode + ' - ' + city + ' - ' + state + ' - ' + country;
            }

            if (e.fieldType == 'reference') {
                oldValue = e.fieldValue;
                newValue = e.idValue + ';' + e.newValue;
                console.log(oldValue);
                console.log(newValue);
                // e.apiName = e.apiName.substr(0, e.apiName.indexOf('.'));
                // e.apiName = (e.apiName.endsWith('__r') ?
                //     e.apiName.replace('__r', '__c') : (e.apiName.endsWith('__c') ?
                //         e.apiName : e.apiName + 'Id')
                // );

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

            if (e.fieldType == 'multipicklist') {
                if(!!e.selectedValues) {
                    newValue = e.selectedValues.join(';');
                }
            }

            if(!!newValue) {
                newValue = newValue.toString();
            } else {
                newValue = '';
            }
            modificationList.push({
                sobjectType: 'crta__Demande_de_modification__c',
                crta__Salarie__c: contactId,
                crta__Champ__c: e.fieldLabel,
                crta__Champ_technique__c: e.apiName,
                crta__Old_Value__c: oldValue,
                crta__New_Value__c: newValue,
                crta__Statut__c: '10 Demandée'
            });
            fieldType.push(e.fieldType);
        });
        console.log('1111 '+component.get('v.myContact.Id'));
        let action = component.get('c.createEditRequestCtrl');
        action.setParams({
            'soList': modificationList,
            'fieldType': fieldType,
            'contactId': component.get('v.myContact.Id'),
            'contentDocumentIds': component.get('v.fileIds')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                if (result != 'SUCCESS') {
                    component.set('v.openModal', false);
                    component.set('v.modalLoading', false);
                    helper.showToast($A.get('$Label.c.Error'), result, 'error', 'dismissible');
                } else {
                    component.set('v.openModal', false);
                    component.set('v.modalLoading', false);
                    helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Request_Success'), 'success', 'dismissible');
                    //<!--Fallou 07/02/2022: Rafraichissement du composant relatedList  -->
                    let params ={
                        "isCreateOrUpdate" : true
                    }
                    let eventCmp = $A.get("e.c:ReloadRelatedList");
                    eventCmp.setParams(params);
                    eventCmp.fire();
                    //<!--Fallou 07/02/2022: Rafraichissement du composant relatedList  -->
                    component.set('v.fileIds', []);
                    component.set('v.filesName', []);
                    
                    let relatedLists = component.find('relatedList');
                    if (relatedLists != undefined) {
                        if (!Array.isArray(relatedLists)) relatedLists = [relatedLists];
                        relatedLists.forEach(function (r) {
                            r.reloadRecords(r.get('v.objectApiName'));
                        });
                    }
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';

                console.error(errors);
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

    updateFile : function(component, event, Id) {
        let action = component.get("c.updateFileCtrl");
        action.setParams({
            documentId: Id,
            recordId: component.get("v.currentContactId")
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state == 'SUCCESS'){
                this.getContactPhotoHelper(component);
            } else {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'mode': 'dismissible',
                    'title': $A.get('$Label.c.Error'),
                    'type': 'error',
                    'message': $A.get('$Label.c.File_Error')
                });
                toastEvent.fire();
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to update profile picture : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    checkFilesHelper: function (component, contactId, recordType) {
        let action = component.get("c.checkFilesCtrl");
        action.setParams({
            "contactId": contactId,
            "currentRecordType" : recordType
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let filesMissed = response.getReturnValue();
                component.set('v.filesMissing', filesMissed);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to check files : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
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