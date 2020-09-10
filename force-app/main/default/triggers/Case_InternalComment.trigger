trigger Case_InternalComment on CaseComment (after insert , after update ,after delete , after undelete ) {
   
   if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
       caseCommentTriggerHandler.createPublicCaseComment(trigger.new);
   }
   if(Trigger.isAfter && (trigger.isInsert || Trigger.isDelete || Trigger.isUndelete)){
        caseCommentTriggerHandler.totalCaseComments(Trigger.New);
   }
    
}