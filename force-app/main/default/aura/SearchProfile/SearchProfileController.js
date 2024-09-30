({
    doInit: function (component, event, helper) {
        helper.initContactList(component);
    },

    handleSearch: function (component, event, helper) {
        let search = component.find('searchInput').get('v.value');
        const dataInit = component.get('v.listContactsInit');
        component.set("v.isSearching", true);
        if (search != '') {
            if (search.length >= 3) {
                let result = helper.clone(dataInit);
                let searchLower = search.toLowerCase();
                result = result.filter(c => c.LastName.toLowerCase().includes(searchLower)
                    || c.FirstName.toLowerCase().includes(searchLower));

                component.set("v.listContacts", result);
                component.set("v.isSearching", false);
            }
        } else {
            component.set("v.listContacts", null);
            component.set("v.isSearching", false)
        }
    },

    goToContact: function (component, event, helper) {
        let userId = event.currentTarget.dataset.userid;
        let contactId = event.currentTarget.dataset.contactid;
        if (component.get("v.chatterProfile") && userId != null) {
            window.open('/lightning/r/User/' + userId + '/view', '_blank');
        } else {
            window.open('/lightning/cmp/crta__Profile?c__token=' + contactId, '_blank');
        }
    }
    //$Label.c.Record_Types
    //$Label.c.Separator_Record_Types
    //$Label.c.Brand_Color
    //$Label.c.Redirect_to_Chatter_Profile
    //$Label.c.Field_1
    //$Label.c.Field_2
    //$Label.c.Field_3
})