@isTest(seealldata=true)
public class Community_Web2CaseCtrlTest {
    
    public static testMethod void testScenario(){
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='Client Community Profile'];
        Account aid = new Account(name = 'portalAccount');
        insert aid;
        
        User u1 = [SELECT Id FROM USer where profileId =: p.Id and isActive = true limit 1];
        system.debug('Community user >>'+u1);
        
        Account acc=new Account();
        acc.Name='testacc';
        insert acc;
        Contact con=new Contact();
        con.FirstName='testfname';
        con.LastName='testlname';
        con.Email='test@abc.com';
        con.Phone='1234';
        insert con;
        Case cases = new Case();
        cases.contactId=con.id;
        cases.AccountId=acc.id;
        
        Case_Reason_Category__c crc = new Case_Reason_Category__c();
        crc.Name = 'test';
        crc.Case_Reason__c = 'Sales';
        crc.Type__c = '';
        crc.API_Name__c = 'Sales';
        crc.Case_Type__c = 'Sales';
        insert crc;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cases);
        Community_Web2CaseCtrl CW = new Community_Web2CaseCtrl(sc);
        CW.ReasonforTicket='Billing';
        CW.ReasonforTicket1='Billing';
        CW.uploadBtn=false;
        CW.emailIdC='test1211@tgd.com';
        CW.WebCompanyName = acc.Name;
        CW.OrderNumber = '123';
        CW.Subjects = 'sasa';
        // CW.UserId='ur.Id';
        CW.firstNameC='test1';
        CW.lastNameC='test2';
       // CW.caseReason='Billing';
        CW.emailIdC = 'test@testing.com';
        CW.WebCompanyName = 'Test Name';
        //CW.OrderNumber = '123';
        CW.Subjects = 'sasa';
        CW.phoneNoC = '9786567989';
        CW.Descriptions = 'testing my value';
        //con.Email=CW.emailIdC;
        
        CW.fileSize();
        
        
        Case cse=new Case();
        cse.Accountid = aid.id;
        cse.Order_Number__c = '123' ;
        insert cse;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cse.id;
        insert attach;
        
        Attachment attach1=new Attachment();     
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        
        CW.attachment = attach1;
        CW.uploadMore();
        CW.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        CW.hasError = 'Go';
        CW.dmlerror=false;
        CW.attachment = attach2;
        CW.removeAttachment();
        CW.upload();
        CW.getRootCategoryName();
        CW.getCategoryGroupName();
        CW.fetchKnowledgeArticles();
        CW.fetchMostRecentArticles();
        String Emailid='test@abc.com';
        // CW.getContact(Emailid);
        PageReference myVfPage = Page.Community_WebtoCase;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('subjectValue',CW.Subjects);
        cw.caseTypeforTicket = 'Sales';
        cw.Reasons4CaseTypeList();
       cw.caseOrdr();
        
       /* cw.getCasePriorityList();
        cw.getCaseTypeList();
        cw.retriveCaseReason();
        cw.retriveCaseSubReason();*/
        system.runAs(u1 ){
            cw.knowledgeQuery = 'Sanjay';
            cw.fetchKnowledgeArticles();
            CW.SaveData();
            
        }
        
    }
}