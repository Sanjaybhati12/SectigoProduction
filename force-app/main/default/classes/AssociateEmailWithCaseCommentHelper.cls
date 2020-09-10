public class AssociateEmailWithCaseCommentHelper {
    
    public static void sendemailReopenCase(Map<String,Case> caseMailMap){
        if(caseMailMap.size() > 0){
            for(String key : caseMailMap.keySet()){
                Casecommentemilalert(caseMailMap.get(key).Id,key);
            }
        }
    }
    @Future
    public static void Casecommentemilalert(Id NewcaseIdSet,String toAddres){
        List<EmailTemplate> templateList = [SELECT Id, Body,DeveloperName, Subject from EmailTemplate where DeveloperName ='Case_Closed_Email_Template' Limit 1];
        String emailTemplateId  = '';
        if(templateList.size() > 0 ){
            emailTemplateId = templateList[0].Id;
        }
        system.debug('@@@et'+emailTemplateId);
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='Support' ];
        String owdId = '',FromAddress = '';
        if(owea.size() > 0){
            owdId = owea[0].Id;
            FromAddress = owea[0].Address;
        }
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        List<case> cas = [SELECT Id,Subject,Contact.email, ContactId,SuppliedEmail,Status,ClosedDate FROM Case where Id =: NewcaseIdSet ];
        if(cas.size()>0){
        if(string.isNotBlank(emailTemplateId)){
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplateId  ,cas.get(0).ContactId,cas.get(0).Id);
            String  subject = email.getSubject();
            String body = email.gethtmlBody();
            email.setSaveAsActivity(false);
            email.setSubject(subject);
            email.setTreatTargetObjectAsRecipient(false);
            email.sethtmlBody(body);
            String[] emailids = new String[]{toAddres};
                system.debug('Case Contact Email'+cas.get(0).Contact.email);
            email.setToAddresses(emailids);
            if(String.isNotBlank(owdId)){
                system.debug('owdId--->'+owdId);
                email.setOrgWideEmailAddressId(owdId);
            }
            emailMessageList.add(email);
        }
        }
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
        }
    }
    public static Integer getDays(DateTime startDate, DateTime endDate){
        Integer days = 0;
        while(startDate <= endDate){
            if(startDate.format('E') != 'Sat' && startDate.format('E') != 'Sun'){
                days += 1;
            }
            startDate = startDate.addDays(1);
        }
        system.debug('days  >>'+days );
        return days;
    }
    
}