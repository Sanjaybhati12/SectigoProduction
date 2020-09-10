/*
* Purpose: Apex controller for quick action on Case to add to create new retail Opportunity   
* Created By: Agile Cloud 26/12/2018
* Last Modified By: 
* Current Version:  v1.0 
* Revision Log:  
*              v1.1 - 
*              v1.0 -           
*/
public class Com_RetailOppCntrl {
    
    /**
* Method to create a Retail Opportunity
* @param Case  
* @return Boolean
**/
    @AuraEnabled
    public static String createOppr (Id recordId ){
        try{
            String userID= Userinfo.getUserRoleId();
            UserRole  myRole=[SELECT DeveloperName,ForecastUserId,Id,Name,PortalRole,PortalType FROM UserRole where id=:userID limit 1];
            if(myRole.DeveloperName== 'Retail_Rep' || myRole.Name=='Retail Rep'){
                System.debug('#$@#%'+myRole.DeveloperName);
                Case myCase=[select id,status,AccountId,Account.Name,IsRetailOpportunity__c   from case where id=:recordId limit 1];
                //New Opportunity
                if(myCase.IsRetailOpportunity__c != true){
                    //get the Retail recordtypeID
                    Id RetailRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
                    //Calculate the date of End of the current Month
                    Date DateField= Date.Today();
                    Integer numberOfDays = Date.daysInMonth(DateField.year(), DateField.month());
                    Date lastDayOfMonth = Date.newInstance(DateField.year(), DateField.month(), numberOfDays);
                    //Create New Opportunity with Retail Recordtype
                    Opportunity Opp= new Opportunity();
                    opp.RecordTypeId=RetailRecordTypeId;
                    opp.Name=myCase.Account.Name+'-';
                    opp.AccountId=myCase.AccountId;
                    opp.LeadSource='Webform';
                    opp.Amount=0;
                    opp.StageName='Sales Qualified Lead';
                    opp.WebForm_Name__c='Support Ticketing Form';
                    opp.Type='New';                
                    opp.CloseDate=lastDayOfMonth ; 
                    opp.DM_Identified__c=true;
                    opp.Forecast_CategoryCom__c='Committed';
                    
                    insert opp;
                    //Update Case Status as Closed.
                    myCase.Status='Closed';
                    myCase.IsRetailOpportunity__c=true;
                    Update myCase;
                    //return opp.id;
                    return opp.id;
                }else{
                    return 'oppExists';
                }
                
                
            }
            else{
                return 'NotAuth';
            }
            
        }catch(DmlException ex){
            // throw new AuraHandledException('User-defined error');
            if(!Test.isRunningTest())
            throw new AuraHandledException(ex.getMessage());
        }
        return null;
    }
    
}