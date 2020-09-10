@isTest(SeeAllData=true)
public class AccountTriggerHandler_Test {
    
    @istest static void setupData() { 
        Account acc = new Account(
            Name = 'Test Acc',
            ShippingCountry = 'US'
            
        );
        insert acc;
        UserRole r = [SELECT Name, Id, ParentRoleId, PortalAccountId FROM UserRole WHERE portalType = 'CustomerPortal' limit 1 ];
        
        account acc1  = new account( name = 'testb ', ShippingCountry = 'US',Channel_partner__c = r.PortalAccountId);
        insert acc1;
       
    }
}