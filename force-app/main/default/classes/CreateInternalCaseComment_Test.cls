@isTest
public class CreateInternalCaseComment_Test{
     private static testmethod void positivescenario(){
     Account acc= new Account();
     acc.Name='test account';
     insert acc;
     Contact con= new Contact();
     con.LastName='abc';
     con.Email='test@abc.com';
     con.Phone='1234';
     insert con;
         Case c= new case();
         c.Reason='Billing';
         c.Status='new';
         c.Origin='Web';
         c.Closing_Note1__c='testing Note';
         
         
        insert c;
        c.Status='Closed';
        c.AccountId=acc.id;
        c.ContactId=con.id;
        
        update c;
        CaseComment cc= new CaseComment();
        cc.ParentId=c.id;
        cc.CommentBody=c.Closing_Note1__c;
        insert cc;
     }
}