({
	doInit : function(component, event, helper) {
        const a = component.get('c.createUser');
        const recordId = component.get('v.recordId');
        let msg;
        msg = $A.get('$Label.c.User_Creation_Failure');
        component.set('v.message', msg);

        /*a.setParams({
            contactId: recordId
        });
        a.setCallback(this, function(r) {
            if(r.getState() === 'SUCCESS') {
                const result = r.getReturnValue();
                let msg;
                if(result == 0) {
                   	msg = $A.get('$Label.c.User_Creation_Success');
                } else if(result == 1) {
                    console.log('user exists already');
                    msg = $A.get('$Label.c.User_Creation_Duplicate');
                } else if(result == 2) {
                    console.log('Create user functionality desactivated.');
                    
                } else if(result == 3) {
                   msg = $A.get('$Label.c.User_Creation_No_Email');
                } else {
                    console.error('Unsupported return value.');
                    msg = $A.get('$Label.c.SIRH_Error_unknown');
                }
                component.set('v.message', msg);
            } else {
                console.error('Something went wrong.');
                const e = helper.handleError(component, helper, r.getError());
                //let msg = $A.get('$Label.c.Error') + '<p class="slds-p-top_large">(' 
                   // + e + ')</p>';
                console.error(e);
                component.set('v.message', $A.get('$Label.c.SIRH_Error_unknown'));
            }
        });
        $A.enqueueAction(a);*/
    } 
})