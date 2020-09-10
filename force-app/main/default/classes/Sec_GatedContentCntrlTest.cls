@isTest
public class Sec_GatedContentCntrlTest{

private static testMethod void testCase(){
    
    Sec_GatedContentCntrl  GatedContentCntrl = new Sec_GatedContentCntrl();

 PageReference pageRef = Page.Sec_GatedContent;  
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
        
        campaign mycamp= new campaign();
        mycamp.name='Private CA Campaign';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c='Inbound';
        insert mycamp;
        
        Database.DMLOptions dml = new Database.DMLOptions();
dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
dml.DuplicateRuleHeader.runAsCurrentUser = true;

        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.email='veera@dazeworks.com';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
       // insert lstLead;  
            Database.insert(lstLead, dml);
 
        
          Lead lstLead1 =   new Lead();
        lstLead1.Company = 'JohnMiller1';
        lstLead1.email='veera1234@dazeworks.com';
        lstLead1.LastName = 'Mike1';
        lstLead1.Status = 'Open';               
        //insert lstLead1; 
                    Database.insert(lstLead1, dml);

        
          Lead lstLead2 =   new Lead();
        lstLead2.Company = 'Johiller';
        lstLead2.email='veera1234@dazeworks.com';
        lstLead2.LastName = 'Mike';
        lstLead2.Status = 'Open';               
        //insert lstLead2; 
                    Database.insert(lstLead2, dml);

    
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

    Sec_GatedContentCntrl  c1=new Sec_GatedContentCntrl();
    c1.firstName='testfirstname';
    c1.lastName='testlastname';
    c1.email='veera@dazeworks.com';
    c1.phoneNumber='9051122553';
    c1.companyName='self';
    c1.employeeCount='1-250';
    c1.region='North America';
    c1.state='Alabama';
    c1.smimeQ='1';
    c1.subjec='Test subject';
    c1.mess='Test message doasda';
        c1.emailOptIn=true;
         c1.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        c1.campaignIdVal= mycamp.Id;
        c1.productInterestVal='Private CA';
        c1.mainSiteUrl ='sectigo' ;
        c1.browserUrl = 'https://craft-staging.sectigodev.com/test/testurl';

    c1.saveData();
    
    
     Sec_GatedContentCntrl c2=new Sec_GatedContentCntrl();
    c2.firstName='testfirstname';
    c2.lastName='testlastname';
    c2.email='veera23232@dazeworks.com';
    c2.phoneNumber='9051122553';
    c2.companyName='self';
    c2.employeeCount='1-250';
    c2.region='North America';
    c2.state='Alabama';
    c2.smimeQ='1';
    c2.subjec='Test subject';
    c2.mess='Test message doasda';
        c2.emailOptIn=true;
         c2.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        c2.campaignIdVal= mycamp.Id;
        c2.productInterestVal='Private CA';
        c2.mainSiteUrl ='sectigo' ;
        c2.browserUrl = 'https://craft-staging.sectigodev.com/test/testurl';

    c2.saveData();

   Sec_GatedContentCntrl c3=new Sec_GatedContentCntrl();
    c3.firstName='testfirstname';
    c3.lastName='testlastname';
    c3.email='vinay@dazeworks.com';
    c3.phoneNumber='9051122553';
    c3.companyName='self';
    c3.employeeCount='1-250';
    c3.region='North America';
    c3.state='Alabama';
    c3.smimeQ='1';
    c3.subjec='Test subject';
    c3.mess='Test message doasda';
        c3.emailOptIn=true;
         c3.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        c3.campaignIdVal= mycamp.Id;
        c3.productInterestVal='Private CA';
        c3.mainSiteUrl ='sectigo' ;
        c3.browserUrl = 'https://craft-staging.sectigodev.com/test/testurl';

    c3.saveData();
    
    
     Sec_GatedContentCntrl c4=new Sec_GatedContentCntrl();
    c4.firstName='testfirstname';
    c4.lastName='testlastname';
    c4.email='veera1234@dazeworks.com';
    c4.phoneNumber='9051122553';
    c4.companyName='self';
    c4.employeeCount='1-250';
    c4.region='North America';
    c4.state='Alabama';
    c4.smimeQ='1';
    c4.subjec='Test subject';
    c4.mess='Test message doasda';
    c4.emailOptIn=true;
     c4.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        c4.campaignIdVal= mycamp.Id;
        c4.productInterestVal='Private CA';
        c4.mainSiteUrl ='sectigo' ;
        c4.browserUrl = 'https://craft-staging.sectigodev.com/test/testurl';
    
    c4.saveData();
	


}

}