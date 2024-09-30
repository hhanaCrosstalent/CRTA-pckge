import { LightningElement,api, track } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/*-------START File JS--------*/
import jquery from '@salesforce/resourceUrl/JQuery_min_3_5_1';
import orgChartJSF from '@salesforce/resourceUrl/lwcOrgCharg';
// import LwcOrgCharthtml2canvas from '@salesforce/resourceUrl/LwcOrgCharthtml2canvas';
import lwcOrgChartJspdf from '@salesforce/resourceUrl/lwcOrgChartJspdf';
import JOrgChart from '@salesforce/resourceUrl/JOrgChart';
import lwcOrgChartespromise from '@salesforce/resourceUrl/lwcOrgChartespromise';
/*-------END File JS--------*/

/*-------START File CSS--------*/
// import fontawesomeCSS from '@salesforce/resourceUrl/font_awesome';
/*-------END File CSS--------*/

/*-------START Fuction Apex--------*/
import getContactAndChildren from '@salesforce/apex/orgChartLWCController.getParentContacts';
import getSetting from '@salesforce/apex/orgChartLWCController.getSetting';
/*-------END Fuction Apex--------*/

/*-------START Custom Label--------*/
import Orgchart_Orientation from '@salesforce/label/c.Orgchart_Orientation';
import Orgchart_Orientation_Vertical from '@salesforce/label/c.Orgchart_Orientation_Vertical';
import Orgchart_Orientation_Horizontal from '@salesforce/label/c.Orgchart_Orientation_Horizontal';
import Orgchart_Depth from '@salesforce/label/c.Orgchart_Depth';
import Display_Orgchart from '@salesforce/label/c.Display_Orgchart';
import Orgchart_Export_Name from '@salesforce/label/c.Orgchart_Export_Name';
import Export_OrgChart from '@salesforce/label/c.Export_OrgChart';
import Search from '@salesforce/label/c.Search';
import Orgchart_Placeholder from '@salesforce/label/c.Orgchart_Placeholder';
import to_Search from '@salesforce/label/c.to_Search';
import to_Reset from '@salesforce/label/c.to_Reset';
import orgchart_error_search_empty from '@salesforce/label/c.Orgchart_Error_Search_Empty';
import orgchart_error_search_not_found from '@salesforce/label/c.Orgchart_Error_Search_not_Found';
import all_company from '@salesforce/label/c.All_Company';
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import OrgChart_Title from '@salesforce/label/c.OrgChart_Title';
import OrgChart_Title_Section_Filtre from '@salesforce/label/c.OrgChart_Title_Section_Filtre';
/*-------END Custom Label--------*/

export default class OrgChartLWC extends LightningElement {
    // @api 
    isDisplay = false;
    constructor(){
        super();
       
    }
    label = {
        Orgchart_Orientation,
        Orgchart_Orientation_Vertical,
        Orgchart_Orientation_Horizontal,
        Orgchart_Depth,
        Display_Orgchart,
        Export_OrgChart,
        Error,
        orgchart_error_search_empty,
        Search,
        Orgchart_Placeholder,
        to_Search,
        OrgChart_Title,
        OrgChart_Title_Section_Filtre,
        Success,
        to_Reset,
        all_company,
        Orgchart_Export_Name
    };
    renderedCallback() {
        console.log(JOrgChart+'/JOrgChart2.1.3/jspdf.min.js');
        Promise.all([
            loadScript(this, jquery),
            // loadScript(this, JOrgChart+'/JOrgChart2.1.3/jspdf.min.js'),
            loadScript(this, lwcOrgChartespromise),
            loadScript(this, JOrgChart+'/JOrgChart2.1.3/html2canvas.min.js'),
            loadScript(this, orgChartJSF+'/OrgChart-master/src/js/jquery.orgchart.js'),
            // loadScript(this, lwcOrgChartJspdf),
            loadScript(this, '/soap/ajax/40.0/connection.js'),
            loadScript(this, '/soap/ajax/40.0/apex.js'),
            loadStyle(this, orgChartJSF+'/OrgChart-master/src/css/jquery.orgchart.css'),
                // loadStyle(this, fontawesomeCSS),
            ])
          .then(response=> {

              this.intialize();
              console.log('loufa1 :');
          })
          .catch((error) => {
              console.log('loufa2 :'+error);
              this.error = error; 
          });        
    }
            
