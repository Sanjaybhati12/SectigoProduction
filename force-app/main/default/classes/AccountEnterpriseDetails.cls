public without sharing class AccountEnterpriseDetails {
    @AuraEnabled public List<ContentVersion> cv {get;set;} 
    @AuraEnabled public list<Contact> contactList {get;set;} 
    @AuraEnabled public Boolean portalUserOrNot {get;set;} 
    @AuraEnabled public Datetime portalAccessDate {get;set;}
    @AuraEnabled public list<user> userList {get;set;} 
    @AuraEnabled public Decimal totalQuoteAmount {get;set;} 
    
    public AccountEnterpriseDetails(){
        contactList=new list<Contact> ();
        cv= new List<ContentVersion>();
        userList=new list<user> ();
        portalUserOrNot=false;
    }
    
    @AuraEnabled
    public static Id saveTheFile( Id recordId,String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion contentVersion = new ContentVersion(
            versionData = EncodingUtil.base64Decode(base64Data),
            title = fileName,
            pathOnClient =  '/' + fileName
        );
        insert contentVersion; 
        account acc=[select id,ContentVersionId__c from Account where id=: recordId];
        if(acc.ContentVersionId__c == null ){
            acc.ContentVersionId__c = '';
        }
        String contentVer = acc.ContentVersionId__c;
        acc.ContentVersionId__c=contentVersion.Id+','+contentVer; 
        update acc;   
        system.debug('contentversion'+contentVersion);system.debug('contentversion'+acc.ContentVersionId__c);
        return contentVersion.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        system.debug('savechunck');
        if (fileId == '') {
            fileId = saveTheFile( parentId,fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion contentVersion = [
            SELECT Id, versionData
            FROM ContentVersion
            WHERE Id = :fileId
        ];
        String existingBody = EncodingUtil.base64Encode(contentVersion.versionData);
        contentVersion.versionData = EncodingUtil.base64Decode(existingBody + base64Data); 
        update contentVersion;   
    }
    
    @AuraEnabled
    public static ContentVersion getContentversion(string contentversionId, String recordId) {
        //recordId='0011N00001RqYUCQA3';
        system.debug('getContentversion========'+contentversionId);
        ContentVersion contentVersion = [
            SELECT id,ContentDocumentId, ContentDocument.Description, ContentDocument.FileExtension ,PathOnClient  
            FROM ContentVersion
            WHERE Id = :contentversionId
        ];
        /*account acc=[select id,ContentVersionId__c from Account where id=: recordId];
        if(acc.ContentVersionId__c == null ){
            acc.ContentVersionId__c = '';
        }
        String contentVer = acc.ContentVersionId__c;
        acc.ContentVersionId__c=contentVersion.Id+','+contentVer; 
        update acc;  */ 
        return contentVersion;
    }
    
    @AuraEnabled
    public static AccountEnterpriseDetails  getAccountContacts(string recordId){
       system.debug('recordId'+recordId);
        list<Contact> con=[select id, FirstName,LastName ,Email,Account.ContentVersionId__c, Account.name,Account.CreatedDate,Account.Service_Account_Manager__r.Name,Account.Enterprise_Premier__c 
                           from contact  where AccountId=:recordId and( Role__c ='Premier 1' or Role__c ='Premier 2' or Role__c ='Premier 3')];
        list<user> u=[SELECT IsActive,IsPortalEnabled,LastName,Contact.Name,CreatedDate, ContactId FROM User where IsPortalEnabled =true AND contactId in:con order by CreatedDate asc];
        
        AccountEnterpriseDetails fupObj=new AccountEnterpriseDetails();
        if(con.size()>0){
            fupObj.contactList= con;
        }
        
        
        if(u.size()>0){
            fupObj.portalUserOrNot=true;
            fupObj.userList=u;
            fupObj.portalAccessDate=u[0].CreatedDate;
        }
        //  string ids='0681N000003ARvtQAG';	
        
        fupObj.totalQuoteAmount = getTotalListAmount(recordId);
        if(fupObj.contactList[0].Account.ContentVersionId__c != null){
        List<String> ids=fupObj.contactList[0].Account.ContentVersionId__c.split(',');
        system.debug('id===='+ids);
        if(ids!=null){
            fupObj.cv= [ select id,ContentDocumentId, ContentDocument.Description, ContentDocument.FileExtension ,PathOnClient  
                        from ContentVersion where id IN :ids];
        }
        }
        
        return fupObj; 
    }
    
    @AuraEnabled
    public static Decimal getTotalListAmount(String recordId){
        List<SBQQ__Subscription__c> subProdList = [SELECT Id, Name, SBQQ__Account__c, SBQQ__Product__r.Name, SBQQ__ProductName__c,SBQQ__Product__r.Family, SBQQ__ListPrice__c 
                                                   FROM SBQQ__Subscription__c
                                                   WHERE SBQQ__Product__r.Family = 'Partner' AND SBQQ__Account__c =: recordId ];
        Decimal totalAmount = 0;
        for(SBQQ__Subscription__c sub : subProdList){
            totalAmount += sub.SBQQ__ListPrice__c;
        } 
        System.debug('totalAmount ' + totalAmount);
        return totalAmount;
    }
    
}