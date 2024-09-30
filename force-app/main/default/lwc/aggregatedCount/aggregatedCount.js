import { LightningElement, api } from 'lwc';
import getAggregatedResults from '@salesforce/apex/AggregatedCountController.getAggregatedResults';

export default class AggregatedCount extends LightningElement {


    @api aggId;
    aggCount;
    isLoading = true;


    connectedCallback() {
     this.isLoading = true;
     this.loadData();
    }


    renderedCallback() {
        console.log('in the render of aggregated count');
    }


    loadData() {
        getAggregatedResults({aggCountId: this.aggId})
            .then(result => {
                console.log('agg result  11');
                console.log(result);
                this.isLoading = false;
                this.aggCount = result;
        })
            .catch(error => {
            console.log('Function getAggregatedResults ERROR :'+JSON.stringify(error));
        });
    }

}