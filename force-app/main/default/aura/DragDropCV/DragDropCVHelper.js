({
	uploadFile : function(component, file, base64Data, callback) {

        const spinner = component.find('mySpinner');
        $A.util.toggleClass(spinner, 'slds-hide');

        const a = component.get('c.uploadFile');
        a.setParams({fileName: file.name, base64Data: base64Data});
        a.setCallback(this, function(r) {
            $A.util.toggleClass(spinner, 'slds-hide');
            if(r.getState() === "SUCCESS") {
                console.log('Response: ' + r.getReturnValue());
                const t = $A.get('e.force:showToast');
                t.setParams({
                    title: $A.get('$Label.c.Congratulation'),
                    type: 'success',
                    message: $A.get('$Label.c.SuccessParsing')
                });
                t.fire();
            } else {
                console.error(JSON.stringify(r.getState()+'/'+r.getError()));
                const t = $A.get('e.force:showToast');
                t.setParams({
                    title: $A.get('$Label.c.Error'),
                    type: 'error',
                    message: $A.get('$Label.c.ErrorParsing') +' (' + r.getState()+'/'+r.getError() + ').'
                });
                t.fire();
            }
        });
        $A.enqueueAction(a);
	}
})