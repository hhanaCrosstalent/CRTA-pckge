({
    callStandardInterviewModuleComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'PerformanceReviewsList',
            'crtatm',
            'interviewsComponent', 
            {
                displayManagerList: true,
            }
        );
    },
    callStandardPotentialPositionsComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'PotentialPositions',
            'crtatm',
            'potentialPositionsComponent', 
            {
                teamFilter: true,
            }
        );
    }, 
    callStandardCompensationReviewModuleComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'CompReviewCampaignManager',
            'c',
            'salaryReviewsComponent', 
            {}
        );
    }, 
    callStandardTalentReviewModuleComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'TeamScanGlobalScore',
            'c',
            'talentReviewsComponent', 
            {}
        );
    }, 
    callStandardNineBoxComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'NineBox',
            'crtatm',
            'nineBoxComponent', 
            {}
        );
    },
    callStandardLeaveModuleComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'LeaveRequestTeam',
            'c',
            'leavesComponent', 
            {
                displayPresence: true, 
                isManager: true,
                relatedToReportsTo: false,
                presenceTypeStr: component.get('v.presenceTypeStr'), 
                leaveTypeStr: component.get('v.leaveTypeStr')
            }
        );
    }, 
    callStandardLeaveAPMModuleComponent: function(component, event, helper) {
        helper.callStandardModuleComponent(
            component, 
            event, 
            helper, 
            'ApprovalRequestManager',
            'c',
            'leavesAPMComponent', 
            {
                approvalTargets: 'Demandes d\'absence'
            }
        );
    }, 
    callStandardModuleComponent: function(component, componentName, namespace, componentVariable, parameters) {
        return new Promise(function (resolve, reject) {
            $A.createComponent(
                namespace + ':' + componentName,
                parameters,
                function(loadedComponent, status, errorMessage){
                    switch(status) {
                        case 'SUCCESS': 
                            component.set('v.' + componentVariable, loadedComponent);
                            resolve(loadedComponent);
                        break;
                        case 'INCOMPLETE': 
                            console.log('No response from server or client is offline.');
                            reject('No response from server or client is offline.');
                        break;
                        case 'ERROR': 
                            console.error('Error on loading component "' + componentName + '": ' + errorMessage);
                            reject('Error on loading component "' + componentName + '": ' + errorMessage);
                        break;
                    }
                }
            );
        });
    }
})