/*
This trigger used to send notification to nick whenever a new file uploaded in community.
5-may-2019: Added condition to notify when case status is "EV Ready". Other status cases won't notify to nick.
*/
trigger sendNotificationBigFileUpload on FeedItem (after insert) {
    
    Set<String> allPrfNames = new Set<String>();
    String myPf;
    if(!Test.IsRunningTest()){
        myPf = Label.Profilename;
        allPrfNames.addAll(myPf.split(','));
        system.debug('@@@@@'+allPrfNames);
    }
    else{
        myPf = 'System Administrator';
        
        allPrfNames.add(myPf);
    }
    //Query the Profile id and users of community 
    Map<Id, User> allCommUSer=new Map<Id, User>([ SELECT Id FROM User WHERE Profile.Name IN: (allPrfNames)]);
    
    //Get the cases information
    Set<Id> allCaseId = new Set<Id>();
    for(FeedItem myFeed : Trigger.New){
        if(myFeed.ParentId!=null && String.ValueOf(myFeed.ParentId).startsWith('500'))
            allCaseId.add(myFeed.ParentId);
    }
    
    //Query the case information.
    List<Case> allNewCse = [select id,Reason,Send_Big_Files_Notification__c from case where id IN:(allCaseId)];
    Map<Id,Case> CaseInfo= new Map<Id,Case>();
    
    for(Case eachCvf : allNewCse){
        if(eachCvf.Reason=='EV Ready')
            CaseInfo.put(eachCvf.id,eachCvf);
    }
    
    if(CaseInfo.size()>0){
        for(FeedItem singleFeed : Trigger.New){
            //Check parentid is case status is EV Ready
            if(singleFeed.ParentId!=null)
                if(CaseInfo.containsKey(singleFeed.ParentId)){
                    if(singleFeed.RelatedRecordId!=null && allCommUSer.containskey(singleFeed.CreatedById)){
                        CaseInfo.get(singleFeed.ParentId).Send_Big_Files_Notification__c = true;                        
                    
                    }
                }
            //End EV Ready Status Check
        }
        
        if(!CaseInfo.isEmpty()){
            Update CaseInfo.values();
        }
    }
}