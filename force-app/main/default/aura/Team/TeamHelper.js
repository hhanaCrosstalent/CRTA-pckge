({
    getTranslations: function (component) {
        let a = component.get("c.getTranslations");
        a.setCallback(this, function (r) {
            if (r.getState() === "SUCCESS") {
                let res = r.getReturnValue();
                component.set("v.translate", res);
            } else {
                let errs = r.getError();
                let i;
                for (i = 0; i < errs.length; i++) {
                    console.error('Problem loading translation: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(a);
    },
    getItems: function (component) {
        //ebe getEmployee au lieu de getEmployees 16/05/2024(prob profendeur)
        let a = component.get("c.getEmployee");
        let level = 1;
        if (component.find("selectedLevel") != undefined) {
            if (component.find("selectedLevel").get('v.value') != undefined) {
                level = component.find("selectedLevel").get('v.value');
                console.log('level', level);
            }
        }


        a.setParams({
            'level': level,
            'recordTypes': component.get('v.recordTypes')
        });
        a.setCallback(this, function (r) {
            if (r.getState() === "SUCCESS") {
                let res = r.getReturnValue();
                //NMA 11/05/2023 Ordonner le résultat récupéré à partir d'Apex
                /*let mapJSON = new Map(Object.entries(res.employees));
			    let sortedAsc = new Map([...mapJSON].sort());*/
                let employeeList = res.employees;
                
                /*for (let key in sortedAsc) {
                    employeeList.push(
                        {
                            level: key,
                            contactsList: res.employees[key]
                        }
                    );
                }*/
             
                /*for (let [key, value] of sortedAsc) {
                 employeeList.push(
                        {
                            level: key,
                            contactsList: value
                        }
                    );
                    
                    
                }*/
                console.log('+++++ '+JSON.stringify(employeeList));
                component.set("v.contacts", employeeList);
                component.set("v.contactsInit", employeeList);
                 console.log('+++++ 22', component.get("v.contactsInit"));
                component.set("v.settings", res.settings);
                console.log('setting' +JSON.stringify(res.settings))
                component.set("v.isLoading", false);
            } else {
                let errs = r.getError();
                let i;
                for (i = 0; i < errs.length; i++) {
                    console.error('Problem loading employees: ' + errs[i].message);
                }
                component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(a);
    },
    clone: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    },
})