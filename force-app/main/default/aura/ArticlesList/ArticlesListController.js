({
    doInit : function(component, event, helper) {
        helper.getArticles(component);
        
        let isVertical = component.get("v.isVertical");
        if (isVertical)
        {
            component.set("v.sizeArticles", "1");
        }
         window.setInterval(
            $A.getCallback(function() {
                helper.getArticles(component);
            }), 600000
        );
    },

    showContent : function(component, event) {
        let article = event.getSource().get("v.name").split('#');
        //window.open('/lightning/cmp/crta__ArticleDetails?c__articleId='+articleId, '_blank');*/
        component.set('v.articleId', article[0]);
        component.set('v.articleName', article[1]);
        component.set('v.displayArticleModal', true);

    },
    closeModal: function (component, event) {
        component.set('v.displayArticleModal', false); 
    },
    changeSelected: function (component, event, helper) {
        //let elt = document.getElementsByClassName('slds-carousel__indicator-action slds-is-active');
        let eltIndex = event.srcElement.id;
        console.log('selected V');
        console.log(eltIndex);
        
        let videoCodes = component.get('v.videoCodes');
        let index = 0;
        videoCodes.forEach(element => {
            let eltX = document.getElementById(index + '');
            let eltVideoActv = document.getElementById(element);
            if (eltIndex == index) {
              component.set("v.selectedVideo", element);       
                eltX.setAttribute("class", "slds-carousel__indicator-action slds-is-active");
                

                eltVideoActv.setAttribute("class", "slds-carousel__panel slds-is-active");
            } else {
                eltX.setAttribute("class", "slds-carousel__indicator-action");
                
                eltVideoActv.setAttribute("class", "slds-carousel__indicator-action slds-is-active slds-hide");
            }
            index++;
        });
    },
    handleclick : function(component, event, helper) {
        component.set("v.displayBody", !component.get("v.displayBody"));       
    }
    
    //$Label.c.Select_Type_Article
    //$Label.c.Vertical_Mode
    //$Label.c.Vertical_Mode_Description
    //$Label.c.Mobile_Version
    //$Label.c.Text_Color
    //$Label.c.is_Accordion

})