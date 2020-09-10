public class Com_OpportunityTeamMemberTriggerHelper {
    public static void updateSalesEngineerAddedCheckbox(List<OpportunityTeamMember> lstOpptyTeamMembers){
        Set<Id> setParentOpptys = new Set<Id>();
        for(OpportunityTeamMember member : lstOpptyTeamMembers){
            setParentOpptys.add(member.OpportunityId);
        }
        
        List<Opportunity> lstRightOpty = [Select id,Sales_Engineer_Added__c from Opportunity where Sales_Engineer_Added__c != true AND ID in :setParentOpptys AND ID in (Select OpportunityId from OpportunityTeamMember where TeamMemberRole = 'Sales Engineer')];
        List<Opportunity> lstWrongOpty = [Select id,Sales_Engineer_Added__c from Opportunity where Sales_Engineer_Added__c = true AND ID in :setParentOpptys AND ID NOT in (Select OpportunityId from OpportunityTeamMember where TeamMemberRole = 'Sales Engineer')];
        
        List<Opportunity> lstOpptyToUpdate = new List<Opportunity>();
        
        
        if(lstRightOpty != null && lstRightOpty.size() > 0){
            for(Opportunity op : lstRightOpty){
                op.Sales_Engineer_Added__c = true;
                lstOpptyToUpdate.add(op);
            }
        }
        
        if(lstWrongOpty != null && lstWrongOpty.size() > 0){
            for(Opportunity op : lstWrongOpty){
                op.Sales_Engineer_Added__c = false;
                lstOpptyToUpdate.add(op);
            }
        }
        
        if(lstOpptyToUpdate != null && lstOpptyToUpdate.size() > 0){
            update lstOpptyToUpdate;
        }
        
    }
}