({
	 doInit: function(component,event,helper) {
        helper.getUserAccount( component, event, helper );
    },
    redirect: function(component,event,helper) {
        helper.redirectExternalUrl( component, event, helper );
    },
})