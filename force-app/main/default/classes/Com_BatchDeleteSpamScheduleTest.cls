/** Class Name   : Com_BatchDeleteSpamScheduleTest 
*  Description  : Test class for Com_BatchDeleteSpamSchedule Class 
*                     
*  Created By   : Srivalli
*  Created On   : 26-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/

@isTest
public class Com_BatchDeleteSpamScheduleTest{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   private Static testmethod void testschedule(){
    List<case> casesTest = new List<Case>();
    Case c1= new Case();
    c1.Subject='[SPAM]test1';
    casesTest.add(c1);
    Case c2= new Case();
    c2.Subject='[SPAM]test2';
    casesTest.add(c2);
     insert casesTest;
     Test.StartTest();
         // Schedule the test job
        String jobId = System.schedule('ScheduledSpamApexTest',
            CRON_EXP, 
            new Com_BatchDeleteSpamSchedule());  
     Test.StopTest();
     
       
   }
}