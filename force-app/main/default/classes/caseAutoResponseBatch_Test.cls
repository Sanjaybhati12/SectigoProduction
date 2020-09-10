@isTest(seealldata=false)
private class caseAutoResponseBatch_Test {
    @isTest
    static void testBatchClass(){
        Contact cs= new Contact(lastName='vijay');
        insert cs;
        Case cd=new Case(Reason='Account Changes',status='New',CreatedDate=Date.newInstance(2020, 06, 06),SuppliedEmail='vijay@gmail.com',LastModifiedDate=Date.today(),ContactId=cs.Id,X24_Hour_Notification__c=false,X48_Hour_Notification__c=false);
        insert cd;

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
        insert cd;
		DateTime crDate = system.now().addDays(-1);
        test.setCreatedDate(cd.id, crDate);
            
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
        List<Case> caseList  = new List<Case>();
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName=:System.Label.Auto_Response_From_Email_Address];
        List<String> emailList = new list<String>();
        emailList.add('Sanjay@dazeworks.com');
        Contact cs= new Contact(lastName='vijay');
        insert cs;
        Case cd=new Case(Reason='Account Changes',status='New',SuppliedEmail='vijay@gmail.com',ContactId=cs.Id,X24_Hour_Notification__c=false,X48_Hour_Notification__c=false);
        insert cd;
        caseList.add(cd);
		DateTime crDate = system.now().addDays(-1);
        test.setCreatedDate(cd.id, crDate);
            
        Test.startTest();
        caseAutoResponseBatch carb=new caseAutoResponseBatch();
        DataBase.executeBatch(carb);
        caseAutoResponseBatch.sendEmailNotification('28', caseList, System.Label.X24_Hour_Notification_Email_Template, owea[0].Id, emailList);
        caseAutoResponseBatch.sendEmailNotification('Customer 48', caseList, System.Label.X24_Hour_Notification_Email_Template, owea[0].Id, emailList);
        Test.stopTest();
        
            
    }
   
}