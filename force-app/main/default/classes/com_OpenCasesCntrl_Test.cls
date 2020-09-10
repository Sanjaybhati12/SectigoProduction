@isTest
public class com_OpenCasesCntrl_Test{
   private static testMethod void positivescenario(){
      Account acc= new Account();
   acc.Name='Acc open case test';
   insert acc;
      Contact con= new Contact();
      con.LastName='test conopencase';
      con.Email='testconcasee@gmail.com';
      con.Accountid=acc.id;
      insert con;
      Case cs= new case();
      cs.Reason='Billing';
      cs.Status='New';
      cs.Origin='web';
      //cs.AccountId=acc.id;
      //cs.ContactId=con.id;
      insert cs;
      com_OpenCasesCntrl.getOpenCases(cs.id);
      com_OpenCasesCntrl.getaccess();
   }
}