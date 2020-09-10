@isTest  
public class communityCaseCtrlTest { 
    
    public static testMethod void testCase(){
             //  integer recordId;
        PageReference pageRef = Page.Community_Case_Detail;  
        Test.setCurrentPage(pageRef);
   
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
        
        
      Case c= new Case();
  // c.id=currentRecordId;
        c.status = 'Awaiting Customer Reply' ;
    //c.casenumber = 00195083;
    c.Reason = 'Billing';
         c.AccountId = acc.Id;
            c.contactId = ct.Id;
            c.EntitlementId = ent.Id;
    c.origin = 'Web';
    c.Priority = 'Medium';
    c.subject = 'test valli';
    insert c;
        String cId = c.id;
ApexPages.CurrentPage().getParameters().put('id',cId );
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=c.id;
        insert attach;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:c.id];
        System.assertEquals(1, attachments.size());
        Task myTasks = new Task(
       Priority = 'Normal',
       Status = 'Completed',           
       ActivityDate = System.today());
    insert myTasks;
      
        Case_Comment__c cc= new Case_Comment__c();
        
      
       cc.Comment_Body__c='';
          cc.Comment_Body__c='test';
          cc.ParentId__c=c.id;
          cc.From_Address__c='nandini@dazeworks.com';
          cc.To_Address__c='srivalli@dazeworks.com';
          insert cc;
//ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
        communityCaseCtrl  curl= new communityCaseCtrl();
        curl.AddCaseComment();
        curl.saveAttachment();
        curl.ReopenCase();
          curl.CloseCase();
        
     //  integer recordId=attach.id;
        
      //  System.assertEquals(recordId,12344433333);
        
        
}
}