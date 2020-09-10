trigger ContactTrigger on Contact (before delete,before update) {
     if(trigger.isbefore && trigger.isdelete){
       if(UserInfo.getProfileId() != Label.system_admin_profile_id){
            for (Contact con : Trigger.old) {
                con.addError(Label.Error_Message_On_Contact_Delete);
            }
        }
    }
    if(trigger.isbefore && trigger.isUpdate){
        for(contact con:Trigger.new){
            system.debug('Old ROle >> '+trigger.oldMap.get(con.Id).Owner_Role__c);
            system.debug('New Role >> '+trigger.newMap.get(con.Id).Owner_Role__c);
            if((trigger.oldMap.get(con.Id).Owner_Role__c != trigger.newMap.get(con.Id).Owner_Role__c) && (con.Owner_Role__c == 'BDR Sales Rep' || con.Owner_Role__c == 'BDR Manager')){
                 con.BDR_Transfer_Date__c = null;
                 con.BDR_Transfer__c = false;
            }
            else if((trigger.oldMap.get(con.Id).Owner_Role__c != trigger.newMap.get(con.Id).Owner_Role__c) && ((trigger.oldMap.get(con.Id).Owner_Role__c =='BDR Sales Rep') || (trigger.oldMap.get(con.Id).Owner_Role__c =='BDR Manager'))){
                con.BDR_Transfer_Date__c = system.today();
                con.BDR_Transfer__c = true;
            }
        }
        //List<Contact> conList = [Select Id,RecordTypeId,Account.SCM__c,AccountId,Owner_Role__c,key_Contact__c From Contact Where Id IN:trigger.new];
        Set<id> accIdSet = new Set<Id>();
        for(Contact con :  trigger.new){
            accIdSet.add(con.AccountId);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Scm__c From Account WHere Id In:accIdSet]);
        ContactOwnerRoleUpdate.updatekeyconatct(trigger.new,Trigger.oldMap,Trigger.newMap,accMap);
    }
}