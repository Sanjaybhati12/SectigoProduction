({
    doInit : function (component, event, helper) {

        var Selectstat = component.get("v.singleCase.Status");
        //alert('In progress!@#$'+Selectstat);
        if(Selectstat == 'In progress'){
            //alert('In progress'+Selectstat);
            component.set("v.Casestatus", 'Action with Sectigo');   
        }
          else if(Selectstat == 'Awaiting Customer Reply'){
             component.set("v.Casestatus", 'Reply from Sectigo');   
        }
         else if(Selectstat == 'New'){
             component.set("v.Casestatus", 'New');   
        }
        else if(Selectstat == 'On Hold'){
             component.set("v.Casestatus", 'On Hold');   
        }
         else if(Selectstat == 'Closed'){
             component.set("v.Casestatus", 'Closed');   
        }
         else if(Selectstat == 'Client Info Completed'){
             component.set("v.Casestatus", 'Client Info Completed');   
        }
    },
    
    
    caseView : function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        console.log('@@@Selected Case@@>>'+selectedItem);
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId": selectedItem  ,
            "slideDevName": "detail"
        });
        sObectEvent.fire(); 
    },
    handleDeleteRecord: function(component, event, helper) {
        var self = this;
         //Disable button 
        var button = component.find('disablebuttonid');
        button.set('v.disabled',true);
        component.find("record").deleteRecord($A.getCallback(function(deleteResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                // record is deleted
                var conf = component.find("confirm");
                $A.util.toggleClass(conf, "slds-hide");
                 var event = component.getEvent("com_OpenCasesEvt");
                  //event.setParam("message", "the message to send" );
                  event.fire();
                var toastEvent1 = $A.get("e.force:showToast");
                toastEvent1.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "mode" : "dismissible",
                    "duration" : 1000,
                    "message": "Case Deleted Successfully!"
                });
                toastEvent1.fire();
                console.log("Record is deleted.");
            } else if (deleteResult.state === "INCOMPLETE") {
                var conf = component.find("confirm");
                $A.util.toggleClass(conf, "slds-hide");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "mode" : "dismissible",
                    "duration" : 5000,
                    "message": "Delete Unsuccessful!"
                });
                toastEvent.fire();
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                var conf = component.find("confirm");
                $A.util.toggleClass(conf, "slds-hide");
                var toastEvent3 = $A.get("e.force:showToast");
                toastEvent3.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "mode" : "dismissible",
                    "duration" : 5000,
                    "message": "Some internal error occured!"
                });
                toastEvent3.fire();
                console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
        }));
    },
    handleSelect: function (cmp, event, helper) {
        var self = this;
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue === "Edit"){        
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": cmp.get("v.singleCase.Id")
            });
            editRecordEvent.fire();
            $A.get("e.force:refreshView").fire();
            /*  if (editRecordEvent.state === "SUCCESS" || editRecordEvent.state === "DRAFT") {
            console.log('---->saved after edit');
        } */
            //window.location.reload();
        }
        if(selectedMenuItemValue === "Delete"){
            var conf = cmp.find("confirm");
            $A.util.toggleClass(conf, "slds-hide");
        }   
    },
    openPop : function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-popover');
        $A.util.addClass(cmpTarget, 'slds-popover_tooltip');
        $A.util.addClass(cmpTarget, 'slds-nubbin_bottom-left');    
        //$A.util.addClass(cmpTarget, 'slds-nubbin_left');
        $A.util.removeClass(cmpTarget, 'slds-hide');
    },
    closePop : function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-hide');
        //$A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.removeClass(cmpTarget, 'slds-popover');
        $A.util.removeClass(cmpTarget, 'slds-popover_tooltip');
        $A.util.removeClass(cmpTarget, 'slds-nubbin_bottom-left');
        //$A.util.removeClass(cmpTarget, 'slds-nubbin_left');
    },
    hidemodal: function (cmp, event, helper){
        var conf = cmp.find("confirm");
        $A.util.toggleClass(conf, "slds-hide");
    },
})