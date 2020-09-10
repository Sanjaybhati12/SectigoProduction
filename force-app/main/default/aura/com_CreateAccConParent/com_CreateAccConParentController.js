({
    doInit : function(component, event, helper) {
        
        var rec = component.get("v.recordId");
        console.log('>>My Record id child help$%%%$***##>>'+rec);
        var action = component.get("c.getOpenCases");
        action.setParams({"caseId": rec });
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('Return value from server>>>>>$'+data);
                if(data == "" || data == null){
                    console.log("nulll");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "mode" : "dismissible",
                        "duration" : 5000,
                        "message": "Error"
                    });
                    // toastEvent.fire();
                    // component.find("overlayLib").notifyClose();
                }else {
                    console.log('$$$record$$???$'+data);
                    // console.log('$$$accountid$$$'+data[0]['AccountId']);
                    // console.log('$$$contactid$$$'+data[0]['ContactId']);
                    var myFinalKey;
                    for (var key in data) {
                        if(key==='isPopup'){
                            console.log('>>>'+key+'$$$value$$'+data[key]);
                            
                            myFinalKey=data[key];
                        }
                    }
                    
                    console.log('myFinalKey******'+myFinalKey);
                    
                    if(myFinalKey===false){
                        //Show toase message, already exists
                        var toastEvent2 = $A.get("e.force:showToast");
                        toastEvent2.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "mode" : "dismissible",
                            "duration" : 5000,
                            "message": "Account and contact Already Exists!!"
                        });
                        toastEvent2.fire();
                    }else{
                        //Show model
                        component.set("v.myCse",data);
                        component.set("v.isOpen", true);
                    }
                }
            }else if( state == "ERROR" ){
                var errors = response.getError();
                if (errors) {
                    console.log("eerrrr");
                    if (errors[0] && errors[0].message) {
                        console.log("Error message:>> " + 
                                    errors[0].message);
                    }
                    
                    
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    submitModel: function(component, event, helper) {
        
        var validContact= true;
        // Showerrormessagesif requiredfieldsare blank
      var allValid = component.find('conAcc').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        if (allValid){        
           
            var button = component.find('disablebuttonid');
            button.set('v.disabled',true);
            component.set('v.loaded', false);
            helper.createAccCon( component, event, helper );
        }
       
        
    },
})