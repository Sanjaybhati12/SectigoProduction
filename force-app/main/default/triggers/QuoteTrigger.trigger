trigger QuoteTrigger on SBQQ__Quote__c (after insert,before update) {
    
    if(trigger.isInsert && trigger.isAfter){
        system.debug('Before Insert Qutote Insert Inner If');
        if(!quoteTriggerHandler.isPrimarySet){
            system.debug('Qutote Insert Inner If');
            quoteTriggerHandler.setPrimaryQuote(trigger.new);
        }
    }
    
}