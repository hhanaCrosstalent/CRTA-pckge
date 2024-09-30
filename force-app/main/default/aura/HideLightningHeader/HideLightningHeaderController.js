({
    doInit : function(component, event, helper) {
        helper.getContactId(component);
        helper.hideContent(helper, '.flexipageHeader.slds-page-header');
        helper.changeStyle(helper, '.flexipageRichText', 'font-weight:300 !important;');
    }
})