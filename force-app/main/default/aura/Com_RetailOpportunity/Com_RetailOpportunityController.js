({
    doInit : function(component, event, helper) {
        component.set('v.loaded', false);
        //Disable button 
        var button = component.find('disablebuttonid');
        button.set('v.disabled',true);
        helper.createOpp( component, event, helper );
    },
})