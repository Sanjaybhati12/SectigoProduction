({
    
  doInit: function(component, event, helper) {        
         helper.getRefundPicklist(component, event);
    },
    
    toggle: function (component, event, helper) {
        
        var sel1 = component.find("fieldSelect");
        var nav1 = sel1.get("v.value");
        console.log('#$#$'+nav1);
        component.set("v.refundTypeVal",nav1);
    },
    closeCase : function(component, event, helper) {
     
       var inputCmp = component.find("FormVal");
        var value = inputCmp.get("v.value");
        
        
        // Clear error
        //inputCmp.set("v.errors", null);
        //
             
        if(value){
            //Disable button 
            var button = component.find('disablebuttonid');
            button.set('v.disabled',true);
            component.set('v.loaded', false);
            console.log('>>child component45>>>>>'+component.get("v.caseId"));
            console.log('>>child component123>>>>>'+component.get("v.refundTypeVal"));
            console.log('>>child component1>>>>>'+component.get("v.ClosingNote"));
            var tempRec = component.get("v.caseId");
            // var tempSol = component.get("v.Solutiontitle");
            var tempSol1 = component.get("v.ClosingNote");
            var tempOrigin = component.get("v.refundTypeVal");
            var action = component.get("c.closeCaseSolut");
            action.setParams({recordId : tempRec,soluDesc: tempSol1,refundType: tempOrigin}); 
            action.setCallback(this, function( response ){
                var state = response.getState();
                if( state == "SUCCESS" ){
                    var data = response.getReturnValue();
                    console.log('Return value from server>>>>>$'+data);
                    if(data == "" || data == null){
                        console.log("nulll");
                        component.set('v.loaded', true);
                        component.find("overlayLib").notifyClose();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "mode" : "dismissible",
                            "duration" : 5000,
                            "message": "Error"
                        });
                        toastEvent.fire();
                    }
                    else if(data === "true" ){      
                        console.log("trueeee");
                        component.set('v.loaded', true);
                        component.find("overlayLib").notifyClose();
                        $A.get('e.force:refreshView').fire();
                        var toastEvent1 = $A.get("e.force:showToast");
                        toastEvent1.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "mode" : "dismissible",
                            "duration" : 5000,
                            "message": "Case Closed Successfully!"
                        });
                        toastEvent1.fire();
                    }
                    
                }else if( state == "ERROR" ){
                    var errors = response.getError();
                    if (errors) {
                        console.log("eerrrr");
                        if (errors[0] && errors[0].message) {
                            console.log("Error message:>> " + 
                                        errors[0].message);
                        }
                        component.set('v.loaded', true);
                        component.find("overlayLib").notifyClose();
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
            
        }else{
           selval.set("v.errors", [{message:"field should not be blank"}]);
        }
    },
    checkValidity : function(component, event, helper) {
        var validity = event.getSource().get("v.validity");
        console.log(validity)
    },
    
})