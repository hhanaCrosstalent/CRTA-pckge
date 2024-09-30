import { LightningElement, track, api } from 'lwc';
import getDynamicFileds from '@salesforce/apex/CreateRecordDynamicallyController.getDynamicFieldsFromCustomSettingCntrl';
import createRecord from '@salesforce/apex/CreateRecordDynamicallyController.createRecord';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CreateRecordDynamically extends LightningElement {

      fieldList;
    @api tableId; //= 'm0Q6M0000010wBp';

    @api btnLabel;
    
    /*tabbleApiName = 'crta__GS_Affectation_poste__c';
    refFieldName = 'crta__GS_Fiche_de_poste__r.Name';*/



    @track modalClass = 'slds-modal '; 


    



    connectedCallback() {
        this.getFiltersListFromCustomSetting();
    }


    openModal() {
        this.modalClass = 'slds-modal slds-fade-in-open modal-background';
      }
    
     closeModal() {
    this.modalClass = 'slds-modal modal-background';
    }
    

    handleLookupChange(event) {
        console.log(event);
        console.log(event.detail.selectedOption.label);
                console.log(event.detail.selectedOption.value);
        console.log(event.detail.fieldLabel);
        
        for (let i = 0; i < this.fieldList.length; i++) {
            if (this.fieldList[i].filterLabel == event.detail.fieldLabel) {
                this.fieldList[i].idValue = event.detail.selectedOption.value;
                console.log('IN SELECT');
                console.log(this.fieldList[i].idValue);
            }
                
            }


        console.log(this.fieldList);

    }


  

    recordCreation() {
        console.log(this.fieldList);
        
        createRecord({ 'fileds': this.fieldList }).then(result => {
            console.log('result creation');
            console.log(result);

        this.dispatchEvent(new CustomEvent('create', { detail: {created: true} })); //Dispatch create event
            this.closeModal();
                const event = new ShowToastEvent({
                    title: 'Information',
                    message: 'Enregistrement crée avec succès',
                    variant: 'success',
                    mode: 'dismissable'
                });
            this.dispatchEvent(event); 
            
                            
        })
            .catch(error => {
                console.log('Function createRecord ERROR :' + JSON.stringify(error));
    
            });
    }

    handleInputChange(event) {
         console.log(event);
        console.log(event.detail.value);
        console.log(event.target.name);
        for (let i = 0; i < this.fieldList.length; i++) {
            if (this.fieldList[i].filterLabel == event.target.name) {
                this.fieldList[i].idValue = event.detail.value;
                console.log('IN handleSelectionChange');
                console.log(this.fieldList[i].idValue);
            }
                
        }
        console.log(this.fieldList);
    }


    getFiltersListFromCustomSetting() {
        getDynamicFileds({ 'tableId': this.tableId }).then(result => {
            console.log('result f');
            console.log(result);
            this.fieldList = result;
                            
        })
            .catch(error => {
                console.log('Function getDynamicFileds ERROR :' + JSON.stringify(error));
    
            });
    }



}