@isTest
public class TestMilestoneTimeCalculator{
  
    @testSetup 
    public static void commontestdata(){
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
        mileStonCaseRea.Label__c ='Brand Validation';
        insert mileStonCaseRea ;
        
         mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
         mileStonCaseRea1.Label__c='CCM Validation';
        insert mileStonCaseRea1 ;
        
         mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
         mileStonCaseRea2.Label__c='EV Validation';
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
        Case cas1 = new Case(      
            Status = 'New',
            priority = 'High (L2)',
            Subject = 'TestCase',
            AccountId = acc.Id,
            contactId = ct.Id,
            EntitlementId = ent.Id      
        );     
        insert cas1;
        Case_Comment__c cm = new Case_Comment__c(
        ParentId__c = cas1.Id,
        Comment_Body__c = 'Vinay testing'
        );
        insert cm;
        
        Case cas2 = new Case(      
            Status = 'New',
            priority = 'High (L2)',
            Subject = 'TestCase1',
            contactId = ct.Id,
            EntitlementId = ent.Id      
        );     
        insert cas2;
        
        Case cas3 = new Case(      
            Status = 'New',
            priority = 'Meduim (L3)',
            Subject = 'TestCase2',
            contactId = ct1.Id,
            EntitlementId = ent1.Id      
        );     
        insert cas3;
    
    }
    static testmethod void calculateMilestoneTriggerTimetest(){
        Case cas = [select Id,CaseNumber,EntitlementId,Priority,Status from case limit 1];
        Account a = [Select Id, Name, Segment__c From Account limit 1];
        ServiceContract sc = [Select Id,Name, AccountID From ServiceContract where AccountID=:a.ID limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
        Test.startTest();       
            MilestoneTimeCalculator cal = new  MilestoneTimeCalculator();
            Integer actualTriggerTime2 = cal.calculateMilestoneTriggerTime(cas.Id, mlt1.Id);
            Integer actualTriggerTime3 = cal.calculateMilestoneTriggerTime(cas.Id, mlt2.Id);
        Test.stopTest();
    }
    
    static testmethod void calculateMilestoneTriggerTimetest1(){
        Case cas = [select Id,CaseNumber,EntitlementId,Priority,Status from case where subject = 'TestCase1' limit 1];
        Account a = [Select Id, Name, Segment__c From Account limit 1];
        a.Segment__c = 'Enterprise-Large';
        update a;
        ServiceContract sc = [Select Id,Name, AccountID From ServiceContract where AccountID=:a.ID limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
        Test.startTest();       
            MilestoneTimeCalculator cal = new  MilestoneTimeCalculator();
            Integer actualTriggerTime2 = cal.calculateMilestoneTriggerTime(cas.Id, mlt1.Id);
            Integer actualTriggerTime3 = cal.calculateMilestoneTriggerTime(cas.Id, mlt2.Id);
        Test.stopTest();
    }
    
    static testmethod void calculateMilestoneTriggerTimetest2(){
        Case cas = [select Id,CaseNumber,EntitlementId,Priority,Status from case where subject = 'TestCase2' limit 1];
        Account a = [Select Id, Name, Segment__c From Account where name = 'TestAccount1' limit 1];       
        ServiceContract sc = [Select Id,Name, AccountID From ServiceContract where AccountID=:a.ID limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
        Test.startTest();       
            MilestoneTimeCalculator cal = new  MilestoneTimeCalculator();
            Integer actualTriggerTime2 = cal.calculateMilestoneTriggerTime(cas.Id, mlt1.Id);
            Integer actualTriggerTime3 = cal.calculateMilestoneTriggerTime(cas.Id, mlt2.Id);
        Test.stopTest();
    }
    static testmethod void calculateMilestoneTriggerTimetest3(){
        Case cas = [select Id,CaseNumber,EntitlementId,Priority,Status from case where subject = 'TestCase2' limit 1];
        cas.priority = 'Low';
        cas.status = 'In Progress';
        Update cas;
        Account a = [Select Id, Name, Segment__c From Account where name = 'TestAccount1' limit 1];       
        ServiceContract sc = [Select Id,Name, AccountID From ServiceContract where AccountID=:a.ID limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
        Test.startTest();       
            MilestoneTimeCalculator cal = new  MilestoneTimeCalculator();
            Integer actualTriggerTime2 = cal.calculateMilestoneTriggerTime(cas.Id, mlt1.Id);
            Integer actualTriggerTime3 = cal.calculateMilestoneTriggerTime(cas.Id, mlt2.Id);
        Test.stopTest();
    }
    
    static testmethod void calculateMilestoneTriggerTimetest4(){
        Case cas = [select Id,CaseNumber,EntitlementId,Priority,Status from case where subject = 'TestCase' limit 1];
        
        Account a = [Select Id, Name, Segment__c From Account where name = 'TestAccount' limit 1]; 
        a.segment__c = 'Retail';      
        ServiceContract sc = [Select Id,Name, AccountID From ServiceContract where AccountID=:a.ID limit 1];
        MilestoneType  mlt1 = [select Id, name from MilestoneType where Name = 'Initial SLA'];
        MilestoneType  mlt2= [select Id, name from MilestoneType where Name = 'Followup SLA'];
        Test.startTest();       
            MilestoneTimeCalculator cal = new  MilestoneTimeCalculator();
            Integer actualTriggerTime2 = cal.calculateMilestoneTriggerTime(cas.Id, mlt1.Id);
            Integer actualTriggerTime3 = cal.calculateMilestoneTriggerTime(cas.Id, mlt2.Id);
        Test.stopTest();
    }
    
}