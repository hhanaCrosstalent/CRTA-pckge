import { LightningElement, api } from 'lwc';
import getContactPhoto from '@salesforce/apex/ContactPhotoController.getContactPhoto';


export default class Contactphoto extends LightningElement {

    @api contactId;

    content;


    connectedCallback() {
    this.loadData();
    }


    loadData() {
        getContactPhoto({ 'contactId': this.contactId }).then(result => {
            if (result) {
                console.log('result');
                console.log(result);
                this.content = result;
            }
        })
        .catch(error => {
                console.log('Function getContactPhoto ERROR :' + JSON.stringify(error));
    
            });
    }

}