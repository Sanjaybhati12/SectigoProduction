({
    doInit : function(component, event, helper) {
        component.set("v.iconNames", 'utility:chevronright');
        helper.getContacts(component,event,helper);
    },
    save: function (component, event, helper) {
        helper.save(component,event,helper);
        
    },
    waiting: function (component, event, helper) {
        component.set("v.uploading", true);
    },
    doneWaiting: function (component, event, helper) {
        component.set("v.uploading", false);
    },
    toggle: function (component, event, helper) {
        console.log('hi')
        var expandval=component.get("v.expand");
        if(!expandval){
            component.set("v.iconNames", 'utility:chevrondown');
            component.set("v.expand",true);
        }
        if(expandval){
            component.set("v.iconNames", 'utility:chevronright');
            component.set("v.expand",false);
        }
        
        
        // expandval ? component.set("v.iconNames", 'utility:image') : component.set("v.iconNames", 'utility:image');
        
    },
    navigateToRecord: function (component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log('doc id',id_str);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({ 
            "recordId": id_str,
            "slideDevName": "detail"
        });
        navEvt.fire();
        
    },
    IntegrationProduct: function(component,event,helper){
        var fields = event.getParam('fields');
        component.find("intProduct").submit(fields);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            type: 'success',
            message: "The record has been updated successfully."
        });
        toastEvent.fire();
    }
})