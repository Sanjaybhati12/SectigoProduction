@isTest
public class UpdateTouchPointsBatchTest{
    
    static testMethod void PositiveMethod(){
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
        
        Id taskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
        
        
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
        
        List<task> t = new List<task>();
        task t1= new task(WhatID = acc.id,Subject='Outbound',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId);
        task t2= new task(WhatID = acc.id,Subject='test . Email:',Status='Completed',Priority='Normal',whoId=ct.Id,activitydate = date.today(),recordTypeId = taskTypeId);
        task t3= new task(Subject='Outbound',Status='Completed',Priority='Normal',whoId=testLead.Id,activitydate = date.today(),recordTypeId = taskTypeId);
        task t4= new task(WhatID = o.id,Subject='test . Email:',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId);
        task t5 = new task(WhoID = testLead.id,Subject='test . Email:',Status='Completed',Priority='Normal',activitydate = date.today(),recordTypeId = taskTypeId);
       
        t.add(t1);
        t.add(t2);
        t.add(t3);
        t.add(t4);
        t.add(t5);
        if(!t.isEmpty())
             insert t;  
             
             test.startTest();
                 UpdateTouchPointsBatch obj = new UpdateTouchPointsBatch();
                 DataBase.executeBatch(obj);
             test.stopTest();
     }
        
    }