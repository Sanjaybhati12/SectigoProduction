/** Trigger Name   : createQualifyingQuestions 
*  Description  : Whenever lead is converted , create a new record in qualify question and capture the contact ,opportunity information
*  Created By   : Agile Cloud Consulting 
*  Created On   : 10-07-2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
trigger createQualifyingQuestions on Lead (before Insert,before update,after update,before delete,after insert) {
    
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.isUpdate)){
        // Except Channel Partner Round Robin
        leadTriggerHelper.RoundRobinFunctionality(trigger.new);
        //Round Robin for channel Partner
        
    }
    
    // Update Qualifying question related to lead
    if(Trigger.Isafter && Trigger.IsUpdate){
        Map<Id,Lead> leadmap= new Map<Id,Lead>();
        for(Lead eachLead : Trigger.New){
            if(eachLead.IsConverted == true){
                leadmap.put(eachLead.id,eachLead);
            }
        }
        
        List<Qualifying_Questions__c> existingQQ = [select id,Name,Contact__c,Lead__c,Lead__r.Id,Opportunity__c from Qualifying_Questions__c where Lead__c IN:leadmap.keySet()];
        List<Qualifying_Questions__c> updateQQ= new List<Qualifying_Questions__c>();
        for(Qualifying_Questions__c eachQQ:existingQQ ){
            
            eachQQ.Lead__c = leadmap.get(eachQQ.Lead__r.Id).Id;
            if(leadmap.get(eachQQ.Lead__r.Id).ConvertedContactId!=null){
                eachQQ.Contact__c=leadmap.get(eachQQ.Lead__r.Id).ConvertedContactId;
            }
            if(leadmap.get(eachQQ.Lead__r.Id).ConvertedOpportunityId!=null){
                eachQQ.Opportunity__c=leadmap.get(eachQQ.Lead__r.Id).ConvertedOpportunityId;
            }
            
            updateQQ.add(eachQQ);
        }
        if(updateQQ.size()>0){
            Update updateQQ;
        }
    }
    
    // Only Admin can delete the lead
    if(trigger.isbefore && trigger.isdelete){
        if(UserInfo.getProfileId() != Label.system_admin_profile_id){
            for (Lead led : Trigger.old) {
                led.addError(Label.Error_Message_On_Lead_Delete);
            }
        }
    }
    // Set No of emmployee field and Territory assignment from custom setting
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
        leadTriggerHelper.setNoOfEmployee(trigger.new);
        leadTriggerHelper.TerritoryAssignment(Trigger.New);
        
        // checks email domain
        if(!leadTriggerHelper.isDomainUpdate){
            leadTriggerHelper.checkIsUniversityDomain(trigger.new);  // email domain check
        }
         
    }
    if(trigger.isUpdate && trigger.isAfter){
       if(!leadTriggerHelper.isChannelAssignment){
           //leadTriggerHelper.channelPartnerRoundRobin(trigger.new);
           leadTriggerHelper.roundRobinQueue(trigger.new,System.Label.Channel_Partner_Round_Robin_Queue_Name);
           leadTriggerHelper.roundRobinQueue(trigger.new,System.Label.Retail_Queue_Round_Robin_Queue_Name);
       }
    }
    // On record creation fire lead assignment rule.
    if(trigger.isInsert && trigger.isAfter){
        
        if(!leadTriggerHelper.isLeadAssignment){
            leadTriggerHelper.fireLeadAssignment(trigger.new);
        }
        
    }
    
    // BDR Transfer functionality
    if(trigger.isbefore && trigger.isUpdate){
        for(Lead le:Trigger.new){
            if((trigger.oldMap.get(le.Id).Owner_Role__c != trigger.newMap.get(le.Id).Owner_Role__c) && (le.Owner_Role__c == 'BDR Sales Rep' || le.Owner_Role__c == 'BDR Manager') ){
                 le.BDR_Transfer_Date__c = null;
                 le.BDR_Transfer__c  = false;
            }
            else if((trigger.oldMap.get(le.Id).Owner_Role__c != trigger.newMap.get(le.Id).Owner_Role__c) && (trigger.oldMap.get(le.Id).Owner_Role__c =='BDR Sales Rep' || trigger.oldMap.get(le.Id).Owner_Role__c =='BDR Manager')){
                le.BDR_Transfer_Date__c = system.today();
                le.BDR_Transfer__c   = true;
            }
        }
    }
}