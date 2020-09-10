public with sharing class Com_SearchCntrl {
    @AuraEnabled
    public static sobjectwrapperclass fetchSobjectInfo(String searchStr){
        system.debug('>>'+searchStr);
        User u= [Select Id, Contact.AccountId,profileid from User where ID =: UserInfo.getUserId()];
        String AccountID =u.Contact.AccountId;
        sectigoChannelPartner__c  mc1 =sectigoChannelPartner__c.getInstance(u.profileid);
        system.debug('$$$$$$$$'+mc1.IsChannelPartner__c );
        
        sobjectwrapperclass myWrap= new sobjectwrapperclass();
        
        if (!mc1.IsChannelPartner__c) {
            //normal results  with account id cases
            List<Case> caseList= new List<Case>();
            List<SObject> myKnowArt = new List<SObject>();
            if(searchStr.length() > 1){
                String searchStr1 = '*'+searchStr+'*';
                String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Case(Id,CaseNumber,Subject,Status, Order_Number__c,CreatedDate,Accountid), KnowledgeArticleVersion (Id, Title,UrlName WHERE PublishStatus=\'online\')';
                List<List <sObject>> searchList = search.query(searchQuery);
                system.debug('>>sosl searchList in ctrl>>>'+searchList);
                caseList = ((List<Case>)searchList[0]);
                myKnowArt= ((List<Sobject>)searchList[1]);
                //Added on 16 May 2019
                List<Case> myNewLst= new List<Case>();
                for(Case myFilterCase : caseList){
                    if(myFilterCase.Accountid==AccountID)
                        myNewLst.add(myFilterCase);
                }
                myWrap.cases=myNewLst;
                myWrap.knowArtles=myKnowArt;
                myWrap.caseCount=myNewLst.size();
                myWrap.knowCount=myKnowArt.size();
            }else{
                myWrap=null;
            }
            
        }else{
            //Incommon results . Filter own account id and partner id's
            
              //Query the Accounts that are related to incommonllc 
                Map < Id, Account > myAccInCommon = new Map < Id, Account > ([SELECT id, Channel_partner__c, Channel_partner__r.Name, Name FROM Account WHERE Channel_partner__r.id=:AccountID]);
                List<Case> caseList= new List<Case>();
                List<SObject> myKnowArt = new List<SObject>();
            if(searchStr.length() > 1){
                String searchStr1 = '*'+searchStr+'*';
                String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Case(Id,CaseNumber,Subject,Status, Order_Number__c,CreatedDate,Accountid), KnowledgeArticleVersion (Id, Title,UrlName WHERE PublishStatus=\'online\')';
                List<List <sObject>> searchList = search.query(searchQuery);
                system.debug('>>sosl searchList in ctrl>>>'+searchList);
                caseList = ((List<Case>)searchList[0]);
                myKnowArt= ((List<Sobject>)searchList[1]);
                //Added on 16 May 2019
                List<Case> myNewLst= new List<Case>();
                for(Case myFilterCase : caseList){
                    if(myFilterCase.Accountid==AccountID || myAccInCommon.containskey(myFilterCase.Accountid))
                        myNewLst.add(myFilterCase);
                }
                myWrap.cases=myNewLst;
                myWrap.knowArtles=myKnowArt;
                myWrap.caseCount=myNewLst.size();
                myWrap.knowCount=myKnowArt.size();
            }else{
                myWrap=null;
            }
        }
        system.debug('>>Final Wrap>>'+myWrap);
        return myWrap;
    }
}