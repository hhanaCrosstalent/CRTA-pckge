({
    doInit: function(component) {
        component.set('v.isPrivate', component.get('v.parent').get('v.isPrivate'));
         if(component.get("v.node") != null) {
             console.log('Node'+JSON.stringify(component.get("v.node")));
            let isNodeExpanded = component.get("v.node").expanded;
            if(isNodeExpanded != undefined) {
                if(isNodeExpanded) {
                    component.set('v.iconName', 'utility:opened_folder');
                } else {
                    component.set('v.iconName', 'utility:open_folder');
                }
            }
        }
    },
    
    toggle: function(component, event) {
        let currentElement = event.currentTarget;
        let parentEle = currentElement.parentElement;
        let isFile = parentEle.dataset.isfile;
        if(isFile != 'true') {
            let isExpanded = (parentEle.getAttribute('aria-expanded') == 'true');
            parentEle.setAttribute('aria-expanded', !isExpanded);
            if(!isExpanded) {
                component.set('v.iconName', 'utility:opened_folder');
            } else {
                component.set('v.iconName', 'utility:open_folder');
            }
        }
    },
    
    displayFiles: function (component, event) {
         event.stopPropagation();
        //Ebenrhouma 31/10/2023
        /*let ele = event.target;       
        let documentId = ele.dataset.documentid;*/      
        var documentId = event.target.closest("[data-id]").dataset.id;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
    },
    
    downloadFiles: function(component, event) {  
        event.stopPropagation();
        //Ebenrhouma 31/10/2023
        /*let ele = event.target;       
        let documentId = ele.dataset.documentid;*/    
        var fileId = event.target.closest("[data-id]").dataset.id;
        console.log('Id file '+ fileId)
       window.open('/sfc/servlet.shepherd/document/download/'+fileId, "_blank");
    },

    deleteFile: function(component, event) {
        let ele = event.target;
        //let fileId = ele.dataset.documentid;
        //NMA 05/04/2024
        var fileId = event.target.closest("[data-id]").dataset.id;
        console.log('***** '+fileId);
          var compEvent = component.getEvent("sampleComponentEvent");
          compEvent.setParams({
            "fileId" : fileId
         });
        compEvent.fire();
        let parent = component.get('v.parent');
        parent.openConfirmModal(component,event);
    }
})