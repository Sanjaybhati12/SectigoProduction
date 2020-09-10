({
    onSpam : function(component, event, helper) {
        //component.set('v.loaded', false);
        
        var button = event.getSource();
        button.set('v.disabled',true);
        component.set("v.Spinner", true);
        var myRecIn = component.get("v.recordId");
        console.log('####Record id##'+myRecIn);
        var action = component.get("c.closeSpamCase");
        action.setParams({recordId : myRecIn}); 
        action.setCallback(this, function( response ){
            var state = response.getState();
            
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('Return value from server>>>>>$'+data);
                var button = event.getSource();
                button.set('v.disabled',false);
                if(data == "" || data == null){
                    console.log("nulll");
                    //component.set('v.loaded', true);
                    //component.find("overlayLib").notifyClose();
                    component.set("v.Spinner", false);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Error"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                }
                else if(data === "true" ){      
                    console.log("trueeee");
                    //component.set('v.loaded', true);
                    // component.find("overlayLib").notifyClose();
                    component.set("v.Spinner", false);
                    
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
                    
                }
                
            }else if( state == "ERROR" ){
                var button = event.getSource();
                button.set('v.disabled',false);
                var errors = response.getError();
                if (errors) {
                    console.log("eerrrr");
                    if (errors[0] && errors[0].message) {
                        console.log("Error message:>> " + 
                                    errors[0].message);
                    }
                    //component.set('v.loaded', true);
                    //component.find("overlayLib").notifyClose();
                    component.set("v.Spinner", false);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": errors[0].message
                    });
                    toastEvent.fire();
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction( action );
        
    },
})