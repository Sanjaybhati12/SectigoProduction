@isTest
Public class Com_OpportunityContact_Test {
    @isTest
    Private static void Com_OpportunityContact_testmethod1() {
        
        Date closeDt = Date.Today().adddays(10);
        date myDate = date.today();
        Account a2 = new Account(Name = 'icrm testing acc');
        insert a2;
        Contact con = new Contact();
        con.FirstName = 'test1';
        con.LastName = 'test2';
        con.Accountid = a2.id;
        con.Email = 'test@abc.com';
        insert con;
        Pricebook2 pb22 = new Pricebook2(Name = 'testDIE');
        insert pb22;
        OpportunityController__c oc = new OpportunityController__c();
        //oc.Check_Contact_Role__c = true;
        oc.Check_Product_On_Retail__c = true;
        oc.Check_Contact_Role__c =true;
        oc.Is_Product_Validation__c = true;
        oc.Check_Product_and_Plateform_Interest__c = true;
        oc.Check_Quote_on_Enterprise__c =true;
        oc.Check_Campaign_On_Lead_Source__c = true;
        oc.Create_Task_On_Update__c = true;
        oc.Set_BDR_Transfer__c = true;
        oc.Set_Primary_Quote_Discount_Approve__c = true;
        oc.Set_Primary_Quote_Approved__c = true;
        oc.Set_Price_Book__c = true;
        insert oc;
        
        
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        opportunity opp = new opportunity();
        opp.Name = 'testing DIE 4/6/2015';
        opp.AccountId = a2.Id;
        opp.StageName = 'Presentation';
        opp.CloseDate = closeDt;
        opp.RecordTypeId = OppRetailRecId;
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.OMS_Account_Manager__c = 'test';
        opp.Order_Number__c = 'test';
        opp.Contract_Start_Date__c = system.today();
        opp.Contract_Term_Months__c = 12;
        opp.Current_Status__c = 'test demo';
        
        opp.PO_Required__c = true;
        opp.PO_Amount__c = 100;
        opp.PO_Type__c = 'One-Year';
        opp.PO_Number__c = 'demo';
        opp.DM_Identified__c = true;
        opp.BDR_Transfer_Date__c = null;
        opp.BDR_Transfer__c = false;
        opp.PriceBook2Id = pb22.id;
        insert opp;
        
        OpportunityContactRole occ = new OpportunityContactRole ();
        occ.Contactid = con.id;
        occ.Opportunityid = opp.id;
        occ.Role = 'Decision Maker';
        occ.IsPrimary = true;
        insert occ;
        
        occ.Contactid = con.id;
        occ.Role = 'Billing Primary ';
        occ.IsPrimary = true;
        update occ;
        
        
        String standardPriceBook = Test.getStandardPricebookId();
        
        opp.Current_Status__c = 'Hello Hi';
        update opp;
        
        opp.StageName = 'Contract Review/Redline';
        update opp;
        
        
        
        
        
        Opportunity oppObj = [SELECT Id, PriceBook2Id FROM Opportunity];
        Product2 pro2 = new Product2(Name = 'BXCD', isActive = true);
        insert pro2;
        PricebookEntry pbe = new PricebookEntry(unitprice = 0.01, Product2Id = pro2.Id, Pricebook2Id = standardPriceBook,
                isActive = true);
        INSERT pbe;
        PricebookEntry pbe2 = new PricebookEntry(unitprice = 0.01, Product2Id = pro2.Id,Pricebook2Id = oppObj.Pricebook2Id,
                isActive = true);
        insert pbe2;
        system.debug('!@@' + pbe2.Pricebook2Id);
        system.debug('@@1' + standardPriceBook);
        
        
        test.startTest();
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity = 2, OpportunityId = opp.Id, UnitPrice = 0.01, PriceBookEntryId = pbe2.Id
        );
        insert OPplineitem2;
        
        
        //Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        



        Account a3 = new Account(Name = 'icrm testing acc');
        insert a3;
        Contact con1 = new Contact();
        con1.FirstName = 'test1';
        con1.LastName = 'test2';
        con1.Accountid = a3.id;
        con1.Email = 'test@abc.com';
        insert con1;
        Pricebook2 pb222 = new Pricebook2(Name = 'testDIE');
        insert pb222;
        //List<Opportunity> newOpp = new List<Opportunity>();
        Id OppRetailRecId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        Id oppEnterPriseId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        opportunity opp1 = new opportunity();
        opp1.Name = 'testing';
        opp1.AccountId = a3.Id;
        opp1.StageName = 'Contract Review/Redline';
        opp1.CloseDate = closeDt;
        opp1.RecordTypeId = RecordTypeIdOpp;
        opp1.Forecast_CategoryCom__c = 'Committed';
        opp1.OMS_Account_Manager__c = 'test1';
        opp1.Order_Number__c = 'test1';
        opp1.Contract_Start_Date__c = system.today();
        opp1.Contract_Term_Months__c = 10;
        opp1.PO_Required__c = true;
        opp1.PO_Amount__c = 1009;
        opp1.PO_Type__c = 'One-Year';
        opp1.PO_Number__c = 'demo1';
        opp1.Email_Contact_for_PO__c = 'test@daze.com';
        opp1.BDR_Transfer_Date__c = null;
        opp1.BDR_Transfer__c = false;
        //opp.SBQQ__PrimaryQuote__c = SbQ.id;
        //newOpp.add(opp1);
        insert opp1;
        
        
        OpportunityContactRole occ1 = new OpportunityContactRole ();
        occ1.Contactid = con1.id;
        occ1.Opportunityid = opp1.id;
        occ1.Role = 'Decision Maker';
        occ1.IsPrimary = true;
        insert occ1;
        
        SBQQ__Quote__c SbQ1 = new SBQQ__Quote__c();
        SbQ1.SBQQ__Account__c = a3.id;
        SbQ1.SBQQ__Opportunity2__c = opp1.id;
        SbQ1.SBQQ__Primary__c = true;
        SbQ1.SBQQ__Status__c = 'Approved';

        SbQ1.SBQQ__SubscriptionTerm__c = 12;
        insert SbQ1;
        opp1.StageName = 'Deal Approval';
        update opp1;
       
		test.stopTest();
    }
    @isTest
    private static void Com_OpportunityContact_RecordLockTestMethod() {
        Account a2 = new Account(Name ='icrm22');
        insert a2;  
        Contact con= new Contact();
        con.FirstName='test122';
        con.LastName='test222';
        con.Accountid=a2.id;
        con.Email='test22@abc.com';
        insert con;
        Pricebook2 pb22 = new Pricebook2(Name='test22DIE');
        insert pb22;
         Test.startTest();
        //List<Opportunity> newOppList = new List<Opportunity>();
        Id oppEnterPriseId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        opportunity opportunityInstance = new opportunity();
        opportunityInstance.Name = 'testing';
        opportunityInstance.AccountId = a2.id;
        opportunityInstance.StageName = 'New';
        opportunityInstance.CloseDate = Date.today();
        opportunityInstance.RecordTypeId = oppEnterPriseId1;
        opportunityInstance.Forecast_CategoryCom__c = 'Committed';
        opportunityInstance.OMS_Account_Manager__c = 'test1';
        opportunityInstance.Order_Number__c = 'test1';
        opportunityInstance.Contract_Start_Date__c = system.today();
        opportunityInstance.Contract_Term_Months__c = 10;
        opportunityInstance.PO_Required__c = true;
        opportunityInstance.PO_Amount__c = 1009;
        opportunityInstance.PO_Type__c = 'One-Year';
        opportunityInstance.PO_Number__c = 'demo1';
        opportunityInstance.BDR_Transfer_Date__c = null;
        opportunityInstance.BDR_Transfer__c = false;
        //newOppList.add(opportunityInstance);
        insert opportunityInstance;
        Quote quot = new Quote ();           
        quot.Name = 'TestPro';            
        //quot.Status ='Draft';           
        quot.OpportunityId = opportunityInstance.id ;           
        insert quot;
        OpportunityContactRole occ= new OpportunityContactRole ();
        occ.Contactid=con.id;
        occ.Opportunityid=opportunityInstance.id;
        occ.Role = 'Decision Maker';
        occ.IsPrimary =true;
        insert occ;
        //Com_OpportunityContactHelperClass.setPriceBook(newOppList);
        SBQQ__Quote__c SbQ1 = new SBQQ__Quote__c();
        //sbQ1.Name__c = 'test56';
        SbQ1.SBQQ__Account__c = a2.id;
        SbQ1.SBQQ__Opportunity2__c = opportunityInstance.id;
        SbQ1.SBQQ__Primary__c = true;
        SbQ1.SBQQ__Status__c = 'Discount Approved';

        SbQ1.SBQQ__SubscriptionTerm__c = 12;
        insert SbQ1;
        
        Test.stopTest();
    }
    
     @isTest
    Private static void Com_OpportunityContact_testmethod4() {
        
        Date closeDt = Date.Today().adddays(10);
        date myDate = date.today();
        Account a2 = new Account(Name = 'icrm testing acc');
        insert a2;
        Contact con = new Contact();
        con.FirstName = 'test1';
        con.LastName = 'test2';
        con.Accountid = a2.id;
        con.Email = 'test@abc.com';
        insert con;
        Pricebook2 pb22 = new Pricebook2(Name = 'testDIE');
        insert pb22;
        OpportunityController__c oc = new OpportunityController__c();
        //oc.Check_Contact_Role__c = true;
        oc.Check_Product_On_Retail__c = true;
        oc.Check_Contact_Role__c =true;
        oc.Is_Product_Validation__c = true;
        oc.Check_Product_and_Plateform_Interest__c = true;
        oc.Check_Quote_on_Enterprise__c =true;
        oc.Check_Campaign_On_Lead_Source__c = true;
        oc.Create_Task_On_Update__c = true;
        oc.Set_BDR_Transfer__c = true;
        oc.Set_Primary_Quote_Discount_Approve__c = true;
        oc.Set_Primary_Quote_Approved__c = true;
        oc.Set_Price_Book__c = true;
        insert oc;
        
        
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        opportunity opp = new opportunity();
        opp.Name = 'Renewal Opportunity testing DIE 4/6/2015';
        opp.AccountId = a2.Id;
        opp.StageName = 'Presentation';
        opp.CloseDate = closeDt;
        opp.RecordTypeId = OppRetailRecId;
        opp.Forecast_CategoryCom__c = 'Committed';
        opp.OMS_Account_Manager__c = 'test';
        opp.Order_Number__c = 'test';
        opp.Contract_Start_Date__c = system.today();
        opp.Contract_Term_Months__c = 12;
        opp.Current_Status__c = 'test demo';
        
        opp.PO_Required__c = true;
        opp.PO_Amount__c = 100;
        opp.PO_Type__c = 'One-Year';
        opp.PO_Number__c = 'demo';
        opp.DM_Identified__c = true;
        opp.BDR_Transfer_Date__c = null;
        opp.BDR_Transfer__c = false;
        opp.PriceBook2Id = pb22.id;
        insert opp;
        
        OpportunityContactRole occ = new OpportunityContactRole ();
        occ.Contactid = con.id;
        occ.Opportunityid = opp.id;
        occ.Role = 'Decision Maker';
        occ.IsPrimary = true;
        insert occ;
        
        occ.Contactid = con.id;
        occ.Role = 'Billing Primary ';
        occ.IsPrimary = true;
        update occ;
        
        
        String standardPriceBook = Test.getStandardPricebookId();
        
        opp.Current_Status__c = 'Hello Hi';
        update opp;
        
        opp.StageName = 'Contract Review/Redline';
        update opp;
        
        
        
        
        
        Opportunity oppObj = [SELECT Id, PriceBook2Id FROM Opportunity];
        Product2 pro2 = new Product2(Name = 'BXCD', isActive = true);
        insert pro2;
        PricebookEntry pbe = new PricebookEntry(unitprice = 0.01, Product2Id = pro2.Id, Pricebook2Id = standardPriceBook,
                isActive = true);
        INSERT pbe;
        PricebookEntry pbe2 = new PricebookEntry(unitprice = 0.01, Product2Id = pro2.Id,Pricebook2Id = oppObj.Pricebook2Id,
                isActive = true);
        insert pbe2;
        system.debug('!@@' + pbe2.Pricebook2Id);
        system.debug('@@1' + standardPriceBook);
        
        
        test.startTest();
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity = 2, OpportunityId = opp.Id, UnitPrice = 0.01, PriceBookEntryId = pbe2.Id
        );
        insert OPplineitem2;
        
        
        //Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        



        Account a3 = new Account(Name = 'icrm testing acc');
        insert a3;
        Contact con1 = new Contact();
        con1.FirstName = 'test1';
        con1.LastName = 'test2';
        con1.Accountid = a3.id;
        con1.Email = 'test@abc.com';
        insert con1;
        Pricebook2 pb222 = new Pricebook2(Name = 'testDIE');
        insert pb222;
        //List<Opportunity> newOpp = new List<Opportunity>();
        Id OppRetailRecId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        Id oppEnterPriseId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        opportunity opp1 = new opportunity();
        opp1.Name = 'Amendment for contract test';
        opp1.AccountId = a3.Id;
        opp1.StageName = 'Contract Review/Redline';
        opp1.CloseDate = closeDt;
        opp1.RecordTypeId = RecordTypeIdOpp;
        opp1.Forecast_CategoryCom__c = 'Committed';
        opp1.OMS_Account_Manager__c = 'test1';
        opp1.Order_Number__c = 'test1';
        opp1.Contract_Start_Date__c = system.today();
        opp1.Contract_Term_Months__c = 10;
        opp1.PO_Required__c = true;
        opp1.PO_Amount__c = 1009;
        opp1.PO_Type__c = 'One-Year';
        opp1.PO_Number__c = 'demo1';
        opp1.Email_Contact_for_PO__c = 'test@daze.com';
        opp1.BDR_Transfer_Date__c = null;
        opp1.BDR_Transfer__c = false;
        //opp.SBQQ__PrimaryQuote__c = SbQ.id;
        //newOpp.add(opp1);
        insert opp1;
        
        
        OpportunityContactRole occ1 = new OpportunityContactRole ();
        occ1.Contactid = con1.id;
        occ1.Opportunityid = opp1.id;
        occ1.Role = 'Decision Maker';
        occ1.IsPrimary = true;
        //insert occ1;
        
        SBQQ__Quote__c SbQ1 = new SBQQ__Quote__c();
        SbQ1.SBQQ__Account__c = a3.id;
        SbQ1.SBQQ__Opportunity2__c = opp1.id;
        SbQ1.SBQQ__Primary__c = true;
        SbQ1.SBQQ__Status__c = 'Approved';

        SbQ1.SBQQ__SubscriptionTerm__c = 12;
        insert SbQ1;
       
        opp1.StageName = 'Deal Approved';
        Com_OpportunityContactHelperClass.insertCall = false;
        update opp1;
       	
        Delete opp1;
		test.stopTest();
    }
    
    public testmethod static void testMethod2(){
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
        test.startTest();
        insert oppList;
        delete opp1;
        test.stopTest();
    }
}