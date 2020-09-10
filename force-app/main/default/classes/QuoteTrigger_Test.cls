@isTest
public class QuoteTrigger_Test {
    static testmethod void  insertOpp() {
        quoteTriggerHandler qth = new quoteTriggerHandler();
        Account acc = new Account (name='Acme');
        insert acc;
       Contact c = new Contact();
		c.FirstName = 'Paul';
		c.LastName  = 'Test';
		c.AccountId = acc.id;
		c.MailingStreet = '298 S. Ringo Street';
		c.MailingCity = 'Little Rock';
		c.MailingState = 'AR';
		c.MailingPostalCode = '72201'; 
		
		insert c;
        Opportunity opp= new Opportunity ();
        opp.name= 'Testopp';
        Opp.Accountid= acc.id;
        opp.CloseDate= date.today();
        opp.StageName= 'Qualification';
        
        insert opp;

Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
    insert pb;
Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
    insert prod;
PricebookEntry pbe=new PricebookEntry(unitprice=0.01,Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
     insert pbe;   
       
        Quote q= new Quote ();
        	 q.Name= 'Testq';
        	q.OpportunityId= Opp.id;
        	q.BillingStreet= '123';
        	q.BillingCity= 'City';
        	q.BillingPostalCode= '12345';
        	q.Pricebook2Id= pb.id;
        	insert q;
        OpportunityContactRole ocr = new OpportunityContactRole();
		ocr.ContactId = c.Id;
		ocr.OpportunityId = opp.Id;
		ocr.IsPrimary = TRUE;
		ocr.Role = 'Decision Maker';
		insert ocr;
        
        SBQQ__Quote__c SbQ = new SBQQ__Quote__c();
        
        SbQ.SBQQ__Opportunity2__c = opp.id;
        SbQ.SBQQ__Primary__c = true;
        insert SbQ;
       
     // QuoteLineItem qli= new QuoteLineItem(id=q.id, PricebookEntryid= pbe.Id,  quantity=2);
       // insert qli;
       // opp.StageName= 'Closed Won';

									}
}