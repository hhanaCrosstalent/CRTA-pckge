/**
 * Created by Saad on 12/01/2022.
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import customStyle from '@salesforce/resourceUrl/customStyle';
import { loadStyle } from 'lightning/platformResourceLoader';
import sendToParser from '@salesforce/apex/FileLoaderController.sendToParser';
import { NavigationMixin } from "lightning/navigation";

export default class FileLoader  extends NavigationMixin(LightningElement) {
    // Accepted formats
    FORMATS = ['.png','.pdf','.docx','.xlsx'];


    // Text values
    UPLOAD_FAIL_MESSAGE = 'Upload failed - Error : ';
    UPLOAD_SUCCESS_MESSAGE = 'Upload Succeeded : ';
    SUCCESS_VARIANT = 'Success';
    FAIL_VARIANT = 'Fail';
    SUCCESS_TITLE = 'Success';
    FAIL_TITLE = 'Fail';

    loading = false;


    renderedCallback() {
        Promise.all([
            loadStyle(this, customStyle )
        ])
    }

    handleUpload(event)
    {
        this.loading = true;
        // We restrict the number of files to 1
        const uploadedFile = event.detail.files[0];

        sendToParser({fileId :uploadedFile.documentId})
        .then(result => {
            this.loading = false;
            if (result != null && result.substring(0, 9)=='ProfileId'){
                this.showToast(
                    this.UPLOAD_SUCCESS_MESSAGE + uploadedFile.name,
                    this.SUCCESS_VARIANT,
                    this.SUCCESS_TITLE
                );
                
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.substring(9),
                        objectApiName: 'Contact',
                        actionName: 'view'
                    }
                });

            }
           else if(result != null)
            { 
                this.showToast(
                    this.UPLOAD_FAIL_MESSAGE + result,
                    this.FAIL_VARIANT,
                    this.FAIL_TITLE
                );
            }
            else
            {
                this.showToast(
                    this.UPLOAD_SUCCESS_MESSAGE + uploadedFile.name,
                    this.SUCCESS_VARIANT,
                    this.SUCCESS_TITLE
                );
            }
        })
        .catch(error => {
            this.loading = false;
            this.showToast(
                this.UPLOAD_FAIL_MESSAGE + error.body?.message,
                this.FAIL_VARIANT,
                this.FAIL_TITLE
            );
        });
    }

    showToast(message, variant, title)
    {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}