@isTest
public class Sec_dealRegistrationCtrlTest{
    
    /*  @testSetup static void testSetupMethod(){

Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();

Account acc = new Account();
acc.name='test account';
acc.ShippingCity = 'bangalore';
acc.ShippingState='teststate';
acc.ShippingPostalCode='560066';
acc.ShippingCountry='India';
acc.Phone='1234567890';
acc.RecordTypeid=accountRecTypeId;
insert acc;

Contact c = new Contact();
c.LastName = 'test keyStakeholderLastName';
c.FirstName = 'test keyStakeholderFirstName';
c.Email = 'test1@gmailtest.com';
c.Title = 'dev';
c.AccountId = acc.Id;        
c.recordTypeId = contactRecTypeId;
c.MailingStreet = acc.ShippingStreet;
c.MailingCity = acc.ShippingCity ;
c.MailingState = acc.ShippingState ;
c.MailingPostalCode = acc.ShippingPostalCode ;
c.MailingCountry = acc.ShippingCountry ;
c.Phone = acc.Phone;
insert c;

}
*/
    private static testMethod void testCase(){   
        
        Test.startTest();
        Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
        Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
        Account acc = new Account();
        acc.name='test account';
        acc.ShippingCity = 'bangalore';
        acc.ShippingState='teststate';
        acc.ShippingPostalCode='560066';
        acc.ShippingCountry='India';
        acc.Phone='1234567890';
        acc.RecordTypeid=accountRecTypeId;
        insert acc;
        
        Pricebook2 pro = new Pricebook2(Name = Label.Pricebook_Name);
        Insert pro;
        
        Contact c = new Contact();
        c.LastName = 'test keyStakeholderLastName';
        c.FirstName = 'test keyStakeholderFirstName';
        c.Email = 'test1@gmailtest.com';
        c.Title = 'dev';
        c.AccountId = acc.Id;        
        c.recordTypeId = contactRecTypeId;
        c.MailingStreet = acc.ShippingStreet;
        c.MailingCity = acc.ShippingCity ;
        c.MailingState = acc.ShippingState ;
        c.MailingPostalCode = acc.ShippingPostalCode ;
        c.MailingCountry = acc.ShippingCountry ;
        c.Phone = acc.Phone;
        insert c;

        
        Opportunity opp = new Opportunity();
        opp.Name='hari';
        opp.CloseDate = system.today();
        opp.DM_Identified__c = True;
        opp.StageName = 'Presentation/Proof of Concept';
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.Rag_Rating__c = 'Green';
        opp.Pricebook2id = pro.id;
        opp.Amount = 12345.00;
        opp.POC_Presentation_Date__c = system.today();
        opp.Demo_Status__c = 'Not Required';
        opp.CampaignId = Label.Deal_Registration_Campaign_Id;
        insert opp;
        
        OpportunityContactRole conopprole = new OpportunityContactRole();
        conopprole.OpportunityId = Opp.Id;
        conopprole.ContactId = c.Id;
        Insert conopprole;
        //conopprole    
        
        List<Campaign> DealregcampList = new List<Campaign>();
       
        Campaign Dealregcamp = new Campaign();
        
        Dealregcamp.Name = 'Deal Reg Web Form';
        Dealregcamp.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp); 
        
        Campaign Dealregcamp1 = new Campaign();
        
