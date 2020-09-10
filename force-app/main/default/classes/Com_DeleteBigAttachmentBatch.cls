/** Class Name   : Com_DeleteBigAttachmentBatch 
*  Description  : Batchclass to delete big files uploaded by community users
*                     
*  Created By   : Agile Cloud Consulting
*  Created On   : 26-04-2019

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/
global class Com_DeleteBigAttachmentBatch implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        
        Set<String> allPrfNames = new Set<String>();
        String myPf;
        DateTime dt;
        if(!Test.IsRunningTest()){
         myPf = Label.Profilename;
         allPrfNames.addAll(myPf.split(','));
         system.debug('@@@@@'+allPrfNames);
         dt = System.Now().adddays(-Integer.ValueOf(Label.AddDays));//initialize datetime with current datetime

        }else{
         myPf = 'System Administrator';
          dt = System.Now().addDays(2);
            allPrfNames.add(myPf);
        }
        
        
        String myTargetDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');//format the datetime to make it Dynamic Soql ready
        System.debug('>>formatedDt>>>'+myTargetDate);  
        
        
        
        //Query the Profile id and users
        Map<Id, User> allCommUSer=new Map<Id, User>([ SELECT Id FROM User WHERE Profile.Name IN: (allPrfNames)]);
        System.debug('#####community users count###'+allCommUSer.size());
        set<Id> setUserIds = new set<Id>();
        setUserIds.addAll(allCommUSer.keySet());
        //List<FeedItem> myCommunityFeeds=[SELECT CreatedById,CreatedDate,Id,InsertedById,IsClosed,IsDeleted,LastEditById,LastEditDate,LastModifiedDate,ParentId,RelatedRecordId,Status,SystemModstamp,Title,Type,Visibility FROM FeedItem WHERE CreatedById IN:(allCommUSer.keySet()) AND CreatedDate<YESTERDAY  LIMIT 20];
        String query='SELECT CreatedById,CreatedDate,Id,InsertedById,IsClosed,IsDeleted,LastEditById,LastEditDate,LastModifiedDate,ParentId,RelatedRecordId,Status,SystemModstamp,Title,Type,Visibility FROM FeedItem WHERE CreatedById IN: setUserIds AND CreatedDate<'+myTargetDate;  //AND CreatedDate<'+myTargetDate
        return Database.getQueryLocator(query);
                   
        //query = 'SELECT Id, (SELECT id, LinkedEntityId FROM ContentDocumentLinks), Owner.Name, Owner.Profile.Name  FROM ContentDocument';
        //query += ' WHERE CreatedDate <:formatedDt ';
      /*  Schema.DescribeSObjectResult case1 = Case.sObjectType.getDescribe();
       String caseKeyPrefix = case1.getKeyPrefix();
        String Query1='SELECT id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId.StartsWith(caseKeyPrefix) AND CreatedDate < '+formatedDt+'';
        system.debug('$%$%%%%condoclinks'+Query1);
        String Query='SELECT Id,Owner.Name, Owner.Profile.Name,CreatedDate  FROM ContentDocument where CreatedDate < '+formatedDt+'';
        return Database.getQueryLocator(Query);*/
    }
    
    global void execute(Database.BatchableContext BC, List<FeedItem> scope){
        system.debug('$$$$scope size$$$$'+scope.size());
         Set<Id> setContentVerIds = new Set<Id>();
            for(FeedItem FI : scope ) { 
                //checkign realted record is not empty.
                //Empty: it is not a file. Not empty: it is realted to file.
                //Need to add extra condition only to pick case realted files .ParentId
                    if (String.isNotBlank(FI.RelatedRecordId))
                        setContentVerIds.add(FI.RelatedRecordId);//RelatedRecordId is the Content Version Id
                }
                List <ContentDocument> listFiles = new List <ContentDocument>();
            for(ContentVersion CV :[SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: setContentVerIds]){
                listFiles.add(new ContentDocument(Id = CV.ContentDocumentId));
                }
        
        system.debug('$$$$Final$$$$'+listFiles.size());
        if(listFiles.size()>0){
               delete listFiles;
               //delete from recyclin bin 
               //Database.emptyRecycleBin(listFiles); 
           }
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}