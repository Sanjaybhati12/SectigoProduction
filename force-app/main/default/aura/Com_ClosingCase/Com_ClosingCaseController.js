({
	doInit : function(component, event, helper) {
		//helper.closetheCase( component, event, helper );
		var myRecIn = component.get("v.recordId");
		var modalBody;
        $A.createComponent("c:Com_modalContent", {"caseId":myRecIn},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Close Case",
                       body: modalBody, 
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                          // alert('You closed the alert!');
                       }
                   })
               }                               
           });
	},
})