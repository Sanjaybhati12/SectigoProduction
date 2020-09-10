public class com_Hyperlinkcntrl2 {
@AuraEnabled
    public static String getOpenCases(){
        String Accounname = [Select Id, Contact.Account.Name, Reseller_Portal__c   from User where ID=: UserInfo.getUserId()].Reseller_Portal__c ;
        system.debug('>>>Accounname>>>'+Accounname);
        return Accounname;
    }
    
}