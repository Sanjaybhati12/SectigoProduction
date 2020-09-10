({
     /**
    * AgileCloudConsulting.
    * @category  Lightning helper
    * @author    AgileCloudConsulting
    **/
    getSobjectInfo : function(component) {
        console.log('here');
        var action = component.get("c.fetchSobjectInfo");
        var self = this;
        console.log('$$$$Search String$$$'+component.get("v.searchString"));
        action.setParams({
            "searchStr": component.get("v.searchString")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('STATE>>>'+state);
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() !=null){
                    console.log('RESPONSE>>>>'+response.getReturnValue());
                    component.set("v.myResults", response.getReturnValue());
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: "sticky",
                        type:"success",
                        message: " Sorry, no results returned with matching string..",              
                    });
                    toastEvent.fire();
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    $A.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        
                    }
                } else {
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
})