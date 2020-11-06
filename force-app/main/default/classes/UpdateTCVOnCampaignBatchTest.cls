@isTest
public class UpdateTCVOnCampaignBatchTest {
    public static testmethod void updateTestOpp(){
        
        List<Opportunity> oppList = new List<Opportunity>(); 
        
        campaign cmp = new Campaign(Name='WHMCS Test',Source_Category__c='Inbound',CurrencyIsoCode='USD');
        insert cmp;
        Id accountRecTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
        Id contactRecTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id oppRecTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
        Account acc = new Account(name='test account',ShippingCity = 'bangalore',ShippingState='teststate',ShippingPostalCode='560066',ShippingCountry='India',Phone='1234567890',RecordTypeid=accountRecTypeId);
        insert acc;
        Contact c = new Contact(LastName = 'test keyStakeholderLastName',FirstName = 'test keyStakeholderFirstName',Email = 'test1@gmailtest.com',Title = 'dev',AccountId = acc.Id,recordTypeId = contactRecTypeId,MailingStreet = acc.ShippingStreet,MailingCity = acc.ShippingCity ,MailingState = acc.ShippingState ,MailingPostalCode = acc.ShippingPostalCode ,MailingCountry = acc.ShippingCountry ,Phone = acc.Phone);
        insert c;
        
        Opportunity opp = new Opportunity( Name='Test Opportunity',CloseDate = system.today(),StageName = 'Sales Qualified Lead',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        Opportunity opp1 = new Opportunity( Name='Test Opportunity',CloseDate = system.today(),StageName = 'Sales Qualified Lead',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        Opportunity opp2 = new Opportunity( Name='Test Opportunity',Order_Value_New__c=123,CloseDate = system.today(),StageName = 'Closed Won',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        Opportunity opp3 = new Opportunity( Name='Test Opportunity',Order_Value_New__c=123,CloseDate = system.today(),StageName = 'Closed Won',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        Opportunity opp4 = new Opportunity( Name='Test Opportunity',Lost_Reason__c='inValied',CloseDate = system.today(),StageName = 'Closed Lost',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        Opportunity opp5 = new Opportunity( Name='Test Opportunity',Lost_Reason__c='inValied',CloseDate = system.today(),StageName = 'Closed Lost',Amount = 12345.00,AccountId = acc.Id,CampaignId =cmp.Id,RecordTypeId=oppRecTypeId);
        oppList.add(opp);oppList.add(opp1);oppList.add(opp2);oppList.add(opp3);oppList.add(opp4);oppList.add(opp5);
        insert oppList;
        
        Test.startTest();
        Database.executeBatch(new UpdateTCVOnCampaignBatch(),10);
        Test.stopTest();

    }
}