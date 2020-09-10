/*
This batch class updates the touch point fields on leads, contacts and opportunities based on the general completed tasks.
This is meant to run only once for the old data that has to be updated, there is a trigger for future data.

Date: 31-07-2019

*/

global class UpdateTouchPointsBatch implements Database.Batchable<sObject>{
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = 'Select Id,WhoId,whatId From Task Where RecordTypeId=\''+generalRecordTypeId+'\' and Status=\'Completed\' and Type!=\'Webform\' and Type!=\'Reminder\' and Type!=\'Automated Email\'';
        return Database.getQueryLocator(queryString );
    }
    
    global void execute(Database.BatchableContext bc, List<Task> scope){
        // process each batch of records
       
       
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        
        map<id,lead> leads = new map<id,lead>();
        map<id,contact> contacts = new map<id,contact>();
        map<id,opportunity> opportunities = new map<id,opportunity>();
        
        String leadPrefix = lead.SObjectType.getDescribe().getKeyPrefix();
        String contactPrefix = contact.SObjectType.getDescribe().getKeyPrefix();
        String opportunityPrefix = opportunity.SObjectType.getDescribe().getKeyPrefix();
        
        for(task tsk : scope){
             if(tsk.WhoId != null && String.valueOf(tsk.WhoId).startsWith(leadPrefix)){
                 
                 leads.put(tsk.whoid,null);
             }
             if(tsk.WhoId != null && String.valueOf(tsk.WhoId).startsWith(contactPrefix)){
                 
                  contacts.put(tsk.whoid,null);
             }
             if(tsk.WhatId != null && String.valueOf(tsk.WhatId).startsWith(opportunityPrefix)){
                
                 opportunities.put(tsk.whatid,null);
             }
        }
        //lead last touch point
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
            
            Database.SaveResult[] SR =  Database.update(leads.values(),false);
            system.debug('lead result: '+SR);
        }
        
        //contact last touch point
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
           
            Database.SaveResult[] SRC =  Database.update(contacts.values(),false);
            system.debug('contact result: '+SRC);
        }
        
        //opportunity last touch point
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
           
            Database.SaveResult[] SRO =  Database.update(opportunities.values(),false);
            system.debug('contact result: '+SRO);
        }
        
        
        Set<ID> LeadIds = new Set<ID>();
        //We only care about tasks linked to Leads.
        
        //Add any Lead ids coming from the new data
        
            for (Task t : scope) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) ) {
                    if(!LeadIds.contains(t.WhoId)){
                        //adding unique lead ids since there can be many tasks with single lead
                        LeadIds.add(t.WhoId);
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
                //update leadsUpdatable;
                Database.SaveResult[] SR1 =  Database.update(leadsUpdatable,false);
                system.debug('lead result: '+SR1);
                //update all the leads with activity count
            }
        }
        
        
        Set<ID> ContactIds = new Set<ID>();
        //We only care about tasks linked to Contacts.
        
        //Add any Contact ids coming from the new data
        
            for (Task t : scope) {
                if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(ContactPrefix) ) {
                    if(!ContactIds.contains(t.WhoId)){
                        //adding unique Contact ids since there can be many tasks with single Contact
                        ContactIds.add(t.WhoId);
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
                //update ContactsUpdatable;
                Database.SaveResult[] SRC1 =  Database.update(ContactsUpdatable,false);
                system.debug('contact result: '+SRC1);
                //update all the Contacts with activity count
            }
        }
        
        
        
        Set<ID> opportunityIds = new Set<ID>();
        //We only care about tasks linked to opportunities.        
        //Add any opportunity ids coming from the new data
        
            for (Task t : scope) {
                if (t.WhatId!= null && string.valueof(t.WhatId).startsWith(opportunityPrefix) ) {
                    if(!opportunityIds.contains(t.WhatId)){
                        //adding unique opportunity ids since there can be many tasks with single opportunity
                        opportunityIds.add(t.WhatId);
                    }
                }
            }
        
        if (opportunityIds.size() > 0){
            List<opportunity> opportunitiesWithTasks = [select id,Number_of_General_Activities__c,(select id,status,recordtypeid from Tasks where RecordTypeId =: generalRecordTypeId and Status =: 'Completed' and Type!='Webform' and Type!='Reminder' and Type!='Automated Email') from opportunity where Id IN : opportunityids];
            List<opportunity> opportunitiesUpdatable = new List<opportunity>();
            for(opportunity L : opportunitiesWithTasks){
                L.Number_of_General_Activities__c = L.Tasks.size();
                opportunitiesUpdatable.add(L);
            }
            if(opportunitiesUpdatable.size()>0){
                //update opportunitiesUpdatable;
                Database.SaveResult[] SRO1 =  Database.update(opportunitiesUpdatable,false);
                system.debug('contact result: '+SRO1);
                //update all the opportunities with activity count
            }
        }
        
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}