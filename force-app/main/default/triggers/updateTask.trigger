trigger updateTask on Task (before insert,before update,after insert, after delete, after undelete, after update) {
    system.debug('Task Trigger');
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        for(Task eachTsk : Trigger.New){
            if(eachTsk.subject!=null){
                if(eachTsk.subject.startsWith('Outbound')||eachTsk.subject.startsWith('Inbound')){
                    eachTsk.Type='Call';
                }else if(eachTsk.subject.contains('Email:')){
                    eachTsk.Type='Email';
                }
            }
        }
    }
    
    if(Trigger.isAfter && (trigger.isInsert || trigger.isUpdate || Trigger.isDelete || Trigger.ISUndelete)){
        
        //rollUp on Lead
            if(!TaskTriggerHandler.isGeneralActivitiesRollUpOnLead){
                TaskTriggerHandler.GeneralActivitiesRollUpOnLead(trigger.new,Trigger.old);
            }
            
            //rollUp on Contact
            if(!TaskTriggerHandler.isGeneralActivitiesRollUpOnContact){
                TaskTriggerHandler.GeneralActivitiesRollUpOnContact(trigger.new,Trigger.old);
            }
            
            //rollUp on Opportunity
            if(!TaskTriggerHandler.isGeneralActivitiesRollUpOnopportunity){
                TaskTriggerHandler.GeneralActivitiesRollUpOnopportunity(trigger.new,trigger.old);
            }
            
            //get last activity date 
            if(!TaskTriggerHandler.isLastActivityDateRollUpOnLead){
                TaskTriggerHandler.LastActivityDateRollUpOnLead(trigger.new,Trigger.old);
            }
            if(!TaskTriggerHandler.isLastActivityDateRollUpOnContact){
                TaskTriggerHandler.LastActivityDateRollUpOnContact(trigger.new,Trigger.old);
            }
            if(!TaskTriggerHandler.isLastActivityDateRollUpOnOpportunity){
                TaskTriggerHandler.LastActivityDateRollUpOnOpportunity(trigger.new,Trigger.old);
            }
        }
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        TaskWebformHandler.RecordTypeChangeToWebform(trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert){
        Id taskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        List<Task> taskList = new List<Task>();
        for(Task tsk : trigger.new){
            system.debug('Record Type Name >>' +tsk.recordTypeId);
            if(tsk.recordTypeId == taskTypeId){
                taskList.add(tsk);
            }
        }
        system.debug('taskList >> '+taskList);
        if(taskList.size() > 0){
            TaskTriggerHandler.setOwner(taskList);
        }
    }
    if(trigger.isInsert && trigger.isAfter){
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        List<Task> taskList = new List<Task>();
        Set<Id> conIdSet = new Set<Id>();
        Set<String> typeSet = new Set<String>();
        for(String str : Label.Hubspot_Notification_Task_Type.split(',')){
            typeSet.add(str);
        }
        system.debug('typeSet >> '+typeSet);
        for(Task tsk : [Select Id, WhoId,Type,Employee_Count__c,Customer_Segment__c From Task Where (recordTypeId =: taskRecordTypeId) and Type IN : typeSet and Id IN : trigger.new ORDER BY CreatedDate desc ]){
            if(String.isNotBlank(tsk.Employee_Count__c)){
                if(tsk.Employee_Count__c.contains('+')){
                    tsk.Employee_Count__c = tsk.Employee_Count__c.replace('+','');
                }
                if(Integer.valueOf(tsk.Employee_Count__c) > 500){
                    if(typeSet.contains(tsk.Type)){
                        taskList.add(tsk);
                    }
                    if(!conIdSet.contains(tsk.WhoId) && String.valueOf(tsk.WhoId).startsWith('003')){
                        conIdSet.add(tsk.WhoId);
                    }
                }
            }
        }
        system.debug('taskList  >> '+taskList );
        if(taskList.size() > 0){
            TaskTriggerHandler.sendNotification(taskList);
            TaskTriggerHandler.sendContactNotification(taskList,conIdSet);
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        TaskTriggerHandler.updateCurrentstatus(trigger.new);
    }
    if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore){
        List<Task> taskList = new List<Task>();
        Set<String> typeSet = new Set<String>();
        for(String str : Label.Hubspot_Notification_Task_Type.split(',')){
            typeSet.add(str);
        }
        for(Task tsk : trigger.new){
            if(typeSet.contains(tsk.type)){
                taskList.add(tsk);
            }
        }
        if(taskList.size() > 0){
            TaskTriggerHandler.updatetaskforDescription(taskList); 
        }
    }
    if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore){
        TaskTriggerHandler.updateLeadSource(trigger.new); 
        TaskTriggerHandler.setLeadAndContact(trigger.new);
    }
    
    
}