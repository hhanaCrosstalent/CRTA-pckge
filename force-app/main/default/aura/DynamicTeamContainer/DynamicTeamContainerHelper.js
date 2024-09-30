({
    getTabs: function (component, helper) {
        let action = component.get("c.getTabsCtrl");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let tabs = response.getReturnValue();
                tabs.forEach(function(item, i) {
                    item.id = helper.sanitizeString(item.label) + i;
                    item.subTabsList.forEach(function (subItem, si) {
                        subItem.id = helper.sanitizeString(subItem.label) + si;
                        subItem.parentId = helper.sanitizeString(item.label) + i;
                    });
                });

                component.set("v.tabsList", tabs);
            } else {
                let errs = response.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Problem loading tabs : ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    sanitizeString: function (str){
        str = str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(' ', '');
        return str.trim();
    },
})