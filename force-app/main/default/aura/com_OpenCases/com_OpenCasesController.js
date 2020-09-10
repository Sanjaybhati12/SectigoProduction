({
    /**
    * Agile Cloud Consulting.
    * @category  Lightning controller
    * @author    Agile Cloud Consulting 
    **/
    doInit: function(component,event,helper) {
        helper.sendCase( component, event, helper );
    },
    handleComponentEvent : function(component, event, helper) {
        var rec = component.get("v.recordId");
        console.log('>rec>>'+rec);
        var action = component.get("c.getOpenCases");
        action.setParams({
            "RecordId" : rec
        }); 
        action.setCallback(this, function( response ){
            var state = response.getState();
            if( state == "SUCCESS" ){
                var data = response.getReturnValue();
                console.log('%%%'+JSON.stringify(data));
                if(data == "" || data == null){
                    console.log('No Account id');
                }else{
                    component.set("v.openCases", data);
                    component.set("v.ThreeCases", data.slice(0,3));
                    console.log('$$$Account Id$**&&'+data[0]['AccountId']);
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
        $A.enqueueAction( action );
    },
    navigateToList : function (component, event, helper) {
        var currenAccId= component.get("v.CurrentAccountId");
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Cases",
            "parentRecordId": currenAccId
        });
        relatedListEvent.fire();
    },
})