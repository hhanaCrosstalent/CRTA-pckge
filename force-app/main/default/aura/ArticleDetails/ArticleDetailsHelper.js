({
    getArticleDetails : function(component) {
    let action = component.get("c.getArticleDetails");
        action.setParams({
            "articleId" : component.get("v.articleId")
        });
        action.setCallback(this, function(r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let res = r.getReturnValue();
                if(res.crta__Texte__c == undefined) {
                    res.crta__Texte__c = '';
                } else {
                	res.crta__Texte__c = this.decodeHtml(component, res.crta__Texte__c);
                }
               	component.set('v.article', res);
            } else {
                let errs = r.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Error loading article detail: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getArticleImage : function(component) {
        let action = component.get("c.getFileFromArticle");
            action.setParams({
                "articleId" : component.get("v.articleId")
            });
        action.setCallback(this, function(r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let fileId = r.getReturnValue();
                if(fileId != '') {
                    component.set('v.articleImg', '/sfc/servlet.shepherd/version/download/' + fileId);
                }
            } else {
                let errs = r.getError();
                for (let i = 0; i < errs.length; i++) {
                    console.error('Error loading article image: ' + errs[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    decodeHtml: function (component, html) {
        let txt = document.createElement("textarea");
        html = html.replace(/<ul/i, '<ul class="slds-list_dotted"')
                    .replace(/<ol/i, '<ol class="slds-list_ordered"');
        txt.innerHTML = html;
        return txt.value;
    }
})