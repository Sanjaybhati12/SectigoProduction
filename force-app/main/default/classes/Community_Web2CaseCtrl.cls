/** Class Name   : Community_WebToCaseController
*  Description  : This is controller for custom webtocase page(Community_WebtoCase) 

*  Created By   : Dazeworks
*  Created On   : August 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                                                       
**/
public class Community_Web2CaseCtrl{
    
    
    
    public Case caseObject {get; set;}    
    public Contact contactObject {get; set;}    
    public String exceptionMessage;    
    public String hasError {get;set;}    
    public Attachment attachment {get; set;}    
    public Map<String, String> attachmentList {get; set;}
    public String knowledgeQuery{get; set;}    
    public List<String> attachmentNames{get; set;}    
    Public String ReasonforTicket {get;set;}      
    Public String ReasonforTicket1 {get;set;}
    public String caseTypeforTicket {get;set;}
    public List<KnowledgeArticlesWrapper> knowledgeArticleList {get; set;}    
    public List<KnowledgeArticlesWrapper> mostRecentKnowledge {get; set;}    
    public string WebCompanyName {get; set;} 
    public string OrderNumber {get; set;}
    public string Subjects {get; set;}
    public string Descriptions {get; set;}
    public Boolean uploadBtn {get; set;}
    public string attachmentIdToRemove {get; set;}
    //public Boolean isRobot {get; set;}
    //public String contentType {get; set;}    
    public string firstNameC  {get; set;}
    public string lastNameC  {get; set;}
    public string emailIdC  {get; set;}
    public string phoneNoC  {get; set;}
    public Boolean dmlerror {get;set;}
    public String UserId;
    public String UserFname;
    public String UserLname;
    public String UserEmail;
    public Boolean ExistCase{get;set;}
    public String ExistedcaseId{get;set;}
    public Case exist{get;set;}
    public Map<String,Case> existingorderMap{get;set;}
    public String caseId{get;set;}
    public List<Case> CaseWithExistingOrderNumber{get;set;}
    public Boolean IsSingleCase{get;set;}
    public Map<String,List<Case>> mapOrderNumCases{get;set;}
    public string redirect{get;set;}
    public static List<Case> caseOrdr{get;set;}
    public List<SelectOption> reasonValues {get; set;}
    public List<SelectOption> CaseTypeValues {get; set;}
    //public String knowledgeQuery {get; set;}
    Id communityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Default_Public_Record_Type).getRecordTypeId();
    
    public static final String CATEGORY_GROUP_NAME = 'Support_Categories';
    public static final String ROOT_CATEGORY_NAME = 'All';
    
    
    public String getRootCategoryName() {
        return ROOT_CATEGORY_NAME;//siteSetup.RootCategoryName__c == null ? '' : siteSetup.RootCategoryName__c;
    }
    
    
    public String getCategoryGroupName() {
        return CATEGORY_GROUP_NAME;//siteSetup.CategoryGroupName__c == null ? '' : siteSetup.CategoryGroupName__c;
    }
    
    /**
* Method description : Default constructor to initilaize the case,attachement
* @param  : 
* @return : 
**/
    
    public Community_Web2CaseCtrl(ApexPages.StandardController controller){
        caseObject = new Case();
        exist = new Case();
        contactObject = new Contact();
        attachment = new Attachment();
        attachmentList = new Map<String, String>();
        uploadBtn = false;
        ExistCase=false;
        // isRobot = false;
        knowledgeArticleList = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = fetchMostRecentArticles();
        dmlerror = false;
        UserId=userinfo.getUserId();
        UserFname=userinfo.getFirstName();
        UserLname=userinfo.getLastName();
        UserEmail=userinfo.getUserEmail();
        system.debug('User Info is&&'+UserId+ 'USer Fname::::' +UserFname+'User Lname:::##'+UserLname+'User Email:$%'+UserEmail);
        mapOrderNumCases= new Map<String,List<Case>>();
        CaseWithExistingOrderNumber= new List<Case>();
        
        if(caseOrdr==null)
            caseOrdr=new List<Case>();
        CasePickValues();
        
    }
    
    
    public void CasePickValues(){
        reasonValues = new List<SelectOption>();
        reasonValues.add(new SelectOption('','Please select a case reason..'));
        CaseTypeValues = new List<SelectOption>();
        CaseTypeValues.add(new SelectOption('','Please select a case type..'));
        Set<String> setCaseTypes = new Set<String>();
        for(Case_Reason_Category__c tr : [select id,Name,API_Name__c,Case_Type__c,Case_Reason__c from Case_Reason_Category__c]){
            setCaseTypes.add(tr.Case_Type__c);
        }
        for(String sct : setCaseTypes){
            CaseTypeValues.add(new SelectOption(sct,sct));
        }
        
    }
    
    public void Reasons4CaseTypeList(){
        system.debug('caseTypeforTicket ' + caseTypeforTicket);
        reasonValues = new List<SelectOption>();
        reasonValues.add(new SelectOption('','Please select a case reason...'));
        for(Case_Reason_Category__c tr : [select id,Name,API_Name__c,Case_Type__c,Case_Reason__c from Case_Reason_Category__c WHERE Case_Type__c =: caseTypeforTicket]){
            reasonValues.add(new SelectOption(tr.API_Name__c,tr.Case_Reason__c));
        }
    }
    
    
    /**
* Method description : Onclick of Submit button this method will invoke
* @param  : 
* @return : PageReference
**/
    
    public PageReference saveData(){
        
        // if(isRobot)
        
        //ExistCase=false;
        system.debug('fgygghgghg');
        existingorderMap= new Map<String,Case>();
        dmlerror = false;
        
        try{
            
            //List<Contact> con = new List<Contact>();        
            if(String.isNotEmpty(ReasonforTicket1) && String.isNotEmpty(Subjects) && String.isNotEmpty(Descriptions) ){  
                system.debug('coming here');
                // con = getContact(emailIdC);   
                ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
                //String conphone=[select Phone from Contact where id=:contactId].Phone;
                // system.debug('Phone num is'+conphone);
                ID AccID  = [Select AccountId from Contact where id =: contactId].AccountId;
                String Accname=[select Name from Account where id=:AccID].Name;
                Database.DMLOptions dmo = new Database.DMLOptions(); 
                dmo.assignmentRuleHeader.useDefaultRule = true;
                /*if(con.size() > 0){
//contactObject.Id = con[0].Id; 
//contactObject.AccountId = con[0].Id;               
}*/
                
                if(ReasonforTicket1 !=null)
                    caseObject.Reason = ReasonforTicket1 ; 
               	caseObject.Parent_Case_Reason__c =  caseTypeforTicket;
                caseObject.Origin = 'Community';
                caseObject.Web_Company_Name__c = Accname;
                caseObject.Order_Number__c = OrderNumber;
                caseObject.Subject = Subjects;
                caseObject.SuppliedName= UserFname +' ' +UserLname  ;
                //caseObject.SuppliedPhone=conphone;
                //  if(checkEmail(emailIdC))
                caseObject.SuppliedEmail=UserEmail;
                caseObject.Description = Descriptions;
                //if(con.size() > 0)   
                caseObject.contactId = contactId;                     
                caseObject.AccountId = AccID;
                caseObject.recordTypeId=communityRecordTypeId;
                caseObject.OwnerId=UserId;
                
                if(String.isNotEmpty(OrderNumber)){
                    
                    
                    List<Case> ExistingCases=[select id,CaseNumber,Order_Number__c,status,subject,CreatedDate,LastModifiedDate from case where Order_Number__c=:OrderNumber and
                                              AccountId=:AccID ORDER BY CreatedDate DESC];
                    caseOrdr=ExistingCases;
                    system.debug('ss###'+ExistingCases);
                    //for(Case c:ExistingCases){
                    //existingorderMap.put(c.Order_Number__c,c);
                    if(ExistingCases.size()>0){
                        mapOrderNumCases.put(caseObject.Order_Number__c,ExistingCases);
                    }
                    //  system.debug('$$$$$'+mapOrderNumCases.size());
                    // }
                    
                    
                    if(mapOrderNumCases.containskey(caseObject.Order_Number__c)){
                        system.debug('UUUUUUUUUUUUU%%%');
                        List<Case> orderExistingCases= mapOrderNumCases.get(caseObject.Order_Number__c);
                        system.debug('!!!!!!!!!!###'+orderExistingCases.size());
                        if(orderExistingCases.size()==1){
                            caseId=orderExistingCases[0].id;
                            redirect='One';
                        } if(orderExistingCases.size()>1){
                            system.debug('######');
                            CaseWithExistingOrderNumber=orderExistingCases;
                            redirect='more';
                            system.debug('$$%$#%@#'+orderExistingCases);
                            system.debug('Caseswithmoreorders'+CaseWithExistingOrderNumber);
                            PageReference pageRef = new PageReference('/Community_CaseOrder?OrderNumber='+OrderNumber);
                            pageRef.setRedirect(true);
                            return pageRef;
                        } 
                    }
                    else
                    {  
                        redirect='NoOrder';  
                        
                        caseObject.setOptions(dmo);                   
                        Database.upsert(caseObject);
                    }
                }
                if(String.isEmpty(OrderNumber)){
                    redirect='NoOrder'; 
                    caseObject.setOptions(dmo);                   
                    Database.upsert(caseObject);
                }
                
                
                
                
                /* PageReference pg = new PageReference('/apex/Community_Case_Detail?id='+caseObject.id);
pg.setRedirect(false);
system.debug('#####'+pg);
return pg; */
                
                
                
            } 
            
            //  else if(!isRobot)
            //      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Confirm you are not a Robot'));
            // 
            hasError = 'Go';
        }catch(DMLException e){           
            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            dmlerror = true;
            hasError  = 'error';
            return null;
            //return null;
        }
        /*if(caseObject.id!=null){
PageReference pg = new PageReference('/apex/Community_Case_Detail?id='+caseObject.id);
pg.setRedirect(false);
system.debug('#####'+pg);
return pg;
}*/
        return null;        
    }
    /**
* Method description : Onclick of upload button this method will invoke
* @param  : 
* @return : PageReference
**/    
    public PageReference upload(){
        if(hasError=='Go'){
            try {
                
                if(String.isNotBlank(attachment.name)){
                    attachment.ParentId = caseObject.Id; // the record the file is attached to
                    insert attachment;
                }else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Fill Mandatory Fields'));
                    // hasError  = 'error';
                    return null;
                }
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
                hasError  = 'error';
                return null;
            }
        }
        
        attachment = new Attachment();
        //  caseObject = new Case();        
        //  hasError = '';
        // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Case created successfully!'));
        return null;
    }
    
    /**
* Method description : Onclick of upload button this method will invoke
* @param  : 
* @return : PageReference
**/    
    public PageReference uploadMore(){
        // if(isRobot){
        if(attachmentNames==null){
            attachmentNames = new List<String>();
        }
        
        if(String.isNotBlank(attachment.name) && caseObject !=null){
            system.debug('66666###'+caseObject.id);
            attachment.parentId = caseObject.Id;
            attachmentNames.add(attachment.name);
        }
        if(attachmentList.size() <= 9){
            system.debug('$$$$$$$$$$$$$');
            if(attachment != null && attachment.Body != null && caseObject!=null ){
                try {
                    insert attachment;        
                    attachmentList.put(attachment.Id, attachment.Name);
                }
                catch (DMLException e) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
                    hasError  = 'error';
                    return null;
                }
            }
        }else if(attachmentList.size() > 9){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Maximum 10 attachment per case'));
        }
        if(attachment.Body == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Add an attchment to upload '));
        }
        //  }else if(!isRobot){
        //      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Confirm you are not a Robot'));
        //  }
        attachment = new Attachment();
        return null;
    }
    
    /**
* Method description : Query the contact based on Email
* @param  : 
* @return : List<Contact>
**/    
    /* public List<Contact> getContact(string EmailId){
return [SELECT Name, AccountId FROM Contact WHERE Email =:EmailId limit 1];
}*/
    /**
* Method description : Remove the attachement when cross mark clicked 
* @param  : 
* @return : void
**/
    public void removeAttachment(){
        Attachment at = new attachment();
        at.Id = attachmentIdToRemove;
        delete at;        
        attachmentList.remove(attachmentIdToRemove);
    }
    
    
    /**
* Method description : Fetch the Most Recent Knowledge Articles based on view count 
* @param  : 
* @return : List<KnowledgeArticlesWrapper>
**/
    public List<KnowledgeArticlesWrapper> fetchMostRecentArticles(){    
        List<KnowledgeArticlesWrapper> mostRecentKnow = new List<KnowledgeArticlesWrapper>();    
        for(Knowledge__kav knowledgeArticle : [SELECT Id,Title,urlName,ArticleTotalViewCount,Article_Number__c,Summary_Data__c From Knowledge__kav ORDER BY ArticleTotalViewCount DESC LIMIT 10 ]){
            if(String.isNotBlank(knowledgeArticle.urlName)){
                mostRecentKnow.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.urlName,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
            }else{
                mostRecentKnow.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.Id,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
            }
        }
        
        return mostRecentKnow ;
    }
    
    public void fetchKnowledgeArticles(){
        knowledgeQuery = Apexpages.currentPage().getParameters().get('subjectValue');
        knowledgeArticleList = new List<KnowledgeArticlesWrapper>();
        if(String.isBlank(knowledgeQuery)){
            return;
        }       
        knowledgeQuery = '%'+knowledgeQuery+'%';
        List<Knowledge__kav> knowledgeList = [SELECT Id,Title,urlName,Summary_Data__c  FROM Knowledge__kav where title like :knowledgeQuery limit 12];
        if(knowledgeList.size() > 0){
            for(Knowledge__kav knowledgeArticle : knowledgeList ){
                if(knowledgeArticle.urlName != null && knowledgeArticle.Title != null && knowledgeArticle.Summary_Data__c != null){
                    if(String.isNotBlank(knowledgeArticle.urlName)){
                        knowledgeArticleList.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.urlName,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
                    }else{
                        knowledgeArticleList.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.Id,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
                    }
                }
            }
        }
        
    }
    
    public PageReference fileSize(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You not allowed to upload .exe or .msi file'));
        attachment.clear();
        return null;
    }
    
    public class KnowledgeArticlesWrapper{    
        public String subject{get; set;}
        public String link{get; set;}   
        public String description {get;set;}     
        public KnowledgeArticlesWrapper(String subject, String link,String description){
            this.subject = subject;
            this.link = link;
            this.description =description ;
        }
        
    } 
    
    public PageReference caseOrdr(){
        
        
        system.debug('GGGGG'+OrderNumber);
        system.debug('>in new methods>>>>>'+caseOrdr);
        
        return null;
        
    }
}