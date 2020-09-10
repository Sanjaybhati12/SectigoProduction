@isTest
public class InternalCommentCountTest {
    @TestSetup
    public static void setupMethod(){
        Contact con = new Contact();
        con.LastName = 'Test';
        insert con;
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Case   tCase = new Case();
        tCase.Status = 'Open';
        tCase.Description = 'Test Description';
        tCase.Origin = 'Annuity External';
        tCase.Type = 'Feature Request';
        tCase.Priority = 'Low';
        tcase.Total_Internal_Comments__c = 2;
        tcase.AccountId = acc.Id;
        tcase.ContactId = con.Id;
        insert tCase;
        
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = tCase.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;
        insert tComment;
    }
    
    @isTest
    public static void test1(){
        InternalCommentCount myBatchObject = new InternalCommentCount(); 
        Id batchId = Database.executeBatch(myBatchObject);
    }
}