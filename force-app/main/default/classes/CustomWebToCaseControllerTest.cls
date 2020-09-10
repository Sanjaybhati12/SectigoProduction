/** Class Name   : CustomWebToCaseControllerTest
*  Description  : Test class for "CustomWebToCaseController"  
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
public class CustomWebToCaseControllerTest{
    public static TestMethod void CustomWebToCaseControllerTest1(){
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
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
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
        
        
        PageReference myVfPage = Page.Com_knowledgeWeb2Casepage;
        Test.setCurrentPage(myVfPage);
        Apexpages.currentPage().getParameters().put('subjectValue','test');
        CustomWebToCaseController customWeb = new CustomWebToCaseController(new ApexPages.StandardController(cases));
        
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
        
        customWeb.saveData();
        customWeb.fileSize();
        
        
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
        customWeb.uploadMore();
        customWeb.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        customWeb.hasError = 'Go';
        customWeb.attachment = attach2;
        //customWeb.removeAttachment();
        customWeb.upload();
        customWeb.getRootCategoryName();
        customWeb.getCategoryGroupName();
        customWeb.fetchKnowledgeArticles();
        customWeb.cleardata();
        String Emailid='test@abc.com';
        customWeb.getContact(Emailid);
        PageReference myVfPage1 = Page.Com_KnowledgeWeb2CasepageSectigo;
        Test.setCurrentPage(myVfPage1);
        ApexPages.currentPage().getParameters().put('subjectValue',customWeb.Subjects);
        ApexPages.Message[] messages = ApexPages.getMessages();
        
        //System.assertEquals(2, messages.size());
        //System.assertEquals('Message 1', messages[0].getDetail());
        //System.assertEquals('Message 2', messages[1].getDetail());
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));

        List<Knowledge__kav> knowledgeList = new List<Knowledge__kav>();
        
        
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
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
        insert mileStonCaseRea2 ;
        
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        Account acc1 = new Account(
            Name = 'TestAccount1',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true    
        );
        insert acc1; 
        ServiceContract sc = new ServiceContract();  
        sc.Name = 'Partner/Reseller Support'; 
        sc.accountId = acc.Id;     
        insert sc;
        ServiceContract sc1 = new ServiceContract();  
        sc1.Name = 'Enterprise Premier Support'; 
        sc1.accountId = acc1.Id;     
        insert sc1;
        Entitlement ent = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc.Id,
            ServiceContractId = sc.Id
        );
        insert ent;
        Entitlement ent1 = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc1.Id,
            ServiceContractId = sc1.Id
        );
        insert ent1;
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id
        );
        insert ct;
        contact ct1 = new contact(
            LastName = 'test contact1',
            Email = 'vinay@dazework.com',
            Phone = '123456789',
            accountId = acc1.Id
        );
        insert ct1;
        test.startTest();
        Case cas1 = new Case(      
            Status = 'In progress',
            SuppliedEmail='test@testing.com',
            priority = 'High',
            Subject = 'TestCase',
            AccountId = acc.Id,
            contactId = ct.Id,
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
        cases.contactId=ct.id;
        cases.AccountId=acc.id;
        cases.Order_Number__c = '123456789';
        cases.Status = 'New';
        insert cases;
        cases.Status = 'Closed';
        update cases;
        CustomWebToCaseController customWeb = new CustomWebToCaseController(new ApexPages.StandardController(cases));
        customWeb.firstNameC='test1';
        customWeb.lastNameC='test2';
        customWeb.ReasonforTicket1='Billing';
        customWeb.emailIdC = 'test@testing.com';
        customWeb.WebCompanyName = 'Test Name';
        customWeb.OrderNumber = '123456789';
        customWeb.Subjects = 'sasa';
        customWeb.phoneNoC = '9786567989';
        customWeb.Descriptions = 'testing my value';
        customWeb.ReasonforTicket='Test';
        ct.Email=customWeb.emailIdC;
        
        
        
        Case cse=new Case();
        cse.contactId=ct.id;
        cse.AccountId=acc.id;
        cse.Order_Number__c = '123456789';
        cse.Origin = 'Web';
        cse.Reason = 'Account Changes';
        cse.Status = 'In progress';    
        insert cse;
        cse.status = 'closed';
        update cse;
        //System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
        Case_Comment__c onecasecmt= new Case_Comment__c();
        onecasecmt.ParentId__c=cse.id;
        oneCaseCmt.Send_Email_to_Customer__c = true;
        onecasecmt.Comment_Body__c =customWeb.Descriptions; 
        insert onecasecmt;  
        
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
        
        customWeb.attachment = attach1;
        customWeb.uploadMore();
        customWeb.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        customWeb.hasError = 'Go';
        customWeb.attachment = attach2;
        customWeb.removeAttachment();
        customWeb.upload();
        customWeb.getRootCategoryName();
        customWeb.getCategoryGroupName();
        customWeb.fetchKnowledgeArticles();
        //customWeb.getMatchedOrder('8787787');
        customWeb.cleardata();
        String Emailid='test@abc.com';
        customWeb.getContact(Emailid);
        PageReference myVfPage = Page.Com_KnowledgeWeb2CasepageSectigo;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('subjectValue',customWeb.Subjects);
        // ApexPages.Message[] messages = ApexPages.getMessages();
        
        //System.assertEquals(2, messages.size());
        //System.assertEquals('Message 1', messages[0].getDetail());
        //System.assertEquals('Message 2', messages[1].getDetail());
        // System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
        
        customWeb.saveData();
        customWeb.fileSize();
        test.stopTest();
        
    }
    public static TestMethod void CustomWebToCaseControllerTest3(){
         Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id
        );
        insert ct;
        
        Case cas1 = new Case(      
            Status = 'New',
            priority = 'High',
            Subject = 'In progress',
            AccountId = acc.Id,
            contactId = ct.Id,
            Order_Number__c='123456789'
            
        );     
        insert cas1;
        
        Case_Comment__c onecasecmt= new Case_Comment__c();
        onecasecmt.ParentId__c = cas1.id;
        oneCaseCmt.Send_Email_to_Customer__c = false;
        onecasecmt.Comment_Body__c = 'Descriptions'; 
        insert onecasecmt;     
    }
    public static TestMethod void CustomWebToCaseControllerTest4(){
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
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
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
        
        
        PageReference myVfPage = Page.Com_knowledgeWeb2Casepage;
        Test.setCurrentPage(myVfPage);
        Apexpages.currentPage().getParameters().put('subjectValue','test');
        CustomWebToCaseController customWeb = new CustomWebToCaseController(new ApexPages.StandardController(cases));
        
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
        
        customWeb.saveData();
        customWeb.fileSize();
        
        
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
        customWeb.uploadMore();
        customWeb.attachmentIdToRemove = attach.Id;
        
        Attachment attach2=new Attachment();     
        attach2.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob2;
        
        customWeb.hasError = 'Go';
        customWeb.attachment = attach2;
        //customWeb.removeAttachment();
        customWeb.upload();
        customWeb.getRootCategoryName();
        customWeb.getCategoryGroupName();
        customWeb.fetchKnowledgeArticles();
        customWeb.cleardata();
        String Emailid='test@abc.com';
        customWeb.getContact(Emailid);
        PageReference myVfPage1 = Page.Com_KnowledgeWeb2CasepageSectigo;
        Test.setCurrentPage(myVfPage1);
        ApexPages.currentPage().getParameters().put('subjectValue',customWeb.Subjects);
        ApexPages.Message[] messages = ApexPages.getMessages();
        
        //System.assertEquals(2, messages.size());
        //System.assertEquals('Message 1', messages[0].getDetail());
        //System.assertEquals('Message 2', messages[1].getDetail());
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));

      
        
        
    }
    
    	
}