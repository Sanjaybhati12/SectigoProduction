public class EnterpriseCustomerTiles_Controller {
    @AuraEnabled
    public static AccountWrapper getwrapper() {
        AccountWrapper accWrap = new AccountWrapper();
        User currentUser =  [SELECT id, Username, ContactId,Account.Enterprise_Premier__c,AccountId,Contact.AccountId FROM User
                             where id =:UserInfo.getUserId() limit 1]; 
        accWrap.accountId = currentUser.Contact.AccountId;
        if(currentUser.Contact.AccountId  != null){
            if(currentUser.Account.Enterprise_Premier__c == True){
                accWrap.Enterprise = true;
            }else{
                accWrap.Enterprise = false;
            }
            
            // Learning code
            list<string> accValue =  label.Community_Learning_Tile_Account.split(',');
            if(accValue.contains(currentUser.Contact.AccountId)){
                accWrap.learning = true;
            }else{
                accWrap.learning = false;
            }
            
        }
        return accWrap;
    }
    public class AccountWrapper{
        @AuraEnabled
        public Boolean learning {get;set;}
        @AuraEnabled
        public Boolean Enterprise {get;set;}
        @AuraEnabled
        public String accountId {get;set;}
    }
    
    // Community Buttons Merged : 14-09-2020 - added by Sanjay
    @AuraEnabled
    public static User getLoginUser(){
        return [SELECT Id, LastName, Username, Name, Email, IsActive, Show_SCM_Dev_Login__c, Show_SCM_Login__c, 
                SCM_Login__c, SCM_Dev_Login__c, Show_Reseller_Portal__c, Reseller_Portal__c 
                FROM User 
                where ID=: UserInfo.getUserId()];
    }
    
    
}