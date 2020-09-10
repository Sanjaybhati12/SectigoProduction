trigger EmailAttachmentTrigger on Attachment (after insert) {
    
    Set<Id> parents = new Set<Id>();
    List<Attachment> newFiles = new List<Attachment>();
    Set<Id> emailMessageSet = new Set<Id>();

    for(Attachment a : Trigger.New){
        parents.add(a.parentId);
    }

    for(Case_Comment__c caseComment : [SELECT Id, EmailMessageId__c from Case_Comment__c WHERE EmailMessageId__c in :parents]){//loop through unique parents       
        for (Attachment a : Trigger.New) {
            if (caseComment.EmailMessageId__c==a.parentId){
                Attachment newFile = a.clone();
                newFile.parentId = caseComment.Id;
                newFiles.add(newFile);
            }
        }
    }

    insert newFiles;
}