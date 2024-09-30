import { LightningElement , api } from 'lwc';
// import the dataHandler method
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
//import ChartJS from '@salesforce/resourceUrl/ChartJS';
import chart from '@salesforce/resourceUrl/chartJS';
import loadData from '@salesforce/apex/DynamicChartsController.loadData'; 




export default class Charttest extends LightningElement {


    @api selectionField; //= 'crta__Salaire_mensuel_Futur__c'; 
    @api objectApiName; //= 'crta__Revision_salariale__c'; 
    @api typeOfQry;// = 'SUM'; 
    @api groupbyField; //= 'crta__Date_de_la_revision__c'; 
    @api contactFilter; //= 'crta__Salarie__c'; 
    @api filterCriteria; //= '';
    @api chartTitle;
    @api chartType; 
    @api complementaryFilter; //= 'crta__IE_Competence_evaluee_par_le_salarie__c != \'Acquise\'';
    @api chartLabels;

    @api backColors;//= 'rgba(255, 99, 132, 0.2);rgba(54, 162, 235, 0.2);rgba(255, 206, 86, 0.2);rgba(75, 192, 192, 0.2);rgba(153, 102, 255, 0.2);rgba(255, 159, 64, 0.2)';
    @api borderColors;// = 'rgba(255, 99, 132, 1);rgba(54, 162, 235, 1);rgba(255, 206, 86, 1);rgba(75, 192, 192, 1);rgba(153, 102, 255, 1);rgba(255, 159, 64, 1)';

    @api chartHeight = 450;
    chartInitialized = false;

    percentValue;
    showPercentBar;

    renderedCallback() {
        this.showPercentBar = this.chartType == 'Percent';
        console.log('in the render chart');
        if (this.chartInitialized) {
            return;
        }
        this.chartInitialized = true;

        Promise.all([
            loadScript(this, chart)
        ])
        .then(() => {
        this.loadContentChart();
        })
        .catch(error => {
            console.error({
                message: 'Error loading Chart.js',
                error
            });
        });
    }


    loadContentChart() {
        loadData({
            selectionField: this.selectionField,
            datatableName: this.objectApiName,
            typeOfQry: this.typeOfQry,
            groupbyField: this.groupbyField,
            filterCriteria: this.filterCriteria,
            contactFilter: this.contactFilter,
            complementaryFilter: this.complementaryFilter,
            chartLabels: this.chartLabels,
            chartType: this.chartType
            })
            .then(result => {
                console.log('chart data result 11 ');
                console.log(result);
                if (this.chartType != 'Percent') {
                    this.renderChart(result.labels, result.data, result.chartLabel);
                } else {
                    const percentValue = result.data[1];
                    if (percentValue) {
                        this.percentValue = Number.parseFloat(percentValue).toFixed(2);
                    }
                }
        })
            .catch(error => {
            console.log('Function loadData ERROR :'+JSON.stringify(error));
            });/*   selectionField: '$selectionField',
            datatableName: '$objectApiName',
            typeOfQry: '$typeOfQry',
            groupbyField: '$groupbyField',
            filterCriteria: '$filterCriteria',
            contactFilter: '$contactFilter' */

   }


    renderChart(labels, data, chartLabel) {
        console.log('chartTitle');
        console.log(this.chartTitle);
        console.log(chartLabel);
        console.log(data);
                console.log(labels);
        const ctx = this.template.querySelector(`[data-id="${this.chartTitle}"]`).getContext('2d');
        this.chart = new window.Chart(ctx, {
            type: this.chartType,
            data: {
                labels: labels,//['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                datasets: [{
                    label: chartLabel,
                    data: data,
                    backgroundColor: this.backColors.toString().split(";"),/*[
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],*/
                    borderColor: this.borderColors.toString().split(";"),/*[
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],*/
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
    }
}