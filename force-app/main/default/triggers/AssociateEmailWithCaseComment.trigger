trigger AssociateEmailWithCaseComment on EmailMessage (before insert,after insert,before delete) {  
    
    List<Case_Comment__c >  lstCaseComment = new List<Case_Comment__c >();
    if(Trigger.isBefore && Trigger.isInsert){
        for(EmailMessage eMsg : Trigger.new){
            if(eMsg.Subject.countMatches('ref:')>1){
                eMsg.adderror(Label.EmailMessage_ref_error_message);
            }
            //system.debug('HTML body'+eMsg.HtmlBody);
            //system.debug('HTML body Length'+eMsg.HtmlBody.length());            
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        String letterHeadBody= Label.Trigger_Image;
        List<Case_Comment__c> caseComments = new List<Case_Comment__c>();
        List<Case> caseList = new List<Case>();
        Map<Id, Case_Comment__c> attachmentParentIdMap = new Map<Id, Case_Comment__c>();
        Set<Id> caseIdSet = new Set<Id>();
        for(EmailMessage eMsgs : Trigger.new){
            caseIdSet.add(eMsgs.ParentId);
        }
        Map<String,Case> caseMailMap = new Map<String,Case>();
        Map<Id,Case> CaseMap = new Map<Id,Case>([Select Id,Subject,Reason,ClosedDate from Case where ID In: caseIdSet]);
        List<Case> emsgCaseList = new List<Case>();
        // query case and put into map caseMap
        for(EmailMessage eMsg : Trigger.new){
            system.debug('emesaeg ='+eMsg );
            String subject = eMsg.subject;
            if(eMsg.ParentId!=null && subject.indexOf('ref:')!=-1 && subject.indexOf(':ref')!=-1){
                // Create case comment for both incoming and outgoing emails 
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eMsg.ParentId;
                //autoCaseComment.Contact__c=eachCse.ContactId;
                if(eMsg.HtmlBody != Null){
                    autoCaseComment.Comment_Body__c= (eMsg.HtmlBody).stripHtmlTags() ;  //emailBody
                }
                if(eMsg.TextBody != NUll){
                    autoCaseComment.Comment_Body__c= (eMsg.TextBody);  //emailBody
                }
                autoCaseComment.From_Address__c =eMsg.FromAddress;                
                autoCaseComment.To_Address__c = eMsg.ToAddress;
                lstCaseComment.add(autoCaseComment);
                
                System.debug('In Email Message Trigger >>>'+eMsg.Incoming);
                Case cs = new case();
                if(CaseMap.containskey(eMsg.ParentId)){
                    cs = CaseMap.get(eMsg.ParentId);
                }
                Integer days = 0;
                system.debug('closedDate >>'+cs.closedDate);
                if(cs.closedDate < system.now()){
                    days = AssociateEmailWithCaseCommentHelper.getDays(cs.closedDate,system.now());
                }
                system.debug('days >'+days);
                Boolean caseclos = True;
                List<String> reasonSet = system.Label.Email_Notification_Case_Validation.split(',');
                if(eMsg.Incoming == false){  
                    caseList.add(new Case(Id = eMsg.ParentId, Status='Awaiting Customer Reply'));
                }else if(cs != null && days > 5 && reasonSet.contains(cs.Reason)){
                    system.debug('Validation');
                    emsgCaseList.add(cs);
                    caseMailMap.put(eMsg.FromAddress,cs);
                }else if(cs != null && days > 28 && !reasonSet.contains(cs.Reason)){
                    emsgCaseList.add(cs);
                    caseMailMap.put(eMsg.FromAddress,cs);
                }else{
                    caseList.add(new Case(Id = eMsg.ParentId, Status='In progress'));
                }
                
                System.debug('In Email Message Trigger new case list >>>'+caseList);
            }
        }
        
        try{
            if(!lstCaseComment.isEmpty())
                insert lstCaseComment;
            
        }catch(Exception e){
            
        }
        
        if(caseList.size()>0){
            system.debug('Case List Update >>');
            update caseList;
        }
        
        if(emsgCaseList.size()>0){
            System.debug('Email Case Closed More Than 28 Days ');
            AssociateEmailWithCaseCommentHelper.sendemailReopenCase(caseMailMap);
        }
        
        
    }
    if(trigger.isbefore && trigger.isdelete){
        Profile SystemAdminId=[select id from Profile where Name='System Administrator' limit 1];
        if (UserInfo.getProfileId() != SystemAdminId.Id){
            for(EmailMessage  eml:trigger.old){
                eml.adderror('You are not authorized to delete the record , please contact your system administrator');
            }
        }
    }
    
}