({
    CreateCaseoncontact : function(component, event,helper) {
        var ContactId = component.get("v.recordId");
        var action = component.get("c.getContactList");
        action.setParams({
            ContactId: ContactId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state+result'+state);  
            component.set("v.spinner", false);
            if(state == 'SUCCESS'){    
                var response = response.getReturnValue();
                console.log('response---->'+response);
                if(!response.isError){
                    if(response.message != 'Case Already Created'){
                        var navEvt = $A.get("e.force:navigateToSObject");
                        console.log('navEvt---->'+navEvt);
                        navEvt.setParams({
                            "recordId": response.caseId,
                            "slideDevName": "Detail"
                        });
                        navEvt.fire();
                        helper.displayMessage(component, event,helper,'Success',response.message,'Success');
                    
                    }else{
                    	helper.displayMessage(component, event,helper,'Success',response.message,'info');    
                    }
                    
                    
                } else{
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
                toastEvent.fire();
                component.set("v.ErrorMessage",errors[0].message);                
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();            
        });
        $A.enqueueAction(action);	
    },
    
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