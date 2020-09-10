/** Class Name   : Com_NoActivityCaseScheduleTest 
*  Description  : Test class for Schedul Class 
*                     
*  Created By   : Veera
*  Created On   : 08-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
@isTest
private class Com_NoActivityCaseScheduleTest {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
        // Create some out of date case records
         Com_NoActivityCase.dateField = Case.Duetime__c;      
       List<Case> Cases= new List<Case>();       
        Case c = new Case();        
        C.Status = 'Awaiting Customer Reply';
        c.Duetime__c= System.now().addDays(-3);
        Cases.add(c);        
         Case c1 = new Case();        
        C1.Status = 'Awaiting Customer Reply';
        c1.Duetime__c= System.now().addDays(-4);
        Cases.add(c1);        
         Case c2 = new Case();        
        C2.Status = 'Awaiting Customer Reply';
        c2.Duetime__c= System.now().addDays(-3);
        Cases.add(c2);        
         Case c3 = new Case();        
        C3.Status = 'Awaiting Customer Reply';
        c3.Duetime__c= System.now().addDays(-3);
        Cases.add(c3);        
        insert Cases;
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new Com_NoActivityCaseSchedule ());         
      
        // Stopping the test will run the job synchronously
        Test.stopTest();
     
    }
}