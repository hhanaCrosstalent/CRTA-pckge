({
    doInit: function(component, event, helper) {
        if(component.get('v.showPerfomanceReviews')) {
            helper.callStandardInterviewModuleComponent(component, event, helper);
        }
        if(component.get('v.showCompensationReview')) {
            helper.callStandardCompensationReviewModuleComponent(component, event, helper);
        }
        if(component.get('v.showTalentReview')) {
            //helper.callStandardTalentReviewModuleComponent(component, event, helper);
            helper.callStandardNineBoxComponent(component, event, helper);
            helper.callStandardPotentialPositionsComponent(component, event, helper);
        }
        if(component.get('v.showLeave')) {
            helper.callStandardLeaveModuleComponent(component, event, helper);
            helper.callStandardLeaveAPMModuleComponent(component, event, helper);
        }
    },
    loadNineBox: function(component, event, helper) {
        helper.callStandardNineBoxComponent(component, event, helper);
    },


    //$Label.c.Record_Types
    //$Label.c.Separator_Record_Types
    //$Label.c.Brand_Color
    //$Label.c.Display_Performance_Reviews_Tab
    //$Label.c.Display_Compensation_Review_Tab
    //$Label.c.Display_Team_Tab
    //$Label.c.Display_Attachement_Level
    //$Label.c.Display_Search_Employee
    //$Label.c.Display_Talent_Review_Tab
    //$Label.c.Display_Leaves_Tab
})