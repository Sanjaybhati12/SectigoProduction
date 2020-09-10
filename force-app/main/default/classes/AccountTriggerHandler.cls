public class AccountTriggerHandler{
    public static void createAccountShare(List<Account> newList){
        Set<Id> channelIdSet = new Set<Id>();
        Map<Id,Id> channelMap = new Map<Id,Id>();
        Map<Id,Id> roleMap = new Map<Id,Id>();
        for(Account acc : newList){
            if(acc.Channel_partner__c != null){
                channelIdSet.add(acc.Channel_partner__c);
                channelMap.put(acc.Id,acc.Channel_partner__c);
            }
        }
        List<UserRole> userRoleList = [SELECT Name, Id, ParentRoleId, PortalAccountId FROM UserRole Where PortalAccountId =:channelIdSet];
        for(UserRole ur : userRoleList){
            roleMap.put(ur.PortalAccountId,ur.Id);
        }
        List<Group> groupList = [Select Id, Name, RelatedId, Type From Group Where RelatedId=:roleMap.values() and type='RoleAndSubordinates'];
        Map<Id,Id> groupMap = new Map<Id,Id>();
        for(Group grp : groupList){
            groupMap.put(grp.RelatedId,grp.Id);
        }
        List<AccountShare> accShareList = new List<AccountShare>();
        for(Account acc : newList){
            if(channelMap.containskey(acc.Id)){
                if(roleMap.containskey(channelMap.get(acc.Id))){
                    if(groupMap.containskey(roleMap.get(channelMap.get(acc.Id)))){
                        AccountShare Acctshr = new AccountShare();
                        Acctshr.AccountId = acc.Id;
                        Acctshr.UserOrGroupId = groupMap.get(roleMap.get(channelMap.get(acc.Id)));
                        Acctshr.AccountAccessLevel = 'Edit';
                        Acctshr.OpportunityAccessLevel = 'Edit';
                        accShareList.add(Acctshr);
                    }
                }
            }
        }
        if(accShareList.size() > 0){
            insert accShareList;
        }
    }
}