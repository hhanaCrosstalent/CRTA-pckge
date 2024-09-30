({
    doInit : function(component, event, helper) {
        let t1 = component.get('v.table1');
        let lines = t1.split('|')
        t1 = [];
        for(let i=0; i<lines.length; i++) {
            let cells = lines[i].split(',');
            t1.push({
                one: cells[0],
                two: cells[1],
                three: cells[2],
                four: cells[3]
            });
        }
        component.set('v.table1csv', t1);

        let t2 = component.get('v.table2');
        lines = t2.split('|')
        t2 = [];
        for (let i = 0; i < lines.length; i++) {
            let cells = lines[i].split(',');
            t2.push({
                one: cells[0],
                two: cells[1],
                three: cells[2],
                four: cells[3],
                five: cells[4]
            });
        }
        component.set('v.table2csv', t2);

        let t3 = component.get('v.table3');
        lines = t3.split('|')
        t3 = [];
        for (let i = 0; i < lines.length; i++) {
            let cells = lines[i].split(',');
            t3.push({
                one: cells[0],
                two: cells[1],
                three: cells[2],
                four: cells[3],
                five: cells[4]
            });
        }
        component.set('v.table3csv', t3);
    },
    handleClick: function(component, event, helper) {
        const b = event.getSource().getLocalId();
        helper.save(component, helper, b);
    },
    togglePanel: function (component) {
        let panel = component.find('panel');
        component.set('v.isClose', !component.get('v.isClose'));
        $A.util.toggleClass(panel, 'slds-is-open');
        $A.util.toggleClass(panel, 'slds-is-closed');
    },
})