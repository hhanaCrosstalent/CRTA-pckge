({
    doInit: function (component, event, helper) {
        helper.getTranslations(component);
        helper.getItems(component);
         
    },
    onChange: function (component, event, helper) {
        component.set("v.contacts", []);
        component.set("v.contactsInit", []);
        component.set("v.isLoading", true);
        helper.getItems(component);
    },
    displayFile: function (component, event) {
        event.stopPropagation();
        let ele = event.target;
        let documentId = ele.dataset.documentid;

        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
    },
    handleSearch: function (component, event, helper) {
        let search = component.find('enter-search').get('v.value');
        const dataInit = component.get('v.contactsInit');
        component.set("v.isSearching", true);
        if (search != '') {
            let result = helper.clone(dataInit);
            let searchLower = search.toLowerCase();
            const myFilter = (arr, s) => {
                const contacts = arr.filter(item => !!item.contactsList.find(c => c.name.toLowerCase().includes(s)));

                return contacts.map(item => {
                    item.contactsList = item.contactsList.filter(c => c.name.toLowerCase().includes(s));
                    return item;
                });
            };
            result = myFilter(result, searchLower);

            component.set("v.contacts", result);
            component.set("v.isSearching", false);
        } else {
            component.set("v.contacts", dataInit);
            component.set("v.isSearching", false)
        }
    },
 //NMA 19/05/2023 --> Résoudre le prob de redirection dans l'application mobile #ticket 5050 Point 2
     redirectToProfile: function (component, event, helper) {
          var selectedId = event.target.dataset.id; 
         var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({ 
             "url": '/lightning/cmp/crta__Profile?c__token='+selectedId
            });
         urlEvent.fire();
   
}

 
})