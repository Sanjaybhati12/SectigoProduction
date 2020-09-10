/** Class Name   : Com_BatchapexDeleteSpamTest
*  Description  : Test class for Com_BatchapexDeleteSpam Batch to delete spam case records. 
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
private class Com_BatchapexDeleteSpamTest{
    private static testmethod void testscenario(){
    List<Case> casestest= new List<Case>();
    Case c1= new Case();
    c1.Subject='SPAM test';
    casestest.add(c1);
    Case c2= new Case();
    c2.Subject='SPAM test test2';
    casestest.add(c2);
     Case c3= new Case();
    c3.Subject='test test4';
    casestest.add(c3);
    
    Case c4= new Case();
    c4.Subject='spam test test6';
    casestest.add(c4);
    
    Case c5= new Case();
    c5.Subject='sPam test test7';
    casestest.add(c5);
    
    insert casestest;
    Test.StartTest();
      Com_BatchDeleteSpam bc= new Com_BatchDeleteSpam ();
      Id batchId = Database.executeBatch(bc,10);
    Test.StopTest();
     System.assertEquals(0, [select count() from Case where Subject like '%SPAM%']);
     
          System.assertEquals(1, [select count() from Case]);

    }
}