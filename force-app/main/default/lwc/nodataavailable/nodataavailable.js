import { LightningElement , api } from 'lwc';
import noAvailableDataMsg from '@salesforce/label/c.noAvailableDataMsg';

export default class Nodataavailable extends LightningElement {
    nodataMsg = noAvailableDataMsg;
    srcImg;
    cssImg = 'slds-illustration__svg ';
    cssImgF;
    @api wimg = '';
    imgs = ['/img/chatter/OpenRoad.svg','/img/chatter/Desert.svg','/projRes/ui-home-private/emptyStates/noEvents.svg','/projRes/ui-home-private/emptyStates/noAssistant.svg'];


 getRandomInt(max) {
  return Math.floor(Math.random() * max);
}
    renderedCallback() {
                console.log('this.wimg');
        console.log(this.wimg);
                console.log(this.cssImg + this.wimg);

       this.cssImgF = this.cssImg + this.wimg;
       this.srcImg = this.imgs[this.getRandomInt(3)];
    }
}