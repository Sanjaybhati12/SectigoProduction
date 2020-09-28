({
	doInit: function(cmp,event,helper) {
        var action = cmp.get("c.getwrapper");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('result:', response.getReturnValue());
                var result = response.getReturnValue();
                console.log(result);
                cmp.set("v.isEnterprise", result.Enterprise);
                cmp.set("v.isLearning", result.learning);
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
    }
})