/** Class Name   : CustomWebToCaseController1
*  Description  : This is controller for custom webtocase page(Com_KnowledgeWeb2Casepagesectigo).
*  This is the main controller in production refered in IFRAME for Sectigo and Positive SSL Site
*  Created By   : Dazeworks
*  Created On   : june 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*     Sanjay                  04/03/2020                                 Added ordernumber and email logic                                                                                                                 
**/
global class CustomWebToCaseController1{
    
    
    /* Case Input Variables */
    public string firstNameC  {get; set;}
    public string lastNameC  {get; set;}
    public string emailIdC  {get; set;}
    public string phoneNoC  {get; set;}
    public string WebCompanyName {get; set;} 
    public string OrderNumber {get; set;}
    public string Subjects {get; set;}
    public string Descriptions {get; set;}
    public string sessionId {get;set;}
    /* Knowledge Input Variables */
    public Case caseObject {get; set;}    
    public Contact contactObject {get; set;}    
    public String exceptionMessage;    
    public String hasError {get;set;}  
    public String displaymessage1 {get;set;} 
    public Attachment attachment {get; set;}    
    public Map<String, String> attachmentList {get; set;}
    public String knowledgeQuery{get; set;}    
    public List<String> attachmentNames{get; set;}    
    Public String caseTypeforTicket {get;set;}      
    Public String ReasonforTicket1 {get;set;}
    public String caseNumer {get; set;}
    public List<SelectOption> CaseTypeValues {get; set;}
    public List<SelectOption> reasonValues {get; set;}
    public List<KnowledgeArticlesWrapper> knowledgeArticleList {get; set;}    
    public List<KnowledgeArticlesWrapper> mostRecentKnowledge {get; set;}    
    public Boolean uploadBtn {get; set;}
    public string attachmentIdToRemove {get; set;}
    public string sessionFirst {get;set;}
    public string sessionSecond {get;set;}
    
    public string caseType {get;set;}
    public string caseReason {get;set;}
    public string subCaseReason {get;set;}
    public List<SelectOption> caseReasonList {get;set;}
    public List<SelectOption> caseSubReasonList {get;set;} 
    
    
    public Boolean dmlerror {get;set;}
    public List<Attachment> attchmentList;
    
    public static final String CATEGORY_GROUP_NAME = 'Support_Categories';
    public static final String ROOT_CATEGORY_NAME = 'All';
    
    
    public String getRootCategoryName() {
        return ROOT_CATEGORY_NAME;//siteSetup.RootCategoryName__c == null ? '' : siteSetup.RootCategoryName__c;
    }
    
    public String getCategoryGroupName() {
        return CATEGORY_GROUP_NAME;//siteSetup.CategoryGroupName__c == null ? '' : siteSetup.CategoryGroupName__c;
    }
    
    public CustomWebToCaseController1(ApexPages.StandardController controller){
        sessionId = userInfo.getSessionId();
        if(sessionId != null){
            sessionFirst = sessionId.substring(0,17);
            system.debug(sessionFirst);
            sessionSecond = sessionId.substring(17,sessionId.length());
        }
        caseObject = new Case();
        contactObject = new Contact();
        attachment = new Attachment();
        attachmentList = new Map<String, String>();
        attchmentList = new List<Attachment>();
        uploadBtn = false;
        knowledgeArticleList = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = new List<KnowledgeArticlesWrapper>();
        mostRecentKnowledge = fetchMostRecentArticles();
        caseReasonList = new List<SelectOption>();
        caseReasonList.add(new SelectOption('','please select..'));
        dmlerror = false; 
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
    
    
    public List<SelectOption> getReasons4CaseTypeList(){
        system.debug('caseTypeforTicket ' + caseTypeforTicket);
        reasonValues = new List<SelectOption>();
        reasonValues.add(new SelectOption('','Please select a case reason...'));
        for(Case_Reason_Category__c tr : [select id,Name,API_Name__c,Case_Type__c,Case_Reason__c from Case_Reason_Category__c WHERE Case_Type__c =: caseTypeforTicket]){
            reasonValues.add(new SelectOption(tr.API_Name__c,tr.Case_Reason__c));
        }
        return null ;
    }
    
    public void retriveCaseReason(){
        caseReasonList  = new List<SelectOption>();
        caseReasonList.add(new SelectOption('','please select case reason...'));
        If(String.isNotBlank(caseType)){
            Case_Reason_Category__c  cr = [select id,Name,Case_Reason__c from Case_Reason_Category__c 
                                               Where Name=:caseType];
            List<String> pickList = cr.Case_Reason__c.split(',');
            for(Integer i=0;i<pickList.size();i++){
                caseReasonList.add(new SelectOption(pickList[i],pickList[i]));
            }
        }
        system.debug('caseReasonList >>'+caseReasonList);
    }
    public void retriveCaseSubReason(){
        caseSubReasonList = new List<SelectOption>();
        caseSubReasonList.add(new SelectOption('','please select case sub reason...'));
        If(String.isNotBlank(caseReason)){
            List<Case_Reason_Category__c>  crList = [select id,Name,Case_Reason__c from Case_Reason_Category__c 
                                               Where Name=:caseReason];
            if(crList.size() > 0){                                   
                List<String> pickList = crList[0].Case_Reason__c.split(',');
                for(Integer i=0;i<pickList.size();i++){
                    caseSubReasonList.add(new SelectOption(pickList[i],pickList[i]));
                }
            }
        }
    }
    
    
    @RemoteAction()
    global static responseWrapper saveDataRemoting(String fir_name,String last_name,String email,String webcompany,String phone,String reason,String ordernumber,String subject,String description,String ipAddress,String antiSpam){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Default_Public_Record_Type).getRecordTypeId();
        Database.DMLOptions dmo = new Database.DMLOptions(); 
        Integer antiSpamNum = Integer.valueOf(antiSpam);
        dmo.assignmentRuleHeader.useDefaultRule = true;
        Contact conObj = getContact(email);
        responseWrapper rw = new responseWrapper();
        List<String> restrictedPhoneList = system.label.Ticket_Restricted_Phone.split(',');
       system.debug('antiSpamNum ' + antiSpamNum);
        if( !restrictedPhoneList.contains(phone) && antiSpamNum  >= 10 ){ 
                system.debug('order '+getCaseByOrderNumber(ordernumber));
                if(getCaseByOrderNumber(ordernumber) == null){
                    Case caseObject = new Case();
                    caseObject.Reason = reason;            
                    caseObject.Origin = 'Web';
                    caseObject.Web_Company_Name__c = webcompany;
                    caseObject.Order_Number__c = ordernumber;
                    caseObject.Subject = subject;
                    caseObject.IP_Address__c = ipAddress;
                    caseObject.SuppliedName = fir_name +' ' +last_name;
                    caseObject.SuppliedPhone = phone;
                    caseObject.SuppliedEmail = email;
                    caseObject.Description = Description;
                    caseObject.recordTypeId = devRecordTypeId ;
                    //caseObject.Parent_Case_Reason__c = caseType;
                    //caseObject.Case_Sub_Reason__c = subCaseReason;
                    if(conObj != null){   
                        caseObject.contactId = conObj.Id;                     
                        if(conObj.Accountid!=null){
                            caseObject.AccountId = conObj .AccountId;  
                        }                
                    }
                    caseObject.setOptions(dmo);
                    
                    insert caseObject;
                    
                    String caseNumer = [Select Id, CaseNumber, CreatedDate From Case Where Id =:caseObject.Id].CaseNumber;
                    rw.caseId = caseObject.Id;
                    rw.type = 'Created';
                    rw.message = system.Label.Ticket_Case_Created_Message+' '+caseNumer;
                    return rw;
                }else{
                    case existCe = getCaseByOrderNumber(ordernumber);
                    existCe.Priority = 'High (L2)';
                    existCe.Status = 'In progress';
                    update existCe; 
                    
                    Case_Comment__c onecasecmt= new Case_Comment__c();
                    onecasecmt.ParentId__c = existCe.id;
                    oneCaseCmt.Send_Email_to_Customer__c = true;
                    onecasecmt.Comment_Body__c = Description; 
                    insert onecasecmt;  
                    rw.caseId = existCe.Id;
                    rw.type = 'Order Number';
                    rw.message = system.Label.Ticket_Case_Updated_With_Order_Message+' '+ordernumber;
                    return rw;                 
                }
           
        }else{
            rw.type = 'Null Values';
            rw.message = system.Label.Ticket_Blank_Value_Message;
            return rw;
        }
       
    }
    public Static Contact getContact(string EmailId){
        List<Contact> conList = new List<Contact>();
        conList = [SELECT Name, AccountId FROM Contact WHERE Email =:EmailId limit 1];
        if(conList.size() >0){
            return conList[0];
        }
        return null;
    }
    public static Case getCaseByOrderNumber(String ordernumber){
        List<Case> existingOrder = new List<Case>();
        Case caseObj = new Case();
        if(String.isNotBlank(ordernumber)){
           existingOrder = [SELECT id,casenumber,Order_Number__c,SuppliedEmail,CreatedDate FROM Case WHERE Order_Number__c=: OrderNumber AND Status != 'Closed' AND Order_Number__c != null ORDER BY CreatedDate DESC limit 1];
           system.debug('existingOrder >>'+existingOrder);
           if(existingOrder.size() > 0){
               caseObj = existingOrder[0];
               return caseObj;
           }else{
               return null;
           } 
        }
        return null;
    }
    public static Boolean isValidIpAddress(String ipAddress, String subject, String phone, String companyName, String email){
        List<Case> caseIpAddrList1 = [Select Id,IP_Address__c,Last_Modified_Min__c,SuppliedEmail,subject,Web_Company_Name__c,SuppliedPhone from Case where subject=: subject and SuppliedPhone =: phone and Last_Modified_Min__c < = 1];
        List<Case> caseIpAddrList = [Select Id,IP_Address__c,Last_Modified_Min__c,SuppliedEmail,subject,Web_Company_Name__c,SuppliedPhone from Case where IP_Address__c=: ipAddress and Last_Modified_Min__c < = 1   ];
        
        if(caseIpAddrList1.Size() > 0){
            return false;
        }else if(caseIpAddrList.Size() > 0){
           return false;            
        }else{
            return true;
        }
        
    }
    
    public List<KnowledgeArticlesWrapper> fetchMostRecentArticles(){    
        List<KnowledgeArticlesWrapper> mostRecentKnow = new List<KnowledgeArticlesWrapper>();    
        for(Knowledge__kav knowledgeArticle : [SELECT Id,Title,urlName,ArticleTotalViewCount,Article_Number__c,Summary_Data__c From Knowledge__kav ORDER BY ArticleTotalViewCount DESC LIMIT 10 ]){
           system.debug('KnowledgeArticle:'+KnowledgeArticle);
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
    @RemoteAction
    global static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
    public void cleardata(){
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
        caseType = '';
        caseReason = '';
        subCaseReason = '';
        caseTypeforTicket = '';
        ReasonforTicket1 = '';
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
    public class KnowledgeArticlesWrapper{    
        public String subject{get; set;}
        public String link{get; set;}   
        public String description {get;set;}    
        public KnowledgeArticlesWrapper(){
        }
        public KnowledgeArticlesWrapper(String subject, String link,String description){
            this.subject = subject;
            this.link = link;
            this.description =description ;
        }
    }
    global class responseWrapper{
        public string type {get;set;}
        public string message {get;set;}
        public string caseId {get;set;}
    }
}