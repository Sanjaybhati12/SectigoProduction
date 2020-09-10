public Class TaskTriggerHandler{
    public static Boolean isGeneralActivitiesRollUpOnLead = false;
    public static Boolean isGeneralActivitiesRollUpOnContact = false;
    public static Boolean isGeneralActivitiesRollUpOnopportunity = false;
    public static Boolean isLastActivityDateRollUpOnLead = false;
    public static Boolean isLastActivityDateRollUpOnContact = false;
    public static Boolean isLastActivityDateRollUpOnOpportunity = false;
    
    
    
    public static void GeneralActivitiesRollUpOnLead(List<Task> newTaskList, List<Task> oldTskList){
        system.debug('GeneralActivitiesRollUpOnLead Method Start >>');
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        Set<ID> LeadIds = new Set<ID>();
        //We only care about tasks linked to Leads.
        String leadPrefix = Lead.SObjectType.getDescribe().getKeyPrefix();
        //Add any Lead ids coming from the new data
        if(newTaskList!=null){
            for (Task t : newTaskList) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) ) {
                    if(!LeadIds.contains(t.WhoId)){
                        //adding unique lead ids since there can be many tasks with single lead
                        LeadIds.add(t.WhoId);
                    }
                }
            }
        }
        //Also add any Lead ids coming from the old data (deletes, moving an activity from one Lead to another)
        if(oldTskList!=null){
            for (Task t2 : oldTskList) {
                if (t2.WhoId!= null && string.valueof(t2.WhoId).startsWith(leadPrefix) ){
                    if(!LeadIds.contains(t2.WhoId)){
                        //adding unique lead ids since there can be many tasks with single lead
                        LeadIds.add(t2.WhoId);
                    }
                }
            }
        }
        if (LeadIds.size() > 0){
            List<Lead> leadsWithTasks = [select id,Number_of_General_Activities__c,(select id,RecordTypeId,status from Tasks where RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email') from Lead where Id IN : Leadids];
            List<Lead> leadsUpdatable = new List<Lead>();
            for(Lead L : leadsWithTasks){
                L.Number_of_General_Activities__c = L.Tasks.size();
                leadsUpdatable.add(L);
            }
            if(leadsUpdatable.size()>0){
                update leadsUpdatable;
                isGeneralActivitiesRollUpOnLead = true;
                //update all the leads with activity count
            }
        }
        system.debug('GeneralActivitiesRollUpOnLead Method End >>');
    }
    
    public static void GeneralActivitiesRollUpOnContact(List<Task> newTaskList, List<Task> oldTskList){
        system.debug('GeneralActivitiesRollUpOnContact Method Start >>'); 
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        Set<ID> ContactIds = new Set<ID>();
        //We only care about tasks linked to Contacts.
        String ContactPrefix = Contact.SObjectType.getDescribe().getKeyPrefix();
        //Add any Contact ids coming from the new data
        if(newTaskList!=null){
            for (Task t : newTaskList) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(ContactPrefix) ) {
                    if(!ContactIds.contains(t.WhoId)){
                        //adding unique Contact ids since there can be many tasks with single Contact
                        ContactIds.add(t.WhoId);
                    }
                }
            }
        }
        //Also add any Contact ids coming from the old data (deletes, moving an activity from one Contact to another)
        if(oldTskList!=null){
            for (Task t2 : oldTskList) {
                if (t2.WhoId!= null && string.valueof(t2.WhoId).startsWith(ContactPrefix) ){
                    if(!ContactIds.contains(t2.WhoId)){
                        //adding unique Contact ids since there can be many tasks with single Contact
                        ContactIds.add(t2.WhoId);
                    }
                }
            }
        }
        if (ContactIds.size() > 0){
            List<Contact> ContactsWithTasks = [select id,Number_of_General_Activities__c,(select id,status,recordtypeid from Tasks where RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email') from Contact where Id IN : Contactids];
            List<Contact> ContactsUpdatable = new List<Contact>();
            for(Contact L : ContactsWithTasks){
                L.Number_of_General_Activities__c = L.Tasks.size();
                ContactsUpdatable.add(L);
            }
            if(ContactsUpdatable.size()>0){
                update ContactsUpdatable;
                isGeneralActivitiesRollUpOnContact = true;
                //update all the Contacts with activity count
            }
        }
        system.debug('GeneralActivitiesRollUpOnContact Method End >>'); 
    }  
    
    Public static void LastActivityDateRollUpOnLead(List<Task> newTaskList, List<Task> oldTaskList){
        system.debug('LastActivityDateRollUpOnLead Method Start >>'); 
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        map<id,lead> leads = new map<id,lead>();
        String leadPrefix = lead.SObjectType.getDescribe().getKeyPrefix();
        if(newTaskList!=null){
            for(task t:newTaskList){
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) ) {
                    leads.put(t.whoid,null);
                }
            }
        }
        if(oldTaskList!=null){
            for(task t:oldTaskList){
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) ) {
                    leads.put(t.whoid,null);
                }
            }
        }
        leads.putall([select id,Last_Activity_Date__c, (select id,activitydate,status,recordtypeid from tasks where activitydate <=: date.today() and RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email' order by activitydate desc limit 1) from lead where id in :leads.keyset()]);
        for(lead a:leads.values()){
            if(a.tasks.isempty()){
                a.Last_Activity_Date__c= null;
            }
            else{
                a.Last_Activity_Date__c = a.tasks[0].activitydate;
            }
        }
        if(!leads.values().isEmpty()){
            update leads.values();
            isLastActivityDateRollUpOnLead = true;
        }
        system.debug('LastActivityDateRollUpOnLead Method End >>'); 
    }
    
    Public static void LastActivityDateRollUpOnContact(List<Task> newTaskList, List<Task> oldTaskList){
        system.debug('LastActivityDateRollUpOnContact Method Start >>');
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        map<id,contact> contacts = new map<id,contact>();
        String contactPrefix = contact.SObjectType.getDescribe().getKeyPrefix();
        if(newTaskList!=null){
            for(task t:newTaskList){
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(contactPrefix) ) {
                    contacts.put(t.whoid,null);
                }
            }
        }
        if(oldTaskList!=null){
            for(task t:oldTaskList){
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(contactPrefix) ) {
                    contacts.put(t.whoid,null);
                }
            }
        }
        contacts.putall([select id,Last_Activity_Date__c, (select id,activitydate,Status,RecordTypeId from tasks where activitydate <=: system.today() and RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email' order by activitydate desc limit 1) from contact where id in :contacts.keyset()]);
        for(contact a:contacts.values()){
            if(a.tasks.isempty()){
                a.Last_Activity_Date__c= null;
            }
            else{
                a.Last_Activity_Date__c = a.tasks[0].activitydate;
            }
        }
        if(!contacts.values().isEmpty()){
            update contacts.values();
            isLastActivityDateRollUpOnContact = true;
        }
        system.debug('LastActivityDateRollUpOnContact Method End >>');
    }
    
    
    public static void GeneralActivitiesRollUpOnopportunity(List<Task> newTaskList, List<Task> oldTskList){
        system.debug('GeneralActivitiesRollUpOnopportunity Method Start >>');
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        Set<ID> opportunityIds = new Set<ID>();
        //We only care about tasks linked to opportunities.
        String opportunityPrefix = opportunity.SObjectType.getDescribe().getKeyPrefix();
        //Add any opportunity ids coming from the new data
        if(newTaskList!=null){
            for (Task t : newTaskList) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith(opportunityPrefix) ) {
                    if(!opportunityIds.contains(t.WhatId)){
                        //adding unique opportunity ids since there can be many tasks with single opportunity
                        opportunityIds.add(t.WhatId);
                    }
                }
            }
        }
        //Also add any opportunity ids coming from the old data (deletes, moving an activity from one opportunity to another)
        if(oldTskList!=null){
            for (Task t2 : oldTskList) {
                if (t2.WhatId!= null && string.valueof(t2.WhatId).startsWith(opportunityPrefix) ){
                    if(!opportunityIds.contains(t2.WhatId)){
                        //adding unique opportunity ids since there can be many tasks with single opportunity
                        opportunityIds.add(t2.WhatId);
                    }
                }
            }
        }
        if (opportunityIds.size() > 0){
            List<opportunity> opportunitiesWithTasks = [select id,Number_of_General_Activities__c,(select id,status,recordtypeid from Tasks where RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email' ) from opportunity where Id IN : opportunityids];
            List<opportunity> opportunitiesUpdatable = new List<opportunity>();
            for(opportunity L : opportunitiesWithTasks){
                L.Number_of_General_Activities__c = L.Tasks.size();
                opportunitiesUpdatable.add(L);
            }
            if(opportunitiesUpdatable.size()>0){
                update opportunitiesUpdatable;
                isGeneralActivitiesRollUpOnopportunity = true;
                //update all the opportunities with activity count
            }
        }
        system.debug('GeneralActivitiesRollUpOnopportunity Method End >>');
    }  
    
    Public static void LastActivityDateRollUpOnOpportunity(List<Task> newTaskList, List<Task> oldTaskList){
        system.debug('LastActivityDateRollUpOnOpportunity Method Start >>');
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        map<id,opportunity> opportunities = new map<id,opportunity>();
        String opportunityPrefix = opportunity.SObjectType.getDescribe().getKeyPrefix();
        if(newTaskList!=null){
            for(task t:newTaskList){
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith(opportunityPrefix) ) {
                    opportunities.put(t.whatid,null);
                }
            }
        }
        if(oldTaskList!=null){
            for(task t:oldTaskList){
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith(opportunityPrefix) ) {
                    opportunities.put(t.whatid,null);
                }
            }
        }
        opportunities.putall([select id,Last_Activity_Date__c, (select id,activitydate,status,recordtypeid from tasks where activitydate <=: system.today() and RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email' order by activitydate desc limit 1) from opportunity where id in :opportunities.keyset()]);
        for(opportunity a:opportunities.values()){
            if(a.tasks.isempty()){
                a.Last_Activity_Date__c= null;
            }
            else{
                a.Last_Activity_Date__c = a.tasks[0].activitydate;
            }
        }
        if(!opportunities.values().isEmpty()){
            update opportunities.values();
            isLastActivityDateRollUpOnOpportunity = true;
        }
        system.debug('LastActivityDateRollUpOnOpportunity Method End >>');
    }
    
    public static void setOwner(List<Task> newList){
        system.debug('setOwner Method Start >>');
        Set<Id> leadIdSet = new Set<Id>();
        Set<Id> conIdSet = new Set<Id>();
        Map<Id,Id> leadOwnerMap = new Map<Id,Id>();
        Map<Id,Id> conOwnerMap = new Map<Id,Id>();
        for(Task tsk : newList){
            if(String.valueOf(tsk.whoId).startsWith('00Q')){
                leadIdSet.add(tsk.whoId);
            }else{
                conIdSet.add(tsk.whoId);
            }
        }
        system.debug('newList >>'+newList);
        for(Lead led : [Select Id,OwnerId From Lead Where Id IN : leadIdSet]){
            leadOwnerMap.put(led.Id,led.OwnerId);
        }
        
        for(Contact con : [Select Id,OwnerId From Contact Where Id IN : conIdSet]){
            conOwnerMap.put(con.Id,con.OwnerId);
        }
        for(Task tsk : newList){
            if(leadOwnerMap.containskey(tsk.whoId)){
                tsk.ownerId = leadOwnerMap.get(tsk.whoId);
            }
            if(conOwnerMap.containskey(tsk.whoId)){
                tsk.ownerId = conOwnerMap.get(tsk.whoId);
            }
        }
        system.debug('setOwner Method End >>');
    }
    
    public static void sendNotification(List<Task> taskList){
        system.debug('setOwner sendNotification Start >>');
        Map<Id,Task> taskMap = new Map<Id,Task>();
        for(Task tsk : taskList){
            if(!taskMap.containskey(tsk.whoId)){
                taskMap.put(tsk.whoId,tsk);
            }
        }
        if(taskMap.size() > 0){
            sendMarketingMail(taskMap);
        }
        system.debug('setOwner sendNotification End >>');
    }
    public static void sendMarketingMail(Map<Id,Task> emailMap){
        system.debug('setOwner sendMarketingMail Start >>');
        Set<String> emailTemplateName = new Set<String>{'Management_Web_Form_Submission_HS','Channel_Partners_Web_Form_Submission_HS'};
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
            system.debug('Task in Marketing >> '+emailMap.get(whoId));
            List<String> emailList = new List<String>();
            if(emailMap.containskey(whoId)){
                if(emailMap.get(whoId).Customer_Segment__c == 'Channel Partner'){
                    emailList  = channelEmailList;
                    if(templateMap.containskey('Channel_Partners_Web_Form_Submission_HS')){
                        emailTemplateId = templateMap.get('Channel_Partners_Web_Form_Submission_HS');
                    } 
                }else{
                    if(templateMap.containskey('Management_Web_Form_Submission_HS')){
                        emailTemplateId = templateMap.get('Management_Web_Form_Submission_HS');
                    }
                    emailList  = webEmaillList;
                }
            }
            
            
            system.debug('emailTemplateId  >>'+emailTemplateId);
            if(String.isNotBlank(emailTemplateId )){
                Messaging.SingleEmailMessage email = campaignMemberHelper.getMailMessage(emailTemplateId,whoId,emailMap.get(whoId).Id,owea[0].Id,emailList);
                emailMessageList.add(email);
            }
            
        }
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
        }
        system.debug('setOwner sendMarketingMail End >>');
    }
    public static void sendContactNotification(List<Task> newList,Set<Id> conIdSet){
        system.debug('setOwner sendContactNotification Start >>');
        Map<Id,String> conTaskMap = new Map<Id,String>();
        Map<Id,String> conEmailMap = new Map<Id,String>();
        List<campaignMemberHelper.contactEmailWrapper> conEmailWrapList = new List<campaignMemberHelper.contactEmailWrapper>();
        
        for(Contact con : [Select Id,Account.Owner.Email From Contact Where Id IN:conIdSet]){
            conEmailMap.put(con.Id,con.Account.Owner.Email );
        }
        system.debug('conEmailMap Map '+conEmailMap);
        Set<Id> tskIdSet = new Set<Id>();
        for(task tsk : newList){
            if(conEmailMap.containskey(tsk.WhoId)){
                campaignMemberHelper.contactEmailWrapper cew = new campaignMemberHelper.contactEmailWrapper();
                cew.conId = tsk.whoId;
                cew.taskId = tsk.Id;
                cew.email = conEmailMap.get(tsk.WhoId);
                conEmailWrapList.add(cew);
            }
        }
        if(conEmailWrapList.size() > 0){
            system.debug('conEmailWrapList >>'+conEmailWrapList);
            campaignMemberHelper.sendContactEmail(conEmailWrapList,'Hubspot');
        }
        system.debug('setOwner sendContactNotification End >>');
    }
    public static void updateCurrentstatus(List<Task> newlist) {
        system.debug('setOwner updateCurrentstatus Start >>');
        system.debug('newlist>> '+newlist);
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,String> oppStatusMap  = new Map<Id,String>();
        for(Task tsk : newList){
            if(tsk.WhatId!=null && tsk.status == 'Completed'){
                if(String.valueOf(tsk.whatId).startsWith('006')){
                    oppIdSet.add(tsk.WhatId);
                    oppStatusMap.put(tsk.WhatId,tsk.Subject);
                }
            }
        }
        system.debug('oppIdSet>> '+oppIdSet);
        List<opportunity> oppList = new List<opportunity>();
        for(Opportunity opp : [Select Id,Current_status__c from opportunity where stageName !='Closed Won' and id in : oppStatusMap.keyset()]){
            if(opp.Current_status__c == null){
                if(oppStatusMap.containskey(opp.Id)){
                    opp.Current_Status__c = oppStatusMap.get(opp.Id);
                    oppList.add(opp);
                }
            }
        }
        if(oppList.size() >0){
            update oppList;
        }
        system.debug('setOwner updateCurrentstatus End >>');
    }
    
    
    public static void updatetaskforDescription(List<Task> newlist) {
        system.debug('setOwner updatetaskforDescription Start >>');
        map<Id,Campaign> Campaignmap = new map<Id,Campaign>([Select Id,Name From Campaign]);
        for(Task tsk : newlist){
            if(tsk.Description != null){
                system.debug(tsk.Description);
                for(String str : tsk.Description.split('\\n')){
                    system.debug(str);
                    if(string.isNotBlank(str)){
                        
                        if(str.split(':').size() >1){
                            string fieldName = str.split(':')[0];
                            string fieldValue = str.split(':')[1];
                            if(fieldName == 'Company name'){
                                tsk.Company_Name__c = fieldValue;
                            }
                            if(fieldName == 'Employee Count'){
                                system.debug('Employee Count'+fieldValue);
                                if(string.valueOf(fieldValue).contains('-')){
                                    if(fieldValue.split('-').size() == 2){
                                        tsk.Employee_Count__c = String.valueOf(fieldValue.split('-')[1]);
                                    }
                                }else{
                                    tsk.Employee_Count__c = String.valueOf(fieldValue.trim());
                                }
                            }
                            if(fieldName == 'sfCampaignId'){
                                system.debug('campaign Id '+fieldValue);
                                if(string.isNotBlank(fieldValue)){
                                    if(Campaignmap.containskey(fieldValue.trim())){
                                        tsk.Campaign_Name__c = Campaignmap.get(fieldValue.trim()).Name; 
                                    } 
                                }
                                
                            }
                        }
                    }
                }    
            }
            
        }
        system.debug('setOwner updatetaskforDescription End >>');
        
    }
    
    public static void updateLeadSource(List<Task> taskList){
        system.debug('setOwner updateLeadSource Start >>');
        Set<Id> LeadIds = new Set<Id>();
        Set<Id> conIds = new set<Id>();
        Map<Id,String> leadSourceMap = new Map<Id,String>();
        Map<Id,string> ConMap = new Map<Id,string>();
        
        for(Task t : taskList){
          if(t.whoId !=null && string.valueOf(t.whoId).startsWith('00Q')){
              LeadIds.add(t.WhoId);
          }
          if(t.whoId !=null && string.valueOf(t.whoId).startsWith('003')){
              conIds.add(t.WhoId);
          }
        }
        
        for(Lead led : [Select id,LeadSource from Lead Where id=:LeadIds]){
            leadSourceMap.put(led.Id,led.LeadSource);
        }
        for(Contact con : [select Lead_Source__c from contact where id in :conIds ]){
            ConMap.put(con.id,con.Lead_Source__c);
        }
        
        for(Task tsk : taskList){
          if(leadSourceMap.containsKey(tsk.whoId)){
              tsk.Lead_Source__c = leadSourceMap.get(tsk.whoId);
          }
          if(ConMap.containsKey(tsk.whoId)){
              tsk.Lead_Source__c = ConMap.get(tsk.whoId);
          }
        }
        system.debug('setOwner updateLeadSource End >>');
    }
    
    public static void setLeadAndContact(List<Task> tasklist){
        for(Task tsk : tasklist){
            if(tsk.WhoId != null){
                if(String.valueOF(tsk.WhoId).startsWith('00Q')){
                    tsk.Lead__c = tsk.WhoId;
                    tsk.Contact__c = null;
                }else if(String.valueOF(tsk.WhoId).startsWith('003')){
                    tsk.Lead__c = null;
                    tsk.Contact__c = tsk.WhoId;
                }
            }
        }
    }
}