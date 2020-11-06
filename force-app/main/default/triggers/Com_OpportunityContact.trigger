trigger Com_OpportunityContact on Opportunity (before Update,after update,before insert,after insert, after delete) {
    
    OpportunityController__c control = OpportunityController__c.getInstance();
    if(trigger.isInsert){
        Com_OpportunityContactHelperClass.insertCall = true;
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        Com_OpportunityContactHelperClass.checkProductAndContactRole(trigger.new,trigger.oldMap);
        if(control.Check_Campaign_On_Lead_Source__c){
            Com_OpportunityContactHelperClass.PrimaryCampaignInfo(Trigger.New);
        }
        if(control.Set_BDR_Transfer__c){
            Com_OpportunityContactHelperClass.setBDRTransfer(trigger.new,trigger.oldMap,trigger.newMap);
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        // Logic for Related Quote Updates
        Set<Id> SetDealOppID = new Set<Id>();
        Set<Id> SetContractOppID = new Set<Id>();
        Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();        
        Id oppEnterPriseId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        List<Opportunity> OppDealAp = new List<Opportunity>();
        List<Opportunity> OppConRevi = new List<Opportunity>();
        for(Opportunity oppquote: Trigger.New){
            if(oppquote.RecordTypeId == OppRetailRecId || oppquote.RecordTypeId == oppEnterPriseId  && trigger.oldMap.get(oppquote.Id).StageName != oppquote.StageName){
                if(oppquote.StageName == 'Contract Review/Redline'){
                    SetContractOppID.add(oppquote.Id);
                    SetDealOppID.add(oppquote.Id);
                } 
                /*else if(oppquote.StageName == 'Deal Approval'){ 
                    SetDealOppID.add(oppquote.Id);
                }*/
            }
        }
        if(control.Set_Primary_Quote_Approved__c){
            if(SetDealOppID.size()>0){
                Com_OpportunityContactHelperClass.aproveisPrimary(SetDealOppID,trigger.OldMap);
            }
        }
        if(control.Set_Primary_Quote_Discount_Approve__c){
            if(SetContractOppID.size() > 0){
               Com_OpportunityContactHelperClass.PrimaryQuoteDA(SetContractOppID,trigger.OldMap);  
            }
        }
        if(control.Create_Task_On_Update__c){
            // Logic for Create Task on opportunity
            if(!Com_OpportunityContactHelperClass.isTaskCreated){
                List<Opportunity> oppList = new List<Opportunity>();
                Set<Id> oppIdSet = new Set<Id>();
                for(Opportunity opp :  [Select Id,OwnerId,Current_Status__c From Opportunity Where Current_Status__c != null And Id IN:trigger.new]){
                    if(trigger.oldMap.get(opp.Id).Current_Status__c != opp.Current_Status__c){
                        oppList.add(opp);
                    } 
                }
                if(oppList.size() > 0){
                    Com_OpportunityContactHelperClass.createTaskOnUpdate(oppList);
                }
            }
        }
    }
     if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore){
        if(control.Set_Price_Book__c){
            Com_OpportunityContactHelperClass.setPriceBook(trigger.new);
        }
    } 

    if(trigger.isAfter && trigger.isUpdate){
        Com_OpportunityContactHelperClass.validateOpportunityTransfer(trigger.new ,trigger.OldMap);
    }
    
    // Update TCV Values on Campaign
    if( trigger.isAfter && (trigger.IsInsert || Trigger.IsUpdate) ){
        Com_OpportunityContactHelperClass.updateTCVOnCampaign(trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete){
        system.debug(trigger.old);
        Com_OpportunityContactHelperClass.updateTCVOnCampaign(trigger.old);
    }
    
    
}