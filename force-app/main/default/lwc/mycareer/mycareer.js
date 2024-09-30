import { LightningElement, api, track } from 'lwc';
//import loadTheTableContentCtrl  from '@salesforce/apex/MyCareerController.loadTheTableContentCtrl';
import loadContent from '@salesforce/apex/MyCareerController.loadContent'; 
import getAggregatedResults from '@salesforce/apex/MyCareerController.getAggregatedResults';
export default class Mycareer extends LightningElement {

    data ;
    columns;

    @track content;
    aggIds;
    
    isLoading = false;
    isLoading1 = false;
    componentConstructor;
    childProps;
    @api appId;
    emptyCMP = true;
    showAggSection = false;
    aggregatedGridClass;
    components;

    loadingCmp = false;

    URL = '/lightning/o/';
    @api background;


    @api appLabel;

    @api pageLim;


    @track value=100; //reactive in nature 
  //public method
    @api handleValueChange(e) {
        console.log('passed ' + e);
        this.content = {};
        this.isLoading = false;
        this.appId = e;
        this.aggregatedGridClass = '';
        console.log('handeled changes ');
        console.log(this.appId);
        this.loadData();
    this.value=200;
  }

    connectedCallback() {
    console.log('connected in lycarrer');
    this.loadData();

    }
    /*renderedCallback() {
        console.log('in the render');
        /*this.isLoading = false;
        if (this.isLoading == false) {
            this.loadData();
        }*/
         //   this.loadData();
    //  }
    


  

    handleActive(event) {
        this.childProps = {};
        this.loadingCmp = false;
        console.log('handled active');
        let tab = event.target; 
        const theId = tab.id.split('-')[0];
        console.log(theId);
        let elt = this.components.find(i => i.identifier === theId);
        console.log('elt  ****');
        console.log(elt);
        this.childProps = elt.parameters;
        this.loadComponent(elt.name, elt.prefix);
    
    }

    async loadComponent(cmpName, cmpPrefic) {
        const ctor = await import(cmpPrefic + '/'+cmpName);
        this.componentConstructor = ctor.default;
        this.loadingCmp = true;
    }

    loadData() {
        loadContent({appId: this.appId, limitPage: this.pageLim})
            .then(result => {
                console.log('table result 11 ');
                console.log(result);
                this.content = result;
                this.components = result.components;
                this.emptyCMP = (!this.components || this.components.length == 0);
                this.showAggSection = (result.aggregates && result.aggregates.length > 0);
                if (this.content.aggregates) {
                    this.aggregatedGridClass = 'slds-col slds-size_1-of-' + this.content.aggregates.length;
                }
                this.isLoading = true;

        /*this.columns = result.columns;
        console.log(this.columns);
        this.data = result.values;
        console.log(this.data);*/

        })
            .catch(error => {
            console.log('Function loadTheTableContentCtrl ERROR :'+JSON.stringify(error));
            /*this.showToast(
                this.UPLOAD_FAIL_MESSAGE + error.body?.message,
                this.FAIL_VARIANT,
                this.FAIL_TITLE
            );*/
            });
        
     
    }


    onChangeGlobalFilter(event) {
        console.log(event.target.title);
        let elt = this.content.globalFilters.find(e => e.value == event.target.title);
        this.setAggregatedResults(elt.value);
        console.log('elt');
        console.log(elt.value);
        for (let i = 0; i < this.content.globalFilters.length; i++) {
            console.log(this.content.globalFilters[i].value);
            console.log((this.content.globalFilters[i].value == elt.value));
                this.content.globalFilters[i].selected = (this.content.globalFilters[i].value == elt.value);
        }
        
    }

    setAggregatedResults(globalFilter) {

        getAggregatedResults({ appId: this.appId, globalFilter: globalFilter })
            .then(result => {
                this.content.aggregates = result;
            })
            .catch(error => {
                console.log('Function getAggregatedResults ERROR :' + JSON.stringify(error));
           
            });
    }

    handleOpenWindow(e) {
        console.log(e.target.name);  
        let url = this.URL + e.target.name; 
        window.open(url, "_blank");
    }

    handleOpenGLink(e) {
                console.log(e.target.name);  
               window.open(e.target.name, "_blank"); 
    }
   /*loadCounts() {
        getAggregatedCountIdsByApp({ appId: this.appId })
            .then(result => {
                console.log('aggs Ids result  ');
                console.log(result);
                this.aggIds = result;
            })
            .catch(error => {
                console.log('Function getAggregatedCountIdsByApp ERROR :' + JSON.stringify(error));
           
            });
    }*/


    /*constructor() {
            super(); // this is required
        console.log('in const11');
        const result = loadTheTableContentCtrl({});
        console.log('the result');

        console.log(result);
        this.columns = result.columns;
        this.data = result.values;
    }*/

    /*@wire(loadTheTableContentCtrl, {})
    wiredContacts({ error, data }) {
        if (data) {
               console.log('the result');

        console.log(data);
            this.columns = data.columns;
            this.data = data.values;
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
        
    }*/

}