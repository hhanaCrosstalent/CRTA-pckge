/*
 * @Author: Nouha Maddeh	
 * @CreatedDate: 27/02/2024
 * 
 * */
public class LaborContractHandler {

    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<crta__Labor_Contract__c> triggerNew;
    private Map<Id, crta__Labor_Contract__c> triggerNewMap;
    private List<crta__Labor_Contract__c> triggerOld;
    private Map<Id, crta__Labor_Contract__c> triggerOldMap;
    private Integer size;
   
    
   public LaborContractHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<crta__Labor_Contract__c> triggerNew,
        Map<Id, crta__Labor_Contract__c> triggerNewMap,
        List<crta__Labor_Contract__c> triggerOld,
        Map<Id, crta__Labor_Contract__c> triggerOldMap,
        Integer size
    ) {
        this.isExecuting = isExecuting;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.triggerNew = triggerNew;
        this.triggerNewMap = triggerNewMap;
        this.triggerOld = triggerOld;
        this.triggerOldMap = triggerOldMap;
        this.size = size;
    }
    
    
     public void handleTrigger() {
          if(this.isBefore) {
                if(this.isUpdate) {
                   setPicklistFieldsUpdate();
               }
          }
         
     }
    
    
    
     private void setPicklistFieldsUpdate(){
          for(crta__Labor_Contract__c c : this.triggerNew) {
             if(this.triggerOldMap.get(c.Id).crta__End_Date__c ==null && c.crta__End_Date__c!=null){
                c.crta__ADP_endDateChange__c='1';
            }else if(this.triggerOldMap.get(c.Id).crta__End_Date__c!=null && c.crta__End_Date__c==null){
                c.crta__ADP_endDateChange__c='3';
            }
             else if(this.triggerOldMap.get(c.Id).crta__End_Date__c!=null && c.crta__End_Date__c!=null && this.triggerOldMap.get(c.Id).crta__End_Date__c!=c.crta__End_Date__c){
                 c.crta__ADP_endDateChange__c='2';
            }
            
             
         }
         
         
     }
    
    
     
    
    
   
}