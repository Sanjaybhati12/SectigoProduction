public with sharing class PaginationExtension {
    Public Integer noOfRecords {get;set;}
    Public Integer size {get;set;}
    Public List < SelectOption > ListOfCse {get;set;}
    Public String selectVal {get;set;}
    Public String selectPriority {get;set;}
    public ApexPages.StandardSetController setCon {get;set;}
    
    public PaginationExtension() {
        selectPriority = '';
        if (setCon == null) {
            size = 10;
            User u= [Select Id, Contact.AccountId,profileid from User where ID =: UserInfo.getUserId()];
            string queryString;
            String AccountID =u.Contact.AccountId;
            
            sectigoChannelPartner__c  mc1 =sectigoChannelPartner__c.getInstance(u.profileid);
            
            if (!mc1.IsChannelPartner__c) {
                queryString = 'select Id,Last_Comment_Date__c,Priority,CaseNumber,Status,Subject,Account.Name,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId =:AccountID  ORDER BY CreatedDate DESC';
                
                
            } else {
                Map < Id, Account > myAccInCommon = new Map < Id, Account > ([SELECT id, Channel_partner__c, Channel_partner__r.Name, Name FROM Account WHERE Channel_partner__r.id=:AccountID]);
                List < Id > myIncomm=new List<Id>();
                for(Id eachRec : myAccInCommon.keyset()){
                    myIncomm.add(eachRec);
                }
                myIncomm.add(AccountID);
                queryString = 'select Id,CaseNumber,Status,Priority,Subject,Account.Name,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId IN: myIncomm ORDER BY CreatedDate DESC';
               
            }
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            setCon.setPageSize(size);
            noOfRecords = setCon.getResultSize();
        }
    }
    
    public void fetchRecs() {
        
        User u= [Select Id, Contact.AccountId,profileid from User where ID =: UserInfo.getUserId()];
        String AccountID=u.Contact.AccountId;
        
        sectigoChannelPartner__c  mc1 =sectigoChannelPartner__c.getInstance(u.profileid);
        string queryString1 = '';
        system.debug('selectVal >>'+selectVal);
        system.debug('selectPriority >>'+selectPriority);
        if (!mc1.IsChannelPartner__c) {
            if (selectVal == 'All' && selectPriority == 'All') {
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId =:AccountID ORDER BY CreatedDate DESC';
            }else if(selectVal != 'All' && selectPriority == 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId =:AccountID AND Status=:selectVal ORDER BY CreatedDate DESC';
            }else if(selectVal != 'All' && selectPriority != 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId =:AccountID AND Status=:selectVal AND Priority=:selectPriority ORDER BY CreatedDate DESC';
            }else if(selectVal == 'All' && selectPriority != 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId =:AccountID AND Priority=:selectPriority ORDER BY CreatedDate DESC';
            }
            
        } else {
            Map < Id, Account > myAccInCommon1 = new Map < Id, Account > ([SELECT id, Channel_partner__c, Channel_partner__r.Name, Name FROM Account WHERE Channel_partner__r.id=:AccountID]);
            List < Id > myIncomm1=new List<Id>();
            for(Id eachRec : myAccInCommon1.keyset()){
                myIncomm1.add(eachRec);
            }
            myIncomm1.add(AccountID);
            
            if (selectVal == 'All' && selectPriority == 'All') {
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId IN: myIncomm1 ORDER BY CreatedDate DESC';
            }else if(selectVal != 'All' && selectPriority == 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId IN: myIncomm1 AND Status=:selectVal ORDER BY CreatedDate DESC';
            }else if(selectVal != 'All' && selectPriority != 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId IN: myIncomm1 AND Status=:selectVal AND Priority=:selectPriority ORDER BY CreatedDate DESC';
            }else if(selectVal == 'All' && selectPriority != 'All'){
                queryString1 = 'select Id,Priority,CaseNumber,Status,Subject,Account.Name,Last_Comment_Date__c,contact.name,Order_Number__c,Description,CreatedDate,LastModifiedDate  from Case where AccountId IN: myIncomm1 AND Priority=:selectPriority ORDER BY CreatedDate DESC';
            }
            
        }
        
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString1));
        setCon.setPageSize(size);
        noOfRecords = setCon.getResultSize();
    }
    
    Public List < Case > getCases() {
        List < Case > caseList = new List < Case > ();
        if (setCon.getRecords() != null)
            for (Case c: (List < Case > ) setCon.getRecords())
            caseList.add(c);
        return caseList;
    }
    
    public List < SelectOption > getmyOpt() {
        List < SelectOption > myNewOpt = new List < SelectOption > ();
        myNewOpt.add(new SelectOption('All', 'Select Status'));
        myNewOpt.add(new SelectOption('New', 'New'));
        myNewOpt.add(new SelectOption('On Hold', 'On Hold'));
        myNewOpt.add(new SelectOption('Awaiting Customer Reply', 'Reply from Sectigo'));
        myNewOpt.add(new SelectOption('In progress', 'Action with Sectigo'));
        myNewOpt.add(new SelectOption('Closed', 'Closed'));
        return myNewOpt;
    }
    public List < SelectOption > getPriorityOpt() {
        List < SelectOption > myNewOpt = new List < SelectOption > ();
        String objectName = 'Case';
        String fieldName ='Priority';
          
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        myNewOpt.add(new SelectOption('All', 'Select Priority'));
        for( Schema.PicklistEntry pickListVal : ple){
            myNewOpt.add(new SelectOption( pickListVal.getValue(),pickListVal.getLabel()));
        }    
        return myNewOpt;
    }
    
    public pageReference refresh() {
        setCon = null;
        getCases();
        setCon.setPageNumber(1);
        return null;
    }
    
}