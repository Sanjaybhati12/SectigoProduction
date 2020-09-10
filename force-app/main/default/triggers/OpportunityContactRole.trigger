trigger OpportunityContactRole on OpportunityContactRole (before insert, before Update, after insert,after update) {
    if(Trigger.isAfter &&  trigger.isInsert){
        Map<id,OpportunityContactRole> oppcontacrole = new Map<id,OpportunityContactRole>();
        for(OpportunityContactRole oppconrole:[Select Id,opportunityId,IsPrimary,ContactId,Opportunity.RecordType.Name From OpportunityContactRole WHere Id IN:Trigger.new]){
            system.debug('oppconrole >'+oppconrole);
            if(oppconrole.Opportunity.RecordType.Name == 'Enterprise'){
               oppcontacrole.put(oppconrole.opportunityid,oppconrole);
            }
        }
        List<Lead> LeadList = New List<Lead>();
        
        if(oppcontacrole.size()>0)
        OpportunityContactRoleHelperClass.contactcampmember(oppcontacrole);
        
    }
    
    if(trigger.isInsert && trigger.isAfter){
        system.debug('Opp Con Inserted');
        OpportunityContactRoleHelperClass.DMCheckboxupdate(Trigger.New);
    }
}