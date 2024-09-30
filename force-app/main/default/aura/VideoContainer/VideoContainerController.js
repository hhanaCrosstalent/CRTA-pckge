({
  //$Label.c.Text_Color
  //$Label.c.Width_Video
  //$Label.c.Height_Video
  //$Label.c.Video_Code
  //$Label.c.Display_Icon
  doInit: function(component, event, helper) {
    let videoCodes = component.get("v.videoCode");
    console.log(" Hana  ");
    if (videoCodes) {
      component.set("v.videoCodes", videoCodes.split(";"));
      component.set("v.selectedVideo", component.get("v.videoCodes")[0]);
    }
let index = 0;
    const videos = component.get("v.videoCodes");
      if (videos && videos.length>0) {
    let interId = setInterval(function() {
      if (index < videos.length) {
        component.set("v.selectedVideo", videos[index]);
        
        index++;
      } else {
        index = 0;
      }
    }, 5000); component.set("v.intervId", interId);
    }
  },
  onclickIframe: function (component, event, helper) {
    console.log('loaded  *');
    //console.log(document.getElementById('theIframe').contentWindow);

     
    /*document.getElementById('theIframe').contentWindow.document.body.onclick = function() {
      //document.getElementById("theIframe").contentWindow.location.reload();
      console.log('clickeddd ');
    }*/

    /*document.getElementById("theIframe").contentWindow.addEventListener(
      'click', function (event) { console.log("HHHHH ***** CLICKED"); }, false
    );*/
  },
  setOnInterval: function (component, event, helper) {
    console.log('ON  *');
    let index = 0;
    const videos = component.get("v.videoCodes");
      if (videos && videos.length>0) {
    let interId = setInterval(function() {
      if (index < videos.length) {
        component.set("v.selectedVideo", videos[index]);
        
        index++;
      } else {
        index = 0;
      }
    }, 5000); component.set("v.intervId", interId);
      }
   
  },
  stopInterval: function (component, event, helper) {
    console.log('STOP  *');
     let i = component.get("v.intervId");
    if (i) {
    clearInterval(i);
    }
  },
  changeSelected: function(component, event, helper) {
    //let elt = document.getElementsByClassName('slds-carousel__indicator-action slds-is-active');
    let eltIndex = event.srcElement.id;
    console.log("selected V");
    console.log(eltIndex);

    let videoCodes = component.get("v.videoCodes");
    let index = 0;
    videoCodes.forEach(element => {
      let eltX = document.getElementById(index + "");
      let eltVideoActv = document.getElementById(element);
      if (eltIndex == index) {
        component.set("v.selectedVideo", element);
        eltX.setAttribute(
          "class",
          "slds-carousel__indicator-action slds-is-active"
        );

        eltVideoActv.setAttribute(
          "class",
          "slds-carousel__panel slds-is-active"
        );
      } else {
        eltX.setAttribute("class", "slds-carousel__indicator-action");

        eltVideoActv.setAttribute(
          "class",
          "slds-carousel__indicator-action slds-is-active slds-hide"
        );
      }
      index++;
    });
  },
  handleclick: function(component, event, helper) {
    component.set("v.displayBody", !component.get("v.displayBody"));
  }
});