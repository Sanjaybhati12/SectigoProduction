({
    doInit: function(component,event,helper) {
        helper.getUserDetails( component, event, helper );        
    },
    redirect: function(component,event,helper) {
        var loginUrl = event.currentTarget.dataset.url; //it will return thisDiv
        if(!loginUrl.includes('https://')){
            loginUrl = 'https://'+loginUrl;
        }
        window.open(loginUrl,'_blank');
    },
})