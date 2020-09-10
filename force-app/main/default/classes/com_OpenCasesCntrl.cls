/** Class Name   : com_OpenCasesCntrl 
*  Description  : Convenience class that can be called from com_OpenCases lightning component to get the open cases under contact
*  Created By   : Agile Cloud Consulting 
*  Created On   : 23rd January 2019
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class com_OpenCasesCntrl {
    /**
* @description : To get currently logged-in user language value 
* @param : 
* @return : string
**/
    @AuraEnabled
    public static List<Case> getOpenCases(String RecordId){
        system.debug('>RecordId>>'+RecordId);
        Case myCase = [select id,ContactId,Accountid from case WHERE Id=:RecordId limit 1];
        system.debug('>myCase>>'+myCase);
        
        if(myCase.Accountid==null){
            return null;
        }else{
            String myCon= myCase.Accountid;
            List<Case>  myOpenCases=[select id,ContactId,Accountid,casenumber,Status,Createddate from case where Accountid=:myCon ORDER BY CreatedDate DESC];
            return myOpenCases;
        }
        //return null;
    }
    @AuraEnabled
    public static ObjectPermissions getaccess(){
        ObjectPermissions op = [SELECT PermissionsEdit, PermissionsDelete, SobjectType,parent.profileId, Id FROM ObjectPermissions where SobjectType='Case' and parent.profileId=: Userinfo.getprofileId() limit 1];
        return op;
    }
    
}