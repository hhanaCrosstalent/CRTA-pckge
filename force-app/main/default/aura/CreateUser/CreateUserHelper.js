({
	handleError: function(component, helper, errors) {
        let s = '';
        for(let i=0; i<errors.length; i++) {
            let e = errors[i];
            if(e.fieldErrors) {
                for(let f in e.fieldErrors) {
                    if(e.fieldErrors.hasOwnProperty(f)) {
                        for (let j = 0; j < e.fieldErrors[f].length; j++) {
                            s += ' ' + JSON.stringify(e.fieldErrors[f][j]) + '<br/>';
                        }
                    }
                }
            }
            if(e.pageErrors) {
                for(let j=0; j<e.pageErrors.length; j++) {
                    s += ' ' + JSON.stringify(e.pageErrors[j]) + '<br/>';
                }
            }
        }
        console.error(s);
        return s;
    }
})