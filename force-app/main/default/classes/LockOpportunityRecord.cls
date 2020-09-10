public class LockOpportunityRecord {
    @AuraEnabled
    public static Boolean checkUser(String recordId){
        List<String> userList = label.LockOpportunity.split(',');
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Id,StageName FROM Opportunity WHERE Id =:recordId Limit 1];
        if(oppList.size() > 0){
            if(userList.contains(Userinfo.getUserId()) && oppList[0].StageName == 'Closed Won'){
                system.debug('userList : '+userList);
                return true;
            }
        }
        return false;
    }
    @AuraEnabled
    public static string LockOpportunity(String recordId) {
        system.debug('recordId : '+recordId);
        string success ='';
        try {
            
            List<Opportunity> opportunityListToLock = new List<Opportunity>();
            opportunityListToLock = [SELECT Id,StageName FROM Opportunity WHERE StageName = 'Closed Won' AND Id =:recordId limit 1];
            system.debug('opportunityListToLock1:'+opportunityListToLock );
            Approval.LockResult[] lockResult = Approval.lock(opportunityListToLock, false);
            system.debug('lockResult1:'+lockResult);
            if (lockResult[0].isSuccess()) {
                success =  'Success';
                system.debug('success:'+success );
            }else{
                success =  'Failed To Update';
                system.debug('success11:'+success );
            }
        }catch(exception e){
            success = 'Error'+e.getMessage();
        }  
        return success;
    }
    public class OpportunityWrapper{
        
        @AuraEnabled public String message;
        //@AuraEnabled public Boolean isError;
    } 
}