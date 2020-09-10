@isTest
public class CaseShareCreationTest{
    
    static testMethod void positivescenarioCaseShare(){
     
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id
        );
        insert ct;
        //System Administrator
        
        
        user user1 = new user();
             user u1 = [select id from user where id=:userinfo.getuserid() limit 1];  
system.runAs(u1){
         
        user1.ProfileID = [Select Id From Profile Where Name='System Administrator'].id;
        user1.UserRoleID = [Select Id From UserRole Where Name='CEO'].id;
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.LanguageLocaleKey = 'en_US';
        user1.TimeZoneSidKey = 'America/New_York';
        user1.LocaleSidKey = 'en_US';
        user1.FirstName = 'firsfght';
        user1.LastName = 'lasrtyt';
        user1.username = 'testerer@apdfghpertirio.com';   
        user1.CommunityNickname = 'tewersdfghtstuser1123';
        user1.Alias = 't1';
        user1.Email = 'no@emertail.com';
        user1.IsActive = true;
        //user1.ContactId = ct1.Id;
        
        insert user1;
        
      }
        
             System.RunAs(user1) {  
        //test.starttest();
       
        
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();

        
         
         
          
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();

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
        
        Account acc2 = new Account(
            Name = 'TestAccodfgunt',
            Segment__c = 'Partner/Reseller',
            recordtypeid = RecordTypeIdAccount
        );
        insert acc2; 
        
        Account acc12 = new Account(
            Name = 'TestAccovbnunt1',
            Segment__c = 'Partner/Reseller',
            Enterprise_Premier__c = true,
            Channel_partner__c = acc2.id,
            recordtypeid = RecordTypeIdAccount
        );
        insert acc12; 
        
        ServiceContract sc = new ServiceContract();  
        sc.Name = 'Partner/Reseller Support'; 
        sc.accountId = acc2.Id;     
        insert sc;
        
        ServiceContract sc1 = new ServiceContract();  
        sc1.Name = 'Enterprise Premier Support'; 
        sc1.accountId = acc12.Id;     
        insert sc1;
        
        Entitlement ent = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc2.Id,
            ServiceContractId = sc.Id
        );
        insert ent;
        
        Entitlement ent1 = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc12.Id,
            ServiceContractId = sc1.Id
        );
        insert ent1;
        
        contact ct2 = new contact(
            LastName = 'test contactert',
            Email = 'vinay@dadfgzeworks.com',
            Phone = '1234567890',
            accountId = acc12.Id
        );
        insert ct2;
        
        contact ct3 = new contact(
            LastName = 'test contactert1',
            Email = 'vinay@dadfgfzeworks.com',
            Phone = '123456789f0',
            accountId = acc2.Id
        );
        insert ct3;
        //Channel Partner CP
          User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='Customer Community Plus User'].id;
        //user.userroleId = [Select Id From userrole Where Name='InCommon LLC Customer User'].id;
        //user.userroleid = '00Eq0000000sfLaEAI';
        //user.userroleid = '00Eq0000000sfLa';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'firsfght';
        user.LastName = 'lasrtyt';
        user.Username = 'testerer@appertirio.com';   
        user.CommunityNickname = 'tewertstUser123';
        user.Alias = 't1';
        user.Email = 'no@emertail.com';
        user.IsActive = true;
        user.PortalRole = '';
        user.ContactId = ct3.Id;
        
        insert user;
        
        system.debug('user >> '+user.Id);
        User userObj = [SELECT Id,ContactId, AccountId,profileId,contact.AccountId FROM User WHERE Username='testerer@appertirio.com' ]; 
        
        
           system.debug('userid coming: '+userObj);  
           system.debug('>>>user.contact.accountid: '+userObj.Contact.AccountId);           
        Case cas1 = new Case(      
            Status = 'New',
            priority = 'High',
            Subject = 'TestCase',
            AccountId = acc12.Id,
            contactId = ct2.Id,
            EntitlementId = ent.Id      
        );     
        insert cas1;
        Case_Comment__c cm = new Case_Comment__c(
            ParentId__c = cas1.Id,
            Comment_Body__c = 'Vinay testing'
        );
        insert cm;  
                   
            system.debug('contactrec: '+ct);
             list<Case> cas = [select Id,CaseNumber,EntitlementId,Priority,Status,accountid,contactid from case];
        list<Account> acount = [Select Id, Name, Segment__c,Channel_partner__c,RecordTypeId  From Account];
        contact contactrec = [Select Id, Name,email,accountid From contact where id =: userObj.ContactId ];
        list<contact> contact = [Select Id, Name,email,accountid From contact where accountid =: userObj.accountid ];
        system.debug('testdata contact: '+contact);
        account accountrec = [Select Id, Name, Segment__c,Channel_partner__c,RecordTypeId  From Account where id =: userObj.accountid];
        ServiceContract scontract = [Select Id,Name, AccountID From ServiceContract where AccountID in: acount limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
            
            // do all of my tests
            
            CaseShareCreation.CommunityPlusCaseSharing(cas);
            
        }
        //test.stoptest();
    }
}