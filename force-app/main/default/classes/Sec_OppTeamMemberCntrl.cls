/*
* Purpose: Apex controller for quick action on opportunity to add the current user to opportunity team member.   
* Created By: Agile Cloud 03/12/2018
* Last Modified By: 
* Current Version:  v1.0 
* Revision Log:  
*              v1.1 - 
*              v1.0 -           
*/
public without sharing class Sec_OppTeamMemberCntrl {
    
        /**
    * Method to check current user eligible to add themself as opportunity team member.
    * @param OpportunityRecordId  
    * @return Boolean
    **/
    @AuraEnabled
    public static String checkOppTeamMem (Id recordId ){
        
        try{
            String userID= Userinfo.getUserRoleId();
            UserRole  myRole=[SELECT DeveloperName,ForecastUserId,Id,Name,PortalRole,PortalType FROM UserRole where id=:userID limit 1];
            system.debug(' >>>>>'+myRole.DeveloperName);
            system.debug(' >>>recordId>>'+recordId);
            Opportunity myOpp=[select id,StageName  from opportunity where id=:recordId limit 1];
            // check the role belongs to 
            if(myRole.DeveloperName == 'Sales_Engineers'){
                system.debug('Inside>>>>');
                OpportunityTeamMember member = new OpportunityTeamMember();  
                member.OpportunityId = recordId;  
                member.UserId = Userinfo.getUserId();  
                member.TeamMemberRole  = 'Sales Engineer';
                member.OpportunityAccessLevel ='Edit';
                insert member;
                return 'true';
            }else if(myOpp.StageName == 'Closed Won' || myOpp.StageName == 'Closed Lost'){
                return 'closed';
            }
            else{
                system.debug('Not authroized to add as a team member');            
                return null;
            }
        }catch(DmlException ex){
            // throw new AuraHandledException('User-defined error');
            throw new AuraHandledException(ex.getMessage());
        }
    }
}