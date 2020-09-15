@isTest
public class EnterpriseCustomerTiles_Controller_Test {
    public static testMethod void test1() {
        Id p = [select id from profile where name='Customer Community Plus User'].id;
        
        Account ac = new Account(name ='Grazitti',Enterprise_Premier__c=true) ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,email ='test@gmail.com' , Phone = '43656');
        insert con;  
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             SCM_Login__c='www.testurl.com', SCM_Dev_Login__c='www.testurl.com', Show_SCM_Login__c=true,
                             Show_SCM_Dev_Login__c=true, Reseller_Portal__c='www.testurl.com', Show_Reseller_Portal__c=true,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;
        system.runAs(user) {
            EnterpriseCustomerTiles_Controller.getwrapper();
            EnterpriseCustomerTiles_Controller.getLoginUser();
        }
        
    }
}