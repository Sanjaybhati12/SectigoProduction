global class InternalCommentCount implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Total_Internal_Comments__c From Case Where ContactId !=null and AccountId != null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        Map<Id,Integer> countMap = new Map<Id,Integer>();
        try{
            for(CaseComment cc : [Select Id,ParentId From CaseComment where ParentId IN:caseList]){
                Integer temp = 0;
                if(countMap.containskey(cc.ParentId)){
                    temp = countMap.get(cc.ParentId);
                }
                temp += 1;
                countMap.put(cc.ParentId,temp);
            }
            List<Case> updateList = new List<Case>();
            
            for(Case cs : caseList){
                if(countMap.containskey(cs.Id)){
                    cs.Total_Internal_Comments__c = countMap.get(cs.Id);    
                    updateList.add(cs);
                }
            } 
            system.debug('caseList >>'+caseList);
            Database.update(updateList, false);
        }catch(exception ex){
            
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
    }
}