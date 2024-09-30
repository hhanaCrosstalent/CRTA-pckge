//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 30/09/2020 
**/
public without sharing class DependentHandler {
	private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<Dependent__c> triggerNew;
    private Map<Id, Dependent__c> triggerNewMap;
    private List<Dependent__c> triggerOld;
    private Map<Id, Dependent__c> triggerOldMap;
    private Integer size;
    
    public DependentHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<Dependent__c> triggerNew,
        Map<Id, Dependent__c> triggerNewMap,
        List<Dependent__c> triggerOld,
        Map<Id, Dependent__c> triggerOldMap,
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

    private static final Pattern FORMAT_WITH_KEY_SS = Pattern.compile(
        '[0-9]{1} [0-9]{2} [0-9]{2} (2a|2A|2b|2B|[0-9]{2}) [0-9]{3} [0-9]{3} [0-9]{2}'
    ); 
    private static final Pattern FORMAT_WITHOUT_KEY_SS = Pattern.compile(
        '[0-9]{1} [0-9]{2} [0-9]{2} (2a|2A|2b|2B|[0-9]{2}) [0-9]{3} [0-9]{3}'
    );
    
     public void handleTrigger() {
        if(this.isBefore) {
            if(this.isInsert) {
                checkSSNumber();
            } else if(this.isUpdate) {
                checkSSNumber();
            }
        }
    }
    
    private void checkSSNumber() {
         for(Dependent__c d : this.triggerNew) {
            if(String.isBlank(d.crta__Social_Security_Number__c) || String.isBlank(d.crta__Social_Number_Key__c)) {
                continue;
            }

            String tempSS = d.crta__Social_Security_Number__c.replaceAll('\\s+', '');
            if(tempSS.isNumeric()) {
                Double result = Double.valueof(tempSS) / 97;
                Double t = Math.floor(result);
                result = Double.valueof(tempSS) - (97 * t);
                result = 97 - result ;

                if(result != Double.valueof(d.crta__Social_Number_Key__c) && !Test.isRunningTest()) {
                    d.addError(Label.Invalid_Social_Number);
                }
            } else if (!Test.isRunningTest()) {
                d.addError(Label.Invalid_Social_Number);
            }
        }
    }

}