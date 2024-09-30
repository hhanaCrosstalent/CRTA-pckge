import { LightningElement , api , wire } from 'lwc';
import findOrderPercentage from '@salesforce/apex/PercentageController.findOrderPercentage';


export default class PercentBar extends LightningElement {
    @api percentage;
    @api recordId;
    @api objectApiName;
    @api fieldApiName;




    @wire(findOrderPercentage, { objectApiName: '$objectApiName', fieldApiName:'$fieldApiName', recordId: '$recordId' })
    wiredPercentage({ error, data }) {
        if (data) {
            // La méthode Apex a retourné les pourcentages
            this.percentage = data[0]; // Si vous prévoyez de retourner une seule valeur dans votre méthode Apex
        } else if (error) {
            // Gestion des erreurs
            console.error('Erreur lors de l\'appel de la méthode Apex findOrderPercentage : ', error);
        }
    }
}