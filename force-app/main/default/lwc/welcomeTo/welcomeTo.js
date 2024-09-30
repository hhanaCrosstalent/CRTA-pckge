import { LightningElement, wire, api, track } from 'lwc';
import getIncommingContacts from '@salesforce/apex/WelcomeToController.getIncommingContacts';
import getNewContacts11 from '@salesforce/apex/WelcomeToController.getNewContacts11';
import getAccountNameFromConnectedContact from '@salesforce/apex/WelcomeToController.getAccountNameFromConnectedContact';



import hi from '@salesforce/resourceUrl/hi_welcomeTo';

import Welcome_to from '@salesforce/label/c.Welcome_to';
import new_members from '@salesforce/label/c.new_members';
import Started from '@salesforce/label/c.Started';
import welcome_To_Label from '@salesforce/label/c.welcome_To_Label';
import Started_w_to from '@salesforce/label/c.Started_w_to'; 
import noContactsMsg from '@salesforce/label/c.no_contact_found';
import nodata from '@salesforce/resourceUrl/nodataavailable';



export default class WelcomeTo extends LightningElement {


    hi = hi;
    started = Started_w_to;


    welcome = Welcome_to;
    newM = new_members;
    started = Started;
    welcomeToLabel = welcome_To_Label;

    contacts = [];

    newContacts = [];
    seeMoreLabel = '+';
    startedDate;
    displayBody = true;
    accName = ' ';

    @api limit;
    @api intervalDays;
    @api functionApiName = 'title';
    @api accApiName = 'AccountId';

    @track modalClass = 'slds-modal ';
    @track  showModal = false;
    @track modalBackdropClass = 'slds-backdrop '; 

    isContactsNotEmpty;
    noContactsMsg = noContactsMsg;
    nodata = nodata;

    connectedCallback() {
        this.getAccounName();
        this.getNewContacts();
    }
    getAccounName() {
         getAccountNameFromConnectedContact({accApiName: this.accApiName })
             .then(result => {//{lim: '$limit', intervalDays: '$intervalDays'}
                 this.accName += result;
                
            }).catch(error=>{
                console.log('Function getAccountNameFromConnectedContact ERROR :'+JSON.stringify(error));
    
            });
    }

      openModal() {
          this.showModal = true;
        this.modalClass = 'slds-modal slds-fade-in-open modal-background';
        this.modalBackdropClass = 'slds-backdrop slds-backdrop_open';
    }

      handleclick() {
        console.log('helloo');
        this.displayBody = !this.displayBody;
    } 

    closeModal() {
                  this.showModal = false;

    this.modalClass = 'slds-modal modal-background';
    this.modalBackdropClass = 'slds-backdrop ';
    }


    getNewContacts() {
        getNewContacts11({ lim: Number(this.limit), intervalDays: Number(this.intervalDays), accApiName: this.accApiName })
             .then(result => {//{lim: '$limit', intervalDays: '$intervalDays'}
                 this.newContacts = result;
                 
                 this.newContacts.forEach(e => {
                     console.log(e);
                 });
                 this.getIN();
                
                
            }).catch(error=>{
                console.log('Function getNewContacts ERROR :'+JSON.stringify(error));
    
            });
    }

     getIN() {
        getIncommingContacts({ lim: Number(this.limit), intervalDays: Number(this.intervalDays), functionApiName: this.functionApiName, accApiName: this.accApiName })
             .then(result => {//{lim: '$limit', intervalDays: '$intervalDays'}
 if (result) {
            console.log('hello ');
            if (result[0]) {
                console.log(result[0].contacts);
                this.statedDate = result[0].entryDate;
                this.contacts = result[0].contacts;
                this.isContactsNotEmpty = this.contacts && this.contacts.length > 0;
            }
        }                
                
            }).catch(error=>{
                console.log('Function getNewContacts ERROR :'+JSON.stringify(error));
    
            });
    }

    @wire(getIncommingContacts, {lim: '$limit', intervalDays: '$intervalDays', functionApiName: '$functionApiName', accApiName: '$accApiName'})
    wiredContacts({ error, data }) {
        if (data) {
            console.log('hello ');
            if (data[0]) {
                console.log(data[0].contacts);
                this.statedDate = data[0].entryDate;
                this.contacts = data[0].contacts;
                this.isContactsNotEmpty = this.contacts && this.contacts.length > 0;
            }
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
        
    }


}