//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/07/2020 
**/
public without sharing class BankAccountHandler {
    private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<crta__Bank_Account__c> triggerNew;
    private Map<Id, crta__Bank_Account__c> triggerNewMap;
    private List<crta__Bank_Account__c> triggerOld;
    private Map<Id, crta__Bank_Account__c> triggerOldMap;
    private Integer size;

    public BankAccountHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<crta__Bank_Account__c> triggerNew,
        Map<Id, crta__Bank_Account__c> triggerNewMap,
        List<crta__Bank_Account__c> triggerOld,
        Map<Id, crta__Bank_Account__c> triggerOldMap,
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

    private static final Map<String,String> TO_NUMBER_FOR_IBAN = new Map<String,String> {
        'A' => '10', 
        'B' => '11', 
        'C' => '12', 
        'D' => '13', 
        'E' => '14', 
        'F' => '15', 
        'G' => '16', 
        'H' => '17', 
        'I' => '18', 
        'J' => '19', 
        'K' => '20', 
        'L' => '21', 
        'M' => '22', 
        'N' => '23', 
        'O' => '24', 
        'P' => '25', 
        'Q' => '26', 
        'R' => '27', 
        'S' => '28', 
        'T' => '29', 
        'U' => '30', 
        'V' => '31', 
        'W' => '32', 
        'X' => '33', 
        'Y' => '34', 
        'Z' => '35',
        'a' => '10', 
        'b' => '11', 
        'c' => '12', 
        'd' => '13', 
        'e' => '14', 
        'f' => '15', 
        'g' => '16', 
        'h' => '17', 
        'i' => '18', 
        'j' => '19', 
        'k' => '20', 
        'l' => '21', 
        'm' => '22', 
        'n' => '23', 
        'o' => '24', 
        'p' => '25', 
        'q' => '26', 
        'r' => '27', 
        's' => '28', 
        't' => '29', 
        'u' => '30', 
        'v' => '31', 
        'w' => '32', 
        'x' => '33', 
        'y' => '34', 
        'z' => '35'
    };

    private static final Pattern ALL_SPACES = Pattern.compile(
        '\\s+'
    );

    public void handleTrigger() {
        if(this.isAfter) {
            if(this.isInsert || this.isUpdate) {
                system.debug(this.isInsert || this.isUpdate);
                checkIBAN();
            }
        }
    }
    
    
    //NMA 27/02/2024
    public void handleADPTrigger() {
         if(this.isBefore) {
                if(this.isUpdate) {
                   setPicklistFieldsUpdate();
               }
             if(this.isInsert){
                 setBankAccountNumber();
             }
          }
    }

    private void checkIBAN() {
        Long tempLong;
        for(crta__Bank_Account__c b : this.triggerNew) {
            String IBAN = b.crta__IBAN__c;
            if(!String.isBlank(IBAN)) {
                String toTest = IBAN;
                String temp = ALL_SPACES.matcher(toTest).replaceAll('').toUpperCase().left(4);
                toTest = toTest.remove(temp) + temp;
                for(String toReplace: TO_NUMBER_FOR_IBAN.keySet()) {
                    toTest = toTest.replace(toReplace, TO_NUMBER_FOR_IBAN.get(toReplace));
                }
                
                String stringResult;
                tempLong = 0;
                do {
                    Integer endIndex = 3;
                    if(endIndex >= toTest.length()) {
                        endIndex = toTest.length();
                    }
                    String tempToTreat = tempLong.format() + toTest.substring(0, endIndex);
                    toTest = toTest.subString(endIndex);
                    
                    tempLong = Math.mod(Long.valueOf(tempToTreat), 97);
                    
                } while(toTest.length() != 0);
                if(tempLong != 1) {
                    b.addError(Label.Invalid_IBAN);
                }
            }
        }
    }
    
    
    
    private void setBankAccountNumber(){
        Set<Id> contactId=new Set<Id>();
        for(crta__Bank_Account__c b : this.triggerNew) {
               contactId.add(b.crta__Contact__c);     
           }
      List<Contact> ListBank=[SELECT Id, Name, (SELECT Id  FROM crta__Bank_Account_Contact__r)  FROM Contact  where Id IN:contactId ];
        Map<Id,Integer> numberBankAccountByContact = new  Map<Id,Integer> ();
        for(Contact con : ListBank) {
           numberBankAccountByContact.put(con.Id,con.crta__Bank_Account_Contact__r.size());
        }
        
        
          for(crta__Bank_Account__c b : this.triggerNew) {
               b.crta__ADP_itemID__c=numberBankAccountByContact.get(b.crta__Contact__c)+1;
           }
        
        
       
        
    }
    
    
    
    
    
    private void setPicklistFieldsUpdate(){
          for(crta__Bank_Account__c bank : this.triggerNew) {
              
              if (this.triggerOldMap.get(bank.Id).crta__Payment_method__c!=bank.crta__Payment_method__c    ||
                  this.triggerOldMap.get(bank.Id).crta__BIC__c!=bank.crta__BIC__c   ||
                  this.triggerOldMap.get(bank.Id).crta__IBAN__c!=bank.crta__IBAN__c ||
                  this.triggerOldMap.get(bank.Id).crta__Currency_code__c!=bank.crta__Currency_code__c  ||
                  this.triggerOldMap.get(bank.Id).crta__Bank_Account_Holder__c!=bank.crta__Bank_Account_Holder__c){
                  
                bank.crta__ADP_bankChange__c='1'; 
                  
              }
              
              
              
              
              
          }
    }
}