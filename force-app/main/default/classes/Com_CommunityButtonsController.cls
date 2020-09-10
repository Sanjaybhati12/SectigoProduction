public class Com_CommunityButtonsController {
	@AuraEnabled
    public static User getLoginUser(){
        return [SELECT Id, LastName, Username, Name, Email, IsActive, Show_SCM_Dev_Login__c, Show_SCM_Login__c, 
                SCM_Login__c, SCM_Dev_Login__c, Show_Reseller_Portal__c, Reseller_Portal__c 
                FROM User 
                where ID=: UserInfo.getUserId()];
    }
}