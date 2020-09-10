@isTest
public class announcementCtrl_Test {
  public static TestMethod void Test11(){
      Announcement__c ann = new Announcement__c();
      ann.Name = 'Test';
      ann.Title__c = 'Test-sectigo data';
      ann.Description__c = 'salesforce.com is a cloud computing company';
      ann.Priority__c = 'High';
      insert ann;
      announcementCtrl acc = new announcementCtrl();
}
}