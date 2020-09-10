/** Class Name   : Com_NoActivityCase 
*  Description  : Batch Class to update no activivty Cases 
*                     
*  Created By   : Dazeworks
*  Created On   : 08-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/

global class Com_NoActivityCase implements Database.Batchable<sObject> {
    
        @TestVisible static SObjectField dateField = Case.LastModifiedDate;  //Duetime__c
        
    global Database.QueryLocator start(Database.BatchableContext BC) {
            
            String businessHourId =system.label.NoActivityBusinesshours; 
            //This is in minutes 
            Integer noActivityTime=Integer.ValueOf(system.label.NoActivityBusinesshours1);
            //converting minutes to milli seconds
            noActivityTime= noActivityTime*60*1000*-1;
            system.debug('#####noActivityTime'+noActivityTime);
            DateTime dt = BusinessHours.add(businesshourId, system.now(), noActivityTime);
            System.debug('#$#$#$#$#$dateTeam'+dt);
            String ki=dt.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            System.debug('#$formatGMT#$#$#$#$'+ki); 
            
              String caseReason='';            
             if(noActivityCase__c.getAll().values().size()> 0){
                integer i=noActivityCase__c.getAll().values().size();               
                integer j=1;     
                caseReason +=' AND ( ' ;         
               for( noActivityCase__c eachActivityCase : noActivityCase__c.getAll().values()){                  
                 if(j!=i){
                 
                  caseReason += 'Reason =\''+ eachActivityCase.Label__c +'\' OR  ';
                     j++;
                  }else{                  
                     caseReason += 'Reason =\''+ eachActivityCase.Label__c +'\'' ;
                      j++;
                  }               
               }   
               caseReason += ' )';         
             }
             
             system.debug('********'+caseReason );
             system.debug('dateField >>'+dateField);
            String query='select id,LastModifiedDate,contactid,Accountid,ResolutionDateline__c,Status from case where contactid!=null AND Accountid!=null '+ caseReason + ' AND  Status=\''+ 'Awaiting Customer Reply' +'\' AND '+dateField +'<='+ki+'';
            system.debug('Query in batch class>>>'+query);
            system.debug(Database.getQueryLocator(query));
            return Database.getQueryLocator(query);
       
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
                
        List<Case> newLst = new List<Case>();     
        System.debug('!!!!!!!!!>>>>'+caseList);   
        for(Case eachCase: caseList){
        
            eachCase.status='Closed';
            newLst.add(eachCase);  
        }
        
        if(newLst != null && !newLst.isEmpty()){
            system.debug('case updated');    
            Database.update(newLst, false);
        }
            
               

    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
    
    
}