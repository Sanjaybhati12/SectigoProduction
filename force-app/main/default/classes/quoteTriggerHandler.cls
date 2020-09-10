public class quoteTriggerHandler{
    public static Boolean isPrimarySet = false;
    public static void setPrimaryQuote(List<SBQQ__Quote__c> newList){
        system.debug('Quote List'+newList);
        Map<Id,List<SBQQ__Quote__c>> quoteMap = new Map<Id,List<SBQQ__Quote__c>>();
        Set<Id> oppIdSet = new Set<Id>(); 
        for(SBQQ__Quote__c quote : newList){
            system.debug('Quote List Step-1'+quote);
            if(quote.SBQQ__Opportunity2__c != null){
                oppIdSet.add(quote.SBQQ__Opportunity2__c);
            }
        }
        system.debug('oppIdSet--->3'+oppIdSet);
        if(oppIdSet.size() > 0){
            List<SBQQ__Quote__c> quoteList = [Select Id,Name,SBQQ__Opportunity2__c From SBQQ__Quote__c Where SBQQ__Opportunity2__c IN:oppIdSet];
            system.debug('oppIdSet ---->4'+quoteList);
            for(SBQQ__Quote__c quote : quoteList ){
                system.debug('oppIdSet ---->5'+quote);
                if(quote.SBQQ__Opportunity2__c != null){
                    List<SBQQ__Quote__c> tempList = new List<SBQQ__Quote__c>();
                    if(quoteMap.containskey(quote.SBQQ__Opportunity2__c)){
                        tempList = quoteMap.get(quote.SBQQ__Opportunity2__c);
                    }
                    tempList.add(quote);
                    system.debug('oppIdSet ---->6'+tempList);
                    quoteMap.put(quote.SBQQ__Opportunity2__c,tempList);
                }
            }
        }
        system.debug('quoteMap >>'+quoteMap);
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quote : newList){
            System.debug('quote'+quote);
            SBQQ__Quote__c qt = new SBQQ__Quote__c();
            if(quoteMap.containskey(quote.SBQQ__Opportunity2__c)){
                if(quoteMap.get(quote.SBQQ__Opportunity2__c).size() == 1){
                    qt.Id = quote.Id;
                    qt.SBQQ__Primary__c = true;
                    quoteList.add(qt);
                }
            }
        }
        update quoteList;
        quoteTriggerHandler.isPrimarySet = true;
        
    }
    
}