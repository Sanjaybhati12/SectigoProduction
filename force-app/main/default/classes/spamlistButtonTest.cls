@isTest
public class spamlistButtonTest{
 testMethod static void positiveTest(){
 //  integer recordId;
       
   
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
        
        List<Case> myLst= new List<Case>();
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
        myLst.add(c);
        
        
         ApexPages.StandardsetController sc54 = new ApexPages.standardsetController(myLst);
       spamlistButton myPageCon = new spamlistButton(sc54);

        PageReference pageRef7 = Page.CaseSpamUpdateList;
        pageRef7.getParameters().put('id', String.valueOf(c.Id));

        Test.setCurrentPage(pageRef7);
        
        myPageCon.doSubmit();

}

testMethod static void positiveTest1(){
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
        
        List<Case> myLst= new List<Case>();
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
        //insert c;
        myLst.add(c);
        
        
        Case c1= new Case();
        // c.id=currentRecordId;
        c1.status = 'Awaiting Customer Reply' ;
        //c.casenumber = 00195083;
        c1.Reason = 'Billing';
        c1.AccountId = acc.Id;
        c1.contactId = ct.Id;
        c1.EntitlementId = ent.Id;
        c1.origin = 'Web';
        c1.Priority = 'Medium';
        c1.subject = 'test valli';
                myLst.add(c1);

        
        
       // insert myLst;
        
         ApexPages.StandardsetController sc54 = new ApexPages.standardsetController(myLst);
         sc54.setSelected(myLst);

       spamlistButton myPageCon = new spamlistButton(sc54);

        PageReference pageRef7 = Page.CaseSpamUpdateList;
        pageRef7.getParameters().put('id', String.valueOf(c.Id));

        Test.setCurrentPage(pageRef7);
        
        myPageCon.doSubmit();
        


}

}