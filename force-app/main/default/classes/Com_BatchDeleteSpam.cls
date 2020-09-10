/** Class Name   : Com_BatchapexDeleteSpam 
*  Description  : Batchclass to delete spam case records. 
*                     
*  Created By   : Srivalli
*  Created On   : 26-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/


Global class Com_BatchDeleteSpam implements Database.Batchable<sObject>{
         
    global Database.QueryLocator Start(Database.BatchableContext bc){
   
        return Database.getQueryLocator([select id,Subject from Case where Subject like '%SPAM%']);
        
      }

     global void execute(Database.BatchableContext bc,List<Case> scope){

       List<Case> caseToDelete= new List<Case>();
          for(Case ca:scope){
             caseToDelete.add(ca);
             system.debug('sssss%%$'+caseToDelete);
          }
          
          if(!caseToDelete.isEmpty()){          
              delete caseToDelete;          
          }
        
        
       }
      global void finish(Database.BatchableContext bc){
          
      }    


   }