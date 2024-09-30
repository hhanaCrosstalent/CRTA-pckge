({
	getHeader : function(component) {
        let action = component.get('c.getHeader');
        action.setCallback(this, function(r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let res = r.getReturnValue();
                component.set('v.articleId', res.Id);
                this.getArticleImage(component);
            } else {
                console.log('no header found');
               //component.set('v.isLoading', false);
            }
            window.setTimeout(
                $A.getCallback(function () {
                    component.set('v.isLoading', false);
                }), 1500
            );
        });

        $A.enqueueAction(action);
    },

    getCurrentContact: function (component) {
    let action = component.get("c.getLoggedContactCtrl");
    action.setCallback(this, function(r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let currentContactName = r.getReturnValue();
                component.set('v.currentContactName', currentContactName);
            } else {
                console.log('Error loading banner');
            }
        });
        $A.enqueueAction(action);
    },

    getArticleImage : function(component) {
        let action = component.get("c.getFileFromArticle");
        let articleId = component.get("v.articleId");
        if(articleId == undefined) {
            articleId = '';
        }
        action.setParams({
            "articleId" : articleId
        });
        action.setCallback(this, function(r) {
            let state = r.getState();
            if (state == 'SUCCESS') {
                let fileId = r.getReturnValue();
                if(fileId != '') {
                    component.set('v.bannerImg', '/sfc/servlet.shepherd/version/download/' + fileId);
                }

            } else {
                console.log('Error loading banner');

            }
          //  component.set('v.isLoading', false);

        });
        $A.enqueueAction(action);
    }
})