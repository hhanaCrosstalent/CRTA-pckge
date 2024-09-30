({  
    getCurrentContactIdHelper: function (component) {
        let action = component.get("c.getConnectedContactIdCtrl");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contactId", response.getReturnValue().Id);
                if(response.getReturnValue().Onboarding == "true") {
                    component.set('v.isOnboardingReadOnly', true);
                } 
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading current contact id: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getParentFolder: function (component, helper) {
        let action = component.get("c.getFoldersCtrl");
        action.setParams({
            'isPrivate': component.get("v.isPrivate"),
            'contactId': component.get("v.contactId")
        });

        action.setCallback(this, function (r) {
            if (r.getState() === "SUCCESS") {
                let resultat = r.getReturnValue();
                let l = [];
                let allFiles = [];
                resultat.forEach(function (e, i) {
                    let indexLevel = 1;
                    l.push({
                        label: e.folder.Name,
                        labelSanitize: e.folder.Name.toLowerCase(),
                        name: e.folder.Id,
                        metatext: "",
                        expanded: false,
                        items: helper.getChildren(component, helper, e, indexLevel + 1)['folders'],
                        isFolder: true,
                        customIcon: e.folder.crta__Folder_Custom_Icon__c,
                        level: indexLevel
                    });
                    let files = helper.getChildren(component, helper, e)['files'];
                    if (files && files.length > 0) {
                        files.forEach(function (e) { allFiles.push(e) });
                    }
                });
                component.set("v.allFiles", allFiles);
                component.set("v.publicParentFolder", l);
                component.set("v.publicParentFolderInit", l);
                component.set("v.isLoading", false);
            } else {
                let errs = r.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to get folders : '  + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getChildren: function (component, helper, e, indexLevel) {
        let m = { 'folders': [], 'files': [] };
        if (e.folder.AttachedContentDocuments && e.folder.AttachedContentDocuments.length > 0) {
            e.folder.AttachedContentDocuments.forEach(function (f) {
                let type = component.get('v.allFileTypes').filter(item => item.crta__API_Name__c === f.ContentDocument.LatestPublishedVersion.crta__Type__c)[0];
                let deletable = false;
                console.log(component.get('v.allFileTypes')+'aaa'+JSON.stringify(component.get('v.allFileTypes')));
                if(!!type) {
                    deletable = type.crta__Allow_to_Delete__c && (f.ContentDocument.OwnerId ==  $A.get("$SObjectType.CurrentUser.Id"));
                }
                m['folders'].push({
                    label: f.ContentDocument.Title,
                    labelSanitize: f.ContentDocument.Title.toLowerCase(),
                    name: f.ContentDocument.Id,
                    metatext: f.ContentDocument.LatestPublishedVersion.crta__Type__c + ' • ' + f.ContentDocument.FileType,
                    level: indexLevel,
                    deletable: deletable,
                    tags: helper.getFileTags(component, f.ContentDocument.LatestPublishedVersion.crta__Tags__c),
                    tagsSanitize: helper.getTagsSanitize(f.ContentDocument.LatestPublishedVersion.crta__Tags__c)
                });
                m['files'].push(f.ContentDocument);
            })
        }
        if (e.childFolders && e.childFolders.length > 0) {
            e.childFolders.forEach(function (f) {
                m['folders'].push({
                    label: f.folder.Name,
                    labelSanitize: f.folder.Name.toLowerCase(),
                    name: f.folder.Id,
                    metatext: "",
                    expanded: false,
                    items: helper.getChildren(component, helper, f, indexLevel + 1)['folders'],
                    isFolder: true,
                    customIcon: f.folder.crta__Folder_Custom_Icon__c,
                    level: indexLevel
                });
            });
        }
        return m;
    },

    getFileTypesHelper: function (component) {
        let action = component.get("c.getFileTypes");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.fileTypes", result);
                if (result.length > 0) {
                    component.set("v.fileTypeSelected", result[0].crta__API_Name__c);
                }
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading file types : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getAllFileTypesHelper: function (component, helper) {
        let action = component.get("c.getAllFileTypes");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.allFileTypes", result);
                this.getParentFolder(component, helper);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading all file types : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getAllFileTagsHelper: function (component) {
        let action = component.get("c.getTagsList");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                let picklist = [];
                for (let key in result) {
                    picklist.push({
                        label: result[key],
                        value: key
                    });
                }
                component.set("v.fileTags", picklist);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading file types : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getFoldersListHelper: function (component) {
        let action = component.get("c.getFoldersList");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.folders", result);
                if (result.length > 0) {
                    component.get("v.fileFolderSelected", result[0].Id);
                }
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading file types : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    updateFile: function (component, helper, documentId) {
        let action = component.get("c.updateFilesCtrl");
        let fileType = component.get("v.fileTypeSelected");
        console.log('fileType 111'+fileType);
        let index = component.get("v.fileTypes").findIndex(item => item.crta__API_Name__c == fileType);
        console.log('fileType 2222222'+component.get("v.fileTypes").findIndex(item => item.crta__API_Name__c == fileType));
        let tags = component.get("v.fileTagsSelected");
        action.setParams({
            "documentId": documentId,
            "recordId": component.get("v.fileFolderSelected"),
            "fileType": fileType,
            "tags": tags
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set('v.fileId', documentId);
                let uploadedFiles = response.getReturnValue();
                if(uploadedFiles.length > 0) {
                    this.showToast(
                        $A.get('$Label.c.Success'),
                        $A.get('$Label.c.File_Upload') + ' ' + uploadedFiles[0].Title + '.'
                        + uploadedFiles[0].FileType.toLowerCase(),
                        'success'
                    );
                    this.sendMail(component);
                    //this.getParentFolder(component, helper, false);
                }
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Failed to upload file : ' + errs[i].message);
                }
                
            }
        });
        $A.enqueueAction(action);
    },

    sendMail: function (component) {
        let fileApiName = component.get("v.fileTypeSelected");
        let file = component.get("v.fileTypes").find(files => fileApiName === files.crta__API_Name__c);
        if (file.crta__Send_Mail__c != undefined) {
            component.set("v.isMail", file.crta__Send_Mail__c);
        }
        component.set("v.emailTemplate", file.crta__Email_Template_API_Name__c);

        if (file.crta__Public_Group__c != undefined) {
            component.set("v.publicGroup", file.crta__Public_Group__c);
        }
        component.set("v.labelFileType", file.MasterLabel);
        if (component.get("v.isMail")) {
            let action = component.get("c.sendMailCtrl");
            action.setParams({
                'publicGroup': component.get("v.publicGroup"),
                'documentId': component.get('v.fileId'),
                'folderId': component.get("v.fileFolderSelected"),
                'emailTemplateName': component.get("v.emailTemplate"),
            });
            action.setCallback(this, function (response) {
                if (response.getState() != 'SUCCESS') {
                    let errs = response.getError();
                    let message = '';
                    for (let i = 0; i < errs.length; i++) {
                        console.error('Failed to send email : ' + errs[i].message);
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errs[i].message;
                        }
                    }
                    this.showToast($A.get('$Label.c.Error'), message, 'error', 'dismissible');
                }else{
                    let returnFonction = response.getReturnValue();
                    if(returnFonction == 'SUCCESS'){
                        $A.get('e.force:refreshView').fire();
                    } else {
                        this.showToast($A.get('$Label.c.Error'), returnFonction, 'error', 'dismissible');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    deleteFileHelper: function(component, helper) {
        let action = component.get('c.deleteFileCtrl');
        action.setParams({
            'recordId': component.get('v.filetoDeleteId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Delete_Success'), 'success', 'dismissible');
                this.getParentFolder(component, helper);
                component.set('v.confirmDeleteModal', false);
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

    getFileTags: function (component, tagStr) {
        var arrayTag;
        if (tagStr != undefined) {
            arrayTag = tagStr.split(';');
            this.setTagsList(component, arrayTag);
        } else {
            arrayTag = [];
        }
        return arrayTag;
    },

    setTagsList: function (component, tagArray) {
        let currentTags = component.get("v.tagsList");
        tagArray.forEach(function (f) {
            if (!currentTags.includes(f)) {
                currentTags.push(f);
            }
        });
        component.set("v.tagsList", currentTags);
    },

    getTagsSanitize: function (tagStr) {
        if (tagStr != undefined) {
            return tagStr.toLowerCase();
        }
    },

    clone: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    },

    showToast: function (title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            title: title,
            message: message,
            type: type,
            duration: '30000'
        });
        toastEvent.fire();
    },

})