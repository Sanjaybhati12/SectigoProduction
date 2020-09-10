@isTest  
public class com_HyperlinkcntrlTest { 
    
    public static testMethod void testCase(){
        
        
        Id p = [select id from profile where name='Customer Community Login User'].id;
        
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,email='vasdasdadsa@gmail.com');
        insert con;  
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, SCM_Dev_Login__c='testtt',Reseller_Portal__c='Hari', SCM_Login__c='jggfhgfh', country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;
        system.runAs(user) {
            // statements to be executed by this test user.
            String tsd= com_Hyperlinkcntrl.getOpenCases();
            String tsd1= com_Hyperlinkcntrl1.getOpenCases();
            String tsd2= com_Hyperlinkcntrl2.getOpenCases();
            Com_CommunityButtonsController.getLoginUser();
        }
        
        
        
    }
    
    
}