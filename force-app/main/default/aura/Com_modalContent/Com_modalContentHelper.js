({
	getRefundPicklist: function(component, event) {
        var action = component.get("c.getRefundvalues");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var refundMap = [];
                for(var key in result){
                    refundMap.push({key: key, value: result[key]});
                }
                console.log('absadjcvjad'+refundMap);
                component.set("v.refundMaps", refundMap);
            }
       });
        $A.enqueueAction(action);		
	}
})