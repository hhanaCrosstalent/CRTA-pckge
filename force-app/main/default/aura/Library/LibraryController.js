({
    doInit: function (component, event, helper) {
        helper.getCurrentContactIdHelper(component);
        helper.getAllFileTypesHelper(component, helper);
        //helper.getParentFolder(component, helper);
        helper.getFileTypesHelper(component);
        helper.getAllFileTagsHelper(component);
        helper.getFoldersListHelper(component);
        let header = $A.get('$Resource.' + component.get('v.headerBanner'));
        component.set('v.headerBannerLink', header);
    },
    openModalFiles: function (component, event, helper) {
        helper.getFileTypesHelper(component);
        component.set('v.isUploadFiles', !component.get('v.isUploadFiles'));
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
    },

    handleChangeLanguage: function (component, event, helper) {
        helper.getParentFolder(component, helper);
    },

    handleSearch: function (component, event, helper) {
        let search = component.find('enter-search').get('v.value');
        const dataInit = component.get('v.publicParentFolderInit');
        let result = helper.clone(dataInit);
        let searchLower = search.toLowerCase();
        result = result.filter(function f(o) {

            let toKeep = false;
            if (o.isFolder && o.items) {
                o.expanded = true;
            }
            if (o.labelSanitize.includes(searchLower)) {
                toKeep = true;
            }

            if (o.tagsSanitize != undefined) {
                if (o.tagsSanitize.includes(searchLower)) {
                    toKeep = true;
                }
            }
            if (toKeep) {
                return true;
            }

            if (o.items) {
                return (o.items = o.items.filter(f)).length;
            }
        });

        if (search != '') {
            component.set("v.isExpanded", true);
            component.set("v.publicParentFolder", result);
        } else {
            component.set("v.isExpanded", false);
            component.set("v.publicParentFolder", dataInit);
        }
    },

    handleTags: function (component, event, helper) {
        let tag = event.getSource();
        let tagName = tag.get("v.label");
        let tagId = tag.getLocalId();
        let tagArray = [];
        let allTags = [];

        if (!Array.isArray(component.find('tag'))) {
            allTags.push(component.find('tag'));
        } else {
            allTags = component.find('tag');
        }

        if (allTags.length > 0) {
            allTags.forEach(function (f) {
                if ($A.util.hasClass(f, "tag-active")) {
                    if (tagId != 'tag-all') {
                        tagArray.push(f.get("v.label"));
                    } else {
                        $A.util.removeClass(f, 'tag-active');
                    }
                }
            });

            $A.util.removeClass(component.find('tag-all'), 'tag-active');
            $A.util.toggleClass(tag, 'tag-active');
            if (tagId != 'tag-all') {
                if ($A.util.hasClass(tag, "tag-active")) {
                    tagArray.push(tagName);
                } else {
                    tagArray.splice(tagArray.indexOf(tagName), 1);
                }
            }

            const dataInit = component.get('v.publicParentFolderInit');
            let result = helper.clone(dataInit);
            result = result.filter(function f(o) {
                let toKeep = false;
                if (o.isFolder && o.items) {
                    o.expanded = true;
                }
                if (o.tags != undefined) {
                    if (tagArray.some(val => o.tags.includes(val))) {
                        toKeep = true;
                    }
                }
                if (toKeep) {
                    return true;
                }

                if (o.items) {
                    return (o.items = o.items.filter(f)).length;
                }
            });

            if (tagArray.length > 0) {
                component.set("v.isExpanded", true);
                component.set("v.publicParentFolder", result);
            } else {
                $A.util.addClass(component.find('tag-all'), 'tag-active');
                component.set("v.isExpanded", false);
                component.set("v.publicParentFolder", dataInit);
            }
        }
    },

    closeModal: function (component, event, helper) {
        
        component.set('v.isUploadFiles', false);
        //   window.location.reload();
        
    },
    handleUploadFinished: function (component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        helper.updateFile(component, helper, documentId);
        console.log('je suis dans update ')
    },
    onSelectFolder: function (component, event) {
        let folderId = component.find('picklistFoldersFiles').get('v.value');
        component.set('v.parentId', folderId);
    },

    openConfirmModal: function(component, event) {
          //NMA 05/04/2024
        component.set('v.confirmDeleteModal', true);
        /*let params = event.getParam('arguments');
        if (params) {
            let fileId = params.contentDocumentId;
            component.set('v.filetoDeleteId', fileId);
        }*/
    },

    closeConfirmModal: function(component, event, helper) {
        component.set('v.confirmDeleteModal', false);
    },

    deleteFile: function(component, event, helper) {
        helper.deleteFileHelper(component, helper);
    },
    handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("fileId");
        component.set('v.filetoDeleteId', valueFromChild);
    }
    //$Label.c.Show_Private_Folders
    //$Label.c.Account_Filter
    //$Label.c.Account_Filter_Description
    //$Label.c.Library_Header_Banner_Name
    //$Label.c.Library_Header_Banner_Name_Descr
    //$Label.c.Display_Library_Header_Banner
    //$Label.c.Display_Library_Header_Banner_Descr
    //$Label.c.Active_Tag_Color
    //$Label.c.Display_Tags_Filter
    //$Label.c.Display_Tags_List
    //$Label.c.Display_Languages_Filter
})