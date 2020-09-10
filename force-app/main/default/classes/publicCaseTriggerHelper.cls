public class publicCaseTriggerHelper{
    public static boolean iscaseComment = true;
    
    public static void updateRecentCommentOnCase(List<Case_Comment__c> commentList){
        iscaseComment  = false;
        Map<Id,Case> caseMap = new Map<Id,Case>();
        for(Case_Comment__c cc : commentList){
            if(cc.ParentId__c != null && !caseMap.containskey(cc.ParentId__c )){
                Case cs = new Case();
                cs.Id = cc.ParentId__c ;
                cs.Last_Comment_Date__c = Date.valueOf(cc.createdDate);
                caseMap.put(cc.ParentId__c,cs);
            }
        }
        if(caseMap.size()>0){
            update caseMap.values();
        }
    }
}