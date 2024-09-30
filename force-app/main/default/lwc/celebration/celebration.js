import { LightningElement, wire, api, track } from 'lwc';
import getContactsByBirthday from '@salesforce/apex/CelebrationController.getContactsByBirthday';

import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

import customCSS from '@salesforce/resourceUrl/customCSS';
import celebrate from '@salesforce/resourceUrl/Celebration_ICON';

import Bonne_f from '@salesforce/label/c.Bonne_f';
import celebrationLabel from '@salesforce/label/c.celebration_Label';
import noContactsMsg from '@salesforce/label/c.no_contact_found';
import nodata from '@salesforce/resourceUrl/nodataavailable';
import definePermiter from '@salesforce/label/c.define_permimeter_celebration';
import permiters from '@salesforce/label/c.permiters';
import team from '@salesforce/label/c.Team';
import all from '@salesforce/label/c.All';





export default class Celebration extends LightningElement {

    noContactsMsg = noContactsMsg;
    nodata = nodata;


    celebration = celebrate;
    vfPageUrl = '/apex/FavIconPage';

    team = team;
    all = all;
    permiters = permiters;
    definePermiter = definePermiter;

    contacts;

    contactsAll;

    dynamicFilters = [];

    bestWishes = ' - ' + Bonne_f;
    celebrationLabel = celebrationLabel;
    




  @track modalHeader = '';
  @track isContact = false;
    @track modalClass = 'slds-modal ';
    @track modalClassFilters = 'slds-modal ';

@track modalClassFilters2 = 'slds-modal ';    
    @track modalBackdropClass = 'slds-backdrop '; 

    @api limit = 3;
    @api intervalDays = 300; //0

    @track teamView = false;

    @api heightStyle = 'min-height: 264px !important ; max-height: 223px !important;';

    

    @track photoUrls = [
        'https://crta-dev-ed.file.force.com/profilephoto/005/M',
        'https://crta-dev-ed.file.force.com/profilephoto/005/M',
        // Add more photo URLs as needed
    ];

    displayBody = true;
    noContacts;



     userView = ['tous'];

    get options() {
        return [
            { label: this.team, value: 'employee' }
            //{ label: this.all, value: 'tous' },
        ];
    }

    get selectedValues() {
        return this.userView.join(',');
    }



  

    handleChange(e) {
        this.userView = e.detail.value;
        this.getContactsAll();

    }

    getClassName() {
          return 'slds-border_bottom';
    }

    handleclick() {
        console.log('helloo');
        this.displayBody = !this.displayBody;
    }

    handleTeamViewChange(event) {
        // Update the isChecked property when the checkbox state changes
        this.teamView = event.target.checked;
        console.log('teamView');
        console.log(this.teamView);
    }
    connectedCallback() {

        this.getContactsAll();
        //this.getDynamicFilters();
        loadStyle(this, customCSS);
          this.modalHeader = 'Anniversaires';
      this.btnLabel = 'Voir plus ...';
    }


  



     handleLinkClick(event) {
        // Handle the click event logic here
        alert('Link clicked!');
     }
    
    popupClass = 'popup-hidden';

    openPopup() {
        this.popupClass = 'popup-visible';
    }

    closePopup() {
        this.popupClass = 'popup-hidden';
    }


    openModal() {
        console.log('len ');
        console.log(this.contactsAll.length);
        this.modalClass = 'slds-modal slds-fade-in-open modal-background';
        this.modalBackdropClass = 'slds-backdrop slds-backdrop_open';
    }

    closeModal() {
    this.modalClass = 'slds-modal modal-background ';
    this.modalBackdropClass = 'slds-backdrop ';
    }
    
      openModalFilters() {
        this.modalClassFilters = 'slds-modal slds-fade-in-open modal-background';
        this.modalBackdropClass = 'slds-backdrop slds-backdrop_open';
      }
    
     closeModalFilters() {
    this.modalClassFilters = 'slds-modal modal-background';
    this.modalBackdropClass = 'slds-backdrop ';
    }

    @wire(getContactsByBirthday, {lim: '$limit', intervalDays: '$intervalDays', userView: '$userView'})
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.noContacts = (!(this.contacts && this.contacts.length > 0)) ? true : undefined;
            if (this.noContacts == true) {
                this.heightStyle = 'min-height: 269px !important';
            }
            
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
        
    }


    displayHrLine(index) {
        return index < (this.contacts.length-1);
    }

      //@wire(getContactsByBirthday, {})
    getContactsAll() {
        /*if (data) {
            this.contactsAll = data;
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }*/


        getContactsByBirthday({lim: 0, intervalDays: this.intervalDays, userView: this.userView})
            .then(result => {
                this.contactsAll = result;
                
            }).catch(error=>{
                console.log('Function getContactsByBirthday ERROR :'+JSON.stringify(error));
    
            });
        
    }

}