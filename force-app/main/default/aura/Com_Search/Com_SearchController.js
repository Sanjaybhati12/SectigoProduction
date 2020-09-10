({
     /**
    * AgileCloudConsulting.
    * @category  Lightning controller
    * @author    AgileCloudConsulting
    **/
    doInit : function(component, event, helper) {
        helper.getSobjectInfo(component);
    },
    getSelectedName: function (component, event) {
        var selectedValue = event.currentTarget.dataset.value;
        console.log('@@@@@$$Selected Value@@@@@@@@'+selectedValue);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdcpage/%2Fapex%2FCommunity_Case_Detail%3Fid%3D"+selectedValue ,
            "isredirect":true
        });
        urlEvent.fire();
    },
     getSelectedName1: function (component, event) {
        var selectedValue = event.currentTarget.dataset.value;
        console.log('@@@@@$$Selected Value@@@@@@@@'+selectedValue);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://support.comodoca.com/articles/Knowledge/"+selectedValue ,
            "isredirect":true
        });
        urlEvent.fire();
    },
     firstTab: function(component, event, helper) {
        var tab1 = component.find('firstId');
        var TabOnedata = component.find('firstContentId');
        var tab2 = component.find('secondId');
        var TabTwoData = component.find('secondContentId');
        var tab3 = component.find('thridId');
        var TabThreeData = component.find('thirdContentId');
        //show and Active fruits tab
        $A.util.addClass(tab1, 'slds-is-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-is-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        $A.util.removeClass(tab3, 'slds-is-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
    },
    secondTab: function(component, event, helper) { 
         var tab1 = component.find('firstId');
        var TabOnedata = component.find('firstContentId');
        var tab2 = component.find('secondId');
        var TabTwoData = component.find('secondContentId');
        var tab3 = component.find('thridId');
        var TabThreeData = component.find('thirdContentId');
        //show and Active vegetables Tab
        $A.util.addClass(tab2, 'slds-is-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-is-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide'); 
        $A.util.removeClass(tab3, 'slds-is-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
 
    },
    thirdTab: function(component, event, helper) {
        var tab1 = component.find('firstId');
        var TabOnedata = component.find('firstContentId');
        var tab2 = component.find('secondId');
        var TabTwoData = component.find('secondContentId');
        var tab3 = component.find('thridId');
        var TabThreeData = component.find('thirdContentId');
        //show and Active color Tab
        $A.util.addClass(tab3, 'slds-is-active');
        $A.util.removeClass(TabThreeData, 'slds-hide');
        $A.util.addClass(TabThreeData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-is-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        $A.util.removeClass(tab2, 'slds-is-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
    },
})