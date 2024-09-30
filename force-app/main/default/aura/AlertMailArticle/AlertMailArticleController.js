({
    doInit : function(component, event, helper) {
        helper.getEmailTemplateHelper(component);
        helper.getOrgEmailsHelper(component);
    },
    sendMail: function(component, event, helper) {
        console.log('eee');
        if(component.find('emailTemplate').get('v.value') == '') {
            helper.showToast('error', $A.get('$Label.c.Error'), $A.get('$Label.c.Email_Template_Missing'));
        } else {
            component.set('v.isLoading', true);
            helper.sendMailHelper(component, component.get("v.recordId"));
        }
    }
})