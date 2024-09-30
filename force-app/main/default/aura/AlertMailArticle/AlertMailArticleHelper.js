({
    getEmailTemplateHelper: function(component) {
        let action = component.get("c.getEmailTemplates");
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                let picklist = [];
                for (let key in result) {
                    picklist.push({
                        label: result[key],
                        value: key
                    });
                }
                component.set("v.emailTemplateList", picklist);
                component.set('v.isInit', false);
            } else {
                let errs = response.getError();
                for(let i = 0; i < errs.length; i++) {
                    console.error('Problem getting email templates: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getOrgEmailsHelper: function(component) {
        let action = component.get("c.getOrgEmails");
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                let picklist = [];
                for (let key in result) {
                    picklist.push({
                        label: result[key],
                        value: key
                    });
                }
                component.set("v.orgEmailList", picklist);
            } else {
                let errs = response.getError();
                for(let i = 0; i < errs.length; i++) {
                    console.error('Problem getting org email : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    sendMailHelper : function(component, recordId) {
        let action = component.get("c.sendMailCtrl");
        action.setParams({
            "recordId": recordId,
            "templateName" : component.find('emailTemplate').get('v.value'),
            "senderEmailId" : component.find('orgEmail').get('v.value')
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                if(result == 1) {
                    this.showToast('success', $A.get('$Label.c.Success'), $A.get('$Label.c.Email_Sent'));
                } else if(result == 2) {
                    this.showToast('error', $A.get('$Label.c.Error'), $A.get('$Label.c.No_Mass_Email'));
                } else if(result == 3) {
                    this.showToast('error', $A.get('$Label.c.Error'), $A.get('$Label.c.No_Banner_Email_Alert'));
                }
            } else {
                this.showToast('error', $A.get('$Label.c.Error'), $A.get('$Label.c.Email_Error'));
                let errs = response.getError();
                for(let i = 0; i < errs.length; i++) {
                    console.error('Problem sending mail: ' + errs[i].message);
                }
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(type, title, message) {
        let showToast = $A.get("e.force:showToast");
        showToast.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        showToast.fire();
    },
})