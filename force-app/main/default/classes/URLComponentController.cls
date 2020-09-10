public with sharing class URLComponentController {
    @AuraEnabled
    public static List<Community_NewsLetter__c> getArticles(Integer currentMonth){
        if(String.isBlank(string.valueOf(currentMonth))){
            currentMonth = Date.Today().Month();
        }
        Integer currentYear = Date.Today().Year();
        List<Community_NewsLetter__c>  ArticleList =
            [select id, Name, Description__c,Data__c,Link__c, Type__c from Community_NewsLetter__c 
             Where Type__c = 'Article' and CALENDAR_MONTH(Date__c) =: currentMonth And CALENDAR_YEAR(Date__c)=:currentYear order by createddate desc];
        return ArticleList;
    }
}