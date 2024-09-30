({
    handleFilesChange : function(component, event, helper) {
        console.log('Attempting file upload...');
    	let files = event.getSource().get('v.files');
        if (files && files.length > 0) {
            var file = files[0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.uploadFile(component, file, content, function(answer) {
                    if(answer) {
                        helper.hide(component,event);
                        // success
                    } else {
                        // failure
                    }
                });
            }
            reader.readAsDataURL(file);
        } else {
            console.error('Have not received a file.');
        }
	},
})