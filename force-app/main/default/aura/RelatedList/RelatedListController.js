({
    doInit : function(component, event, helper) {
        const isPhone = $A.get('$Browser.isPhone');
        if(!!component.get("v.fields")) {
            component.set("v.isLoading", true);
            if (Array.isArray(component.get("v.fields"))) {
                let field = [];
                let fieldPhone=[];
                component.get("v.fields").forEach(function (f) {
                    if(f.isToShowMobile==true){
                      fieldPhone.push(f.apiName);
                    }
                     field.push(f.apiName);   
                });
                component.set("v.fieldsStr", field.join(','));
               /* if(!isPhone){
                     
                }
                else{
                    
                   if(fieldPhone.length>2){
                         component.set("v.fieldsStr", fieldPhone.slice(0,2).join(','));    
               		 }
                    else{
                            component.set("v.fieldsStr", fieldPhone.join(','));  
                        }
                }*/
            } else {
                component.set("v.fieldsStr", component.get("v.fields"));
            }
         }
        helper.getFieldsHelper(component,helper);
        //helper.getRecords(component); //=> FME le 12/07/2021
    },
    reloadComponent:function(component,event,helper){ // <!--Fallou 07/02/2022: Rafraichissement du composant relatedList  -->
        let params = event.getParams();
        if(params.isCreateOrUpdate){
            helper.getFieldsHelper(component,helper);
        }
        
    },//<!--Fallou 07/02/2022: Rafraichissement du composant relatedList  -->
    reloadRecords : function(component, event, helper) {
        let params = event.getParam('arguments');
        if (params) {
            if(component.get("v.fieldsStr") != '') {
                component.set("v.isLoading", true);
                helper.getRecords(component);
            }
        }
    },
    
    getNumberRecords : function(component) {
        return component.get('v.records').length;
    },

    showHelpMessageIfInvalid : function(component) {
        let res = true;
        if(component.get('v.records').length == 0 && component.get('v.required')) {
            $A.util.addClass(component.find('cardContainer'), 'error-required-list');
            res = false;
        } else {
            $A.util.removeClass(component.find('cardContainer'), 'error-required-list');
        }
        return res;
    },
    addRecord: function(component, event, helper) {
        component.set('v.objectId', null);
        component.set("v.openModal", true);
        component.set("v.isReadOnly", false);
        component.set('v.isRequiredOnField', false);
        component.set('v.isNewRecord', true);
        helper.getFieldsToInsert(component, true);
        if($A.get('$Browser.isPhone')){
        window.scroll({
          top: 0, 
          left: 0, 
          behavior: 'smooth'
        });
        }
        
        
    },
    editRecord: function(component, event, helper) {
        let recordId = component.get("v.objectId");
        let allValid = true;
        let mandatoryFields = component.find("field");
        if (!Array.isArray(mandatoryFields)) mandatoryFields = [mandatoryFields];
        if(component.find("address") != undefined) {
            mandatoryFields.push(component.find("address"));
        }
        let lookupHasError = helper.checkLookupError(component);
         if (mandatoryFields) { //=> FME 20210906 : Ajout de contrôle sur inputCmp
            allValid = mandatoryFields.reduce(function (validSoFar, inputCmp) {
                if(inputCmp) {
                    if (typeof inputCmp.showHelpMessageIfInvalid !== "undefined") { 
                        try{
                            inputCmp.showHelpMessageIfInvalid();
                            return validSoFar
                            && !(inputCmp.get('v.validity').valueMissing && inputCmp.get('v.required'))
                            && !(inputCmp.get('v.validity').typeMismatch);
                        }catch(e){
                            return true;
                        }
                    } else {
                        let isValid = true;
                        if (inputCmp.get('v.value') == undefined || inputCmp.get('v.value') == '') {
                            inputCmp.set('v.valid', false);
                            isValid = false;
                        } else {
                            inputCmp.set('v.valid', true);
                            isValid = true;
                        }
                        return isValid && validSoFar;
                    }

                }

            }, true);

            if (allValid && lookupHasError.length == 0) {
                helper.editRecordHelper(component, recordId);
            } else {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.Required_Fields'), 'error', 'dismissible');
            }
         } else {
            if (lookupHasError.length == 0) {
                helper.editRecordHelper(component, recordId);
            }
         }
        
     
    },
    closeModal: function(component,event, helper) {
        component.set('v.openModal', false);
        component.set('v.objectId', null);
        component.set('v.fieldsModal', null);
        component.set('v.filesName', null);
    },
    handleBlur: function (component, event) {
        let validity = event.getSource().get("v.validity");
        component.set('v.buttonDisabled', !validity.valid);
    },
    saveRecord: function(component, event, helper) {
        let allValid = true;
        let mandatoryFields = component.find("field");
        if (!Array.isArray(mandatoryFields)) mandatoryFields = [mandatoryFields];
        if(component.find("address") != undefined) {
            mandatoryFields.push(component.find("address"));
        }

        let lookupHasError = helper.checkLookupError(component);
         if (mandatoryFields) {
            allValid = mandatoryFields.reduce(function (validSoFar, inputCmp) {
                if(inputCmp) {
                    if (typeof inputCmp.showHelpMessageIfInvalid !== "undefined") { 
                        try{
                            inputCmp.showHelpMessageIfInvalid();
                            return validSoFar
                            && !(inputCmp.get('v.validity').valueMissing && inputCmp.get('v.required'))
                            && !(inputCmp.get('v.validity').typeMismatch);

                        }catch(e){
                            return true;
                        }
                    } else {
                        let isValid = true;
                        if (inputCmp.get('v.value') == undefined || inputCmp.get('v.value') == '') {
                            inputCmp.set('v.valid', false);
                            isValid = false;
                        } else {
                            inputCmp.set('v.valid', true);
                            isValid = true;
                        }
                        return isValid && validSoFar;
                    }
                }
                },
             true);
            if (allValid && lookupHasError.length == 0) {
                if (component.get('v.attachmentRequired')) {
                    if (component.get('v.filesList').length == 0) {
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'dismissible',
                            "title": $A.get('$Label.c.Error'),
                            "type": "error",
                            "message": $A.get('$Label.c.Attachment_Required')
                        });
                        toastEvent.fire();
                    } else {
                        helper.saveNewRecord(component);
                    }
                } else {
                    helper.saveNewRecord(component);
                }
            } else {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.Required_Fields'), 'error', 'dismissible');
            }
         } else {
             if (lookupHasError.length == 0) {
                 if (component.get('v.attachmentRequired')) {
                    if (component.get('v.filesList').length == 0) {
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'dismissible',
                            "title": $A.get('$Label.c.Error'),
                            "type": "error",
                            "message": $A.get('$Label.c.Attachment_Required')
                        });
                        toastEvent.fire();
                    } else {
                        helper.saveNewRecord(component);
                    }
                } else {
                    helper.saveNewRecord(component);
                }
            }
        }
    },
    handleRowAction: function (component, event, helper) {
        component.set("v.isReadOnly", false);
        component.set('v.isRequiredOnField', false);
        component.set('v.isNewRecord', false);
        component.set('v.hasFile', false);
        let action = event.getParam('action');
        let row = event.getParam('row');
        switch (action.name) {
            case 'show':
                component.set('v.objectId', row.Id);
                helper.getFieldsToShow(component, false, row.Id);
                break;
            case 'edit':
                component.set('v.objectId', row.Id);
                if (!!component.get('v.requiredFileOnField')) {
                    if (row[component.get('v.requiredFileOnField')]) {
                        component.set('v.isRequiredOnField',true);
                    }
                }
                helper.getFieldsToInsert(component, false, row.Id); 
             
                break;
            case 'delete':
                helper.deleteRecordHelper(component, row);
                break;
            case 'file':
                component.set('v.objectId', row.Id);
                helper.getFilesHelper(component, row.Id);
                component.set('v.openFileModal', true);
                if( $A.get('$Browser.isPhone')){
                 window.scroll({
                  top: 0, 
                  left: 0, 
                  behavior: 'smooth'
                 });}
                let records = component.get('v.records');
                records.forEach(function (e) {
                    if (e.Id == row.Id && !!e.AttachedContentDocuments) {
                        component.set('v.filesList', e.AttachedContentDocuments);
                        component.set('v.hasFile', true);
                    }
                });
                 
                break;
        }
    },
    handleUploadFinished: function(component, event, helper) {
        let rowId = component.get('v.objectId');
        let uploadedFiles = event.getParam("files");
        let fileList = [];
        let filesName = [];
        for (let i = 0; i < uploadedFiles.length; i++) {
            fileList.push(uploadedFiles[i]);
            filesName.push(uploadedFiles[i].name);
        }
        component.set('v.filesList', fileList);
        component.set('v.filesName', filesName.join(','));
        if(!component.get('v.isNewRecord')) {
            helper.getFilesHelper(component, rowId);
        }
    },

    handleFileAction: function (component, event, helper) {
        event.stopPropagation();
        let row = event.getParam('row');
        let action = event.getParam('action');

        switch (action.name) {
            case 'view':
                let fileList = component.get('v.filesList');
                fileList.forEach(function (e) {
                    if (e.Id == row.Id) {
                        $A.get('e.lightning:openFiles').fire({
                            recordIds: [e.ContentDocumentId]
                        });
                    }
                });
                break;
            case 'delete':
                helper.deleteFileHelper(component, row.ContentDocumentId);
                break;
        }
    },
    closeFileModal: function (component, event, helper) {
        component.set('v.openFileModal', false);
        component.set('v.objectId', null);
        component.set('v.filesList', null);
        helper.getRecords(component);
    },

    displayFiles: function (component, event) {
        event.stopPropagation();
        let ele = event.target;
        let documentId = ele.dataset.documentid;
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
    },
    
    downloadFiles: function(component, event) {
        event.stopPropagation();
        let ele = event.target;
        let fileId = ele.dataset.documentid;
        
        window.open('/sfc/servlet.shepherd/document/download/'+fileId, "_blank");
    },

    deleteFiles: function(component, event, helper) {
        event.stopPropagation();
        let ele = event.target;
        let fileId = ele.dataset.documentid;

        helper.deleteFileHelper(component, fileId);
    },
    handleRequest: function (component, event, helper) {
        helper.sendEditRequestHelper(component, event, helper);
        
    },
    //$Label.c.Label
    //$Label.c.Icon
    //$Label.c.Object_Api_Name
    //$Label.c.Field_Reference
    //$Label.c.Array_Columns
    //$Label.c.Array_Columns_Description
    //$Label.c.List_Filter
    //$Label.c.List_Filter_Description
    //$Label.c.Sort_to_Apply
    //$Label.c.Sort_to_Apply_Description
    //$Label.c.Additional_Fields
    //$Label.c.Additional_Fields_Description
    //$Label.c.Display_Files
    //$Label.c.Allow_to_Add_Files
    //$Label.c.Allow_to_Add
    //$Label.c.Field_to_Insert
    //$Label.c.Field_to_Insert_Description
    //$Label.c.Allow_to_Edit
    //$Label.c.Field_to_Edit
    //$Label.c.Field_to_Edit_Description
    //$Label.c.Allow_to_Delete
    //$Label.c.Field_Filter
    //$Label.c.Field_Filter_Description
    //$Label.c.Filter_Edit_Values
    //$Label.c.Filter_Edit_Values_Description
    //$Label.c.Filter_Delete_Values
    //$Label.c.Filter_Delete_Values_Description
})