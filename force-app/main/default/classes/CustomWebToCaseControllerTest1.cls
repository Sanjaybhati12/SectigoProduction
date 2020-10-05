/** Class Name   : CustomWebToCaseControllerTest1
*  Description  : Test class for "CustomWebToCaseController1"  
*                     
*  Created By   : 
*  Created On   : 

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
@isTest
public class CustomWebToCaseControllerTest1{
    public static TestMethod void CustomWebToCaseControllerTest11(){
       SLA_Setting__c slaSettings = new SLA_Setting__c();
        slaSettings.Followup_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Retail_Support_Followup_SLA__c = 30;
        slaSettings.Retail_Support_Intial_SLA__c = 30;
        slaSettings.Name='TIME';
        insert slaSettings;
        
        mileStoneCaseReason__c mileStonCaseRea = new mileStoneCaseReason__c();
        mileStonCaseRea.Name='Brand Validation';
        mileStonCaseRea.Label__c = 'Brand Validation';
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
         mileStonCaseRea1.Label__c='CCM Validation';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
        mileStonCaseRea2.Label__c='EV Validation';
        insert mileStonCaseRea2 ;
        
        Account acc=new Account();
        acc.Name='testacc';
        insert acc;
        
        ServiceContract sc = new ServiceContract();  
        sc.Name = 'Partner/Reseller Support'; 
        sc.accountId = acc.Id;     
        insert sc;
        
        Entitlement ent = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc.Id,
            ServiceContractId = sc.Id
        );
        insert ent;
        
        Contact con=new Contact();
        con.FirstName='testfname';
        con.LastName='testlname';
        con.AccountId = acc.id;
        con.Email='test@abc.com';
        con.Phone='1234';
        insert con;
        
        Case cas1 = new Case(      
            Status = 'closed',
            SuppliedEmail='test@testing.com',
            priority = 'High',
            Subject = 'TestCase',
            AccountId = acc.Id,
            contactId = con.Id,
            Order_Number__c='123456789',
            Origin = 'Web',
            Reason = 'Account Changes',
            EntitlementId = ent.Id,ownerId=UserInfo.getUserId()      
        );     
        insert cas1;
        cas1.Order_Number__c = '123456789';
        cas1.Status = 'closed';
        update cas1;
        
        Case cases = new Case();
        cases.contactId=con.id;
        cases.AccountId=acc.id;
        cases.Order_Number__c = '123456789';
        cases.Status = 'New';
        insert cases;
        cases.Status = 'Closed';
        update cases;
        
        Case_Reason_Category__c crc = new Case_Reason_Category__c();
        crc.Name = 'Billing';
        crc.Case_Reason__c = 'Billing';
        crc.API_Name__c='Billing';
        crc.Type__c = '';
        crc.Case_Type__c = 'Biling';
        insert crc;
        
        PageReference myVfPage = Page.Com_KnowledgeWeb2Casepagesectigo ;
        Test.setCurrentPage(myVfPage);
        Apexpages.currentPage().getParameters().put('subjectValue','test');
        CustomWebToCaseController1 customWeb = new CustomWebToCaseController1(new ApexPages.StandardController(cases));
        
        customWeb.firstNameC='test1';
        customWeb.lastNameC='test2';
        customWeb.ReasonforTicket1='Billing';
        customWeb.emailIdC = 'test@abc.com';
        customWeb.WebCompanyName = 'Test Name';
        customWeb.OrderNumber = '123456789';
        customWeb.Subjects = 'sasa';
        customWeb.phoneNoC = '9786567989';
        customWeb.Descriptions = 'testing my value';
        customWeb.caseNumer = '734673';
        customWeb.displaymessage1 = 'for error message';
        customWeb.caseTypeforTicket = 'Billing';
        customWeb.getReasons4CaseTypeList();
        customWeb.retriveCaseReason();
        customWeb.retriveCaseSubReason();
        
        con.Email=customWeb.emailIdC;
        
        String fir_name = 'testfir';
        String last_name = 'lastName';
        String email = 'test@gmail.com';
        String webcompany = 'dazew';
        String phone  = '754755454';
        String reason = 'checking';
        String ordernumber1 = '1234567';
        String subject = 'testMethod';
        String description = 'testingggg';
        blob body = blob.valueOf('test body');
        String caseType = 'Sales';
        String subCaseReason = 'Sales'; 
        //String attachList = '[{"Name":"test","Body":"'+EncodingUtil.base64Encode(body)+'"}]';
        String ipAddress1 = 'true';
        
        CustomWebToCaseController1.saveDataRemoting(fir_name, last_name, email, webcompany, phone, reason, ordernumber1, subject, description, ipAddress1,'30',caseType);
        CustomWebToCaseController1.saveDataRemoting(fir_name, last_name, email, webcompany, phone, reason, ordernumber1, subject, description, ipAddress1,'23',caseType);
        CustomWebToCaseController1.saveDataRemoting(fir_name, last_name, email, webcompany, phone, reason, ordernumber1, subject, description, ipAddress1,'3',caseType);
        //  CustomWebToCaseController1.saveDataRemoting(fir_name,last_name,email,webcompany,phone,caseType,reason,subCaseReason,ordernumber1,subject,description,ipAddress1);       
        
        Ticketing_Case_Reason__c casereason = new Ticketing_Case_Reason__c();
        casereason.Name = 'test';
        casereason.API_Name__c = 'apis';
        casereason.Label__c = 'apis';
        insert casereason;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas1.id;
        insert attach;
        
        Attachment attach1=new Attachment();     
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        
        customWeb.attachment = attach1;
        customWeb.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        customWeb.hasError = 'Go';
        customWeb.attachment = attach2;
        
        customWeb.getRootCategoryName();
        customWeb.getCategoryGroupName();
        customWeb.fetchKnowledgeArticles();
        customWeb.fetchMostRecentArticles();
        customWeb.cleardata();
        String Emailid='test@abc.com';
        String OrderNumber = '123456789';
        CustomWebToCaseController1.getContact(Emailid);
        CustomWebToCaseController1.getCaseByOrderNumber(OrderNumber);
        string Ipaddress = 'truecvc';
        CustomWebToCaseController1.isValidIpAddress(Ipaddress,'subject','12345','webCompany','email@gmail.com');
       
        
        
       
        
        
        
        PageReference myVfPage1 = Page.Com_KnowledgeWeb2Casepagesectigo;
        Test.setCurrentPage(myVfPage1);
        ApexPages.currentPage().getParameters().put('subjectValue',customWeb.Subjects);
        ApexPages.Message[] messages = ApexPages.getMessages();
        
        CustomWebToCaseController1.KnowledgeArticlesWrapper cv = new CustomWebToCaseController1.KnowledgeArticlesWrapper();
        cv.subject =' Test';
        cv.link = 'testlink';
        cv.description = 'rich text';
        CustomWebToCaseController1.KnowledgeArticlesWrapper cv1 = new CustomWebToCaseController1.KnowledgeArticlesWrapper('','','');
      //  CustomWebToCaseController1.attachmentWrapper cv2 = new CustomWebToCaseController1.attachmentWrapper();
        blob body1 = blob.valueOf('test body');
        String attachList1 = '[{"Name":"test","Body":"'+EncodingUtil.base64Encode(body)+'"}]';
       // CustomWebToCaseController1.attachmentWrapper(attachList1,cas1);

        
    }
    
    public static TestMethod void CustomWebToCaseControllerTest2(){
         
       SLA_Setting__c slaSettings = new SLA_Setting__c();
        slaSettings.Followup_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Retail_Support_Followup_SLA__c = 30;
        slaSettings.Retail_Support_Intial_SLA__c = 30;
        slaSettings.Name='TIME';
        insert slaSettings;
        
         mileStoneCaseReason__c mileStonCaseRea = new mileStoneCaseReason__c();
        mileStonCaseRea.Name='Brand Validation';
        mileStonCaseRea.Label__c='Brand Validation';
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
        mileStonCaseRea1.Label__c='CCM Validation';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
        mileStonCaseRea2.Label__c='EV Validation';
        insert mileStonCaseRea2 ;
        
        Account acc=new Account();
        acc.Name='testacc';
        insert acc;
        
        ServiceContract sc = new ServiceContract();  
        sc.Name = 'Partner/Reseller Support'; 
        sc.accountId = acc.Id;     
        insert sc;
        
        Entitlement ent = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc.Id,
            ServiceContractId = sc.Id
        );
        insert ent;
        
        Contact con=new Contact();
        con.FirstName='testfname';
        con.LastName='testlname';
        con.AccountId = acc.id;
        con.Email='test@abc.com';
        con.Phone='1234';
        insert con;
        
        Case cas1 = new Case(      
            Status = 'closed',
            SuppliedEmail='test@testing.com',
            priority = 'High',
            Subject = 'TestCase',
            AccountId = acc.Id,
            contactId = con.Id,
            Order_Number__c='123456789',
            Origin = 'Web',
            Reason = 'Account Changes',
            EntitlementId = ent.Id,ownerId=UserInfo.getUserId()      
        );     
        insert cas1;
        cas1.Order_Number__c = '123456789';
        cas1.Status = 'closed';
        update cas1;
            
        Case cases = new Case();
        cases.contactId=con.id;
        cases.AccountId=acc.id;
        cases.Order_Number__c = '123456789';
        cases.Status = 'New';
        insert cases;
        
       
        
        PageReference myVfPage = Page.Com_KnowledgeWeb2Casepagesectigo ;
        Test.setCurrentPage(myVfPage);
        Apexpages.currentPage().getParameters().put('subjectValue','test');
        CustomWebToCaseController1 customWeb = new CustomWebToCaseController1(new ApexPages.StandardController(cases));
        
        customWeb.firstNameC='test1';
        customWeb.lastNameC='test2';
        customWeb.ReasonforTicket1='Billing';
        customWeb.emailIdC = 'test@abc.com';
        customWeb.WebCompanyName = 'Test Name';
        customWeb.OrderNumber = '123456789';
        customWeb.Subjects = 'sasa';
        customWeb.phoneNoC = '9786567989';
        customWeb.Descriptions = 'testing my value';
        con.Email=customWeb.emailIdC;
        
        
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas1.id;
        insert attach;
        
        Attachment attach1=new Attachment();     
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        
        customWeb.attachment = attach1;
        
        customWeb.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        customWeb.hasError = 'Go';
        customWeb.attachment = attach2;
       
        customWeb.getRootCategoryName();
        customWeb.getCategoryGroupName();
        customWeb.fetchKnowledgeArticles();
        customWeb.cleardata();
        String Emailid='test@abc.com';
        String OrderNumber = '123456789';
        CustomWebToCaseController1.getContact(Emailid);
        CustomWebToCaseController1.getCaseByOrderNumber(OrderNumber);
        string Ipaddress = 'truecvc';
        CustomWebToCaseController1.isValidIpAddress(Ipaddress,'subject','12345','webCompany','email@gmail.com');
         
        PageReference myVfPage1 = Page.Com_KnowledgeWeb2Casepagesectigo;
        Test.setCurrentPage(myVfPage1);
        ApexPages.currentPage().getParameters().put('subjectValue',customWeb.Subjects);
        ApexPages.Message[] messages = ApexPages.getMessages();
        CustomWebToCaseController1.KnowledgeArticlesWrapper cv = new CustomWebToCaseController1.KnowledgeArticlesWrapper();
        cv.subject =' Test';
        cv.link = 'testlink';
        cv.description = 'rich text';
        CustomWebToCaseController1.KnowledgeArticlesWrapper cv1 = new CustomWebToCaseController1.KnowledgeArticlesWrapper('','','');
        //CustomWebToCaseController1.attachmentWrapper cv2 = new CustomWebToCaseController1.attachmentWrapper();
        String fileId = CustomWebToCaseController1.saveChunk(cas1.id,'test','test data','text','');
        CustomWebToCaseController1.saveChunk(cas1.id,'test','test data','text',fileId);
    }
 }