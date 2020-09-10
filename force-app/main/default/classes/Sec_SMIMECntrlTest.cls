@isTest
public class Sec_SMIMECntrlTest{
    
    private static testMethod void testCase(){
        Sec_SMIMECntrl SMIMECntrl  = new Sec_SMIMECntrl();
        PageReference pageRef = Page.Sec_Contactus;  
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
        mycamp.name='Private CA Campaign1';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c='Inbound';
        insert mycamp;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        Campaign_Assignment_SettingsForContactUs__c caCustomSettingsForContactUs = new Campaign_Assignment_SettingsForContactUs__c(Name = 'comodoca--full--c.cs21.visual.force',
                                                                                                                                   CampaignName__c = 'Private CA Campaign', Product__c = 'Private CA', RedirectURL__c = 'https://sectigo.com/lps/sectigo-product-thank-you');
        Insert caCustomSettingsForContactUs ;
        
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
        
        Sec_SMIMECntrl c1=new Sec_SMIMECntrl();
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
        // c1.leadSourceVal='Private CA Campaign';
        c1.productInterestVal='PrivatePKI';
        c1.hasRedirect = 'yes';
        c1.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c1.mainSiteUrl = 'sectigo';
        c1.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"'+mycamp.Id+'"}');
		c1.postmessageValue = '{"name":"sectigo-certificate-manager","webForm":"https://craft-staging.sectigodev.com","campaignName":"'+mycamp.Id+'"}';

        
        c1.captureExternalData();
        c1.saveData();
        
        Sec_SMIMECntrl c2=new Sec_SMIMECntrl();
        c2.firstName='testfirstname';
        c2.lastName='testlastname';
        c2.email='veera12@dazeworks.com';
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
        // c2.leadSourceVal='Private CA Campaign';
        c2.productInterestVal='PrivatePKI';
        c2.hasRedirect = 'yes';
        c2.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c2.mainSiteUrl = 'sectigo';
        c2.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage2 = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage2);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"'+mycamp.Id+'"}');
        c2.postmessageValue = '{"name":"sectigo-certificate-manager","webForm":"https://craft-staging.sectigodev.com","campaignName":"'+mycamp.Id+'"}';
        
        
        c2.captureExternalData();
        c2.DocumentSigningCheckVal = true;
        c2.PrivatePKICheckVal = true;
        c2.SSLCertificatesCheckVal = true;
        c2.WebsiteBackupandRecoveryCheckVal = true;
        c2.OtherCheckVal = true;
        c2.IoTManagementPlatformCheckVal = true;
        c2.EmbeddedSecurityCheckVal = true;
        c2.EnterpriseCodeSigningCheckVal = true;
        c2.EnterpriseSMIMECheckVal = true;
        c2.CertificateManagementPlatformCheckVal = true;
        c2.DevOpsCheckVal = true;
        c2.EmailCertificatesSMIMECheckVal = true;
        c2.EnterpriseSSLCheckVal = true;
        c2.getEmployeeCountOptions();
        c2.getSmimeOptions();
        c2.saveData();        
    }
    
}