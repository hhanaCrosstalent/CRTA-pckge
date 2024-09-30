import { LightningElement , wire } from 'lwc';
import getComponentsCtrl from '@salesforce/apex/PortalHomeController.getComponentsCtrl';


export default class CustomLINKS extends LightningElement {



    filter = ' crta__Component_Name__c = \'CustomLink\' and crta__Sub_Tab__c = null and crta__Tab__c = null ';
    cmpList;
    componentConstructor;
    childProps;
    loadingCmp = false;


    @wire(getComponentsCtrl, { filter:'$filter' })
    wiredCmps({ error, data }) {
        if (data) {
            // La méthode Apex a retourné les pourcentages
            console.log(data);
            this.cmpList = data; 
            this.loadingCmp = true;
        } else if (error) {
            // Gestion des erreurs
            console.error('Erreur lors de l\'appel de la méthode Apex getComponentsCtrl : ', error);
        }
    }


      handleActive(event) {
        this.childProps = {};
        console.log('handled active');
        let tab = event.target; 
        const theId = tab.id.split('-')[0];
        console.log(theId);
        let elt = this.cmpList.find(i => i.identifier === theId);
        console.log('elt  ****');
        console.log(elt);
        this.childProps = elt.parameters;
        this.loadComponent(elt.name);
    
    }

    async loadComponent(lwcCmp) {
        const ctor = await import('c/'+lwcCmp);
        this.componentConstructor = ctor.default;
        this.loadingCmp = true;
    }
}