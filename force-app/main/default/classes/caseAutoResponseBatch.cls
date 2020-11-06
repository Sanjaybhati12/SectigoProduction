global class caseAutoResponseBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        
        String query  = System.Label.Case_Auto_Response_Filter; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> caseList){
        BusinessHours bhour = [Select Id From BusinessHourS Where Name=:System.Label.Case_Auto_Response_Business_Hour];
        List<String> emailList = new List<String>();
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName=:System.Label.Auto_Response_From_Email_Address];
        List<String> ignoreEmailsList = system.label.Case_Auto_Response_Ignore_Emails.split(',');
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        List<Case> casesListToUpdate = new List<Case>();
        List<CaseComment> caseCommentList = new List<CaseComment>();
        List<Case_comment__c> publicCaseCommentList = new List<Case_comment__c>();
        
        List<CaseAutoResponseNotification__c> caseAutoRespNotiList = new List<CaseAutoResponseNotification__c>();
        caseAutoRespNotiList = CaseAutoResponseNotification__c.getAll().values();
        for(case caseRec : caseList){
            
            for(CaseAutoResponseNotification__c customNotiRec : caseAutoRespNotiList){
                Integer lastActioinHours;
                Integer lessThanCheckHour = 0 ;
                emailList = new List<String>();
                String filedToUpdate = customNotiRec.Update_Field__c;
                
                List<String> caseReasons = customNotiRec.Case_Reason__c.split(';');
                if(customNotiRec.Case_Reason_Extra__c != null){
                    system.debug('Case_Reason_Extra__c ' + customNotiRec.Case_Reason_Extra__c);
                    caseReasons.addAll(customNotiRec.Case_Reason_Extra__c.split(';'));
                }
                
                if(customNotiRec.Trigger_on_Create__c == true){
                    lastActioinHours = getHourDate(caseRec.createdDate,bhour.Id) ; 
                }else if(caseRec.Last_Action__c != null && customNotiRec.Trigger_on_Modify__c == true){
                    lastActioinHours = getHourDate(caseRec.Last_Action__c,bhour.Id) ;  // Last_Action__c instead of lastmodified
                }else {
                    lastActioinHours = getHourDate(caseRec.LastModifiedDate,bhour.Id);
                }
                
                if(customNotiRec.Days_LT__c == null){
                    lessThanCheckHour = lastActioinHours + 1;
                }else{
                    lessThanCheckHour = Integer.valueOf( customNotiRec.Days_LT__c );
                }
                
                system.debug('caseRec ' + caseRec.Id );
                system.debug('lastActioinHours ' + lastActioinHours + ' : customNotiRec.Days_GT__c ' + customNotiRec.Days_GT__c + ' : lessThanCheckHour ' + lessThanCheckHour);
                if( lastActioinHours > customNotiRec.Days_GT__c && lastActioinHours < lessThanCheckHour && caseReasons.contains(caseRec.reason) && caseRec.Status == customNotiRec.Case_Status__c && !(Boolean)caseRec.get(filedToUpdate) ){
                    
                    if(customNotiRec.Notification_Type__c == 'Customer'){
                        if(caseRec.SuppliedEmail != null && !ignoreEmailsList.contains(caseRec.SuppliedEmail)){
                            emailList.add(caseRec.SuppliedEmail);
                        }else if(caseRec.ContactEmail != null && !ignoreEmailsList.contains(caseRec.ContactEmail)){
                            emailList.add(caseRec.ContactEmail);
                        }
                    }else if(customNotiRec.Recipient__c != null){
                        emaillist = customNotiRec.Recipient__c.split(',');
                    }
                    system.debug('Line 56 ' + customNotiRec.Name + ' : ' + caseRec.Id + ' : ' + caseRec.Reason + ' ' + caseRec.Status);
                    Messaging.SingleEmailMessage semRec = getMailMessage(customNotiRec.Email_Template_Id__c,caseRec.ContactId,caseRec.Id,owea[0].Id,emailList);
                    emailMessageList.add(semRec);
                    
                    caseRec.Last_Action__c = system.now();
                    caseRec.put(filedToUpdate,true);
                    casesListToUpdate.add(caseRec);
                    
                    if(customNotiRec.Create_Email_Message__c){
                        CaseComment cc = new CaseComment(ParentId = caseRec.Id,CommentBody = semRec.getPlainTextBody());
                        caseCommentList.add(cc);
                    }
                    if(customNotiRec.Create_Public_Case_Comment__c){
                        Case_comment__c publicCaseComment = new Case_comment__c(From_Address__c = owea[0].Address,
                                                                                To_Address__c = String.Join(semRec.toaddresses,','),
                                                                                Comment_Body__c = semRec.getHtmlBody(),
                                                                                Email_Subject__c = semRec.getSubject(),
                                                                                ParentId__c = caseRec.Id,
                                                                                CurrencyIsoCode = caseRec.CurrencyIsoCode);
                        publicCaseCommentList.add(publicCaseComment);
                    }
                }
            }
        }
        
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
        }
        
        try{
            if(casesListToUpdate.size() > 0 ){Update casesListToUpdate;}
            if(caseCommentList.Size() > 0){Insert caseCommentList;}
            if(publicCaseCommentList.size() > 0){Insert publicCaseCommentList;} 
        }catch(dmlException e){system.debug('error ' + e);}
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
    
    //Calculate Hour between two dates.
    public static Integer getHourDate(DateTime createdDate,Id bhId){
        if(!BusinessHours.isWithin(bhId, createdDate)){
            createdDate  = BusinessHours.nextStartDate(bhId, createdDate);
        }
        Long currentTime = system.now().getTime();
        Long caseTime = createdDate.getTime();
        Long milliseconds = (currentTime- caseTime);
        Long hour = (((milliseconds/1000)/60)/60);
        return Integer.valueOf(hour);
    }
    
    //Generate Email Message Using case information.
    public static Messaging.SingleEmailMessage getMailMessage(String emailTemplateId,String whoId,String objId,String owdId,List<String> emailList){
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplateId,whoId,objId);
        String  subject = email.getSubject();
        String body = email.gethtmlBody();
        email.setSaveAsActivity(false);
        email.setSubject(subject);
        email.setTreatTargetObjectAsRecipient(false);
        email.sethtmlBody(body);
        if(String.isNotBlank(owdId)){
            email.setOrgWideEmailAddressId(owdId);
        }
        email.setToAddresses(emailList );
        return email;
    }
    
}