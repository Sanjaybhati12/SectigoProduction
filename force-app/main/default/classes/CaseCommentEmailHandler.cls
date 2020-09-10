global class CaseCommentEmailHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('email >>'+email);
        String subject = email.subject;
        system.debug('$$$$$'+email.fromAddress);
        system.debug('#######'+email.headers+ 'EMail reference@@@'+email.references);
        system.debug('*********-->'+email.plaintextBody);
        if(subject.indexOf('ref:')!=-1 && subject.indexOf(':ref')!=-1){
            subject = subject.subString(subject.indexOf('ref:'), subject.indexOf(':ref'));
            
            System.debug('Subject Tested By Hari Krishna----->'+subject);
            EmailMessage myEmailMess = new EmailMessage();
            myEmailMess.ParentId= myEmailMess.RelatedToId =   Id.valueOf(Cases.getCaseIdFromEmailThreadId(subject));
            myEmailMess.Incoming=true;
            myEmailMess.isInboundMessage__c =true;
            myEmailMess.FromAddress = email.fromAddress;
            myEmailMess.FromName = email.fromName;
            myEmailMess.ToAddress= email.ToAddresses[0];
            
            if(email.ccAddresses!=null){
                string temp='';
                for(string s:email.ccAddresses){
                    temp=(temp==null?s:temp+s);
                    temp+=',';
                    
                }
                myEmailMess.CcAddress = temp;
            }
            myEmailMess.Subject = email.subject;
            system.debug('email.htmlBody >>'+email.htmlBody);
            system.debug('email.plaintextBody >>'+email.plaintextBody);
            if(String.isNotBlank(email.plaintextBody)){
                if(email.plaintextBody.length() > 32000){
                    myEmailMess.TextBody = email.plaintextBody.substring(0,32000);
                }else{
                    myEmailMess.TextBody = email.plaintextBody;
                } 
            }
            if(String.isNotBlank(email.htmlBody)){
                System.debug('--->'+email.htmlBody);
                if(email.htmlBody.length()>32000){
                    myEmailMess.HtmlBody = email.htmlBody.substring(0,32000);
                }else{
                    myEmailMess.HtmlBody = email.htmlBody;
                } 
            }
            system.debug('myEmailMess >> '+myEmailMess);
            insert myEmailMess;
            //Case caseInstance = new Case(Id=myEmailMess.ParentId, status='In progress');
            //update caseInstance;
            // Save attachments, if any
            if(email.textAttachments!=null)
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments){
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = myEmailMess.Id;
                    insert attachment;
                }
            
            //Save any Binary Attachment
            if(email.binaryAttachments!=null)
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = myEmailMess.Id;
                    insert attachment;
                }
            result.success = true;
        }
        return result;
    }
    
}