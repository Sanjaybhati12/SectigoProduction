({
	doInit: function(component,event,helper) {
        
        var action = component.get("c.getwrapper");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('result:', response.getReturnValue());
                var result = response.getReturnValue();
                console.log(result);
                component.set("v.isEnterprise", result.Enterprise);
                component.set("v.isLearning", result.learning);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
        helper.getUserDetails( component, event, helper ); // Community Buttons Merged       

    },
    
    // Community buttons merged
     redirect: function(component,event,helper) {
        var loginUrl = event.currentTarget.dataset.url; //it will return thisDiv
        if(!loginUrl.includes('https://')){
            loginUrl = 'https://'+loginUrl;
        }
        window.open(loginUrl,'_blank');
    },
})