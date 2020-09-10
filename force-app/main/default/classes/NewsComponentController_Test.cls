@isTest
public class NewsComponentController_Test {
  public static testMethod void testuser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@tedfds.com');
        
        System.runAs(u) {
      
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
            Account acc = new Account();
            acc.Name = 'Test';
            acc.Email__c = 'test@gmail.com';
            acc.phone = '3434587';
            acc.RecordTypeId = devRecordTypeId;
            insert acc;
            Contact con  = new Contact();
            con.AccountId = acc.id;
            con.LastName = 'test';
            con.FirstName = 'sfdc';
            con.ownerid = UserInfo.getUserId();
            con.email = 'test@gmail.com';
            con.Phone = '35454';
            con.Email_2__c = 'test676@gmail.com';
            insert con;
        }
      
        List<Community_NewsLetter__c> newsList =  new List<Community_NewsLetter__c>();
        Community_NewsLetter__c news = new Community_NewsLetter__c();
        news.Name = 'Test';
        news.Link__c = 'www.salesforec.com';
        news.Data__c = 'testData';
        news.Type__c = 'News';
        insert news;
        newsList.add(news);
        NewsComponentController.getUser();
        NewsComponentController.getNews(4);
       
    }
}