({
    lockopportunity : function(component, event,helper) {
        var OppId = component.get("v.recordId");
        var action = component.get("c.LockOpportunity");
        action.setParams({
            recordId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                console.log("state",state);
                console.log("returnvalues",response.getReturnValue());
                component.set("v.isVisible",true);
                //alert('success');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'The record has been locked.',
                    
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:'This Record not Locked',
                        
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    
    
})