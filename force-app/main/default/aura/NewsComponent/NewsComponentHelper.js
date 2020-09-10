({
    getNews : function(component, event, helper){
        var currentMonth = helper.getUrlParameter('month');
        var action = component.get("c.getNews");
        action.setParams({currentMonth:currentMonth});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result=response.getReturnValue();
                component.set("v.NewsList",result);
                if(result.length == 0){
                    component.set("v.isNews",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getUser : function(component, event, helper){
        var action = component.get("c.getUser");
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result=response.getReturnValue();
                component.set("v.UserData",result);
                component.set('v.today', today);
            }
        });
        $A.enqueueAction(action);
        
    },
    getUrlParameter : function(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    }
    
})