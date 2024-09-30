({
	// Your renderer method overrides go here
	// 
	// Your renderer method overrides go here
	afterRender : function(component, helper) {
    this.superAfterRender();
    // do custom rendering here
    // 
      
       /* setInterval(function () {
                 component.get("v.videoCodes"); 
        console.log('videos');
        console.log(component.get("v.videoCodes"));
            }, 5000);*/
        
        /*let index = 0;
        let timerId = setInterval(() => {
            if (index < videos.length) {
                //component.set("v.selectedVideo", videos[i]); i = i + 1;    
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
            } else {
                index = 0;
            }
        }, 2000);  */
}
})