        Dealregcamp1.Name = 'Enterprise Web Form Submission';
        Dealregcamp1.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp1);
        
        Insert DealregcampList;
        
        CampaignMember newcampmembers = new CampaignMember();
        
        newcampmembers.CampaignId = Dealregcamp.Id;
        newcampmembers.Status = 'Enterprise Partner';
        newcampmembers.ContactId = c.id;
        Insert newcampmembers;
        
        
        PageReference pgRef = Page.Sec_dealRegistration;
        Test.setCurrentPageReference (pgRef);
        Sec_dealRegistrationCtrl deal = new Sec_dealRegistrationCtrl();
        deal.companyName = 'test account';
        deal.keyStakeholderFirstName='test keyStakeholderFirstName';
        deal.keyStakeholderLastName='test keyStakeholderLastName';
        deal.titlePosition='test titlePosition';
        deal.phoneNumber='12345';
        deal.emailAddress='test@gmail.com';
        deal.streetAddress='streetAddress';
        deal.cityVal = 'bangalore';
        deal.postalCodeVal ='postalCodeVal';
        deal.countryVal='test countryVal';
        deal.stateVal=' test stateVal';
        deal.oppNamePartnerCRM='test opp';
        deal.oppDescription='test oppDescription ';
        deal.sectigoClientDiscovery ='Yes';
        deal.sectigoClientDiscoveryOn=system.today();
        deal.expectedCloseDate =system.today();
        deal.expectedOppVal =1234;
        deal.partnerCompanyName ='partnerCompanyName';
        //deal.leadSourceVal ='Webform';
        deal.partnerAccountManagerFirstName ='partnerAccountManagerFirstName';
        deal.partnerAccountManagerLastName='partnerAccountManagerLastName';
        deal.partnerEmailAddress='testduplicate@est.com';
        deal.partnerPhoneNumber='9087654321';
        deal.areYouCurrentWorking = 'N/A';
        system.debug('values required: '+deal.companyName+' and : '+deal.cityVal);
        
        deal.getItems();
        deal.SubmitAction();
        Test.stopTest();
    }
    
    
    private static testMethod void testCase1(){
        
        Test.startTest();
        Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
        Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
        Account acc = new Account();
        acc.name='test account';
        acc.ShippingCity = 'bangalore';
        acc.ShippingState='teststate';
        acc.ShippingPostalCode='560066';
        acc.ShippingCountry='India';
        acc.Phone='1234567890';
        acc.RecordTypeid=accountRecTypeId;
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'test keyStakeholderLastName';
        c.FirstName = 'test keyStakeholderFirstName';
        c.Email = 'test1@gmailtest.com';
        c.Title = 'dev';
        c.AccountId = acc.Id;        
        c.recordTypeId = contactRecTypeId;
        c.MailingStreet = acc.ShippingStreet;
        c.MailingCity = acc.ShippingCity ;
        c.MailingState = acc.ShippingState ;
        c.MailingPostalCode = acc.ShippingPostalCode ;
        c.MailingCountry = acc.ShippingCountry ;
        c.Phone = acc.Phone;
        insert c;
        
        Pricebook2 pro = new Pricebook2(Name = Label.Pricebook_Name);
        Insert pro;
        
        Opportunity opp = new Opportunity();
        opp.Name='hari';
        opp.CloseDate = system.today();
        opp.DM_Identified__c = True;
        opp.StageName = 'Presentation/Proof of Concept';
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.Rag_Rating__c = 'Green';
        opp.Pricebook2id = pro.id;
        opp.Amount = 12345.00;
        opp.POC_Presentation_Date__c = system.today();
        opp.Demo_Status__c = 'Not Required';
        opp.CampaignId = Label.Deal_Registration_Campaign_Id;
        insert opp;
        
                OpportunityContactRole conopprole = new OpportunityContactRole();
        conopprole.OpportunityId = Opp.Id;
        conopprole.ContactId = c.Id;
        Insert conopprole;
        //conopprole    
        
        List<Campaign> DealregcampList = new List<Campaign>();
       
        Campaign Dealregcamp = new Campaign();
        
        Dealregcamp.Name = 'Deal Reg Web Form';
        Dealregcamp.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp); 
        
        Campaign Dealregcamp1 = new Campaign();
        
        Dealregcamp1.Name = 'Enterprise Web Form Submission';
        Dealregcamp1.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp1);
        
        Insert DealregcampList;
        
        CampaignMember newcampmembers = new CampaignMember();
        
        newcampmembers.CampaignId = Dealregcamp.Id;
        newcampmembers.Status = 'Enterprise Partner';
        newcampmembers.ContactId = c.id;
        Insert newcampmembers;
        
        PageReference pgRef = Page.Sec_dealRegistration;
        Test.setCurrentPageReference (pgRef);
        Sec_dealRegistrationCtrl deal = new Sec_dealRegistrationCtrl();
        deal.companyName = 'test account';
        deal.keyStakeholderFirstName='test FirstName';
        deal.keyStakeholderLastName='test LastName';
        deal.titlePosition='test tition';
        deal.phoneNumber='12345';
        deal.emailAddress='test1@gmailtest.com';
        deal.streetAddress='streetAddress';
        deal.cityVal = 'bangalore';
        deal.postalCodeVal ='postalCodeVal';
        deal.countryVal='test countryVal';
        deal.stateVal=' test stateVal';
        deal.oppNamePartnerCRM='test opp';
        deal.oppDescription='test oppDescription ';
        deal.sectigoClientDiscovery ='Yes';
        deal.sectigoClientDiscoveryOn=system.today();
        deal.expectedCloseDate =system.today();
        deal.expectedOppVal =1234;
        deal.partnerCompanyName ='partnerCompanyName';
        //deal.leadSourceVal ='Webform';
        deal.partnerAccountManagerFirstName ='partnerAccountManagerFirstName';
        deal.partnerAccountManagerLastName='partnerAccountManagerLastName';
        deal.partnerEmailAddress='testduplicate@est.com';
        deal.partnerPhoneNumber='9087654321';
        deal.accountRecTypeId =accountRecTypeId; 
        deal.contactRecTypeId =contactRecTypeId ;
        deal.oppRecTypeId =oppRecTypeId ;
        deal.areYouCurrentWorking = 'N/A';
        system.debug('values required: '+deal.companyName+' and : '+deal.cityVal);
        
        deal.getItems();
        deal.SubmitAction();
        Test.stopTest();
    }
    
    private static testMethod void testCase2(){
        
        Test.startTest();
        Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
        Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
                
        Account acc = new Account();
        acc.name='test account';
        acc.ShippingCity = 'bangalore';
        acc.ShippingState='teststate';
        acc.ShippingPostalCode='560066';
        acc.ShippingCountry='India';
        acc.Phone='1234567890';
        acc.RecordTypeid=accountRecTypeId;
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'test keyStakeholderLastName';
        c.FirstName = 'test keyStakeholderFirstName';
        c.Email = 'test1@gmailtest.com';
        c.Title = 'dev';
        c.AccountId = acc.Id;        
        c.recordTypeId = contactRecTypeId;
        c.MailingStreet = acc.ShippingStreet;
        c.MailingCity = acc.ShippingCity ;
        c.MailingState = acc.ShippingState ;
        c.MailingPostalCode = acc.ShippingPostalCode ;
        c.MailingCountry = acc.ShippingCountry ;
        c.Phone = acc.Phone;
        insert c;
        
        Pricebook2 pro = new Pricebook2(Name = Label.Pricebook_Name);
        Insert pro;
        
        Opportunity opp = new Opportunity();
        opp.Name='hari';
        opp.CloseDate = system.today();
        opp.DM_Identified__c = True;
        opp.StageName = 'Presentation/Proof of Concept';
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.Rag_Rating__c = 'Green';
        opp.Pricebook2id = pro.id;
        opp.Amount = 12345.00;
        opp.POC_Presentation_Date__c = system.today();
        opp.Demo_Status__c = 'Not Required';
        opp.CampaignId = Label.Deal_Registration_Campaign_Id;
        insert opp;
        
        OpportunityContactRole conopprole = new OpportunityContactRole();
        conopprole.OpportunityId = Opp.Id;
        conopprole.ContactId = c.Id;
        Insert conopprole;
        //conopprole    
        
        List<Campaign> DealregcampList = new List<Campaign>();
        
        Campaign Dealregcamp = new Campaign();
        
        Dealregcamp.Name = 'Deal Reg Web Form';
        Dealregcamp.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp); 
        
        Campaign Dealregcamp1 = new Campaign();
        
        Dealregcamp1.Name = 'Enterprise Web Form Submission';
        Dealregcamp1.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp1);
        
        Insert DealregcampList;
        
        CampaignMember newcampmembers = new CampaignMember();
        
        newcampmembers.CampaignId = Dealregcamp.Id;
        newcampmembers.Status = 'Enterprise Partner';
        newcampmembers.ContactId = c.id;
        Insert newcampmembers;
        
        PageReference pgRef = Page.Sec_dealRegistration;
        Test.setCurrentPageReference (pgRef);
        Sec_dealRegistrationCtrl deal = new Sec_dealRegistrationCtrl();
        deal.companyName = 'test account';
        deal.keyStakeholderFirstName='test keyStakeholderFirstName';
        deal.keyStakeholderLastName='test keyStakeholderLastName';
        deal.titlePosition='test titlePosition';
        deal.phoneNumber='12345';
        deal.emailAddress='test@gmail.com';
        deal.streetAddress='streetAddress';
        deal.cityVal = 'bangalore';
        deal.postalCodeVal ='postalCodeVal';
        deal.countryVal='test countryVal';
        deal.stateVal=' test stateVal';
        deal.oppNamePartnerCRM='test opp';
        deal.oppDescription='test oppDescription ';
        deal.sectigoClientDiscovery ='Yes';
        deal.sectigoClientDiscoveryOn=system.today();
        deal.expectedCloseDate =system.today();
        deal.expectedOppVal =1234;
        deal.partnerCompanyName ='partnerCompanyName';
        //deal.leadSourceVal ='Webform';
        deal.partnerAccountManagerFirstName ='partnerAccountManagerFirstName';
        deal.partnerAccountManagerLastName='partnerAccountManagerLastName';
        deal.partnerEmailAddress='testduplicate@est.com';
        deal.partnerPhoneNumber='9087654321';
        deal.areYouCurrentWorking = 'N/A';
        system.debug('values required: '+deal.companyName+' and : '+deal.cityVal);
        
        deal.getItems();
        deal.SubmitAction();
        Test.stopTest();
    }
    
    private static testMethod void testCase3(){
        
        Test.startTest();
        Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
        Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
        Account acc = new Account();
        acc.name='test account';
        acc.ShippingCity = 'bangalore';
        acc.ShippingState='teststate';
        acc.ShippingPostalCode='560066';
        acc.ShippingCountry='India';
        acc.Phone='1234567890';
        acc.RecordTypeid=accountRecTypeId;
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'test keyStakeholderLastName';
        c.FirstName = 'test keyStakeholderFirstName';
        c.Email = 'test1@gmailtest.com';
        c.Title = 'dev';
        c.AccountId = acc.Id;        
        c.recordTypeId = contactRecTypeId;
        c.MailingStreet = acc.ShippingStreet;
        c.MailingCity = acc.ShippingCity ;
        c.MailingState = acc.ShippingState ;
        c.MailingPostalCode = acc.ShippingPostalCode ;
        c.MailingCountry = acc.ShippingCountry ;
        c.Phone = acc.Phone;
        insert c;
        
        Account acc1 = new Account();
        acc1.name='test account test account';
        acc1.ShippingCity = 'Visakhapatnam';
        acc1.ShippingState='tetate';
        acc1.ShippingPostalCode='530046';
        acc1.ShippingCountry='India';
        acc1.Phone='7890654123';
        acc1.RecordTypeid=accountRecTypeId;
        insert acc1;
        
        
        
        Contact c1 = new Contact();
        c1.LastName = 'test LastName';
        c1.FirstName = 'test FirstName';
        c1.Email = 'testsuresh@tegmailst.com';
        c1.Title = 'dev';
        c1.AccountId = acc1.Id;        
        c1.recordTypeId = contactRecTypeId;
        c1.MailingStreet = acc1.ShippingStreet;
        c1.MailingCity = acc1.ShippingCity ;
        c1.MailingState = acc1.ShippingState ;
        c1.MailingPostalCode = acc1.ShippingPostalCode ;
        c1.MailingCountry = acc1.ShippingCountry ;
        c1.Phone = acc1.Phone;
        insert c1;
        
        Pricebook2 pro = new Pricebook2(Name = Label.Pricebook_Name);
        Insert pro;
        
        Opportunity opp = new Opportunity();
        opp.Name='hari';
        opp.CloseDate = system.today();
        opp.DM_Identified__c = True;
        opp.StageName = 'Presentation/Proof of Concept';
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.Rag_Rating__c = 'Green';
        opp.Pricebook2id = pro.id;
        opp.Amount = 12345.00;
        opp.POC_Presentation_Date__c = system.today();
        opp.Demo_Status__c = 'Not Required';
        opp.CampaignId = Label.Deal_Registration_Campaign_Id;
        insert opp;
        
        
        OpportunityContactRole conopprole = new OpportunityContactRole();
        conopprole.OpportunityId = Opp.Id;
        conopprole.ContactId = c.Id;
        Insert conopprole;
        //conopprole    
        
        List<Campaign> DealregcampList = new List<Campaign>();
        
        Campaign Dealregcamp = new Campaign();
        
        Dealregcamp.Name = 'Deal Reg Web Form';
        Dealregcamp.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp); 
        
        Campaign Dealregcamp1 = new Campaign();
        
        Dealregcamp1.Name = 'Enterprise Web Form Submission';
        Dealregcamp1.Source_Category__c = 'Outbound';
        DealregcampList.add(Dealregcamp1);
        
        Insert DealregcampList;
        
        CampaignMember newcampmembers = new CampaignMember();
        
        newcampmembers.CampaignId = Dealregcamp.Id;
        newcampmembers.Status = 'Enterprise Partner';
        newcampmembers.ContactId = c.id;
        Insert newcampmembers;
        
        
        
        
        
        
        
        
        
        PageReference pgRef = Page.Sec_dealRegistration;
        Test.setCurrentPageReference (pgRef);
        Sec_dealRegistrationCtrl deal = new Sec_dealRegistrationCtrl();
        deal.companyName = 'test account';
        deal.keyStakeholderFirstName='test FirstName';
        deal.keyStakeholderLastName='test LastName';
        deal.titlePosition='test tition';
        deal.phoneNumber='12345';
        deal.emailAddress='test1@gmailtest.com';
        deal.streetAddress='streetAddress';
        deal.cityVal = 'bangalore';
        deal.postalCodeVal ='postalCodeVal';
        deal.countryVal='test countryVal';
        deal.stateVal=' test stateVal';
        
        deal.oppNamePartnerCRM='test opp';
        deal.oppDescription='test oppDescription ';
        deal.sectigoClientDiscovery ='Yes';
        deal.sectigoClientDiscoveryOn=system.today();
        deal.expectedCloseDate =system.today();
        deal.expectedOppVal = 1234;
        
        deal.partnerCompanyName ='test account test account';
        //deal.leadSourceVal ='Webform';
        deal.partnerAccountManagerFirstName ='parnagerFirstName';
        deal.partnerAccountManagerLastName='partnerAccostName';
        deal.partnerEmailAddress='testsuresh@tegmailst.com';
        deal.partnerPhoneNumber='9087654321';
        deal.areYouCurrentWorking = 'N/A';
        system.debug('values required: '+deal.companyName+' and : '+deal.cityVal);
        
        deal.getItems();
        deal.SubmitAction();
        Test.stopTest();
    }
}