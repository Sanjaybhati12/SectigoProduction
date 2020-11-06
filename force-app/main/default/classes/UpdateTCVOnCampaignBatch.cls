global class UpdateTCVOnCampaignBatch implements Database.Batchable<sObject>, Database.Stateful{
	
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query = 'SELECT ID,Name,TCV_Value_Won_Opportunities__c,TCV_Value_Lost_Opportunities__c,TCV_Value_Opportunities_in_Campaign__c,(SELECT Id,Name,TCV__c,StageName FROM Opportunities) FROM Campaign ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Campaign> campaignList){
       List<Campaign> campListToUpdate = new List<Campaign>();
        for(Campaign cmp : campaignList){
            Decimal totalTcv = 0 ;
            Decimal totalTcvWon = 0 ;
            Decimal totalTcvLost = 0;
            for(Opportunity op : cmp.opportunities){
                totalTcv += op.TCV__c;
                if(op.StageName == 'Closed Won'){
                    totalTcvWon += op.TCV__c;
                }else if(op.StageName == 'Closed Lost'){
                    totalTcvLost += op.TCV__c;
                }
            }
            cmp.TCV_Value_Opportunities_in_Campaign__c = totalTcv;
            cmp.TCV_Value_Lost_Opportunities__c = totalTcvLost;
            cmp.TCV_Value_Won_Opportunities__c = totalTcvWon;
            campListToUpdate.add(cmp); 
        }
        
        try{
            if(campListToUpdate.size() > 0){update campListToUpdate;}
        }catch(dmlexception e){}
    }
    global void finish(Database.BatchableContext bc){
        
    }  
}