@isTest
public class com_CreateAccountContactCntrlTest {
    @isTest
 public static void  testMe(){
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
         Account acc2 = new Account(
            Name = 'gmail.com',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc2; 
        
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
            c.SuppliedName='Trumph USA';
            c.SuppliedEmail='Elisabeth@sectigo.com';
            c.SuppliedPhone='9051122553';
            c.Web_Company_Name__c='Test Company Name';
    c.origin = 'Web';
    c.Priority = 'Medium';
    c.subject = 'test valli';
    insert c;
        String cId = c.id;
        
        
         Case c1= new Case();
  // c.id=currentRecordId;
        c1.status = 'Awaiting Customer Reply' ;
    //c.casenumber = 00195083;
    c1.Reason = 'Billing';
         c1.AccountId = acc.Id;
            c1.contactId = ct.Id;
            c1.EntitlementId = ent.Id;
            c1.SuppliedName='TrumphUSA1';
            c1.SuppliedEmail='Elisabeth@sectigo.com';
            c1.SuppliedPhone='9051122553';
            c1.Web_Company_Name__c='Test Company Name';
    c1.origin = 'Web';
    c1.Priority = 'Medium';
    c1.subject = 'test valli';
    insert c1;
    String cId1 = c1.id;
    
    
     Case c2= new Case();
  // c.id=currentRecordId;
        c2.status = 'Awaiting Customer Reply' ;
    //c.casenumber = 00195083;
    c2.Reason = 'Billing';
        // c2.AccountId = acc.Id;
          //  c2.contactId = ct.Id;
            c2.EntitlementId = ent.Id;
            c2.SuppliedName='TrumphUSA1';
            c2.SuppliedEmail='Elisabeth@sectigo.com';
            c2.SuppliedPhone='9051122553';
            c2.Web_Company_Name__c='Test Company Name';
    c2.origin = 'Web';
    c2.Priority = 'Medium';
    c2.subject = 'test valli';
    insert c2;
    String cId2 = c2.id;
    
    
        
    com_CreateAccContWrapper myTempRes= new com_CreateAccContWrapper();
    myTempRes= com_CreateAccountContactCntrl.getOpenCases(cId);
    String myRes= com_CreateAccountContactCntrl.createAccCon('Comodo','WEb form','Test form','USA','Comodo','Sectigo','noname@positivessl.com','9051122553',c);
        
         com_CreateAccContWrapper myTempRes1= new com_CreateAccContWrapper();
    myTempRes1= com_CreateAccountContactCntrl.getOpenCases(cId1);
    
        String myRes1= com_CreateAccountContactCntrl.createAccCon('Comodo','WEb form','Test form','USA','Comodo','Sectigo','noname@positivessl.com','9051122553',c2);
       
        String myRes2= com_CreateAccountContactCntrl.createAccCon('Comodo','WEb form','Test form','USA','Comodo','Sectigo','vinay@gmail.com','9051122553',c2);
       
 }  
}