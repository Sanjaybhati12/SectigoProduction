@isTest
private class updateTasktest {
    
    public static testMethod void testTrigger(){
        
        
        
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
        
        Lead testLead = new Lead();
        testLead.FirstName = 'Test First';
        testLead.LastName = 'Test Last';
        testLead.Company = 'Test Co';
        testLead.email='testlead@gmail.com';
        testLead.Account_Creation_Approval__c='Approved';
        testLead.Segment__c='Retail';
        testLead.Product_Interest__c='SMIME';
        insert testLead;
        
        
        
        Id taskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Id generalRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id           
        );
        insert ct;
        
        Opportunity o=new Opportunity();        
        o.Name='Example1';
        o.StageName='Presentation';
        o.AccountId=acc.Id;
        o.CloseDate=system.today();
        o.Order_Number__c =  '123456';
        o.Contract_Term_Months__c = 123;
        //o.Pricebook2Id = EnterpricePB[0].Id ;
        insert o;
        test.startTest();
        List<task> t = new List<task>();
        task task1= new task(WhatID = acc.id,Subject='Outbound',Status='Completed',Priority='Normal',activitydate = date.today());
        task t2= new task(WhatID = acc.id,Subject='test . Email:',Status='Completed',Priority='Normal',whoId=ct.Id,activitydate = date.today());
        task t3= new task(Subject='Outbound',Status='Completed',Priority='Normal',whoId=testLead.Id,activitydate = date.today());
        task t4= new task(WhatID = o.id,Subject='test . Email:',Status='Completed',Priority='Normal',activitydate = date.today());
        task t5 = new task(WhoID = testLead.id,Subject='test . Email:',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId);
        task t6 = new task(WhoID = testLead.id,Subject='testrecordtype test:',type='Automated Email',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = generalRecordTypeId );
        task t7 = new task(WhoID = testLead.id,Subject='testrecordtype test:',type='HubSpot WebForm',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId );
        task t8 = new task(WhoID = ct.id,Employee_count__c = '800',Subject='testrecordtype test:',Customer_Segment__c='Channel Partner',type='HubSpot WebForm',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId );
        //t8.Description = 'First name: Rodrigo Last name: Stefaneli Email: rodrigo.arquiteto@gmail.com Company name: RS Arquitetura Employee Count: 0-250 Region: South America S/MIME Quantity: 1-10 Subject:: Arquitetura Webform Name: Sectigo Lead Source: Webform sfCampaignId:7013F000000Uh0aQAC';
        t.add(task1);
        t.add(t2);
        t.add(t3);
        t.add(t4);
        t.add(t5);
        t.add(t6);
        t.add(t7);
        t.add(t8);
        if(!t.isEmpty())
        insert t;  
        
        test.stopTest();
        
        
        
        List<Opportunity> opp = new List<Opportunity>{ new opportunity(
            name = 'test opp 1',
            StageName = 'Oferecer projeto/orçamento',
            LeadSource = 'Google',
            CloseDate = system.today()) };
                insert opp;
        
        List<task> tt = new List<task>();
        task t3t=new task();
        t3t.WhatID = opp[0].id;
        t3t.Subject='Donni';
        t3t.Status='New';
        t3t.Priority='Normal';
     
        tt.add(t3t);
        t3t.Description='First name: Rodrigo';
        t3t.Company_Name__c='fieldName';
        t3t.Employee_Count__c='Employee Count';
        t3t.Campaign_Name__c='fieldvalue';
       
        insert t3t;
      // t3t.Employee_Count__c='Employee Count';
       // t3t.Company_Name__c='fieldvalue';
        t3t.Subject = 'Hello how';
        // t3t.Description='First name: Rodrigo';
      
        update t3t;
         
    }
}