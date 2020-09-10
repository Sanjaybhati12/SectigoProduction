({
    getData : function(component, event, helper) {
        var action = component.get("c.getDataMonth");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set("v.ArticleList",result);
                helper.getMonthList(component, event, helper,result);
            }
        });
        $A.enqueueAction(action);
        
    },
    getMonthList: function(component,event,helper,result){
        var monthList = new Array();
        var monthMap = helper.getMonthMap();
        var currentMonth = new Date().getMonth()+1;
        for(var i=1;i<=currentMonth;i++){
            if(result.includes(parseInt(i))){
                var month = new Object();
                month.key = i;
                month.value = monthMap.get(i);
                monthList.push(month);
            }
        }
        component.set("v.monthList",monthList);
    },
    getMonthMap : function(){
        let monthMap = new Map();
        monthMap.set(1,'January');
        monthMap.set(2,'February');
        monthMap.set(3,'March');
        monthMap.set(4,'April');
        monthMap.set(5,'May');
        monthMap.set(6,'Jun');
        monthMap.set(7,'July');
        monthMap.set(8,'August');
        monthMap.set(9,'September');
        monthMap.set(10,'October');
        monthMap.set(11,'November');
        monthMap.set(12,'December');
        return monthMap;
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