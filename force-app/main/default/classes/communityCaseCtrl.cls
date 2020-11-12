public class communityCaseCtrl{
    
    public String getCount() {
        return null;
    }
    
    public Case c {set;get;}
    public String currentRecordId {get;set;}
    public List<Case_Comment__c> myCasecmt {set;get;}
    public List<Task> myTasks {set;get;}
    public List<EmailMessage > myEmailmess{set;get;}
    public List<Attachment>  myAttach {set;get;}
    public List<Case_Comment__c> myCasecmmnts {get;set;}
    public string comment{get;set;}
    public String UserEmail;
    public Attachment Attachment{get;set;}
    public transient blob fileBody{get;set;}
    public String contentType {get;set;}
    public String filename{get; set;}
    public List<Attachment> AttchmentsafterInsert{get;set;}
    public List<Attachment> AllAttachments{get;set;}
    public Integer recordId{get;set;}
    public List<ContentDocumentLink> contentDocumentList{get;set;}
    public string chatterAttachmentId {get;set;}
    public List<commCaseComment> newLstCmt{set;get;}
    
    
    
    //public List<EmailMessage> email{get;set;}
    public communityCaseCtrl(){
        
        system.debug('$$$$$$0$'+URL.getCurrentRequestUrl());
        system.debug('$$$$$$0$'+    ApexPages.currentPage().getUrl());
        system.debug('$$$$$$0$'+URL.getCurrentRequestUrl());
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        UserEmail=userinfo.getUserEmail();
        c= new Case();
        myCasecmt  = new List<Case_Comment__c>();   
        myCasecmmnts = new List<Case_Comment__c>();
        myTasks  = new List<Task>();
        myEmailmess = new List<EmailMessage >();
        myAttach = new List<Attachment >();
        AttchmentsafterInsert= new List<Attachment>();
        AllAttachments= new List<Attachment>();
        Attachment = new Attachment();
        newLstCmt= new List<commCaseComment>();
        chatterAttachmentId = '';
        contentDocumentList = new List<ContentDocumentLink>();
        if(currentRecordId  !=null){
            c= [select id,status,casenumber,Account.Name,contact.name,Reason,Priority,origin,CreatedDate,subject,description from case where id=: currentRecordId  ];   
            myCasecmt  =[select id,CreatedDate,Subject__c,Comment_Body__c from Case_Comment__c where ParentId__c=:currentRecordId ORDER BY CreatedDate DESC];
            myTasks =[SELECT CreatedDate,Id,Priority,Subject,Type,WhatId,WhoId FROM Task WHERE WhatId =: currentRecordId ];
            myEmailmess= [SELECT HtmlBody,CcAddress,CreatedById,CreatedDate,FromAddress,Id,ParentId,Subject,TextBody FROM EmailMessage WHERE ParentId = :currentRecordId ORDER BY CreatedDate DESC];
            myAttach =[SELECT BodyLength,ContentType,CreatedById,CreatedDate,Id,Name,ParentId FROM Attachment WHERE ParentId =: currentRecordId ORDER BY CreatedDate DESC];
            contentDocumentList = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId = :currentRecordId ORDER BY ContentDocument.CreatedDate DESC];
            for(Case_Comment__c eachCmt : myCasecmt  ){           
                String s1= eachCmt.Comment_Body__c.stripHtmlTags();
                string s2='';
                String s3=s1;
                system.debug('@@@@@'+s1);
                system.debug('$$$$$'+s1.length());
                if(s1.length()>=150){
                    system.debug('greaterthan150');
                    s2 = s1.substring(0,150);
                }else{
                    system.debug('lessthan150');
                    s2 = s1;
                }
                
                commCaseComment eachCt2 = new commCaseComment(eachCmt,s2,s3);
                newLstCmt.add(eachCt2 );    
                system.debug('@@@Plain Text@@'+s2);
                
            }
            /*for(Attachment acct:myAttach){
Attachment att= new Attachment();
//att.
att=acct;
AllAttachments.add(att);    
}*/
            
            System.debug('$$$myCasecmt  $$$'+myCasecmt  );
            System.debug('###myTasks ##'+myTasks );
            System.debug('@@@@myEmailmess@@@'+myEmailmess);
            System.debug('****myAttach ****'+myAttach );
            
        }
        
    }
    public void AddCaseComment(){
        //Case casetoupdateStatus= new Case();
        Case_Comment__c cc= new Case_Comment__c();
        if(String.isNotEmpty(comment)){
            cc.Comment_Body__c=comment;
            cc.Customer_Email__c = UserEmail;
            cc.ParentId__c=currentRecordId;
            cc.From_Address__c=UserEmail;
            cc.To_Address__c='support@comodoca.com';
            insert cc;
        }
        comment='';
        c= [select id,status,casenumber,Account.Name,contact.name,Reason,Priority,origin,CreatedDate,subject,description from case where id=: currentRecordId  ];
        c.status='In progress';
        update c;
        
        myCasecmmnts  =[select id,From_Address__c,To_Address__c,CreatedDate,Subject__c,Comment_Body__c from Case_Comment__c where ParentId__c=:currentRecordId ORDER BY CreatedDate DESC];
        newLstCmt.clear();
        for(Case_Comment__c eachCmt : myCasecmmnts  ){     
            String s1= eachCmt.Comment_Body__c.stripHtmlTags();
            string s2=''; 
            String s3=s1;
       
            if(s1.length()>=150){
                system.debug('greaterthan150');
                s2 = s1.substring(0,150);
            }else{
                system.debug('lessthan150');
                s2 = s1;
            }
            
            commCaseComment eachCt2 = new commCaseComment(eachCmt,s2,s3);
            newLstCmt.add(eachCt2 );    
        }
    }
    public PageReference resetTextAr() {
        comment='';
        return null;
        
    }
    public void saveAttachment(){
        
        system.debug('jfguhuguij#####');
        /* if(Attachment!=null){
try {
system.debug('uyfyuu&&&&'+Attachment.name);
if(String.isNotBlank(Attachment.name)){
Attachment.ParentId = currentRecordId;

// the record the file is attached to
insert Attachment;
}


} catch(System.DMLException e) {
system.debug('exception'+e);
}  
}*/
        
        
        
        Attachment att= new Attachment();
        att.Body=fileBody;
        att.Name=filename;
        att.ContentType=contentType;
        att.ParentID=currentRecordId;
        
        try{
            insert(att);
        }catch(System.DMLException e) {
            ApexPages.addMessages(e);
            
        }
        
        
        
        // AttchmentsafterInsert= [SELECT Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp FROM Attachment WHERE ParentId =: currentRecordId ORDER BY CreatedDate DESC]; 
        myAttach.clear();
        for(Attachment acct:[SELECT Body,CreatedDate,Id,Name,OwnerId,ParentId FROM Attachment WHERE ParentId =: currentRecordId ORDER BY CreatedDate DESC]){
            myAttach.add(acct);
        }
        
        
    }
    
    public PageReference viewAttach()
    {
        ID lid=apexpages.currentpage().getparameters().get('ViewAttach');
        return new Pagereference ('/servlet/servlet.FileDownload?file='+lid);
        
        
    }
    public void deleteAttachment(){
        System.debug(':::record Id'+recordId);
        Attachment att=myAttach.get(recordId);
        myAttach.remove(recordId);
        delete att;
    }
    
    public void deleteChatterAttachment(){
        ContentDocument condocument = new contentDocument(Id = chatterAttachmentId);
        DELETE condocument ;
        contentDocumentList = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId = :currentRecordId ORDER BY ContentDocument.CreatedDate DESC];
    }
    
    public void CloseCase(){
        
        //c= [select id,status,casenumber,Reason,Priority,origin,CreatedDate,subject,description from case where id=: currentRecordId];
        //Case c= new case(id=currentRecordId,status='Closed'); 
        //update c;  
        c= [select id,status,casenumber,Reason,Account.Name,contact.name,Priority,origin,CreatedDate,subject,description from case where id=: currentRecordId  ];
        c.status='Closed';
        update c;
        
    }
    
    public void ReopenCase(){
        c= [select id,status,casenumber,Reason,Account.Name,contact.name,Priority,origin,CreatedDate,subject,description from case where id=: currentRecordId  ];
        c.status='In progress';
        update c;
    }
    
    public class commCaseComment{
        public Case_Comment__c caseComm {get; set;}
        public String casecommTitle {get; set;}
        public String caseFullcomment {get;set;}
        
        public commCaseComment(Case_Comment__c c,String b,String a){
            caseComm = c;
            casecommTitle = b;
            caseFullcomment =a;
        }
        
    }
}