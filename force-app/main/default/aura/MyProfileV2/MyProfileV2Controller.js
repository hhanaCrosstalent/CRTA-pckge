({
    doInit: function (component, event, helper) {
        const isPhone = $A.get('$Browser.isPhone');
        if (isPhone) {
            component.set('v.photoStyle','photo-on-mobile');
            component.set('v.editBtnStyle', 'myEditProfileButtonMobile');
        }
        let pageReference = component.get("v.pageReference");
        if (!!pageReference) {
            component.set("v.token", component.get("v.pageReference").state.c__token);
        }
        helper.getCurrentContactIdHelper(component,helper);

        //helper.getContactHelper(component, helper);
    },
    //NMA 19/05/2023 pour faire le refr
    //esh du composant 
     reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    reloadData: function (component, event, helper) {
        helper.getContactHelper(component, helper);
    },
    openModal: function (component, event) {
       // let target = event.target;
        var targetName = event.target.closest("[data-id]").dataset.id;
        console.log('targetName'+targetName);
        let fieldGroupsList = component.get('v.fieldGroupsList');
        let fieldGroup;
        component.set('v.listIdLookup',[]);
        let listId=component.get('v.listIdLookup');
        
        fieldGroupsList.forEach(function (e) {
         // if (e.uniqueName == event.target.dataset.uniquename) {
           if (e.uniqueName == targetName) {
                e.fieldsList.forEach(function (f) {
                    if(f.fieldType == 'reference') {
                        f.apiName  = e.uniqueName;
                        listId.push(f.idValue);
                        component.set('v.listIdLookup',listId);
                        if(f.fieldValue != undefined) {
                            f.fieldValue = f.fieldValue + ' (' + f.idValue + ')';

                            //Pour garder la valeur qui existe avant le clique sur le Save ou bien vider le champ lookup
                            f.idValue=component.get('v.listIdLookup')[0];
                        }
                       
                    }
                    if (f.fieldType == 'picklist' || f.fieldType == 'multipicklist') {
                        let picklist = [];
                        for (let key in f.pickListValues) {
                            picklist.push({
                                label: f.pickListValues[key],
                                value: key
                            });
                        }
                        f.picklist = picklist;
                    }
                    if (f.fieldType == 'multipicklist') {
                        if(f.fieldValue != undefined) {
                            let selectedValues = f.fieldValue.split(';');
                            f.selectedValues = selectedValues;
                        }
                    }

                     if (f.fieldType == 'double') {
                        f.fieldValue = parseFloat(f.fieldValue);
                    }

                    if (f.apiName == 'MailingAddress') {
                        component.set('v.street', component.get("v.myContact.MailingStreet"));
                        component.set('v.postalCode', component.get("v.myContact.MailingPostalCode"));
                        component.set('v.city', component.get("v.myContact.MailingCity"));
                        component.set('v.state', component.get("v.myContact.MailingState"));
                        component.set('v.country', component.get("v.myContact.MailingCountry"));
                    }
                    else {
                        if(f.fieldType!='reference'){
                            f.newValue = f.fieldValue;
                        }
                        if (f.fieldType == 'percent') {
                            f.newValue = f.newValue * 100;
                        }
                    }
                    component.set('v.fileIsRequired', f.attachmentRequired);
                });
                   
                fieldGroup = e;
            }
        });
        component.set('v.fieldGroup', fieldGroup);
        component.set('v.modalTitle', fieldGroup.fieldPermissionLabel);
     
        component.set('v.openModal', true);
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
        component.set('v.modalLoading', false);
    },
    closeModal: function (component, event, helper) {
        component.set('v.openModal', false);
        
    },
    closeModalPhoto: function (component, event, helper) {
        component.set('v.isEditPhoto', false);
    },
    handleEdit: function (component, event, helper) {
        component.set('v.modalLoading', true);
        helper.updateFieldsHelper(component, event, helper);
    },
    handleRequest: function (component, event, helper) {
        component.set('v.modalLoading', true);
        if (component.get('v.fileIsRequired')) {
            if (component.get('v.fileIds').length == 0) {
                component.set('v.modalLoading', false);
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": 'dismissible',
                    "title": $A.get('$Label.c.Error'),
                    "type": "error",
                    "message": $A.get('$Label.c.Attachment_Required')
                });
                toastEvent.fire();
            } else {
                helper.sendEditRequestHelper(component, event, helper);
            }
        } else {
            helper.sendEditRequestHelper(component, event, helper);
        }
    },
    handleUploadFinished: function (component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentIds = [];
        let filesName = [];
        for (let i = 0; i < uploadedFiles.length; i++) {
            documentIds.push(uploadedFiles[i].documentId);
            filesName.push(uploadedFiles[i].name);
        }
        component.set('v.fileIds', documentIds);
        component.set('v.filesName', filesName.join(','));
    },
    handleBlur: function (component, event) {
        let validity = event.getSource().get("v.validity");
        component.set('v.buttonDisabled', !validity.valid);
    },
    editPhoto: function (component, event, helper) {
        component.set('v.isEditPhoto', true);
    },
    openModalFiles: function (component, event, helper) {
        component.set('v.isUploadFiles', !component.get('v.isUploadFiles'));
    },

    updatePhoto: function (component, event) {
        let param = event.getParams();
        let newPhoto = param.urlNewPhoto;
        component.set('v.currImage', newPhoto);
    },

    handleUploadPhotoFinished: function (component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId; 
        helper.updateFile(component,event,documentId);
        let toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            "mode": "dismissible",
            "title": $A.get('$Label.c.Success'),
            "type": "success",
            "message": $A.get('$Label.c.Profile_Picture_Updated')
        });
        toastEvent.fire();
    },

    afterRender: function (component) {
        let firstTab = document.querySelector('.slds-sub-tabs__item');
        if (!!firstTab) {
            firstTab.classList.add('slds-active');

            let firstTabContentId = firstTab.firstChild.getAttribute('data-contentid');
            let firstTabContent = document.getElementById(firstTabContentId);
            if (!!firstTabContent) {
                firstTabContent.classList.add('slds-show');
                firstTabContent.classList.remove('slds-hide');
            }
        }
    },

    handlerTabs: function (component, event) {
        let idTab = event.currentTarget.id;
        let idContentTab = event.currentTarget.dataset.contentid;
        let items = component.find('tab-item');
        if (!!items) {
            if (!Array.isArray(items)) items = [items];
            items.forEach(function (e) {
                $A.util.removeClass(e.getElement(), 'slds-active');
            });

            let currentTab = document.getElementById(idTab);
            let parentLi = currentTab.parentElement;
            parentLi.classList.add('slds-active');

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
    //$Label.c.Allow_to_Add_Files
    //$Label.c.Icons_Color
    //$Label.c.Account_Field_API_Name
})