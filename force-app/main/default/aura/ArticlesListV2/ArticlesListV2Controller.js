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
        
        
        
        
  
    } ,

    showContent: function (component, event) {
        if (component.get("v.intervId")) {
            clearInterval(component.get("v.intervId"));
        }
        let article = event.getSource().get("v.name").split('#');
        //window.open('/lightning/cmp/crta__ArticleDetails?c__articleId='+articleId, '_blank');*/
        component.set('v.articleId', article[0]);
        component.set('v.articleName', article[1]);
        component.set('v.displayArticleModal', true);

    },
    closeModal: function (component, event) {
        component.set('v.displayArticleModal', false);
        const limiter = component.get('v.listArticles');
        let index = 0;
        for (let i = 0; i < limiter.length; i++) {
            if (limiter[i].Id == component.get('v.articleId')) { index = i; break; }
        }
         const inetrvalId = setInterval(function() {
      if (limiter && index < limiter.length) {
        component.set("v.articleId", limiter[index].Id);
        index++;
      } else {
        index = 0;
      }
    }, 5000); component.set("v.intervId",inetrvalId);
    },
    changeSelectedArticle: function (component, event, helper) {
        //let elt = document.getElementsByClassName('slds-carousel__indicator-action slds-is-active');
        let eltIndex = event.srcElement.id;
        console.log('selected V');
        console.log(eltIndex);
        
        let listArticles = component.get('v.listArticles');
        let index = 0;
        listArticles.forEach(element => {
            let eltX = document.getElementById(index + '');
            let eltVideoActv = document.getElementById(element.Id);
            if (eltIndex == index) {
              component.set("v.articleId", element.Id);       
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