({
    closetheCase : function( component, event, helper ) {
        var action = component.get("c.closeCase");
        action.setParams({
            "recordId" : component.get("v.recordId")
        }); 
        console.log('>>>>>>>'+component.get("v.recordId"));
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('Return value from server'+data);
                if(data == "" || data == null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Error"
                    });
                    toastEvent.fire();
                    // helper.dismissQuickAction( component, event, helper );
                    
                }
                else if(data === "true" ){                
                    var toastEvent1 = $A.get("e.force:showToast");
                    toastEvent1.setParams({
                        "title": "Success!",
                        "type" : "success",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Case Closed Successfully!"
                    });
                    toastEvent1.fire();
                    $A.get('e.force:refreshView').fire();
                    
                    // helper.dismissQuickAction( component, event, helper );
                }
                
            }else if( state == "ERROR" ){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message:>> " + 
                                    errors[0].message);
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": errors[0].message
                    });
                    toastEvent.fire();
                    // helper.dismissQuickAction( component, event, helper );
                } else {
                    console.log("Unknown error");
                    // helper.dismissQuickAction( component, event, helper );
                }
            }
        });
        $A.enqueueAction( action );
    },
    dismissQuickAction : function( component, event, helper ){
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})