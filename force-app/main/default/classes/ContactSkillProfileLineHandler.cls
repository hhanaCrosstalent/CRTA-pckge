/**
*** @Author : ABOA Ophélie
*** @Date : 15/02/2021
**/
public without sharing class ContactSkillProfileLineHandler {
 private Boolean isExecuting;
    private Boolean isInsert;
    private Boolean isUpdate;
    private Boolean isDelete;
    private Boolean isUndelete;
    private Boolean isBefore;
    private Boolean isAfter;
    private List<crta__Contact_Skill_Profile_Line__c> triggerNew;
    private Map<Id, crta__Contact_Skill_Profile_Line__c> triggerNewMap;
    private List<crta__Contact_Skill_Profile_Line__c> triggerOld;
    private Map<Id, crta__Contact_Skill_Profile_Line__c> triggerOldMap;
    private Integer size;
    private static Boolean runOnce = true;
    
    public ContactSkillProfileLineHandler(
        Boolean isExecuting,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete,
        Boolean isUndelete,
        Boolean isBefore,
        Boolean isAfter,
        List<crta__Contact_Skill_Profile_Line__c> triggerNew,
        Map<Id, crta__Contact_Skill_Profile_Line__c> triggerNewMap,
        List<crta__Contact_Skill_Profile_Line__c> triggerOld,
        Map<Id, crta__Contact_Skill_Profile_Line__c> triggerOldMap,
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
                setActive();
            }
        }
       if(this.isAfter) {
           if(runOnce){
                runOnce = false;
                setActiveOldSkills();
           }
        }
    }

    private void setActive() {
       for(crta__Contact_Skill_Profile_Line__c s : triggerNew) {
            Boolean isActive = false;
            switch on s.crta__Status__c{
                when '10 Created', '20 Waiting for approval' {
                    isActive = false;
                }
                when '30 Approved' {
                    if(s.crta__Unactivation_Reason__c != null) {
                        isActive = false;
                    } else {
                        isActive = true;
                    }
                }
                when '40 Rejected' {
                    isActive = false;
                }
                when '90 Canceled' {
                    isActive = false;
                }
            }
            s.crta__Active__c = isActive;
        }
    }

    private void setActiveOldSkills() {
        Set<String> contactIds = new Set<String>();
        Set<String> skillList = new Set<String>();
        Set<String> currentIds = new Set<String>();

        List<crta__Contact_Skill_Profile_Line__c> records = new  List<crta__Contact_Skill_Profile_Line__c>();
        if(this.isDelete) {
            records = triggerOld;
        } else {
            records = triggerNew;
        }

        List<crta__Contact_Skill_Profile_Line__c> recordsToTreat = new  List<crta__Contact_Skill_Profile_Line__c>();
        for(crta__Contact_Skill_Profile_Line__c s : records) {
            Boolean hasOld = false;
            if(triggerOldMap != null) {
                hasOld = triggerOldMap.get(s.Id).crta__Status__c == '30 Approved';
            }
            if(s.crta__Status__c == '30 Approved' || hasOld) {
                contactIds.add(s.crta__Contact__c);
                skillList.add(s.crta__Skill__c);
                if(s.Id != null) {
                    currentIds.add(s.Id);
                }
                recordsToTreat.add(s);
            }
        }
        List<crta__Contact_Skill_Profile_Line__c> oldSkillsToUpdate = new List<crta__Contact_Skill_Profile_Line__c>();
        Map<String, List<String>> oldSkillsToUpdateByContact = new Map<String, List<String>>();

        for(crta__Contact_Skill_Profile_Line__c pastSkillLine : [
            SELECT Id, 
                crta__Active__c, 
                crta__Unactivation_Reason__c, 
                crta__Skill__c,
                crta__Contact__c,
                CreatedDate
            FROM crta__Contact_Skill_Profile_Line__c
            WHERE crta__Skill__c IN: skillList
            AND crta__Status__c = '30 Approved'
            AND crta__Contact__c IN: contactIds
            AND Id NOT IN:currentIds
            ORDER BY CreatedDate DESC
        ]) {
            if(this.isDelete) {
                pastSkillLine.crta__Active__c = true;
                pastSkillLine.crta__Unactivation_Reason__c = '';
            } else {
                pastSkillLine.crta__Active__c = false;
                pastSkillLine.crta__Unactivation_Reason__c = 'Out-of-date';
            }
            for(crta__Contact_Skill_Profile_Line__c r : recordsToTreat) {
                Datetime createdDate = r.CreatedDate;
                if(createdDate == null) {
                    createdDate = system.now();
                }
                if(pastSkillLine.CreatedDate < createdDate) {
                    if(this.isUpdate) {
                        if(triggerOldMap.get(r.Id).crta__Status__c == '30 Approved' && triggerNewMap.get(r.Id).crta__Status__c != '30 Approved') {
                            pastSkillLine.crta__Active__c = true;
                            pastSkillLine.crta__Unactivation_Reason__c = '';
                        }
                    }
                    if(oldSkillsToUpdateByContact.containsKey(pastSkillLine.crta__Contact__c)) {
                        if(!oldSkillsToUpdateByContact.get(pastSkillLine.crta__Contact__c).contains(pastSkillLine.crta__Skill__c)) {
                            oldSkillsToUpdateByContact.get(pastSkillLine.crta__Contact__c).add(pastSkillLine.crta__Skill__c);
                            oldSkillsToUpdate.add(pastSkillLine);
                        }
                    } else {
                        oldSkillsToUpdateByContact.put(pastSkillLine.crta__Contact__c, new List<String>{pastSkillLine.crta__Skill__c});
                        oldSkillsToUpdate.add(pastSkillLine);
                    }
                }
            }
        }
        if(oldSkillsToUpdate.size() > 0) {
            update oldSkillsToUpdate;
        }
    }

}