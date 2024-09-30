({
    getContactId : function (component) {
        let action = component.get('c.getContactId');
        action.setCallback(this, function (r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let res = r.getReturnValue();
                component.set('v.contactId', res);
            } else {
                let errs = r.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Error get contact id: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    hideContent : function(helper, toHide) {
        let css = toHide + ' { display: none !important;} ',
            head = document.head || document.getElementsByTagName('head')[0],
            style = document.createElement('style');
        style.type = 'text/css';
        if (style.styleSheet){
          style.styleSheet.cssText = css;
        } else {
          style.appendChild(document.createTextNode(css));
        }
        head.appendChild(style);
    },
    
    
    changeStyle: function (helper, toChange, styleToApply) {
        let css = toChange + ' { ' + styleToApply + ';} ',
        head = document.head || document.getElementsByTagName('head')[0],
        style = document.createElement('style');
        style.type = 'text/css';
        if (style.styleSheet) {
            style.styleSheet.cssText = css;
        } else {
            style.appendChild(document.createTextNode(css));
        }
        head.appendChild(style);
    }
})