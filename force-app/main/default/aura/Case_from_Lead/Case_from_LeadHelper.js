({ 
    
    CaseFromLeadController : function(component, event,helper) {
        
        var action = component.get("c.createCaserec");
        action.setParams({ 
            leadId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state+result'+state);  
            component.set("v.spinner", false);
            if (state == "SUCCESS") {
                var response = response.getReturnValue();
                if(!response.isError){
                    helper.displayMessage(component, event,helper,'Success',response.message,'Success');
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": response.caseId,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                }else{
                    helper.displayMessage(component, event,helper,'Error',response.message,'Error');
                }
                
                
            }
            else if(state == "ERROR"){
                $A.util.removeClass(div, "slds-transition-show");
                console.log('State error');
                var errors = response.getError();
                console.log(errors);
                var toastEvent = $A.get("e.force:showToast");
                console.log('toastEvent Status'+toastEvent);
                toastEvent.setParams({
                    mode: 'sticky',
                    "title": "Error Message",
                    "message": errors[0].message
                });
                // var spinner = component.find("mySpinner");
                //	$A.util.addClass(spinner, "slds-hide");
                toastEvent.fire();
                component.set("v.ErrorMessage",errors[0].message);
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
            
        });        
        
        $A.enqueueAction(action);
    } ,  
    displayMessage : function(component, event,helper,title,message,type){
        $A.get('e.force:refreshView').fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }
})