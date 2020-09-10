@isTest
public class Sec_TopNavigationCntrlTest{
    
    private static testMethod void testCase(){
        
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
        slaSettings.Name='TIME1';
        insert slaSettings;
        
        mileStoneCaseReason__c mileStonCaseRea = new mileStoneCaseReason__c();
        mileStonCaseRea.Name='Brand Validation1';
        insert mileStonCaseRea ;
        
        mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation1';
        insert mileStonCaseRea1 ;
        
        mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation1';
        insert mileStonCaseRea2 ;
        
        campaign mycamp= new campaign();
        mycamp.name='Private CA Campaign1';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c ='Inbound';
        insert mycamp;
        system.debug('>>>>>>>>>>>>>>'+mycamp);
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
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id,
            recordTypeId = contactRecordTypeId
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
        
        
      campaign camp = [select id,name from campaign where name='Private CA Campaign1' limit 1];
    system.debug('camp.id>>>>>>>>>>>.'+camp);
        Sec_TopNavigationCntrl  c3 =new Sec_TopNavigationCntrl();
        c3.firstName='testfirstname';
        c3.lastName='testlastname';
        c3.email='veera1234@dazeworks.com';
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
        // c2.leadSourceVal='Private CA Campaign';
        //c2.productInterestVal='EmailCertificatesSMIME';
        c3.hasRedirect = 'yes';
        c3.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c3.mainSiteUrl = 'sectigo';
        c3.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PAgeReference myVfPage1 = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage1);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"'+camp.Id+'"}');
        c3.postmessageValue = '{"name":"sectigo-certificate-manager","webForm":"https://craft-staging.sectigodev.com","campaignName":"'+camp.Id+'"}';
        
        c3.captureExternalData();
        c3.saveData();
        c3.getEmployeeCountOptions();
        
        
    system.debug('camp.id>>>>>>>>>>>.'+camp);
        Sec_TopNavigationCntrl  c2=new Sec_TopNavigationCntrl();
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
        // c2.leadSourceVal='Private CA Campaign';
        //c2.productInterestVal='EmailCertificatesSMIME';
        c2.hasRedirect = 'yes';
        c2.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c2.mainSiteUrl = 'sectigo';
        c2.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage2 = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage2);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"'+camp.Id+'"}');
        c2.postmessageValue = '{"name":"sectigo-certificate-manager","webForm":"https://craft-staging.sectigodev.com","campaignName":"'+camp.Id+'"}';
        
        c2.captureExternalData();
        c2.saveData();
        c2.getEmployeeCountOptions();
        
        Sec_TopNavigationCntrl  C4=new Sec_TopNavigationCntrl();
        C4.firstName='testfirstname';
        C4.lastName='testlastname';
        C4.email='vinay@dazeworks.com';
        C4.phoneNumber='9051122553';
        C4.companyName='self';
        C4.employeeCount='1-250';
        C4.region='North America';
        C4.state='Alabama';
        C4.smimeQ='1';
        C4.subjec='Test subject';
        C4.mess='Test message doasda';
        C4.emailOptIn=true;
        C4.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        // C4.leadSourceVal='Private CA Campaign';
        //C4.productInterestVal='EmailCertificatesSMIME';
        C4.hasRedirect = 'yes';
        C4.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        C4.mainSiteUrl = 'sectigo';
        C4.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage3 = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage3);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"'+camp.Id+'"}');
        C4.postmessageValue = '{"name":"sectigo-certificate-manager","webForm":"https://craft-staging.sectigodev.com","campaignName":"'+camp.Id+'"}';
        
        C4.captureExternalData();
        C4.saveData();
        C4.getEmployeeCountOptions();
    }
    
}