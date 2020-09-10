({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getOptyContactRole");
        
        action.setParams({ 
            optyId : component.get("v.recordId")
           
        });
       
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state',state);
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                console.log("SUCCESS",response.getReturnValue());
                if(response.getReturnValue() == true){
                    helper.showToast(component, event, helper);
                }
                
                //alert("OpportunityContactRole :" + response.getReturnValue());
                
            }
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }
                else if (state === "ERROR") {
                    console.log("ERROR")
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