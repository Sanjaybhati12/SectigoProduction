@isTest
public class TestPaginationExtension {  
    
    @testSetup static void methodName() {
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
        Account acc2 = new Account(
            Name = 'TestAccount123',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true,
            Channel_partner__c = acc1.Id
        );
        insert acc2; 
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
        List<Case> mycase = new List<Case>();
        
        Case cas1 = new Case(      
            Status = 'New',
            priority = 'High',
            Subject = 'TestCase',
            AccountId = acc.Id,
            contactId = ct.Id,
            Order_Number__c='8787787',
            EntitlementId = ent.Id      
        );     
        insert cas1;
        
        sectigoChannelPartner__c mc1 = new  sectigoChannelPartner__c();
        mc1.IsChannelPartner__c = true;
        insert mc1;
        
        mycase.add(cas1);
        Test.setCurrentPage(Page.Community_Case_View);
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(mycase);
        stdSetController.setSelected(mycase);
        
    }
    
    public static testMethod void testSearchCase() {
        Test.startTest();
        
        PaginationExtension ext = new PaginationExtension();
        ext.selectVal='All';
        ext.fetchRecs();
        ext.getmyOpt();
        ext.getCases();
        ext.getPriorityOpt();
        Test.stopTest();
    }
    public static testMethod void testSearchCase1() {
        Test.startTest();
        PaginationExtension ext = new PaginationExtension();
        ext.selectVal='New';
        ext.fetchRecs();
        ext.getmyOpt();
        ext.getCases();
        Test.stopTest();
    }
    public static testMethod void testSearchCase2() {
        Test.startTest();
        PaginationExtension ext = new PaginationExtension();
        ext.selectVal='In progress';
        ext.fetchRecs();
        ext.getmyOpt();
        ext.getCases();
        Test.stopTest();
    }
    public static testMethod void testSearchCase3() {
        Test.startTest();
        PaginationExtension ext = new PaginationExtension();
        ext.selectVal='Closed';
        ext.fetchRecs();
        ext.getmyOpt();
        ext.getCases();
        List<SelectOption>  myNewOpt = new List<SelectOption>();
        myNewOpt.add(new SelectOption('All','All'));
        myNewOpt.add(new SelectOption('New','New'));
        myNewOpt.add(new SelectOption('In progress','In progress'));
        myNewOpt.add(new SelectOption('Closed','Closed'));
        ext.ListOfCse=myNewOpt;
        Test.stopTest();
    }
}