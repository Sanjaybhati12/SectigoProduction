/** Class Name   : Com_RetailOppCntrlTest
*  Description  : Test class for "Com_RetailOppCntrl"  
*                     
*  Created By   : AgileCluod
*  Created On   : 27th Jan 2019

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
@isTest
public class Com_RetailOppCntrlTest{
  private static testmethod void positivescenario(){
      
      
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole ur = new UserRole(DeveloperName = 'Retail_Rep1', Name = 'Retail Rep');
       insert ur;
        User tuser = new User(  firstname = 'testfname',
                                lastName = 'testlName',
                                email = 'test123jhjhygsd@gmail.com',
                                Username = 'testuser123df@test.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'stval',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = pf.Id,
                                UserRoleId = ur.id);
        insert tuser;
        System.runAs(tuser){
        Account acc= new Account();
      acc.Name='Test acc';
      
      insert acc;
      Contact con= new Contact();
      con.LastName='Test con';
      con.Email='test@gmail.com';
      insert con;
      Case cs= new Case();
      cs.Status='New';
      cs.Reason='Billing';
      cs.Origin='Web';
      cs.IsRetailOpportunity__c =false;
      insert cs;
        
        Com_RetailOppCntrl.createOppr(cs.id);
        }
        

      
  }
}