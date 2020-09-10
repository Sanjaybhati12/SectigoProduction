({
	showToast : function(component, event, helper) {
    
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'Please Select a Contact Role',
            type: 'info'
        });
        toastEvent.fire();
    },
	
})