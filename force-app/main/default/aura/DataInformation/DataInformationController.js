({
	doInit : function(component, event, helper) {
		helper.getData(component, event, helper);
        var currentMonth = helper.getUrlParameter("month");
        if(!currentMonth){
            var d = new Date().getMonth();
            currentMonth = d+1;
        }
        component.set("v.currentMonth",parseInt(currentMonth));
	}
})