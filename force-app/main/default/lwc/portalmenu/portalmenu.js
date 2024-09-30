import { LightningElement, track,   api } from 'lwc';

import getAppsListFromCustomSettingCtrl from '@salesforce/apex/PortalMenuController.getAppsListFromCustomSettingCtrl';

import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

import customCSS from '@salesforce/resourceUrl/customCSS';


export default class Portalmenu extends LightningElement {


    @track firstClick = false;
     apps;
    componentConstructor;
    selectedId;

    displayContent = true;
    displayRows = false;
    @api color; //= 'white';
    @api background;// = '#0047bb';
    @api backgroundCmp;

    isFirstRender = true;
renderedCallback() {
  if (!this.isFirstRender) {
     return;
  }
  this.isFirstRender = false;

    document.documentElement.style.setProperty('--color', this.color);
    document.documentElement.style.setProperty('--background', this.background);
    document.documentElement.style.setProperty('--backgroundCmp', this.backgroundCmp);


  /*const customProperty = getComputedStyle(document.documentElement)
    .getPropertyValue('--titleColor');*/

}

    connectedCallback() {
        this.getApps();
    }
    /*youTubeCmpConstructor;
  connectedCallback() {
    import("c/welcomeTo")
      .then(({ default: ctor }) => (this.youTubeCmpConstructor = ctor))
      .catch((err) => console.log("Error importing component"));
  }*/
  



     /*@wire(getAppsListFromCustomSettingCtrl)
    wiredApps({ error, data }) {
        if (data) {
                this.apps = data;
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
        
    }*/
     getApps() { 
        getAppsListFromCustomSettingCtrl()
            .then(result => {
                this.apps = result;
                console.log('appppps ');
                
                console.log(this.apps);
                this.selectedId = this.apps[0].id;

                const selectEvent = new CustomEvent('moduleselect', {
                detail: { appId: this.selectedId , isHome: this.apps[0].isHome , appLabel: this.apps[0].label }
            });
                        console.log('dispatch evt');
            this.dispatchEvent(selectEvent);
            }).catch(error=>{
                console.log('Function getAppsListFromCustomSettingCtrl ERROR :'+JSON.stringify(error));   
            });
        
     }
    
    
    setDisplayRows() {
        this.displayRows = !this.displayRows;
         const selectEvent = new CustomEvent('sizechange', {
                detail: { size: this.displayRows ? 'w-15' : 'w-7' }
            });
                        console.log('dispatch evt');
            this.dispatchEvent(selectEvent);
    }
    
    handleClick(theapp) {
                console.log('handle click');

        let childCmp = this.template.querySelector('c-mycareer');
        if (childCmp && this.firstClick== true) {
           let result = childCmp.handleValueChange(theapp.id);
        }
        for (let i = 0; i < this.apps.length; i++) {
                
                this.apps[i].selected = (this.apps[i].label == theapp.label);
            }
      
        console.log('this.apps');
        console.log(this.apps);
            this.handleChange();
            this.loadComponent(theapp.cmp);
    }
    
    handleClickedIcon(event) {
       console.log('clicked XXXX ');
        console.log(event.target);  

        console.log(event.target.title);  
         const theapp = this.apps.find(e => e.label == event.target.title);
    
        if (theapp) {
            this.selectedId = theapp.id;
            this.handleClick(theapp);
        }
       // this.template.querySelector('lightning-input').value 
    }
    
   
     // handle the selected value
    handleClickedBtn(event) {
        console.log('clicked ');
        console.log(event.target);
        console.log(event.target.name);
       
        const theapp = this.apps.find(e => e.label == event.target.name);
    
        if (theapp) {
            this.selectedId = theapp.id;
            for (let i = 0; i < this.apps.length; i++) {
                
                this.apps[i].selected = (this.apps[i].label == event.target.name);
            }
            console.log('dispatch evt');
            console.log(this.apps);

            const selectEvent = new CustomEvent('moduleselect', {
                detail: { appId: this.selectedId , isHome: theapp.isHome, appLabel: theapp.label}
            });
                        console.log('dispatch evt');
            this.dispatchEvent(selectEvent);
                                    console.log('dispatch evt');

            //this.handleClick(theapp);
        }
     }
     async loadComponent(lwcCmp) {
        const ctor = await import('c/'+lwcCmp);
        this.componentConstructor = ctor.default;
    }

    handleChange() {
        if (this.firstClick == false) {
            this.firstClick = true;
        }
    }

    closeCmp() {
        this.firstClick = false;    
    }
}