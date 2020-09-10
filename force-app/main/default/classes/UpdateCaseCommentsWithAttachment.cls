public class UpdateCaseCommentsWithAttachment implements Queueable {
    
    private Map<Id, Case_Comment__c> caseComments;
    
    public UpdateCaseCommentsWithAttachment(Map<Id, Case_Comment__c> caseComments) {
        this.caseComments = caseComments;
    }
    
    public void execute(QueueableContext context) {
        List<Attachment> newFiles = new List<Attachment>();
        
        for (Attachment a : [select Id, name, Body, parentId from Attachment where parentId in : caseComments.keyset()]) {
            if (caseComments.containsKey(a.parentId)){
                Attachment newFile = a.clone();
                newFile.parentId = caseComments.get(a.parentId).Id;
                newFiles.add(newFile);
            }
        }
        insert newFiles;
    }
    
}