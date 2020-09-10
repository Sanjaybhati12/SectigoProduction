trigger CreateInternalCaseComment on Case (after Update) {
    List<CaseComment> casecommentToInsert= new List<CaseComment>();
    for(Case c:trigger.new){
        if(c.Closing_Note1__c!=null){
            system.debug('test');
            CaseComment cc= new caseComment();
            cc.ParentId=c.id;
            cc.CommentBody=c.Closing_Note1__c;          
            casecommentToInsert.add(cc);
        }
    }
    insert casecommentToInsert;
}