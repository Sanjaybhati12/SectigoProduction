/** Class Name   : CustomWebToCaseController
*  Description  : This is controller for custom webtocase page(Com_KnowledgeWeb2Casepage) 

*  Created By   : Dazeworks
*  Created On   : june 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                                                       
**/
public class CustomWebToCaseController{
    
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
    // public Case existingOrder {get;set;}
    //public String knowledgeQuery {get; set;}
    
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
    
    public CustomWebToCaseController(ApexPages.StandardController controller){
        caseObject = new Case();
        // existingOrder = new Case();
        contactObject = new Contact();
        attachment = new Attachment();
        attachmentList = new Map<String, String>();
        uploadBtn = false;
        // isRobot = false;
        knowledgeArticleList = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = fetchMostRecentArticles();
        dmlerror = false;
        
    }
    
    /**
* Method description : Onclick of Submit button this method will invoke
* @param  : 
* @return : PageReference
**/
    
    public PageReference saveData(){
        
        // if(isRobot){
        
        dmlerror = false;
        try{
            
            List<Contact> con = new List<Contact>();    
            List<Case> existingOrder = new List<Case>();
            
            if(String.isNotEmpty(firstNameC) && String.isNotEmpty(lastNameC) && String.isNotEmpty(emailIdC) && String.isNotEmpty(ReasonforTicket1) && String.isNotEmpty(Subjects) && String.isNotEmpty(WebCompanyName) && String.isNotEmpty(phoneNoC) && String.isNotEmpty(Descriptions) )
            {  
                
                con = getContact(emailIdC); 
                if(OrderNumber!=null)
                    existingOrder = [SELECT id,casenumber,Order_Number__c,CreatedDate FROM Case WHERE Order_Number__c=: OrderNumber AND Status != 'Closed' AND Order_Number__c != null ORDER BY CreatedDate DESC limit 1];
                
                system.debug('$$$Ordernum $$$'+OrderNumber);
                system.debug('###existingOrder ###'+existingOrder );
                system.debug('&&&caseObject&&&&'+caseObject);
                
                if((existingOrder.isEmpty() && (caseObject.id ==null || caseObject.id !=null )) || (!existingOrder.isEmpty() && caseObject.id == existingOrder[0].id )){        
                    Database.DMLOptions dmo = new Database.DMLOptions(); 
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    if(con.size() > 0){
                        contactObject.Id = con[0].Id; 
                        //contactObject.AccountId = con[0].Id;               
                    }
                    if(ReasonforTicket1 !=null)
                        caseObject.Reason = ReasonforTicket1 ;            
                    caseObject.Origin = 'Web';
                    caseObject.Web_Company_Name__c = WebCompanyName;
                    caseObject.Order_Number__c = OrderNumber;
                    caseObject.Subject = Subjects;
                    caseObject.SuppliedName= firstNameC +' ' +lastNameC  ;
                    caseObject.SuppliedPhone=phoneNoC;
                    //  if(checkEmail(emailIdC))
                    caseObject.SuppliedEmail=emailIdC;
                    caseObject.Description = Descriptions;
                    if(con.size() > 0){   
                        caseObject.contactId = contactObject.Id;                     
                        if(con[0].Accountid!=null){
                            caseObject.AccountId = con[0].AccountId;  
                        }                
                    }                    
                    caseObject.setOptions(dmo);
                    Database.upsert(caseObject); 
                    hasError = 'Go';
                    
                } //End of existing order  
                else{
                    
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, string.format(Label.Site_WebtoCase_Error, new String[]{existingOrder[0].casenumber,existingOrder[0].Order_Number__c})));
                    //New code on 11 Oct 2018
                    Case_Comment__c onecasecmt= new Case_Comment__c();
                    onecasecmt.ParentId__c=existingOrder[0].id;
                    oneCaseCmt.Send_Email_to_Customer__c = true;
                    onecasecmt.Comment_Body__c =Descriptions; 
                    insert onecasecmt;     
                    
                    //update a case with high priority 
                    case existCe= new case();
                    existCe.id=existingOrder[0].id;
                    existCe.Priority = 'High (L2)';  
                    update existCe;  
                    existCe= new Case();
                    firstNameC=null;
                    lastNameC=null;
                    emailIdC=null;
                    WebCompanyName=null;
                    phoneNoC=null;
                    ReasonforTicket1='Please Select..';
                    OrderNumber=null;
                    Subjects=null;
                    Descriptions=null;
                    
                    //End code on 11 Oct 2018
                    
                    
                    dmlerror  = true;
                    // hasError  = 'error';
                    // return null;
                }
            } //End of If
            //  }else if(!isRobot){
            //      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Confirm you are not a Robot'));
            // }
        }catch(DMLException e){           
            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            dmlerror = true;
            hasError  = 'error';
            return null;
            //return null;
        }
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
                
                if(String.isNotBlank(attachment.name) &&  caseObject != null){
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
        caseObject = new Case();        
        hasError = '';
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Case created successfully!'));
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
            attachment.parentId = caseObject.Id;
            attachmentNames.add(attachment.name);
        }
        if(attachmentList.size() <= 9){
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
    public List<Contact> getContact(string EmailId){
        return [SELECT Name, AccountId FROM Contact WHERE Email =:EmailId limit 1];
    }
    /**
* Method description : Query the case based on ordernumber
* @param  : 
* @return : case
**/    
    public Case getMatchedOrder(string Ordernum){
        return [SELECT id,casenumber,Order_Number__c FROM Case WHERE Order_Number__c=:Ordernum limit 1];
    }
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
        knowledgeQuery = '';
        if(String.isNotBlank(Apexpages.currentPage().getParameters().get('subjectValue'))){
            knowledgeQuery = Apexpages.currentPage().getParameters().get('subjectValue');
            system.debug('knowledgeQuery  >>'+knowledgeQuery);
            knowledgeArticleList = new List<KnowledgeArticlesWrapper>();
            if(String.isBlank(knowledgeQuery)){
                return;
            }       
            knowledgeQuery = '%'+knowledgeQuery+'%';
            system.debug('knowledgeQuery  >>'+knowledgeQuery);
            List<Knowledge__kav> knowledgeList = new List<Knowledge__kav>();
            knowledgeList = [SELECT Id,Title,urlName,Summary_Data__c  FROM Knowledge__kav where title like :knowledgeQuery limit 12];
            system.debug('knowledgeList   >>'+knowledgeList);
            if(knowledgeList.size() > 0){
                for(Knowledge__kav knowledgeArticle : knowledgeList){
                    if(knowledgeArticle.title != null && knowledgeArticle.urlName != null && knowledgeArticle.Summary_Data__c != null){
                        system.debug('knowledgeArticle.title >>'+knowledgeArticle.title);
                        system.debug('knowledgeArticle.urlName >>'+knowledgeArticle.urlName);
                        system.debug('knowledgeArticle.Summary_Data__c >>'+knowledgeArticle.Summary_Data__c);
                        if(String.isNotBlank(knowledgeArticle.urlName)){
                            knowledgeArticleList.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.urlName,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
                            
                        }else{
                            knowledgeArticleList.add(new KnowledgeArticlesWrapper(knowledgeArticle.title , '/articles/Knowledge/'+knowledgeArticle.Id,knowledgeArticle.Summary_Data__c.replaceAll('\\<.*?\\>', '') ));
                        }
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
    public PageReference cleardata(){
        
        //Reset all the variables
        
        firstNameC=null;
        lastNameC=null;
        emailIdC=null;
        WebCompanyName=null;
        phoneNoC=null;
        ReasonforTicket1='Please Select..';
        OrderNumber=null;
        Subjects=null;
        Descriptions=null;
        attachmentList = new Map<String, String>();
        attachmentNames=new List<String>();
        caseObject = new Case();
        contactObject = new Contact();
        attachment = new Attachment();
        attachmentList = new Map<String, String>();
        uploadBtn = false;
        dmlerror = false;
        
        return null;
        
    }
    
}