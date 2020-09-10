/** Class Name   : Com_NoActivityCaseSchedule 
*  Description  : Schedul Class for Com_NoActivityCase Batch
*                     
*  Created By   : Veera
*  Created On   : 08-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
global class Com_NoActivityCaseSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      Com_NoActivityCase b = new Com_NoActivityCase(); 
      database.executebatch(b);
   }
}