    intialize() {
        console.log('loufa3 :');
        $(this.template.querySelector('[data-id="tree"]')).empty();
        getSetting()
        .then(result => {
            console.log('Setting :'+JSON.stringify(result));
            this.isDisplay = result.crta__Show_Display_Settings__c;
            this.getContactsAndChildrensJS(result.crta__Company_Name__c,result.crta__Redirect_to_Chatter_Profile__c,
                        result.crta__Activate_Redirection__c,result.crta__Color_Banner__c,result.crta__Text_Color_Banner__c);

        })
        .catch(error => {
          console.log(error);
        this.error = error;
        });
    }
    
    getContactsAndChildrensJS(companyName,redirectToChatter,hasRedirection,colorBanner,textColorBanner){
      getContactAndChildren()
        .then(result => {
            if(result && result.length) {
                let depth = (parseInt($(this.template.querySelector('[data-id="depth"]')).val(), 10)).toString();
                if ($(this.template.querySelector('[data-id="depth"]')).val() == undefined) {
                    depth = 2;
                }
                //depth = (!this.isDisplay) ? '10': depth;
                let direction = $(this.template.querySelector('[data-id="orgChartWay"]')).val()
                var items = [];
                // console.log('result :'+JSON.stringify(result));   
                result.forEach(function (e, i) {
                  // 'id': e.contactId,
                  
                    items.push({
                        'id': e.contactId,
                        'userId': e.user.Id,
                        'name': e.contact.Name,
                        'field1': e.field1,
                        'field2': e.field2,
                        'field3': e.field3,
                        'field4': e.field4,
                        'img': (e.photoContact != undefined ? e.photoContact : (e.user != undefined ? e.user.SmallPhotoUrl : '')),
                        'children': this.childrens(e)
                    });
                
                }.bind(this));
              
            var datascource = {
                'name': companyName,
                'title': all_company,
                'children': items
            };
            
            $(this.template.querySelector('[data-id="tree"]')).orgchart({
                'data' : datascource,
                'visibleLevel': depth,
                'nodeContent': 'title',
                'pan': true,
                'zoom': false,
                'exportFileextension': 'pdf',
                'exportButton': false,
                'exportFilename': 'MyOrgChart',
                'direction': direction,
                'createNode': function($node, data) {
                    //=> Ajout de Photo 
                    var secondMenuIcon = $('<i>', {
                        'class': 'fa fa-info-circle second-menu-icon',
                        click: function() {
                        $(this).siblings('.second-menu').toggle();
                        }
                         });
                    var secondMenu = '<div class="second-menu"><img class="avatar" src="' + data.img + '"></div>';
                    $node.append(secondMenuIcon).append(secondMenu);
                    //Ajout du lien vers le profil chatter
                    if (hasRedirection) {
                        if (redirectToChatter) {
                            console.log('data.userId :'+data.userId)
                            if (data.userId != undefined) {
                                $node.children('.title').wrapInner('<a href="/lightning/r/User/' + data.userId + '/view" target="_blank"></a>');
                            }
                        } else {
                            $node.children('.title').wrapInner('<a href="/lightning/cmp/crta__Profile?c__token=' + data.id + '" target="_blank"></a>');
                        }
                    }
                    let html = '';
                    if (data.field1 != undefined) {
                        html += '<div style="word-break: break-word;">' + data.field1 + '</div>';
                    }
                    if (data.field2 != undefined) {
                        html += '<div style="word-break: break-word;">' + data.field2 + '</div>';
                    }
                    if (data.field3 != undefined) {
                        html += '<div style="word-break: break-word;">' + data.field3 + '</div>';
                    }
                    if (data.field4 != undefined) {
                        html += '<div style="word-break: break-word;">' + data.field4 + '</div>';
                    }
                    $node.find(".content").append(html);
                },
                'initCompleted': function (chart) {
                    chart.find('.title,.title a ').css({
                        backgroundColor:colorBanner,
                        color: textColorBanner
                    });
                    chart.find('orgchart .hierarchy').css('border-top', '2px solid'+ { colorBanner});
                    // chart.find('.title a ').css({
                    //     backgroundColor:colorBanner,
                    //     color: textColorBanner
                    // });
                    // $('#spinner').hide();
                }
            });
               
              } else {
            //    console.log(result);
            }
        })
        .catch(error => {
          console.log(error);
        this.error = error;
        });
    
    }
    childrens(child) {
      let items = [];
    //   console.log('child------- '+child);
      
      if (child && child.employee && child.employee.length > 0) {
          child.employee.forEach(function (f) {
              items.push({
                    'id': f.contactId,
                    'userId': f.user.Id,
                    'name': f.contact.Name,
                    'field1': f.field1,
                    'field2': f.field2,
                    'field3': f.field3,
                    'field4': f.field4,
                    'img': (f.photoContact != undefined ? f.photoContact : (f.user != undefined ? f.user.SmallPhotoUrl : '')),
                    'children': this.childrens(f)
              });
          }.bind(this));
      }
      return items;
    }
    //Ajout des champs sur un noeud
    addFields(data) {
        let html = '';

        if (data.field1 != undefined) {
            html += '<div style="word-break: break-word;">' + data.field1 + '</div>';
        }
        if (data.field2 != undefined) {
            html += '<div style="word-break: break-word;">' + data.field2 + '</div>';
        }
        if (data.field3 != undefined) {
            html += '<div style="word-break: break-word;">' + data.field3 + '</div>';
        }
        if (data.field4 != undefined) {
            html += '<div style="word-break: break-word;">' + data.field4 + '</div>';
        }

        return html;
    }
    displayOrgChart() {
        $(this.template.querySelector('[data-id="tree"]')).empty();
        getSetting()
        .then(result => {
            console.log('Setting :'+JSON.stringify(result));
            this.getContactsAndChildrensJS(result.crta__Company_Name__c,result.crta__Redirect_to_Chatter_Profile__c,
                        result.crta__Activate_Redirection__c,result.crta__Color_Banner__c,result.crta__Text_Color_Banner__c);

        })
        .catch(error => {
            console.log(error);
            this.error = error;
        });
    }
    exportTree(){
        $(this.template.querySelector('.oc-export-btn')).click();
    }
    Search (){
        this.filterNodes( $(this.template.querySelector('[data-id="search"]')).val())
    }
    SearchClear(){
        $(this.template.querySelector('[data-id="search"]')).val('');
        this.displayOrgChart();
    }
    filterNodes(keyWord) {
        if(!keyWord.length) {
            this.showToast(orgchart_error_search_empty,Error,'error');
            // return;
        } else {
            keyWord = keyWord.toLowerCase();
            var $chart = $(this.template.querySelector('.orgchart'));
            // disalbe the expand/collapse feture
            $chart.addClass('noncollapsable');
            // distinguish the matched nodes and the unmatched nodes according to the given key word
            $chart.find('.node').filter(function(index, node) {
                return $(node).text().toLowerCase().indexOf(keyWord) > -1;
                }).addClass('matched')
                .closest('.hierarchy').parents('.hierarchy').children('.node').addClass('retained');
            // hide the unmatched nodes
            $chart.find('.matched,.retained').each(function(index, node) {
                $(node).removeClass('slide-up')
                .closest('.nodes').removeClass('hidden')
                .siblings('.hierarchy').removeClass('isChildrenCollapsed');
                var $unmatched = $(node).closest('.hierarchy').siblings().find('.node:first:not(.matched,.retained)')
                .closest('.hierarchy').addClass('hidden');
            });
            // hide the redundant descendant nodes of the matched nodes
            $chart.find('.matched').each(function(index, node) {
                if (!$(node).siblings('.nodes').find('.matched').length) {
                $(node).siblings('.nodes').addClass('hidden')
                    .parent().addClass('isChildrenCollapsed');
                }
            });
            if($(this.template.querySelector(".matched")).length == 0) {
                this.showToast(orgchart_error_search_not_found,Success,'success');
            }
        }
    }
    showToast(message,title,variant) {
        const event = new ShowToastEvent({
            title: title,
            message:message,
            variant:variant,
        });
        this.dispatchEvent(event);
    }

}