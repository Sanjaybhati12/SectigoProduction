public class caseCommentTriggerHandler{
    public static void createPublicCaseComment(List<CaseComment> newList){
        List<Case_Comment__c> comList  = new List<Case_Comment__c>();
        for(CaseComment cc: [SELECT Id, ParentId, IsPublished, CommentBody FROM CaseComment Where IsPublished = true And Id IN :Trigger.New]) {
            if(cc.IsPublished = true){
                Case_Comment__c com = new Case_Comment__c();
                com.Comment_Body__c  = cc.CommentBody;
                com.ParentId__c  = cc.ParentId;
                comList.add(com);
            }
        }
        if(comList.size() > 0){
            insert comList;
        }
    }
   
    
    
    public static void totalCaseComments(List<CaseComment> newList){
        Set<Id> caseIds = new Set<Id>();
        List<Case> caseListtoUpdate=new List<Case>();
        if(Trigger.isInsert||Trigger.isUndelete){
            for(CaseComment com : (List<CaseComment>)Trigger.new){
                caseIds.add(com.ParentId);
            }
        }
        if(Trigger.isdelete){
            for(CaseComment com : (List<CaseComment>)Trigger.old){
                caseIds.add(com.ParentId);
            }
        }
        for(Case ca:[Select Id ,Total_Internal_Comments__c,(Select Id from CaseComments) from Case where Id IN: caseIds])
        {
            ca.Total_Internal_Comments__c = ca.CaseComments.size();
            caseListtoUpdate.add(ca);
        }
        try{
            update caseListtoUpdate;
        }
        catch(Exception e){
            System.debug('Exception e'+e.getMessage());
        }
    }


    
}