({
    createAccCon : function( component, event, helper) {
        var action = component.get("c.createAccCon");
        var temp1= component.get("v.myCse.ConFirst");
        console.log('&&&&&&&'+temp1);
        action.setParams({
            "accN" :component.get("v.myCse.AccName"),
            "accS" :component.get("v.myCse.AccSource"),
            "accB" :component.get("v.myCse.AccCountry"),
            "accW" :component.get("v.myCse.AccWebForm"),
            "conF" :component.get("v.myCse.ConFirst"),
            "conL" :component.get("v.myCse.ConSecond"),
            "conE" :component.get("v.myCse.ConEmail"),
            "conP" :component.get("v.myCse.ConPhone"),
            "ce" :component.get("v.myCse.myCase")
        });
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                component.set("v.loaded", true);
                component.set("v.isOpen", false);
                console.log('Return value from server'+data);
                if(data == "" || data == null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Unknown Error"
                    });
                    toastEvent.fire();
                    // helper.dismissQuickAction( component, event, helper );
                    
                }else if(data==="Created"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type" : "Success",
                        "mode" : "dismissible",
                        "duration" : 4000,
                        "message": "Account and Contact Created!!"
                    });
                    toastEvent.fire();
                    
                    setTimeout(
                        $A.getCallback(function() {
                            $A.get('e.force:refreshView').fire();
                        }), 5000); // Waits 5 seconds
                    //$A.get('e.force:refreshView').fire();
                    //helper.dismissQuickAction( component, event, helper );
                }else if(data==="alreadyExists"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Information!",
                        "type" : "warning",
                        "mode" : "dismissible",
                        "duration" : 4000,
                        "message": "Account,contact Already exists"
                    });
                    toastEvent.fire();
                    
                    setTimeout(
                        $A.getCallback(function() {
                            $A.get('e.force:refreshView').fire();
                        }), 5000); // Waits 5 seconds
                    //$A.get('e.force:refreshView').fire();
                    //helper.dismissQuickAction( component, event, helper );
                }
            }else if( state == "ERROR" ){
                component.set("v.loaded", true);
                component.set("v.isOpen", false);
                
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
})