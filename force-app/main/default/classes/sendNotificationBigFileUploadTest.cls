@isTest
private class sendNotificationBigFileUploadTest {
    private static testMethod void callme(){
       
       
       
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
    c.Reason = 'EV Ready';
         c.AccountId = acc.Id;
            c.contactId = ct.Id;
            c.EntitlementId = ent.Id;
    c.origin = 'Web';
    c.Priority = 'Medium';
    c.subject = 'test valli';
    insert c;
       
        profile p=[select id,name from  profile where name='System Administrator'];
        list<user> u1=[select id,email,profileid from user where profileid =: p.id AND isActive=true];
        
     /*   u1.email='dazeworks@gmail.com';
        u1.emailencodingkey='UTF-8';
        u1.profileid =p.id; 
        u1.Alias='daze';
        u1.TimeZoneSidKey='America/New_York';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LocaleSidKey='en_US'; 
        u1.LanguageLocaleKey='en_US';
        u1.UserName='dazeworks@gmail.com'; 
        u1.ContactId = con.Id;
        u1.PortalRole = 'Manager';
        u1.FirstName = 'dazeworks';
        u1.LastName = 'salesforce'; 
        u1.IsActive=true;
        insert u1;*/
        System.runAs(u1[0]){
            Test.startTest();
            
            //insert content version
            //insert feed item
           
            // Create a ContentVersion
        ContentVersion ContentDoc = new ContentVersion();
        ContentDoc.Title = 'My Doc';
        ContentDoc.ContentUrl= 'test.com';
        Insert ContentDoc;
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :ContentDoc.Id];
        // Create a ContentDocumentLink
           
           
            ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Content',
        PathOnClient = 'Content.html',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
    );
    insert contentVersion_1;//create the the content version record
            //parentid = cse.id,
            FeedItem feed = new FeedItem (
                type = 'ContentPost',
                RelatedRecordId = testContent.id,
                ParentId=c.id,
                Body = 'Hello'
            );
            //then create feedItem record
            
                insert feed;    
           
            Test.stopTest();
            
        }
    }
}