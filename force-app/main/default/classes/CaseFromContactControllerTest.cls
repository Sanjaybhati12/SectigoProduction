@isTest
public class CaseFromContactControllerTest {
    static testMethod void caseFromContact(){
        Id casRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
        
        Contact c=new Contact(); 
        c.FirstName='test';
        c.LastName = 'contact';
        c.Email = 'email@gmail.com';
        c.Phone = '9743800001';
        c.Description = 'tesingcontact';
        c.Survey_Date__c=System.today();
        c.Do_NotSurvey__c =True;
        insert c; 
        Task t = new task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Submitted Form';
        t.Status='Not Started';
        t.Priority='Normal';
        t.Description = 'abc';
        t.WhoId = c.id;
        t.Case_Created__c = false;
        t.subject ='submitted Form';
        insert t;
        //update t;
        Case cs = new case();
        cs.status ='new';
        cs.Reason = 'Technical Certificate Manager';
        cs.Origin = 'Web';
        cs.Description = t.Description;
        cs.Survey_Date__c = c.Survey_Date__c;
        cs.Do_Not_Survey__c = c.Do_NotSurvey__c;
        cs.Web_Company_Name__c = c.Company__c;
        cs.RecordTypeId = casRecordTypeId;
        cs.Subject = t.Subject;
        cs.Description = t.Description;
        insert cs;
        
        Contact c2 =new Contact(); 
        c2.FirstName='test';
        c2.LastName = 'contact';
        c2.Email = 'email@gmail.com';
        c2.Phone = '9743800001';
        c2.Description = 'tesingcontact';
        c2.Survey_Date__c=System.today();
        c2.Do_NotSurvey__c =True;
        insert c2; 
        CaseFromContactController.getContactList(c.id);
        CaseFromContactController.getContactList(c2.id);
    }
}