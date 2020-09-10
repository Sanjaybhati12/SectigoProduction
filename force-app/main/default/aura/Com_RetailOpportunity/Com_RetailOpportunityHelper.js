({
    createOpp : function( component, event, helper ) {
        var action = component.get("c.createOppr");
        action.setParams({
            "recordId" : component.get("v.recordId")
        }); 
        console.log('>>>>>>>'+component.get("v.recordId"));
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('Return value from server>>'+data);
                if(data == "" || data == null){
                    component.set('v.loaded', true);
                    var button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                    
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
                    
                }else if(data === "NotAuth"){
                    //You are not authorized to create Retail opportunity from this Button
                    console.log('data>>>>>>'+data);
                    component.set('v.loaded', true);
                    var button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                    
                    var toastEvent1 = $A.get("e.force:showToast");
                    toastEvent1.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "You are not authorized to create Retail opportunity from this Button"
                    });
                    toastEvent1.fire();
                    $A.get('e.force:refreshView').fire();
                    
                    // helper.dismissQuickAction( component, event, helper );
                }else if(data === "oppExists"){
                    //You are not authorized to create Retail opportunity from this Button
                    console.log('data>>>>>>'+data);
                    component.set('v.loaded', true);
                    var button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                    
                    var toastEvent1 = $A.get("e.force:showToast");
                    toastEvent1.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Retail opportunity already exists under this case"
                    });
                    toastEvent1.fire();
                    $A.get('e.force:refreshView').fire();
                    
                    // helper.dismissQuickAction( component, event, helper );
                }else {
                    component.set('v.loaded', true);
                    var button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                    
                    var toastEvent1 = $A.get("e.force:showToast");
                    toastEvent1.setParams({
                        "title": "Success!",
                        "type" : "success",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Retail Opportunity Created Successfully!"
                    });
                    toastEvent1.fire();
                    $A.get('e.force:refreshView').fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": data,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                }
                
            }else if( state == "ERROR" ){
                component.set('v.loaded', true);
                var button = component.find('disablebuttonid');
                button.set('v.disabled',false);
                
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
                    component.set('v.loaded', true);
                    var button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                    
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