({
    handleClick : function(component, event, helper) {
        component.set("v.spinner", true);
        helper.CaseFromLeadController(component, event, helper); 
 
    }
})