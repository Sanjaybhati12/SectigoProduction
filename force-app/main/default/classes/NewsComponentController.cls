public with sharing class NewsComponentController {
    @AuraEnabled
    public static user getUser() {
        User currentUser =  [SELECT id,Account.Service_Manager_Email__c,Account.Service_Manager_Phone__c, Username,Account.Service_Account_Manager__r.Name,Account.Service_Account_Manager__r.Email,
                             Account.Service_Account_Manager__r.Phone,ContactId, Contact.FirstName, Contact.LastName, Contact.Email, Contact.phone,
                             Contact.AccountId, Contact.Account.Name,Contact.Account.Email__c,Contact.Account.Phone FROM User
                             where id =:UserInfo.getUserId()];
        system.debug('currentUser:'+currentUser);
        return currentUser;
    }
    @AuraEnabled
    public static List<Community_NewsLetter__c> getNews(Integer currentMonth) {
        if(String.isBlank(string.valueOf(currentMonth))){
            currentMonth = Date.Today().Month();
        }
        Integer currentYear = Date.Today().Year();
        List<Community_NewsLetter__c>  NewsList =
            [select id, Name, Description__c,Link__c, Type__c from Community_NewsLetter__c Where Type__c = 'News'
             and CALENDAR_MONTH(Date__c) =: currentMonth And CALENDAR_YEAR(Date__c)=:currentYear order by createddate desc];
        return NewsList;
        
    }
}