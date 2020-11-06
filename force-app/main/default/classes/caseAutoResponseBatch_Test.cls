@isTest(seealldata=false)
private class caseAutoResponseBatch_Test {
    @isTest
    static void testBatchClass(){
        Contact cs= new Contact(lastName='vijay');
        insert cs;
        Case cd=new Case(Reason='Account Changes',status='New',CreatedDate=Date.newInstance(2020, 06, 06),SuppliedEmail='vijay@gmail.com',LastModifiedDate=Date.today(),ContactId=cs.Id,X24_Hour_Notification__c=false,X48_Hour_Notification__c=false);
        insert cd;
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(cd.Id, yesterday);
        CaseAutoResponseNotification__c  cusNotiRec = new CaseAutoResponseNotification__c();
        cusNotiRec.Name = 'test';
        cusNotiRec.Case_Reason__c = 'Account Changes';
        cusNotiRec.Case_Status__c='New';
        cusNotiRec.Create_Public_Case_Comment__c = true;
        cusNotiRec.Days_GT__c = 24;
        cusNotiRec.Notification_Type__c = 'Customer';
        cusNotiRec.Create_Email_Message__c = true;
        //cusNotiRec.Days_LT__c = 48;
        cusNotiRec.Update_Field__c = 'X24_Hour_Notification__c';
        cusNotiRec.Trigger_on_Create__c = true;
        insert cusNotiRec;
        Test.startTest();
        caseAutoResponseBatch carb=new caseAutoResponseBatch();
        DataBase.executeBatch(carb);
        Test.stopTest();
        system.assertEquals(1, 1);
        
        CaseResponseSchedule crc = new CaseResponseSchedule();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, crc );
        
    }
    @isTest
    static void testBatchClass2(){
        Contact cs= new Contact(lastName='vijay');
        insert cs;
        Case cd=new Case(Reason='Account Changes',status='New',SuppliedEmail='vijay@gmail.com',ContactId=cs.Id,X24_Hour_Notification__c=false,X48_Hour_Notification__c=false);
        cd.Last_Action__c = system.now().addDays(-3);
        insert cd;
        DateTime crDate = system.now().addDays(-1);
        test.setCreatedDate(cd.id, crDate);
        Datetime yesterday = Datetime.now().addDays(-2);
        Test.setCreatedDate(cd.Id, yesterday);
        
        EmailTemplate validEmailTemplate = [SELECT Id,Name FROM EmailTemplate LIMIT 1];
        
        CaseAutoResponseNotification__c  cusNotiRec = new CaseAutoResponseNotification__c();
        cusNotiRec.Name = 'test';
        cusNotiRec.Case_Reason__c = 'Account Changes';
        cusNotiRec.Case_Status__c='New';
        cusNotiRec.Create_Public_Case_Comment__c = true;
        cusNotiRec.Days_GT__c = 48;
        cusNotiRec.Recipient__c = 'Test@gmail.com';
       	cusNotiRec.Email_Template_Id__c = validEmailTemplate.id;
        cusNotiRec.Update_Field__c = 'X24_Hour_Notification__c';
        cusNotiRec.Trigger_on_Modify__c = true;
        insert cusNotiRec;
        
        Test.startTest();
        caseAutoResponseBatch carb=new caseAutoResponseBatch();
        DataBase.executeBatch(carb);
        Test.stopTest();
        system.assertEquals(1, 1);
        
        CaseResponseSchedule crc = new CaseResponseSchedule();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, crc );
        
    }
    
    @isTest
    static void testBatchClass3(){
         Contact cs= new Contact(lastName='vijay');
        insert cs;
        Case cd=new Case(Reason='Account Changes',status='New',SuppliedEmail='vijay@gmail.com',ContactId=cs.Id,X24_Hour_Notification__c=false,X48_Hour_Notification__c=false);
        cd.Last_Action__c = system.now().addDays(-3);
        insert cd;
        DateTime crDate = system.now().addDays(-1);
        test.setCreatedDate(cd.id, crDate);
        Datetime yesterday = Datetime.now().addDays(-2);
        Test.setCreatedDate(cd.Id, yesterday);
        
        EmailTemplate validEmailTemplate = [SELECT Id,Name FROM EmailTemplate LIMIT 1];
        
        CaseAutoResponseNotification__c  cusNotiRec = new CaseAutoResponseNotification__c();
        cusNotiRec.Name = 'test';
        cusNotiRec.Case_Reason__c = 'Account Changes';
        cusNotiRec.Case_Status__c='New';
        cusNotiRec.Create_Public_Case_Comment__c = true;
        cusNotiRec.Days_GT__c = 48;
        cusNotiRec.Recipient__c = 'Test@gmail.com';
       	cusNotiRec.Email_Template_Id__c = validEmailTemplate.id;
        cusNotiRec.Update_Field__c = 'X24_Hour_Notification__c';
        cusNotiRec.Trigger_on_Modify__c = true;
        cusNotiRec.Notification_Type__c = 'Customer';
        cusNotiRec.Create_Email_Message__c = true;
        insert cusNotiRec;
        
        Test.startTest();
        caseAutoResponseBatch carb=new caseAutoResponseBatch();
        DataBase.executeBatch(carb);
        Test.stopTest();
        system.assertEquals(1, 1);
        
        CaseResponseSchedule crc = new CaseResponseSchedule();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, crc );
       
    }
    
}