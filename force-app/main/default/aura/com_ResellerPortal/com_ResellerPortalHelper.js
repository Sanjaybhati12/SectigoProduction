({
    getUserAccount : function(component, event, helper) {
        var action = component.get("c.getOpenCases");
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('Reseller data __ '+data);
                if(data == "" || data == null){
                    console.log('>No Accountid>');
                }else{
                    console.log('<>><><>data<><><>*<>'+data);
                    component.set("v.ResellerportalLogin",data);
                }
            }else if( state == "ERROR" ){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message:>> " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction( action );
        
    },
    redirectExternalUrl : function(component, event, helper) {
        //Complete url
        var myAcc = component.get("v.ResellerportalLogin");
        console.log('<><>myAcc<>??///'+myAcc);
        //myAcc = myAcc.replace(/ +/g, "");
        console.log('<><>After removal<>>>///'+myAcc);
        // var cuLa = $A.get("$Label.c.SCM_Login");
        if (! myAcc.includes('http://')){
            myAcc = 'http://'+ myAcc;
            }
        var externalUrl=myAcc;
        console.log('<><>externalUrl<>///'+externalUrl);
        
        //var externalUrl='https://cert-manager.com/customer/'+myAcc;
        console.log('<><>externalUrl<>///'+externalUrl);
        window.open(externalUrl,'_blank');
    },
})