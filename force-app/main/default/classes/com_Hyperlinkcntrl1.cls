/** Class Name   : com_Hyperlinkcntrl1 
*  Description  : Convenience class that can be called from com_Hyperlink lightning component to get the current community user account name
*  Created By   : Agile Cloud Consulting 
*  Created On   : 30th January 2019
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class com_Hyperlinkcntrl1 {
    /**
* @description : To get currently logged-in user Account name 
* @param : 
* @return : string
**/
    @AuraEnabled
    public static String getOpenCases(){
        String Accounname = [Select Id, Contact.Account.Name, SCM_Dev_Login__c    from User where ID=: UserInfo.getUserId()].SCM_Dev_Login__c  ;
        system.debug('>>>Accounname>>>'+Accounname);
        return Accounname;
    }
    
}