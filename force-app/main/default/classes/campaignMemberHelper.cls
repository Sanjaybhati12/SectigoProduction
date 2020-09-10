public class campaignMemberHelper{
     public static void sendTaskNotification(List<CampaignMember> newList){
        //List<CampaignMember> campaignMemList = [Select Id,Lead.Id,Contact.Id From CampaignMember Where Id IN:newList];
        Set<Id> leadIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        for(CampaignMember cm : newList){
            if(cm.Lead.Id != null){
                leadIdSet.add(cm.Lead.Id);
            }
            if(cm.Contact.Id != null){
                contactIdSet.add(cm.Contact.Id);
            }
        }
        Map<Id,Task> emailMap = new Map<Id,Task>();
        for(task tsk : [Select Id,WhoId,type,WebForm_Name__c,Employee_Count__c From Task Where (WhoId IN:LeadIdSet or whoId IN:contactIdSet) and (recordType.Name = 'WebForms')  ORDER BY CreatedDate desc]){
            if(!emailMap.containskey(tsk.whoId)){
                emailMap.put(tsk.whoId,tsk);
            }
        }
        system.debug('emailMap >>'+emailMap);
        sendMarketingMail(emailMap);
    }
    public static void sendContactNotification(List<CampaignMember> newList){
        Set<Id> conIdSet = new Set<Id>();
        Map<Id,String> conOwnerMap = new Map<Id,String>();
        for(CampaignMember cmpMem : newList){
            if(cmpMem.contactId != null){
                conIdSet.add(cmpMem.contactId);
                system.debug('Account OWner Email'+cmpMem.Contact.Account.Owner.email);
                if(String.isNotBlank(cmpMem.Contact.Account.Owner.email)){
                    conOwnerMap.put(cmpMem.contactId,cmpMem.Contact.Account.Owner.email);
                }
            }
        }
        List<contactEmailWrapper> conEmailWrapList = new List<contactEmailWrapper>();
        
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Set<Id> tskIdSet = new Set<Id>();
        for(task tsk : [Select Id, WhoId,Type From Task Where (whoId IN:conIdSet) and (recordTypeId =: taskRecordTypeId and (type = 'Webform' or type = 'Channel Partner'))  ORDER BY CreatedDate desc]){
            if(!tskIdSet.contains(tsk.WhoId)){
                tskIdSet.add(tsk.WhoId);
                if(conOwnerMap.containskey(tsk.whoId)){
                    contactEmailWrapper cew = new contactEmailWrapper();
                    cew.conId = tsk.whoId;
                    cew.taskId = tsk.Id;
                    cew.email = conOwnerMap.get(tsk.whoId);
                    conEmailWrapList.add(cew);
                }
            }
            
        }
        if(conEmailWrapList.size() > 0){
            system.debug('conEmailWrapList >>'+conEmailWrapList);
            sendContactEmail(conEmailWrapList,'');
        }
    }
    public static void sendContactEmail(List<contactEmailWrapper> conEmailWrapList,String type){
        String emailTemplateName = '';
        if(type == 'Hubspot'){ emailTemplateName = 'Contact_Web_Form_Notification_HS'; }else { emailTemplateName = 'Contact_Web_Form_Notification'; }
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName=:emailTemplateName  ORDER BY LastModifiedDate];
        String emailTemplateId = '';
        if(lstEmailTemplates.size() > 0){
            emailTemplateId  = lstEmailTemplates[0].Id;
        }
        system.debug('emailTemplateId'+emailTemplateId);
        if(string.isNotBlank(emailTemplateId)){
            OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='Marketing'];
            List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
            for(contactEmailWrapper cew : conEmailWrapList){
                List<String> emailList = new List<String>{cew.email};
                    Messaging.SingleEmailMessage email = getMailMessage(emailTemplateId,cew.conId,cew.taskId,owea[0].Id,emailList );
                emailMessageList.add(email);
            }
            Messaging.sendEmail(emailMessageList);
        }
    }
    public static void sendMarketingMail(Map<Id,Task> emailMap){
        Set<String> emailTemplateName = new Set<String>{'Management_Web_Form_Submission','Channel_Partners_Web_Form_Submission'};
        String emailTemplateId = '';
        Map<String,Id> templateMap = new Map<String,Id>();
        for(EmailTemplate et : [SELECT Id, Body,DeveloperName, Subject from EmailTemplate where DeveloperName IN : emailTemplateName  ORDER BY LastModifiedDate]){
            templateMap.put(et.DeveloperName,et.Id);
        }
        List<String> webEmaillList = Label.Marketing_Web_Form_Notification_Emails.split(',');
        List<String> channelEmailList = Label.ChannelPartner_Manger_Emails.split(',');
        
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='Marketing'];
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        for(String whoId : emailMap.keyset()){
            List<String> emailList = new List<String>();
            
            
            if(emailMap.get(whoId).Type == 'WebForm'){
                emailList  = webEmaillList;
                if(emailMap.get(whoId).WebForm_Name__c == 'Top Navigation'){
                    if(Integer.valueOf(emailMap.get(whoId).Employee_Count__c) > Integer.valueOf(Label.Top_Navigation_Employee_Notification)){
                       emailTemplateId = templateMap.get('Management_Web_Form_Submission'); 
                    }
                }else{
                    if(templateMap.containskey('Management_Web_Form_Submission')){
                        emailTemplateId = templateMap.get('Management_Web_Form_Submission');
                    }
                }
            }
            system.debug('emailMap.get(whoId).Type >>'+emailMap.get(whoId).Type);
            if(emailMap.get(whoId).Type == 'Channel Partner'){
                emailList  = channelEmailList;
                if(templateMap.containskey('Channel_Partners_Web_Form_Submission')){
                    emailTemplateId = templateMap.get('Channel_Partners_Web_Form_Submission');
                }
            }
            system.debug('emailTemplateId  >>'+emailTemplateId);
            if(String.isNotBlank(emailTemplateId )){
                Messaging.SingleEmailMessage email = getMailMessage(emailTemplateId,whoId,emailMap.get(whoId).Id,owea[0].Id,emailList);
                emailMessageList.add(email);
            }
            
        }
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
        }
    }
    public static Messaging.SingleEmailMessage getMailMessage(String emailTemplateId,String whoId,String objId,String owdId,List<String> emailList){
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplateId  ,whoId,objId);
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
    public class contactEmailWrapper{
        public string email;
        public string conid;
        public string taskid;
    }
    
    public static void updateLeadOwner(List<CampaignMember> campaignMemList){
        
        Campaign camp = [Select id,Name from Campaign where name = 'Enterprise Web Form Submission' limit 1];
        Map<Id, Id> idLeadMap = new Map<Id, Id>();
        for(CampaignMember member : campaignMemList) {
            if(member.LeadId != null && member.CampaignId == camp.id)
                idLeadMap.put(member.LeadId, member.CampaignId);
        }
        if(idLeadMap.size()>0){
            list<Lead> leadList =  [select id , email, ownerid from lead where id =: idLeadMap.keyset() ];
            user us = [Select id,Name from user where name = 'Tristan Fourcault' limit 1];
            boolean doupdate = false;
            for(lead le : leadlist){
                List<string> leEmailDomain = Label.LeadEmailDomains.split(',');
                if(le.email != null){
                    if(le.email.split('@').size() == 2){
                        if(leEmailDomain.contains(le.email.split('@')[1])){
                            le.ownerid = us.id;
                            doupdate = true;
                        }
                    }
                }
                
            }
            if(doupdate)
                update leadlist;
        }
    }
}