public class OpportunityContactRoleController {
    @AuraEnabled
    public static Boolean getOptyContactRole(string optyId ) {
        List<Opportunity> oppList = [select id , StageName from Opportunity Where id =:optyId];
        List<OpportunityContactRole> optyList = [SELECT OpportunityId, Role, Id FROM OpportunityContactRole where OpportunityId =:optyId];
        if(optyList.isEmpty() && oppList.size() > 0 && oppList[0].StageName != 'Closed Won')
            return true;
        else
            return false;
    }
}