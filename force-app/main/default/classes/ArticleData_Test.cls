@isTest
public class ArticleData_Test {
    public static testMethod void testuser() {
        List<Community_NewsLetter__c> newsList =  new List<Community_NewsLetter__c>();
        Community_NewsLetter__c news = new Community_NewsLetter__c();
        news.Name = 'Test';
        news.Link__c = 'www.salesforec.com';
        news.Data__c = 'testData';
        news.Type__c = 'Article';
        insert news;
        newsList.add(news);
        ArticleData.getDataMonth();
        URLComponentController.getArticles(4);
    }
}