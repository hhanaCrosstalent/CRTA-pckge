({  
    // Load current profile picture
    onInit: function(component) {

           //  component.set('v.initials', 'IO');

        var action1 = component.get("c.getInitialsCtrl");
        action1.setParams({recordId: component.get("v.recordId"),
        });
        action1.setCallback(this, function (a) {
            var initials = a.getReturnValue();
            console.log('initals ' + initials);
            component.set('v.initials', initials);
        });
        $A.enqueueAction(action1); 
        var checkbox = component.get("v.AfficherLaPhoto");
        var action = component.get("c.getProfilePictureComposant");
         	action.setParams({
       			parentId: component.get("v.recordId"),
        	});
 
       		//if the checkbox "Afficher la photo" is checked
       		if(checkbox == true){
                action = component.get("c.getProfilePicture");
                 action.setParams({
       					parentId: component.get("v.recordId"),
        		}); 
        		action.setCallback(this, function(a) {
            		var attachment = a.getReturnValue();
           			console.log(attachment);
            		if (attachment && attachment.Id) {
	            		component.set('v.pictureSrc', '/sfc/servlet.shepherd/version/download/' 
                                                  + attachment.Id);
            		}
       	 		});
        	} 
            action.setCallback(this, function(a) {
            var attachment = a.getReturnValue();
            console.log(attachment);
            if (attachment && attachment.Id) {
	            component.set('v.pictureSrc', '/sfc/servlet.shepherd/version/download/' 
                                                  + attachment.Id);
            }
        }); 

        $A.enqueueAction(action); 
    },
    onDragOver: function(component, event) {
        event.preventDefault();
    },

    onDrop: function(component, event, helper) {
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        var files = event.dataTransfer.files;
        if (files.length>1) {
            return alert("Vous ne pouvez ajouter qu'une seule photo de profil");
        }
        helper.readFile(component, helper, files[0]);
	},

 
})