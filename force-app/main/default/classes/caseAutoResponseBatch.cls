global class caseAutoResponseBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        
        String query = System.Label.Case_Auto_Response_Filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> caseList){
        BusinessHours bhour = [Select Id From BusinessHourS Where Name=:System.Label.Case_Auto_Response_Business_Hour];
        List<String> emailList = new List<String>();
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName=:System.Label.Auto_Response_From_Email_Address];
        List<Case> newCustomerNotificationList = new List<Case>();
        List<Case> sectigoNotiforTechSupList = new List<Case>();
        List<Case> sectigoNotiforValidSupList = new List<Case>();
        List<Case> sectigoNotiforTechSup2List = new List<Case>();
        List<Case> sectigoNotiforValidSup2List = new List<Case>();
        List<Case> customerNotificationList = new List<Case>();
        List<String> caseReasonFilterforCustomer = System.label.Case_Auto_Response_Customer_Notification_Filter.split(';');
        List<String> techSupportCaseReason = System.label.Tech_Support_Case_Reason.split(';');
        List<String> techSupportCaseReason2 = System.label.Tech_Support_Case_Reason_2.split(';');
        List<String> validSupportCaseReason = System.label.Validation_Case_Reasons.split(';');
        List<String> validSupportCaseReason2 = System.label.Validation_Case_Reasons_2.split(';');
        
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        for(case cs : caseList){
            List<String> ignoreEmailsList = system.label.Case_Auto_Response_Ignore_Emails.split(',');
            
            Integer createdhour = getHourDate(cs.createdDate,bhour.Id);
            Integer modifiedhour = getHourDate(cs.lastModifiedDate,bhour.Id);
            if( !ignoreEmailsList.contains(cs.SuppliedEmail) && !ignoreEmailsList.contains(cs.ContactEmail) ){
                
                if(createdhour >= 24 && createdhour < 48 &&  cs.X24_Hour_Notification__c == false && cs.Status == 'New' && caseReasonFilterforCustomer.contains(cs.Reason) ){
                    newCustomerNotificationList.add(cs);
                }
                if(modifiedhour >= 48 && cs.Status == 'Awaiting Customer Reply' && cs.X48_Hour_Customer_Notification__c == false && caseReasonFilterforCustomer.contains(cs.Reason) ){
                    customerNotificationList.add(cs);
                }
            }
            if(createdhour >= 48 && cs.X48_Hour_Notification__c == false && cs.Status == 'New'){
                if(techSupportCaseReason.contains(cs.Reason)){
                    sectigoNotiforTechSupList.add(cs);  // for tech support case reason
                }
                if(techSupportCaseReason2.contains(cs.Reason)){
                    sectigoNotiforTechSup2List.add(cs);  // for tech support case reason 2 set
                }
                if(validSupportCaseReason.contains(cs.Reason)){
                    sectigoNotiforValidSupList.add(cs);  // for Validation case reason
                }
                if(validSupportCaseReason2.contains(cs.Reason)){
                    sectigoNotiforValidSup2List.add(cs);  // for Validation case reason 2 set
                }
            }
        }
        if(newCustomerNotificationList.size() > 0){ emailList = new List<String>();
                                                   sendEmailNotification('24',newCustomerNotificationList,System.Label.X24_Hour_Notification_Email_Template,owea[0].Id,emailList);
                                                  }
        if(customerNotificationList.size() > 0){ emailList = new List<String>();
                                                sendEmailNotification('Customer 48',customerNotificationList,System.Label.X48_Hour_Customer_Notification_Email_Template,owea[0].Id,emailList);
                                               }
        if(sectigoNotiforTechSupList.size() > 0){
            emailList = new List<String>();
            emailList = System.Label.X48_Hour_Tech_Support_Notification_EmailList.split(',');
            sendEmailNotification('48',sectigoNotiforTechSupList,System.Label.X48_Hour_Notification_Email_Template,owea[0].Id,emailList);
        }
        if(sectigoNotiforTechSup2List.size() > 0){
            emailList = new List<String>();
            emailList = System.Label.X48_Hour_Tech_Support_Notification_2_EmailList.split(',');
            sendEmailNotification('48',sectigoNotiforTechSup2List,System.Label.X48_Hour_Notification_Email_Template,owea[0].Id,emailList);
        }
        
        if(sectigoNotiforValidSupList.size() > 0){
            emailList = new List<String>();
            emailList = System.Label.X48_Hour_Validation_Support_Notification_EmailList.split(',');
            sendEmailNotification('48',sectigoNotiforValidSupList,System.Label.X48_Hour_Notification_Email_Template,owea[0].Id,emailList);
        }
        if(sectigoNotiforValidSup2List.size() > 0){
            emailList = new List<String>();
            emailList = System.Label.X48_Hour_Validation_Support_Notification_2_EmailList.split(',');
            sendEmailNotification('48',sectigoNotiforValidSup2List,System.Label.X48_Hour_Notification_Email_Template,owea[0].Id,emailList);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
    
    // Update Case Details and Send Email Notification.
    public static void sendEmailNotification(String emailFor,List<Case> caseList,String emailTemplateId,String owdId,List<String> emailList){
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        List<CaseComment> caseCommentList = new List<CaseComment>();
        List<Case_comment__c> publicCaseCommentList = new List<Case_comment__c>();
        OrgWideEmailAddress oweaRec = [select Id,Address from OrgWideEmailAddress where Id =: owdId];
        
        for(Case cs : caseList){
            Case_comment__c publicCaseComment = new Case_comment__c();
            
            if(emailFor == '24'){
                cs.X24_Hour_Notification__c = true;
                emailList = new List<String>();
                if(cs.SuppliedEmail != null){
                    emailList.add(cs.SuppliedEmail);
                }
                else if(cs.ContactEmail != null){
                    emailList.add(cs.ContactEmail);
                }
            }else if(emailFor == '48'){
                cs.X48_Hour_Notification__c = true;
                
            }else if(emailFor == 'Customer 48'){
                cs.X48_Hour_Customer_Notification__c = true;
                emailList = new List<String>();
                if(cs.SuppliedEmail != null){
                    emailList.add(cs.SuppliedEmail);
                }
                else if(cs.ContactEmail != null){
                    emailList.add(cs.ContactEmail);
                }
            }
            if(emailList.size() > 0){
                Messaging.SingleEmailMessage email = getMailMessage(emailTemplateId,cs.ContactId,cs.Id,owdId,emailList);
                emailMessageList.add(email);
                
                if(emailFor == '48'){
                    CaseComment cc = new CaseComment();
                    cc.ParentId = cs.Id;
                    cc.CommentBody = email.getPlainTextBody();
                    caseCommentList.add(cc);
                }else{
                    publicCaseComment.From_Address__c = oweaRec.Address;
                    publicCaseComment.To_Address__c = String.Join(email.toaddresses,',');
                    publicCaseComment.Comment_Body__c = email.getHtmlBody();
                    publicCaseComment.Email_Subject__c = email.getSubject();
                    publicCaseComment.ParentId__c = cs.Id;
                    publicCaseComment.CurrencyIsoCode = cs.CurrencyIsoCode;
                    
                    publicCaseCommentList.add(publicCaseComment);
                }
            }
        }
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
            
        }
        try{
            if(caseList.size() > 0){
                update caseList;
            }
            if(caseCommentList.size() > 0){
                insert caseCommentList;
            }
            if(publicCaseCommentList.size() > 0){
                insert publicCaseCommentList;
            }
            
        }catch(Exception err){
            
        }
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