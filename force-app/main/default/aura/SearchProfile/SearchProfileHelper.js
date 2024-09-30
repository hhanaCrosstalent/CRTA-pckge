({
    initContactList: function (component) {

        var a = component.get("c.getContactsFilter");
       
        a.setParams({
            "fields": component.get('v.field1') + ';' + component.get('v.field2') + ';' + component.get('v.field3'),
            "recordTypes": component.get("v.recordTypes")
        });
        a.setCallback(this, function (r) {
            if (r.getState() === "SUCCESS") {
                var res = r.getReturnValue();
                let contacts = [];
                res.forEach(function (i) {
                    contacts.push({
                        Id: i.Id,
                        LastName: i.LastName,
                        FirstName: i.FirstName,
                        OwnerId: i.OwnerId,
                        field1: (component.get('v.field1') != null ?
                            component.get('v.field1').split('.').reduce((a, v) => a[v], i) : null),
                        field2: (component.get('v.field2') != null ?
                            component.get('v.field2').split('.').reduce((a, v) => a[v], i) : null),
                        field3: (component.get('v.field3') != null ?
                            component.get('v.field3').split('.').reduce((a, v) => a[v], i) : null)
                    })
                });

                component.set("v.listContactsInit", contacts);
            } else {
                var errs = r.getError();
                for (var i = 0; i < errs.length; i++) {
                    console.error('Problem loading users: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(a);
    },

    clone: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    },
})