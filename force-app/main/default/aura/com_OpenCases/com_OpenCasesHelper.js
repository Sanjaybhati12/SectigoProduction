({
    sendCase : function(component, event, helper) {
        var rec = component.get("v.recordId");
        var action = component.get("c.getOpenCases");
        action.setParams({
            "RecordId" : rec
        }); 
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                if(data == "" || data == null){
                }else{
                    component.set("v.openCases", data);
                    component.set("v.ThreeCases", data.slice(0,3));
                    component.set("v.CurrentAccountId",data[0]['AccountId']);
                }
            }
            else if( state == "ERROR" ){
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
        var permission = component.get("c.getaccess");
        permission.setCallback(this, function(a) {
            var result = a.getReturnValue();
            component.set("v.Permissions", result);  
            console.log(component.get("v.Permissions"));
        });
        
        $A.enqueueAction( permission );
        $A.enqueueAction( action );
    },
})