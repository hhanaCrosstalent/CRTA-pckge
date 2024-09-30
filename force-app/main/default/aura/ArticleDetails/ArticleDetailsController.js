({
    doInit: function (component, event, helper) {
        let articleId = component.get('v.articleId');
        if (!articleId) {
            let myPageRef = component.get("v.pageReference");
            let articleId = myPageRef.state.c__articleId;
            component.set("v.articleId", articleId);
        } 
        helper.getArticleDetails(component);
        helper.getArticleImage(component);
    }
})