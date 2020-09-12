@isTest(seeAlldata=false)
public class caseReasonUpdateBatchTest {
    @isTest
    public static void testCase(){
        insert new Account(Name='Sectigo');
        
        List<Case> newCases = new List<Case>();
        newCases.add (new Case(status ='new',Origin = 'Web',Reason = 'SSL Certificate Support') );
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'Technical Certificate Manager') );
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'HackerGuardian Partner Inquiry') );
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'SCM Private CA'));
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'Partner Inquiry'));
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'SCM Validation'));
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'EV Validation'));
        newCases.add(new Case(status ='new',Origin = 'Web',Reason = 'Validation'));
        
        insert newCases;
        
        test.startTest();
        caseReasonUpdateBatch cru = new caseReasonUpdateBatch();
        Id batchId = Database.executeBatch(cru);
        test.stopTest();
    }
}