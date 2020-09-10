/** Class Name   : Com_BatchDeleteSpamSchedule
*  Description  : Schedul Class for Com_BatchDeleteSpam BatchApex
*                     
*  Created By   : Srivalli
*  Created On   : 26-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
global class Com_BatchDeleteSpamSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      Com_BatchDeleteSpam b= new Com_BatchDeleteSpam ();
        database.executebatch(b);

   
   }
   }