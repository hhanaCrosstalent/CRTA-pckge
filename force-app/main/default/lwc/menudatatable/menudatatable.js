import { LightningElement , api, wire} from 'lwc';
import updateDatableValues from '@salesforce/apex/MyCareerController.updateDatableValues';
import getValuesCount from '@salesforce/apex/MyCareerController.getValuesCount';


import nodata from '@salesforce/resourceUrl/nodataavailable';


;
import noAvailableDataMsg from '@salesforce/label/c.noAvailableDataMsg';



export default class Menudatatable extends LightningElement {


    nodata = nodata;
    wimg = 'w-60';
    nodataMsg = noAvailableDataMsg;

    @api tableId;


    @api tables;
    @api table;




    @api displayHeader;


    isFirstRender = true;
    renderedCallback() {
        if (!this.isFirstRender) {
            return;
        }
        if (this.table) {
            console.log('table exist');
            this.tables = [];
            this.tables.push(this.table);
        } 
        console.log('first render datatable');
        this.isFirstRender = false;
          const tabs = this.tables.map((t) => ({
           ...t,
           offset: t.offset
          }));
        this.tables = tabs;
    }


    handleFirst(e) {
  let tabs =  [...this.tables];
        this.tables = [];

        const i = Number(e.target.name);
        
        
        tabs[i].isFirst = true;
        tabs[i].isLast = false;
        tabs[i].offset = 0;

        this.tables = tabs;
        this.setValues(tabs, i, tabs[i].pageLim);

    }
    handlePrev(e) {
        let tabs =  [...this.tables];
        this.tables = [];

        const i = Number(e.target.name);
        tabs[i].offset = tabs[i].offset - tabs[i].pageLim;
        if (tabs[i].offset == 0) {
            tabs[i].isFirst = true;
        }
        tabs[i].isLast = false;

        this.tables = tabs;
        this.setValues(tabs, i, tabs[i].pageLim);
    }

    handleNext(e) {
       let tabs =  [...this.tables];
        this.tables = [];

        const i = Number(e.target.name); 
        
        console.log(tabs[i]);
        console.log(tabs[i].offset);

     
        tabs[i].offset = tabs[i].offset + tabs[i].pageLim;
        /*console.log(this.totalPages);
        console.log(this.offset);*/
        console.log('tal page ' + tabs[i].totalPages);
        console.log('offset ' + tabs[i].offset);
        console.log('pageLim ' + tabs[i].pageLim);
                console.log('count ' + tabs[i].count);

        let lim = tabs[i].pageLim;
        if (tabs[i].offset >= (tabs[i].pageLim*(tabs[i].totalPages-1))) {
            tabs[i].isLast = true;
            lim = tabs[i].count - tabs[i].offset;
        }
        tabs[i].isFirst = false;
        //this.tables[i].values = [];
        
        this.tables = tabs;
        this.setValues(tabs, i, lim);


    }

    handleLast(e) {
        let tabs =  [...this.tables];
        this.tables = [];

        const i = Number(e.target.name);
        /*console.log(i);
        tabs[0].isLast = true;

        this.tables = tabs;
        console.log(this.tables);*/



        /*for (let j = 0; j < tabs.length; j++) {
            if (j == i) {
                tabs[j].isLast = true;
            }
        }*/
        /*const i = e.target.name;*/
        tabs[i].isLast = true;
        console.log(tabs[i].isLast);
        tabs[i].offset = (tabs[i].pageLim*Math.max(tabs[i].totalPages-1,1));


        tabs[i].isFirst = false;


        this.tables = tabs;
        this.setValues(tabs, i, tabs[i].count - tabs[i].offset);

    }




    connectedCallback() {
    console.log('connected in datatable');
    //this.loadData();

    }


    setValues(tabs, index , thelim) {
        console.log('the limit ofr pagination ' + thelim);
      updateDatableValues({tableId: tabs[index].Id, offset:tabs[index].offset, lim: thelim})
            .then(result => {
                console.log('table values result  ');
                console.log(result);
                tabs[index].values = result;
                this.tables = tabs;

        })
            .catch(error => {
            console.log('Function updateDatableValues ERROR :'+JSON.stringify(error));
            });
        
     
    }

    /*loadCount() {
         getValuesCount({tableId: this.tableId})
            .then(result => {
                console.log('table count  ');
                console.log(count);
                this.count = result;

        })
            .catch(error => {
            console.log('Function getValuesCount ERROR :'+JSON.stringify(error));
            });
    }*/

    
    /*@wire(getValuesCount, { tableId: '$tableId'})
    wiredDataTableCount({ error, data }) {
        if (data) {
   
            this.count = data; 
            this.totalPages = Math.ceil(this.count / this.lim);
            console.log('getting count');
            console.log(this.count);
        } else if (error) {
            // Gestion des erreurs
            console.error('Erreur lors de l\'appel de la méthode Apex getValuesCount : ', error);
        }
    }*/
    
    openWindow(e) {
            console.log(e.target.name);  
            window.open(e.target.name, "_blank"); 
    }
}