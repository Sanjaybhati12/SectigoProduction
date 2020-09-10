/**
* Test class for the AssociateEmailWithCaseCommentTest trigger.
*
* @see         AssociateEmailWithCaseCommentTest .cls
*
* @version     2018-14-06 Veera     first version
*              
*/
@isTest 
public class AssociateEmailWithCaseCommentTest {
    @isTest(SeeAllData= true)
    public static  void testEmailMessage() { 
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        Contact con = new Contact();
        con.lastName = 'Test';
        con.AccountId = acc.Id;
        insert con;
        Case cse = [Select Id,Subject,ClosedDate From Case Where AccountId != null and ContactId != null and ClosedDate != null and IsClosed = True order by ClosedDate asc limit 1]; 
		system.debug('case >>'+cse);
        EmailMessage newEmail = new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'test email ref: Test email :ref',HtmlBody='<html><body>Hi veera ,Changes have been made to your details. <br><br>Contact administrator if you are not responisble.</body></html>', TextBody = '23456 ', ParentId = cse.Id); 
        insert newEmail;
        
        Attachment attach=new Attachment(); 
        attach.Name = 'Unit Test Attachment'; 
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body'); 
        attach.body = bodyBlob; 
        attach.parentId = newEmail.id;
        insert attach;
        
    }
    static testMethod void testEmailMessage2() { 
        Case cse=new Case(Subject= 'In Service Billable - A29'); 
        insert cse; 
        
        EmailMessage newEmail = new EmailMessage(FromAddress = 'test@abc.org', Incoming = false , ToAddress= 'ref:hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com:ref', Subject = 'Test email',HtmlBody='<html><body>Hi veera ,Changes have been made to your details. <br><br>Contact administrator if you are not responisble.</body></html>', TextBody = '23456 ', ParentId = cse.Id); 
        insert newEmail;
        
        
    }
    
    static testmethod void testdelete(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        System.runAs(u) {
            Case cse= new Case(Subject= 'In Service Billable - A29');
            insert cse; 
            system.debug('cse.ClosedDate >>'+cse.ClosedDate);
            EmailMessage newEmail = new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'test email ref: Test email :ref',HtmlBody='<html><body>Hi veera ,Changes have been made to your details. <br><br>Contact administrator if you are not responisble.</body></html>', TextBody = '23456 ', ParentId = cse.Id); 
            insert newEmail;
            
            try{
                delete newEmail;
            }catch(Exception e){
                system.assert(e.getMessage().contains('You are not authorized to delete the record'),'You are not authorized to delete the record');   
                
            }
        }
        
    }
    
}