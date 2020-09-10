/*
* Purpose: Apex controller for quick action on case to close. Capture the solution information
* Created By: Agile Cloud 01/01/2019
* Last Modified By: 
* Current Version:  v1.0 
* Revision Log:  
*              v1.1 - 
*              v1.0 -           
*/
public class Com_closecaseWithSCntrl {
    
    /**
* Method to check current user eligible to add themself as opportunity team member.
* @param CaseRecordId  , solution title, solution description
* @return Boolean
**/
    @AuraEnabled
    public static String closeCaseSolut (Id recordId,String soluDesc,String refundType ){
        
        try{
            System.debug('>>>>>>>>>in apex class @@@@@@@@???');
            Case myCase=[select id,status,Refund_Type__c  from case where id=:recordId limit 1];
            /* if(myCase.Status != 'Closed'){
//Create a solution 
Solution newSol = new Solution();
newSol.SolutionName=soluTitle;
newSol.SolutionNote=soluDesc;
insert newSol;

//Create a casesolution 
CaseSolution newCS = new CaseSolution();
newCS.CaseId=myCase.Id;
newCS.SolutionId=newSol.Id;
insert newCS; 
}*/
            //update case to close
            myCase.status='Closed';
            myCase.Closing_Note1__c = soluDesc;
            myCase.Refund_Type__c = refundType;
            update myCase;
            
            return 'true';
            
        }catch(DmlException ex){
            // throw new AuraHandledException('User-defined error');
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getRefundvalues(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Case.Refund_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList){
            
            options.put(p.getValue(), p.getLabel());    
        }
        return options;
    }
    
}