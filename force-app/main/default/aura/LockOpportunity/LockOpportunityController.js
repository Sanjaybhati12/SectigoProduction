({
	handleClick : function(component, event, helper) {
        component.set("v.spinner", true);
        helper.lockopportunity(component, event, helper); 
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.checkUser");
        action.setParams({
            recordId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                
                component.set("v.isVisible",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})