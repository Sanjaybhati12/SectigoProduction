@istest
public class caseCommentTriggerHandlerTest {
    static testMethod  void createTestData(){
        Case   tCase = new Case();
        tCase.Status = 'Open';
        tCase.Description = 'Test Description';
        tCase.Origin = 'Annuity External';
        tCase.Type = 'Feature Request';
        tCase.Priority = 'Low';
        tcase.Total_Internal_Comments__c = 2;
        insert tCase;
        
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = tCase.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;
        insert tComment;
        
        List<Case_Comment__c> comList  = new List<Case_Comment__c>();
        Case_Comment__c com = new Case_Comment__c();
        com.Comment_Body__c  = tComment.CommentBody;
        com.ParentId__c  = tComment.ParentId;
        comList.add(com);
        insert comList;
    }
    
}