({
    getFieldsHelper: function(component,helper) {
        let rowActions = this.getRowActionsHelper.bind(this, component);
        let fileRowActions = this.getFileRowActionsHelper.bind(this, component);
        let action = component.get("c.getFieldsCtrl");
        let objectName = component.get("v.objectApiName");
        const isPhone = $A.get('$Browser.isPhone');
        let fieldsList = [];
        if (!!component.get("v.fieldsStr")) {
            fieldsList = component.get("v.fieldsStr").split(',');
            fieldsList = fieldsList.filter(field => (!!field));
        }
        
         if (fieldsList.length == 0) {
           component.set('v.isLoading', false);
         }
        action.setParams({
            'objectApi': objectName,
            'fieldList': fieldsList, 
            'createMode': true,
            'isPhone': isPhone
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let labelList = [];
                let labelListPhone=[];
                let labels = response.getReturnValue()['Fields'];
                
                let index = 0;
                labels.forEach(function(e) {
                    if(e.fieldName != 'objectLabel' && e.fieldName != 'objectLabelPlural') {
                        if(e.fieldType == 'DATETIME' ||e.fieldType == 'DATE') {
                            labelList.push({
                                label: e.fieldLabel, 
                                fieldName: e.fieldName, 
                                type: 'date-local',
                                typeAttributes: {
                                    year: "numeric",
                                    month: "2-digit",
                                    day: "2-digit"
                                },
                                isPhone:e.isToShowMobile,
                                sortable: false,
                                cellAttributes: {
                                    alignment: 'left'
                                }
                            });
                        } else if(e.fieldType == 'DOUBLE' || e.fieldType == 'INTEGER' || e.fieldType == 'LONG'
                        || e.fieldType == 'PERCENT') {
                            labelList.push({
                                label: e.fieldLabel, 
                                fieldName: e.fieldName, 
                                type: 'number',
                                sortable: false,
                                isPhone:e.isToShowMobile,
                                cellAttributes: {
                                    alignment: 'left'
                                }
                            });
                        } else if (e.fieldType == 'REFERENCE') {
                            labelList.push({
                                label: e.fieldLabel,
                                fieldName: 'refField_' + index,
                                type: e.fieldType, //=> FM 12/07/2021: J'ai enlevé la fonction toLowerCase() pour corriger le problème
                                sortable: false,
                                 isPhone:e.isToShowMobile,
                                cellAttributes: {
                                    alignment: 'left'
                                }
                            });
                            index++;
                        } else {
                            
                            labelList.push({
                                label: e.fieldLabel, 
                                fieldName: e.fieldName, 
                                type: e.fieldType,//=> FM 12/07/2021: J'ai enlevé la fonction toLowerCase() pour corriger le problème
                                sortable: false,
                                 isPhone:e.isToShowMobile,
                                cellAttributes: {
                                    alignment: 'left'
                                }
                            });
                        }
                    }
                    if(component.get("v.title") == undefined || component.get("v.title") == '') {
                        if(e.fieldName == 'objectLabelPlural') {
                            component.set("v.title", e.fieldLabel);
                        }
                    }
                });
                if(component.get('v.allowFiles')) {
                    labelList.push({
                        label: $A.get('{!$Label.c.File}'), 
                        // fieldName: 'file',
                        sortable: false,
                        // iconName: 'standard:file',
                        // type:'button',
                        cellAttributes: {
                            label: '',
                            alignment: 'left',
                            iconName: { fieldName: 'file' },
                            iconAlternativeText: $A.get('{!$Label.c.File}')
                        }
                    });
                }
                
                if(labelList.length > 0) {
                    labelList.push({
                        type: 'action', typeAttributes: {rowActions: rowActions}
                    });
                    
                    //for Phone mobile
                    for(let i=0;i<labelList.length;i++){
                        if(labelList[i].isPhone){
                            labelListPhone.push(labelList[i]);
                        }
                    }
                    
                    
                }
                console.log('++labelListPhone++ '+JSON.stringify(labelListPhone));
                //for Phone mobile : if there is more than one columns to show , we show only 2 columns
                if(isPhone && labelListPhone.length>2){
                 labelListPhone=labelListPhone.slice(0,2);
                }
                  
                if(isPhone && component.get('v.allowFiles')){
                    labelListPhone.push({
                        label: $A.get('{!$Label.c.File}'), 
                        sortable: false,
                        cellAttributes: {
                            label: '',
                            alignment: 'left',
                            iconName: { fieldName: 'file' },
                            iconAlternativeText: $A.get('{!$Label.c.File}')
                        }
                    });
                    
                     labelListPhone.push({
                        type: 'action', typeAttributes: {rowActions: rowActions}
                    });
                    
                    
                }
                    
                if(!isPhone){
                  component.set("v.columns", labelList);
                }
                else{
                    component.set("v.columns", labelListPhone);
                }
             
                
                let fileColumns = [
                    { label: $A.get('{!$Label.c.Create_Date}'), fieldName: 'CreatedDate', type: 'text', sortable: false },
                    { label: $A.get('{!$Label.c.Filename}'), fieldName: 'Title', type: 'text', sortable: false },
                    { label: '', type: 'action', typeAttributes: {
                            rowActions: fileRowActions
                        }
                    }
                ];
                component.set("v.fileColumns", fileColumns);
                 helper.getRecords(component); //=> Ajout FM le 12/07/2021
            } else {
                let errs = response.getError();
                for(let i=0; i<errs.length; i++) {
                    console.error('Problem loading fields: ' + errs[i].message);
                    this.showToast($A.get('$Label.c.Error'), errs[i].message, 'error', 'dismissible');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getRowActionsHelper : function (component, row, doneCallback) {
        let filterField = component.get("v.filterField");
        let editable = false;
        let editRecord = component.get('v.editRecord');
        let ManagerEditRecord = component.get('v.ManagerEditRecord');
        let fieldsToEdit = component.get('v.fieldsToEdit');
        let showFiles = component.get('v.showFiles');
       // if((editRecord || ManagerEditRecord) && fieldsToEdit != undefined) {
        if(editRecord || ManagerEditRecord){
            let allowedEditValues = component.get("v.editFilterValues");
            if(!!allowedEditValues) {
                allowedEditValues = allowedEditValues.split(',');
                if(allowedEditValues.includes(row[filterField])) {
                    editable = true;
                }
            } else {
                editable = true;
            }
        }

        let deletable = false;
        let deleteRecord = component.get('v.deleteRecord');
        let ManagerDeleteRecord = component.get('v.ManagerDeleteRecord');
        if(deleteRecord || ManagerDeleteRecord) {
            let allowedDeleteValues = component.get("v.deleteFilterValues");
            if(!!allowedDeleteValues) {
                allowedDeleteValues = allowedDeleteValues.split(',');
                if(allowedDeleteValues.includes(row[filterField])) {
                    deletable = true;
                }
            } else {
                deletable = true;
            }
        }
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let rowActions = [
            {label: $A.get('{!$Label.c.Show}'), name: 'show'},
            {label: $A.get('{!$Label.c.Edit}'), name: 'edit', disabled: !editable},
            {label: $A.get('{!$Label.c.Delete}'), name: 'delete', disabled: !deletable || (row.CreatedById != userId)},
            { label: $A.get('{!$Label.c.File}'), name: 'file', disabled: !showFiles}
        ];

        setTimeout($A.getCallback(function () {
            doneCallback(rowActions);
        }), 200);
    },

    getFileRowActionsHelper: function (component, row, doneCallback) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let editFiles = component.get('v.allowFiles');
        let isFileReadOnly = component.get("v.isFileReadOnly");
        
        let rowActions = [
            { label: $A.get('{!$Label.c.Preview}'), name: 'view', iconName: 'utility:preview' },
            { label: $A.get('{!$Label.c.Delete}'), name: 'delete', iconName: 'utility:delete', 
                disabled: (row.ContentDocument.OwnerId != userId) || !editFiles || isFileReadOnly}
        ];
        setTimeout($A.getCallback(function () {
            doneCallback(rowActions);
        }), 200);
    }, 

    getRecords : function(component, helper) {
        let fields = component.get("v.fieldsStr");
        let filterField = component.get("v.filterField");
        let recordType = (!!component.get('v.recordType') ? component.get('v.recordType') : null);

        let action = component.get("c.getRecordsCtrl");
        if (!!fields) {
            let fieldsArray = fields.split(',');
            if(!!filterField) {
                if(!fieldsArray.includes(filterField)) {
                    fields += ',' + filterField;
                }
            }

            if (!!component.get('v.requiredFileOnField')) {
                if (!fieldsArray.includes(component.get('v.requiredFileOnField'))) {
                    fields += ',' + component.get('v.requiredFileOnField');
                }
            }
            
            action.setParams({
                'fieldsList' : fields,
                'objectApi' : component.get("v.objectApiName"),
                'referenceField' : component.get("v.referenceField"),
                'referenceValue': component.get("v.parentId"),
                'whereClause' : component.get("v.filterList"),
                'sortClause' : component.get("v.sortClause"),
                'recordType': recordType
            });
            action.setCallback(this, function(response) {
                if(response.getState() === "SUCCESS") {
                    let result = response.getReturnValue();
                    let myThis = this;
                    result.forEach(function (r) {
                        let index = 0;
                        fieldsArray.forEach(function (f) {
                            if (f.includes('.')) {
                                let refValueLabel = 'refField_' + index;
                                let fieldSplit = f.split('.');
                                if (r[fieldSplit[0]] != undefined) {
                                    r[refValueLabel] = fieldSplit.reduce((a, v) => a[v], r);
                                }
                                index++;
                            }
                            let tmpText = r[f];
                            if (myThis.isHTML(tmpText)) {
                                var temp = document.createElement("div");
                                temp.innerHTML = tmpText;
                                let sanitizedText = temp.textContent || temp.innerText;
                                if (sanitizedText != 'undefined') {
                                    r[f] = sanitizedText;
                                }
                            }
                        });
                        if(r.AttachedContentDocuments != undefined) {
                            r.file = 'action:check';
                        } else {
                            if(component.get('v.attachmentRequired') || component.get('v.requiredFileOnField') != undefined) {
                                r.file = 'action:close';
                            } else {
                                r.file = 'action:remove';
                            }
                        }
                    });
                    component.set("v.records", result);
                    component.set("v.isLoading", false);
                } else {
                    let errs = response.getError();
                    for(let i = 0; i < errs.length; i++) {
                        console.error('Problem loading records: ' + errs[i].message);
                        this.showToast($A.get('$Label.c.Error'), errs[i].message, 'error', 'dismissible');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    getFieldsToShow: function(component, createMode, recordId) {
        let fieldsList = component.get("v.fieldsStr").split(',');
        let action = component.get("c.getFieldsCtrl");
        let objectName = component.get("v.objectApiName");

        if(component.get("v.additionalFields") != undefined) {
            fieldsList = fieldsList.concat(component.get("v.additionalFields").split(','));
        }
        if(fieldsList.findIndex(item => 'name' === item.toLowerCase()) == -1) {
            fieldsList.push('Name');
        }

        action.setParams({
            'objectApi': objectName,
            'fieldList': fieldsList,
            'createMode': createMode,
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let labelList = [];
                let labels = response.getReturnValue()['Fields'];
                let files = [];
                if(response.getReturnValue()['Files'] != undefined) {
                    files = response.getReturnValue()['Files'];
                }
                labels.forEach(function(e) {
                    if(e.fieldName != 'Name') {
                    let p = [];
                    if(e.pickListValues != undefined) {
                        for (let key in e.pickListValues) {
                            p.push({
                                label: e.pickListValues[key],
                                value: key
                            });
                        }
                    }
                        
                    if (e.fieldName != 'objectLabel' && e.fieldName != 'objectLabelPlural') {
                        //let fieldItem = component.get('v.fields').find(item => item.apiName == e.fieldName);
                        //Begun ==> Tenhinene : check if "v.fields" is Array or not : 06/09/2021 - CT-202108#003420
                        let fieldItem;
                        if (Array.isArray(component.get("v.fields"))) {
                            fieldItem = component.get("v.fields").find(item => item.apiName == e.fieldName);
                        }
                        else{
                            fieldItem = e.fieldName;
                        }
                        //End ==> Tenhinene : check if "v.fields" is Array or not : 06/09/2021 - CT-202108#003420
                       
                        
                        let value = e.fieldValue;
                        let valueRefLabel;
                        if(e.fieldType == 'DATETIME') {
                            value = $A.localizationService.formatDateTime(e.fieldValue, "YYYY-MM-DDThh:mm:ss.SZ");
                        }
                        //Added BY Tenhinene BENMESSAOUD 19/01/2022
						if(e.fieldType == 'TIME') {
                            value = $A.localizationService.formatTimeUTC(e.fieldValue);
                        }
                        //Added BY Tenhinene BENMESSAOUD 19/01/2022
                        if(e.fieldType == 'REFERENCE') {
                            valueRefLabel = e.fieldValueLabel;
                        } 
                        //Added BY NMA 21/11/2022
                         if (e.fieldType == 'MULTIPICKLIST') {
                            if(e.fieldValue != undefined) {
                                value=e.fieldValue.split(';').toString();
                            }
                        }
                       
                        labelList.push({
                            label: e.fieldLabel, 
                            fieldName: e.fieldName, 
                            type: e.fieldType.toLowerCase(),
                            newValue: value,
                            valueRefLabel : valueRefLabel,
                            picklist: p,
                            fieldHelpText: (fieldItem.hasHelpText ? e.fieldHelpText : '')
                        });
                    }
                } else {
                    
                        component.set("v.objectLabel", e.fieldValue);
                    }
                });
                component.set("v.isReadOnly", true);
                component.set("v.fieldsModal", labelList);
                component.set("v.filesList", files);
                component.set("v.openModal", true);
                const isPhone = $A.get('$Browser.isPhone');
                if(isPhone){
                 //Pour revenir au top du page
                  var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
                }
            } else {
                let errs = response.getError();
                for(let i=0; i<errs.length; i++) {
                    console.error('Problem loading field to show: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);

    },
    getFieldsToInsert : function(component, createMode, recordId) {
        let action = component.get("c.getFieldsCtrl");
        let objectName = component.get("v.objectApiName");
        //let fieldsList = [];
         let fieldsList = component.get("v.fieldsStr").split(',');
         /*if(component.get("v.additionalFields") != undefined) {
            fieldsList = fieldsList.concat(component.get("v.additionalFields").split(','));
        }
        if(fieldsList.findIndex(item => 'name' === item.toLowerCase()) == -1) {
            fieldsList.push('Name');
        }*/

        if(createMode) {
            if(component.get("v.fieldsToAdd") != undefined) {
                fieldsList = component.get("v.fieldsToAdd").split(',');
            }
            
        } else {
            if(component.get("v.fieldsToEdit") != undefined) {
                fieldsList = component.get("v.fieldsToEdit").split(',');
            }
        }

        action.setParams({
            'objectApi': objectName,
            'fieldList': fieldsList,
            'createMode': createMode,
            'recordId': recordId,
            'displayFiles': component.get('v.showFiles')
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let labelList = [];
                let labels = response.getReturnValue()['Fields'];
                let files = [];
                if(response.getReturnValue()['Files'] != undefined) {
                    files = response.getReturnValue()['Files'];
                }
                labels.forEach(function(e) {
                    let p = [];
                    if(e.pickListValues != undefined) {
                        for (let key in e.pickListValues) {
                            p.push({
                                label: e.pickListValues[key],
                                value: key
                            });
                        }
                    }
                    if (e.fieldType == 'BOOLEAN') {
                        e.fieldValue = (e.fieldValue == "true");
                    }
                    
                    if (e.fieldName != 'objectLabel' && e.fieldName != 'objectLabelPlural') {
                        let fieldItem; 
                        // let fieldItem = component.get("v.fields").find(item => item.apiName == e.fieldName);
                        //Begin ==> Tenhinene : check if "v.fields" is Array or not : 06/09/2021 - CT-202108#003420
                        if (Array.isArray(component.get("v.fields"))) {
                            fieldItem = component.get("v.fields").find(item => item.apiName == e.fieldName);
                        }
                        else{
                            fieldItem = e.fieldName;
                        }
                        //End ==> Tenhinene : check if "v.fields" is Array or not : 06/09/2021 - CT-202108#003420
                       
                        let selectedValues;
                        if (e.fieldType == 'MULTIPICKLIST') {
                            if(e.fieldValue != undefined) {
                                selectedValues = e.fieldValue.split(';');
                                e.selectedValues = selectedValues;
                            }
                        }
                        labelList.push({
                            label: e.fieldLabel, 
                            fieldName: e.fieldName, 
                            type: e.fieldType.toLowerCase(),
                            newValue: e.fieldValue,
                            selectedValues: selectedValues,
                            picklist: p,
                            required: fieldItem.isRequired,
                            fieldPermission: fieldItem.fieldPermission,
                            fieldHelpText: (fieldItem.hasHelpText ? e.fieldHelpText : '')
                        });
                    }
                    if(e.fieldName == 'objectLabel') {
                        if(createMode) {
                            component.set("v.objectLabel",$A.get('$Label.c.New') + ' : ' + e.fieldLabel);
                        } else {
                            component.set("v.objectLabel", $A.get('$Label.c.Edit') + ' : ' + e.fieldLabel);
                        }
                    }
                });
                
                component.set("v.fieldsModal", labelList);
                component.set("v.filesList", files);
                component.set("v.openModal", true);
                const isPhone = $A.get('$Browser.isPhone');
                if(isPhone){
                 //Pour revenir au top du page
                  var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
                }
            } else {
                let errs = response.getError();
                for(let i=0; i<errs.length; i++) {
                    console.error('Problem loading field to insert: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveNewRecord: function(component) {
        let objectApi = component.get("v.objectApiName");
        let referenceField = component.get("v.referenceField");
        let fields = component.get("v.fieldsModal");
        let objectToInsert = {sobjectType: objectApi};
        let recordType = (!!component.get('v.recordType') ? component.get('v.recordType') : null);
        let requiredOnfield = '';
        let contentDocumentIds = [];
        if (component.get('v.allowFiles')) {
            if (!!component.get("v.requiredFileOnField") && component.get("v.filesList").length == 0) {
                requiredOnfield = component.get("v.requiredFileOnField");
            }
        }

        fields.forEach(function(e) {
            if(e.type == 'boolean' && !e.newValue) {
                e.newValue = false;
            }
            
            if (e.type == 'reference') {
                e.fieldName = e.fieldName.substr(0, e.fieldName.indexOf('.'));
                e.fieldName = (e.fieldName.endsWith('__r') ?
                             e.fieldName.replace('__r', '__c') : (e.fieldName.endsWith('__c') ?
                                                                e.fieldName : e.fieldName + 'Id'));
            }
            if (e.type == 'multipicklist') {
                if(!!e.selectedValues) {
                    e.newValue = e.selectedValues.join(';');
                }
            }

            objectToInsert[e.fieldName] = e.newValue;
        });

        if(!!component.get('v.filesList')) {
            component.get('v.filesList').forEach(function (f) {
                contentDocumentIds.push(f.documentId);
            });
        }
        let action = component.get('c.insertNewRecord');
        action.setParams({
            'data' : objectToInsert,
            'objectApi': objectApi,
            'referenceField': referenceField,
            'referenceValue': component.get('v.parentId'),
            'recordType': recordType,
            'requiredOnfield' : requiredOnfield,
            'contentDocumentIds' : contentDocumentIds
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.openModal', false);
       			window.location.reload();
                this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Insert_Success'), 'success', 'dismissible');
                let createdData = response.getReturnValue();
                component.set("v.objectId", createdData.Id);
                this.getRecords(component);

                if (component.get('v.allowFiles')) {
                    if (!!component.get("v.requiredFileOnField")) {
                        if (createdData[component.get("v.requiredFileOnField")]) {
                         component.set("v.isRequiredOnField", true);
                       }
                    }
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';
                if (errors) {
                    for(let i=0; i < errors.length; i++) {
                        for(let j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(let fieldError in errors[i].fieldErrors) {
                                let thisFieldError = errors[i].fieldErrors[fieldError];
                                for(let j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                this.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
            }
        });
        $A.enqueueAction(action);
    },
    editRecordHelper: function (component, recordId) {
        let objectApi = component.get("v.objectApiName");
        let fields = component.get("v.fieldsModal");
        let objectToInsert = {sobjectType: objectApi, Id: recordId};
        let types = ['currency', 'double', 'long', 'integer'];

        fields.forEach(function(e) {
            if(e.type == 'boolean' && !e.newValue) {
                e.newValue = false;
            }
            if(e.fieldName != "objectLabel" && e.fieldName != 'objectLabelPlural') {
                let value = e.newValue;
                if(types.includes(e.type)) {
                    value = Number(e.newValue);
                }
                if (e.type == 'reference') {
                    e.fieldName = e.fieldName.substr(0, e.fieldName.indexOf('.'));
                    e.fieldName = (e.fieldName.endsWith('__r') ?
                             e.fieldName.replace('__r', '__c') : (e.fieldName.endsWith('__c') ?
                                                                e.fieldName : e.fieldName + 'Id'));
                }
                if (e.type == 'multipicklist') {
                    if(!!e.selectedValues) {
                        value = e.selectedValues.join(';');
                    }
                }
                
                if(e.type=='picklist'){
                   for (let key in e.picklist) {
                       if(e.picklist[key].label==e.newValue){
                               value=e.picklist[key].value;
                       }
                     
                        }

                }
                                 

                objectToInsert[e.fieldName] = value;
            }
        });
        let action = component.get('c.editRecordCtrl');
        action.setParams({
            'data' : objectToInsert
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.openModal', false);
                component.set('v.objectId', null);
                this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Edit_Success'), 'success', 'dismissible');
                this.getRecords(component);
                let editedData = response.getReturnValue();
                if (component.get('v.allowFiles')) {
                    if (!!component.get('v.requiredFileOnField')) {
                        if (editedData[component.get('v.requiredFileOnField')]) {
                            component.set('v.isRequiredOnField', true);
                        }
                    }
                    this.getFilesHelper(component, recordId);
                    component.set('v.objectId', recordId);
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';
                if (errors) {
                    for(let i=0; i < errors.length; i++) {
                        for(let j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(let fieldError in errors[i].fieldErrors) {
                                let thisFieldError = errors[i].fieldErrors[fieldError];
                                for(let j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                this.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
            }
        });
        $A.enqueueAction(action);
    },

    deleteRecordHelper: function(component, row) {
        let action = component.get('c.deleteRecordCtrl');
        action.setParams({
            'recordId': row.Id
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Delete_Success'), 'success', 'dismissible');
                this.getRecords(component);
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';
                if (errors) {
                    for(let i=0; i < errors.length; i++) {
                        for(let j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(let fieldError in errors[i].fieldErrors) {
                                let thisFieldError = errors[i].fieldErrors[fieldError];
                                for(let j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                this.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
            }
        });
        $A.enqueueAction(action);
    },

    deleteFileHelper: function (component, fileId) {
        let action = component.get('c.deleteFileCtrl');
        action.setParams({
            'recordId': fileId
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Delete_Success'), 'success', 'dismissible');
                this.getFilesHelper(component, component.get('v.objectId'));
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';
                if (errors) {
                    for(let i=0; i < errors.length; i++) {
                        for(let j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(let fieldError in errors[i].fieldErrors) {
                                let thisFieldError = errors[i].fieldErrors[fieldError];
                                for(let j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                this.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
            }
        });
        $A.enqueueAction(action);
    },

    getFilesHelper: function (component, rowId) {
        let action = component.get('c.getFilesCtrl');
        action.setParams({
            'recordId': rowId
        });
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                let fileList = response.getReturnValue();
                fileList.forEach(function (e) {
                    e.CreatedDate = $A.localizationService.formatDate(e.ContentDocument.LatestPublishedVersion.CreatedDate, 'DD/MM/YYYY');
                    e.Title = e.ContentDocument.LatestPublishedVersion.Title;
                });
                component.set('v.filesList', fileList);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to load filesList : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
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
                        inputSearch.showHelpMessageIfInvalid();
                    }
                    if (valueInvalid) {
                        lookupHasError.push(searchbox.get('v.refField'));
                    }
                }
            });
        }
        return lookupHasError;
    },

    isHTML: function (str) {
        let doc = new DOMParser().parseFromString(str, "text/html");
        return Array.from(doc.body.childNodes).some(node => node.nodeType === 1);
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