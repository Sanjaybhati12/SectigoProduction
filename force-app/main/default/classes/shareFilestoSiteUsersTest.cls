@isTest
public class shareFilestoSiteUsersTest {
    static testMethod void myTest() {
        
      
        knowledge__kav obj1 = new knowledge__kav(Title='Unit Test',UrlName='Unit-Test',summary='Test Summary');
        insert obj1;
       // MultiSection_Article__kav article=new MultiSection_Article__kav(Title='Unit Test');

        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = obj1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Case cs = new Case();
        cs.Subject = 'Test Case';
        cs.ClosedDate = system.today();
        insert cs;
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = cs.id;
        cdl1.ContentDocumentId = documents[0].Id;
        cdl1.shareType = 'V';
        insert cdl1;
    }
}