trigger CaseOperation on Case (before insert, after insert, After update,Before Update, Before Delete) {
  if(System.label.TriggerActive == 'true'){
    
    if(Trigger.isAfter && Trigger.isInsert){
        // TriggerUtility.addCaseComments(Trigger.new);      
        TriggerUtility.sendAutoWorkflowEmail(Trigger.new,Trigger.oldMap,Trigger.newMap);
        EmailNotification.NotifyAccountOwner(Trigger.new);
        CaseShareCreation.CommunityPlusCaseSharing(trigger.new);

    }
    
    //To create caseShare records based on case's account and user's contact's account
    
    
    if(Trigger.isBefore && Trigger.isInsert){
       TriggerUtility.checkSpamEmails(trigger.new);
      TriggerUtility.SetEntitlementprocess(trigger.new); 
       // Added for Email Cases Case Reason  
       TriggerUtility.setCaseReason(trigger.new);
       TriggerUtility.setRAGField(trigger.new);
        TriggerUtility.desktopsupportfieldupda(trigger.new);
       
    }
    if(Trigger.isBefore && Trigger.Isupdate){
             TriggerUtility.setRAGField(trigger.new);

       List<case> caselist = new List<Case>();
      for(case c: trigger.new){
        if((c.AccountId != trigger.oldmap.get(c.id).AccountId)){
         caselist.add(c);        
        } 
      }
     if(caselist.size()>0){
        TriggerUtility.SetEntitlementprocess(caselist);
      }
    }
    if(Trigger.isAfter && Trigger.isUpdate){  
    
     Map<Id,case> casemap = TriggerUtility.casemilestonetobeclosed(trigger.newmap,trigger.oldmap);  
      TriggerUtility.CompleteMilestone(casemap);    
      TriggerUtility.sendAutoWorkflowEmail(Trigger.new,Trigger.oldMap,Trigger.newMap);
       
    }
   }
   
   if(trigger.isbefore && trigger.isdelete){
       List<String> ProfileIds = new List<String>();
       ProfileIds = System.Label.Support_Management_profile_Id.split(';');
       if( !ProfileIds.contains( UserInfo.getProfileId() ) ){  
            for (Case c : Trigger.old) {
                c.addError(Label.Error_Message_on_case_deletion);
            }
        }
    }
    if(trigger.isAfter && trigger.isUpdate){
        List<Case> newCaseList = new List<Case>();
        newCaseList = [Select Id,AccountId,isClosed,Do_Not_Survey__c,status,Reason,Contact.Email,Survey_Date__c,contact.Survey_Date__c,ownerId From Case Where Id IN:trigger.new];
        List<Case> caseList = new List<Case>();
        for(Case c : newCaseList){
            if(c.Do_Not_Survey__c == false){
                if(c.isClosed && c.Reason == Label.SurveyCaseReason && (c.contact.Survey_Date__c <= system.Today().addDays(-30) || c.contact.Survey_Date__c == null )){
                    caseList.add(c);
                    system.debug('caselist'+caseList);
                }
            }
        }
        if(caseList.size() > 0){
            TriggerUtility.CaseEmailAlert(caseList);   
        }
        //TriggerUtility.taskduedateupdate(Trigger.new);
        TriggerUtility.casecomments(trigger.new,trigger.oldmap);   
        
        //Create Case Share on owner update
        List<Case> caseShareList = new List<Case>();
        for(Case cs : newCaseList){
            system.debug('new owner'+cs.OwnerId);
            system.debug('old owner'+trigger.oldMap.get(cs.Id).OwnerId);
            if(trigger.oldMap.get(cs.Id).OwnerId != cs.OwnerId){
                caseShareList.add(cs);
            }
        }     
        system.debug('caseShareList >>'+caseShareList);
        if(caseShareList.size()>0){
            system.debug('Case Update');
            CaseShareCreation.CommunityPlusCaseSharing(caseShareList );
        }
        
        
    }
    
}