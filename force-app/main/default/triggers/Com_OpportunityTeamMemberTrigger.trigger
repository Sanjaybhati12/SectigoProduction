trigger Com_OpportunityTeamMemberTrigger on OpportunityTeamMember (after insert, after Update, after delete) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        Com_OpportunityTeamMemberTriggerHelper.updateSalesEngineerAddedCheckbox(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isDelete){
        Com_OpportunityTeamMemberTriggerHelper.updateSalesEngineerAddedCheckbox(Trigger.old);
    }
}