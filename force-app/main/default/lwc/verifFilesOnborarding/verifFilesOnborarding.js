import { LightningElement,api,track , wire } from 'lwc';

import showFileCandidature  from '@salesforce/apex/VerifFilesOnborardingController.showFileCandidature';
import getAllFiles  from '@salesforce/apex/VerifFilesOnborardingController.getAllFiles';
import getPickListValueDynamically from '@salesforce/apex/VerifFilesOnborardingController.getselectOptions';
import updateDocument from '@salesforce/apex/VerifFilesOnborardingController.updateDocument';
import updateAndSendMail from '@salesforce/apex/VerifFilesOnborardingController.updateAndSendMail';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//étiquette perso
import application_verif_documents from '@salesforce/label/c.application_verif_documents';
import checking_document from '@salesforce/label/c.checking_document';
import FILE_NAME from '@salesforce/label/c.FILE_NAME'; 
import CREATED_DATE	 from '@salesforce/label/c.CREATED_DATE';
import DOCUMENT_ACCESS from '@salesforce/label/c.DOCUMENT_ACCESS';
import STATE from '@salesforce/label/c.STATE'; 
import COMMENT from '@salesforce/label/c.COMMENT'; 
import STATUT from '@salesforce/label/c.STATUT'; 
import Fin_de_la_verification_et_envoi_d_email from '@salesforce/label/c.Fin_de_la_verification_et_envoi_d_email';

export default class VerifFilesOnborarding extends  NavigationMixin(LightningElement) {
    //id in url
    @api recordId;

    //étiquette perso
    label = {
        application_verif_documents,checking_document,FILE_NAME,CREATED_DATE,DOCUMENT_ACCESS,STATE,COMMENT,STATUT,Fin_de_la_verification_et_envoi_d_email
    };
    @track isLoading = false;
    @track showButton = false; // montrer les bouton sauvegarde si on fait une modif
    @track showSendMail = false; // montrer la table des doc si doc remplie
    @track NotShowTable = false; // montrer un text si la table est vide 
    @track etatDocPickList;
    @track contactId;

 // récuperation et connexion au serveur 
 connectedCallback(){
    //console.log('value of param recordId 1111 =  ' + this.recordId);
        this.getAllFiles();
        this.getDocumentPickList('crta__Etat__c');
        }

    @track listDocuments = [];

    @api contactFiles;
    
    // récuperer les fichiers   
    getAllFiles(){
        //console.log('value of param recordId in getAllfiles =  ' + this.recordId);
        let IdContact =this.recordId;
        this.isLoading = true;

        getAllFiles({ contactIdParam : IdContact  }).then (result => { 
            console.log(' result result in result =  ' + this.result);
            console.log('result stringfy '+JSON.stringify(this.result));
                if (result==null){
                    this.isLoading = false;
                const event = new ShowToastEvent({
                    title: 'pas de contactId ',
                    message: 'pas de contactIdParam ',
                    variant: 'warning',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }else{
                this.isLoading = false;
                for(let i=0;i<result.length;i++){
                    result[i].url = '/sfc/servlet.shepherd/version/download/'+result[i].Id;
                    result[i].uncheck = false;
                    result[i].compliant = false;
                    result[i].uncompliant = false;
                    if(result[i].crta__Etat__c=='Not verified'){
                        result[i].uncheck = true;
                    }else if(result[i].crta__Etat__c=='Compliant') {
                        result[i].compliant = true;
                    }else if(result[i].crta__Etat__c=='Non-compliant'){
                        result[i].uncompliant = true;
                        this.showSendMail = true; // montrer la table des doc si doc remplie
                    }
                }
               this.listDocuments = result;
               //this.showButton = false;
               this.showTable = true;
               console.log('JSOn listDocuments '+JSON.stringify(this.listDocuments));
            }
        }).catch(error => {
            this.isLoading = false;
            console.log('erreur ', error);    
        });
    }
// show document 
    ShowCVCandidature(event){
        let idCandidature=event.target.dataset.id;
        console.log('showFileCandidature error  '+ idCandidature );
      showFileCandidature({PositionId : idCandidature}).then (result => { 
                  if (result==null){
              const event = new ShowToastEvent({
                  title: 'pas de document',
                  message: 'pas de document pour cette ligne',
                  variant: 'warning',
                  mode: 'dismissable'
              });
              this.dispatchEvent(event);
          }else{
              this[NavigationMixin.Navigate]({
                  type: 'standard__namedPage',
                  attributes: {
                      pageName: 'filePreview'
                  },
                  state : {
                  selectedRecordId: result
                  }
              })
          }
      }).catch(error => {
          console.log('showFileCandidature error  '+JSON.stringify(error));
  
      });
    }
  
//==> Récupération des pickList de joiner
getDocumentPickList(field){
    const ObjectPickList = {
        sobjectType : 'ContentVersion'
    }
    getPickListValueDynamically({objObject :ObjectPickList, field:field })
    .then(result =>{
        if(field == 'crta__Etat__c'){
            this.etatDocPickList = result;
        }
    }).catch(error=>{
        console.log('picklist :'+JSON.stringify(error));

    });
    }


   
 //NMA 18/07/2023 Récupérer les valeurs des champs Etat et Commentaire et sauvegarder les valeurs
 @api DataSaved=false;
     handle_Etat_Change(event) {
        const index = event.currentTarget.dataset.key;
        this.listDocuments[index].crta__Etat__c = event.target.value;
        this.showButton = true;
        if (event.target.value =='Non-compliant') {
            this.showSendMail = true;
            this.DataSaved=true; // montrer la table des doc si doc remplie
        }
     } 

    handle_comment_Change(event) {
        const index = event.currentTarget.dataset.key;
        this.listDocuments[index].crta__Commentaire__c = event.target.value;
        this.showButton = true;
     }
    
     SaveDocumentVerification(){
        this.isLoading = true;
        updateDocument({documents:this.listDocuments}).then(res => {
            console.log('resss '+res);
            if(res='SUCCESS'){
                this.getAllFiles();
                this.DataSaved=false;
            }
            this.dispatchEvent(new ShowToastEvent({
            title: 'Succès',
            message: 'Documents modifiés avec succès',
            variant: 'success',
          }));          
        }).catch(error => {
            //this.spinner = false;
            this.error = error;
           console.log('++++ '+JSON.stringify(error));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erreur',
                message: 'Merci de Contacter votre adminstrateur système',
                variant: 'error',
              }));
        });  
     }

     
     SendMail(){
        // envoyer le mail juste si des doc non-complaiant 
        this.isLoading = true;
        updateAndSendMail({contactId:this.recordId, documents:this.listDocuments }).then(res => {
            if(res =='Succes'){
                this.isLoading = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Succès',
                    message: 'Modification Succes',
                    variant: 'success',
                  }));   
            }            
            
        }).catch(error => {
            //this.spinner = false;
            this.isLoading = false;
            this.error = error;
            console.log('++++ '+JSON.stringify(error));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erreur',
                message: 'Merci de Contacter votre adminstrateur système',
                variant: 'error',
                }));
        });
    }

}