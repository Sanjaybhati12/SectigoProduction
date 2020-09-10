@isTest
Public class OpportunityContactRoleTest {
    @isTest
    Private static  void OpportunityContactRoleTestMethod(){
        Campaign cmp = new Campaign();
        cmp.Name = 'Enterprise Web Form Submission';
        cmp.Source_Category__c = 'Inbound';
        insert cmp;
        
        Date closeDt = Date.Today().adddays(10);            
        date myDate = date.today();        
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;  
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test2';
        con.Accountid=a2.id;
        con.Email='test@abc.com';
        insert con;
        
        CampaignMember cmpMem = new CampaignMember();
        cmpMem.CampaignId = cmp.Id;
        cmpMem.ContactId = con.Id;
        insert cmpMem;
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
       	opportunity opp=new opportunity();
        opp.Name='testing DIE 4/6/2015';
        opp.AccountId=a2.Id;
        opp.Pricebook2Id = pb22.Id;
        opp.StageName='Presentation';
        opp.CloseDate=closeDt;
        opp.RecordTypeId=RecordTypeIdOpp;
        opp.Forecast_CategoryCom__c='Committed';
        opp.OMS_Account_Manager__c = 'test';
        opp.Order_Number__c = 'test';
        opp.Contract_Start_Date__c = system.today();
        opp.Contract_Term_Months__c = 12;
        opp.PO_Required__c = true;
        opp.PO_Amount__c = 100;
        opp.PO_Type__c = 'One-Year';
        opp.Email_Contact_for_PO__c = 'test@gmail.com';
        opp.PO_Number__c = 'demo';
        opp.DM_Identified__c = true;
        
		insert opp;
        OpportunityContactRole occ= new OpportunityContactRole ();
        occ.Contactid=con.id;
        occ.Opportunityid=opp.id;
        occ.Role = 'Decision Maker';
        occ.IsPrimary =true;
        insert occ;
        occ.Contactid=con.id;
        occ.Role = 'Billing Primary	';
        occ.IsPrimary =true;
        update occ;
        String standardPriceBook = Test.getStandardPricebookId();
        
        Opportunity oppObj = [SELECT Id, PriceBook2Id FROM Opportunity];
        Product2 pro2 = new Product2(Name='BXCD', isActive=true);
        insert pro2;
        PricebookEntry pbe =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=standardPriceBook,
                                               isActive=true);
        INSERT pbe;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=oppObj.pricebook2Id,
                                                isActive=true);
        insert pbe2;
        system.debug('!@@' + pbe2.Pricebook2Id);
        system.debug('@@1' + standardPriceBook);
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id
                                                                   );
        insert OPplineitem2;
        Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();        
        Id oppEnterPriseId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        opp.StageName='Deal Approval';
        opp.Current_Status__c = 'Test for creating tasks';
        opp.RecordTypeId=RecordTypeIdOpp;
        opp.Pltform_Interest__c='SCM';
        opp.Original_Interest__c='Private CA';
        
        update opp;
     	Account a3 = new Account(Name ='icrm testing acc');
        insert a3;  
        Contact con1= new Contact();
        con1.FirstName='test1';
        con1.LastName='test2';
        con1.Accountid=a3.id;
        con1.Email='test@abc.com';
        insert con1;
        Pricebook2 pb222 = new Pricebook2(Name='testDIE');
        insert pb222;
        Id OppRetailRecId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();        
        Id oppEnterPriseId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        opportunity opp1=new opportunity();
        opp1.Name='testing';
        opp1.AccountId=a3.Id;
        opp1.StageName='Contract Review/Redline';
        opp1.CloseDate=closeDt;
        opp1.RecordTypeId=RecordTypeIdOpp;
        opp1.Forecast_CategoryCom__c='Committed';
        opp1.OMS_Account_Manager__c = 'test1';
        opp1.Order_Number__c = 'test1';
        opp1.Contract_Start_Date__c = system.today();
        opp1.Contract_Term_Months__c = 10;
        opp1.PO_Required__c = true;
        opp1.PO_Amount__c = 1009;
        opp1.PO_Type__c = 'One-Year';
        opp1.PO_Number__c = 'demo1';
        
		insert opp1;
        OpportunityContactRole occ1= new OpportunityContactRole ();
        occ1.Contactid=con1.id;
        occ1.Opportunityid=opp1.id;
        occ1.Role = 'Decision Maker';
        occ1.IsPrimary =true;
        insert occ1;
    }
    
	}