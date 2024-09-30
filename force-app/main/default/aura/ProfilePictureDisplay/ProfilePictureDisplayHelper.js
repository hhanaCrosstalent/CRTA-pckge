({
    readFile: function(component, helper, file) {
        if (!file) return;
        if (!file.type.match(/(image.*)/)) {
  			return alert('Fichier non supporté');
		}
        var reader = new FileReader();
        reader.onloadend = function() {
            var dataURL = reader.result;
            console.log(dataURL);
            component.set("v.pictureSrc", dataURL);
            helper.upload(component, file, dataURL.match(/,(.*)$/)[1]);
        };
        reader.readAsDataURL(file);
	},
    upload: function(component, file, base64Data) {
        var checkbox = component.get("v.AfficherLaPhoto");
        var action; 
        //If the checkbox "Afficher la photo de profile" is checked then save the file
        //If It's not checked then saveTheFileAsProfilPicture
        if(checkbox == true) {
            action = component.get("c.saveTheFileAsProfilPicture");
        } else {
            action = component.get("c.saveTheFile"); 
        }
       	action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: base64Data, 
        });
 
        
      	action.setCallback(this, function(a) {
            component.set("v.message", "Image chargée");
        });
        component.set("v.message", "Chargement...");
 
        
        $A.enqueueAction(action);
    }
 
})