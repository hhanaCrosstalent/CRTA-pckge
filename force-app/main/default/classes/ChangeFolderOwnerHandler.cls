//Security isCreateable() isUpdateable() isDeletable() checked
/**
*** @Author : ABOA Ophélie
*** @Date : 18/05/2020
**/
public without sharing class ChangeFolderOwnerHandler {
	private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isUpdate;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<crta__Dossier_documentaire__c> triggerNew;
    private Map<Id, crta__Dossier_documentaire__c> triggerNewMap;
    private List<crta__Dossier_documentaire__c> triggerOld;
    private Map<Id, crta__Dossier_documentaire__c> triggerOldMap;
    private Integer size;
    
     public ChangeFolderOwnerHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<crta__Dossier_documentaire__c> triggerNew,
        Map<Id, crta__Dossier_documentaire__c> triggerNewMap,
        List<crta__Dossier_documentaire__c> triggerOld,
        Map<Id, crta__Dossier_documentaire__c> triggerOldMap,
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
            if(this.isInsert || this.isUpdate) {
                changeOwner();
            }
        }
    }
    
    private void changeOwner() {
        Set<String> contactsId = new Set<String>();
        for(crta__Dossier_documentaire__c d : this.triggerNew) {
            if(d.crta__Salarie__c != null) {
                contactsId.add(d.crta__Salarie__c);
            }
        }
        
        Map<String, String> userIdByContactId = new Map<String, String>();
        if(contactsId.size() > 0) {
            for(User u : [SELECT Id, 
                crta__Contact__c
            FROM User
            WHERE crta__Contact__c IN:contactsId
            ]) {
                userIdByContactId.put(u.crta__Contact__c, u.Id);
            }

            for(crta__Dossier_documentaire__c d : this.triggerNew) {
                if(d.crta__Salarie__c != null) {
                    String userId = userIdByContactId.get(d.crta__Salarie__c);
                    if(userId != null) {
                        if(userId != d.OwnerId) {
                            d.OwnerId = userId;
                        }
                    }
                }
            }
        }
    }
}