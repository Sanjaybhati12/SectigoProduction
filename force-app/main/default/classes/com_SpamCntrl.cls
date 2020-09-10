public class com_SpamCntrl {
    
    /**
* Method to check current user eligible to add themself as opportunity team member.
* @param CaseRecordId  , solution title, solution description
* @return Boolean
**/
    @AuraEnabled
    public static String closeSpamCase(String recordId){
        
        try{
            List<Case> myCase=[select id,status, AccountId,ContactId,Closing_Note1__c   from case where id=:recordId limit 1];
            
            if(myCase.size()>0){
                myCase[0].Reason='Not a Support Request';
                myCase[0].Status='Closed';
                myCase[0].AccountId =Label.Unknown_Account;
                myCase[0].ContactId =Label.Unknown_Contact;
                myCase[0].Closing_Note1__c = 'Spam';
                update myCase[0];
                return 'true';
            }
            
        }catch(DmlException ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return null;  
        
    }
    
}