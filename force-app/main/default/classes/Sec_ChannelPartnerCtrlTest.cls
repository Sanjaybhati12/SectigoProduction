@isTest
public class Sec_ChannelPartnerCtrlTest{
    
    private static testMethod void testCase(){
        test.startTest();
        PageReference pageRef = Page.Sec_Contactus;  
        Test.setCurrentPage(pageRef);

        
        campaign mycamp= new campaign();
        mycamp.name='Enterprise Web Form Submission';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c = 'Outbound';
        insert mycamp;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.email='san1232@dazeworks.com';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        // insert lstLead;  
        Database.insert(lstLead, dml);
        
        
        Lead lstLead1 =   new Lead();
        lstLead1.Company = 'JohnMiller1';
        lstLead1.email='san1232@dazeworks.com';
        lstLead1.LastName = 'Mike1';
        lstLead1.Status = 'Open';               
        //insert lstLead1; 
        Database.insert(lstLead1, dml);
        
       // update lstLead1;
        
        Lead lstLead2 =   new Lead();
        lstLead2.Company = 'Johiller';
        lstLead2.email='sanjay134@dazeworks.com';
        lstLead2.LastName = 'Mike';
        lstLead2.Status = 'Open';               
        //insert lstLead2; 
       // Database.insert(lstLead2, dml);
        
        Id accounChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        Account acc1 = new Account(
            Name = 'TestAccount1',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true,
            email__c = 'vinay@dazeworks.com',
            recordTypeId = accounChannelPartnerId
        );
        //insert acc1; 

        Id contactChannelPartnerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'san1232@dazeworks.com',
            Phone = '1234567890',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
        //insert ct;
        contact ct1 = new contact(
            LastName = 'test contact1',
            Email = 'vinay@dazework.com',
            Phone = '123456789',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
        //insert ct1;        
        Sec_ChannelPartnerCtrl c1 = new Sec_ChannelPartnerCtrl();
        c1.firstName = 'testfirstname';
        c1.lastName = 'testlastname';
        c1.email = 'san1232@dazeworks.com';
        c1.phoneNumber = '9051122553';
        c1.companyName = 'self';
        c1.state = 'Alabama';
        c1.subjec='Test subject';
        c1.hgcheck = true;
        c1.sslcheck = false;
        c1.emailOptIn = true;
        c1.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        // c1.leadSourceVal='Private CA Campaign';
        c1.productInterestVal='PrivatePKI';
        c1.hasRedirect = 'yes';
        c1.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c1.campaignIdVal = mycamp.Id;
        c1.mainSiteUrl = 'sectigo';
        c1.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"7013F00000024poQAA"}');
        
        c1.captureExternalData();
        c1.saveData();
        c1.getEmployeeCountOptions();
        c1.getSmimeOptions();
        

        test.stopTest();
        
        
    }
    private static testMethod void testCase1(){
		        test.startTest();
        PageReference pageRef = Page.Sec_Contactus;  
        Test.setCurrentPage(pageRef);

        
        campaign mycamp= new campaign();
        mycamp.name='Enterprise Web Form Submission';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c = 'Outbound';
        insert mycamp;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.email='san1232@dazeworks.com';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        // insert lstLead;  
       // Database.insert(lstLead, dml);
        
        
        Lead lstLead1 =   new Lead();
        lstLead1.Company = 'JohnMiller1';
        lstLead1.email='san1232@dazeworks.com';
        lstLead1.LastName = 'Mike1';
        lstLead1.Status = 'Open';               
        //insert lstLead1; 
       // Database.insert(lstLead1, dml);
        
       // update lstLead1;
        
        Lead lstLead2 =   new Lead();
        lstLead2.Company = 'Johiller';
        lstLead2.email='sanjay134@dazeworks.com';
        lstLead2.LastName = 'Mike';
        lstLead2.Status = 'Open';               
        //insert lstLead2; 
       // Database.insert(lstLead2, dml);
        
        Id accounChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        Account acc1 = new Account(
            Name = 'TestAccount1',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true,
            email__c = 'vinay@dazeworks.com',
            recordTypeId = accounChannelPartnerId
        );
        insert acc1; 

        Id contactChannelPartnerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'san1232@dazeworks.com',
            Phone = '1234567890',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
        //insert ct;
        contact ct1 = new contact(
            LastName = 'test contact1',
            Email = 'san1232@dazeworks.com',
            Phone = '123456789',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
       // insert ct1;        
        Sec_ChannelPartnerCtrl c1 = new Sec_ChannelPartnerCtrl();
        c1.firstName = 'testfirstname';
        c1.lastName = 'testlastname';
        c1.email = 'san1232@dazeworks.com';
        c1.phoneNumber = '9051122553';
        c1.companyName = 'self';
        c1.state = 'Alabama';
        c1.subjec='Test subject';
        c1.hgcheck = true;
        c1.sslcheck = false;
        c1.emailOptIn = true;
        c1.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        // c1.leadSourceVal='Private CA Campaign';
        c1.productInterestVal='PrivatePKI';
        c1.hasRedirect = 'yes';
        c1.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c1.campaignIdVal = mycamp.Id;
        c1.mainSiteUrl = 'sectigo';
        c1.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"7013F00000024poQAA"}');
        
        c1.captureExternalData();
        c1.saveData();
        c1.getEmployeeCountOptions();
        c1.getSmimeOptions();
        

        test.stopTest();
          
    }
    private static testMethod void testCase2(){
        test.startTest();
        PageReference pageRef = Page.Sec_Contactus;  
        Test.setCurrentPage(pageRef);

        
        campaign mycamp= new campaign();
        mycamp.name='Enterprise Web Form Submission';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c = 'Outbound';
        insert mycamp;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.email='san1232@dazeworks.com';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        // insert lstLead;  
       // Database.insert(lstLead, dml);
        
        
        Lead lstLead1 =   new Lead();
        lstLead1.Company = 'JohnMiller1';
        lstLead1.email='san1232@dazeworks.com';
        lstLead1.LastName = 'Mike1';
        lstLead1.Status = 'Open';               
        //insert lstLead1; 
       // Database.insert(lstLead1, dml);
        
       // update lstLead1;
        
        Lead lstLead2 =   new Lead();
        lstLead2.Company = 'Johiller';
        lstLead2.email='sanjay134@dazeworks.com';
        lstLead2.LastName = 'Mike';
        lstLead2.Status = 'Open';               
        //insert lstLead2; 
       // Database.insert(lstLead2, dml);
        
        Id accounChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        Account acc1 = new Account(
            Name = 'TestAccount1',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true,
            email__c = 'vinay@dazeworks.com',
            recordTypeId = accounChannelPartnerId
        );
        insert acc1; 

        Id contactChannelPartnerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'san1232@dazeworks.com',
            Phone = '1234567890',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
        insert ct;
        contact ct1 = new contact(
            LastName = 'test contact1',
            Email = 'vinay@dazework.com',
            Phone = '123456789',
            accountId = acc1.Id,
            recordTypeId = contactChannelPartnerId
        );
        insert ct1;        
        Sec_ChannelPartnerCtrl c1 = new Sec_ChannelPartnerCtrl();
        c1.firstName = 'testfirstname';
        c1.lastName = 'testlastname';
        c1.email = 'san1232@dazeworks.com';
        c1.phoneNumber = '9051122553';
        c1.companyName = 'self';
        c1.state = 'Alabama';
        c1.subjec='Test subject';
        c1.hgcheck = true;
        c1.sslcheck = false;
        c1.emailOptIn = true;
        c1.redirectUrlVal='https://sectigo.com/lps/sectigo-product-thank-you';
        // c1.leadSourceVal='Private CA Campaign';
        c1.productInterestVal='PrivatePKI';
        c1.hasRedirect = 'yes';
        c1.urlValue = 'https://sectigo.com/lps/sectigo-product-thank-you';
        c1.campaignIdVal = mycamp.Id;
        c1.mainSiteUrl = 'sectigo';
        c1.allStringHubProdInterest = 'Enterprise S/MIME,Certificate Management Platform';
        PageReference myVfPage = Page.Sec_Contactus;
        Test.setCurrentPage(myVfPage);        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('postmessageExData', '{"name":"enterprise-ssl","webForm":"https://craft-staging.sectigodev.com","redirectUrl":"https://sectigo.com/lps/sectigo-product-thank-you","campaignName":"7013F00000024poQAA"}');
        
        c1.captureExternalData();
        c1.saveData();
        c1.getEmployeeCountOptions();
        c1.getSmimeOptions();
        

        test.stopTest();
        
        
    }
}