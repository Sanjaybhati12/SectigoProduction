trigger shareFilestoSiteUsers on ContentDocumentLink (before insert) {
   
    User u =[select id,UserPermissionsKnowledgeUser from user where id=: UserInfo.getUserId()];
    if(trigger.isbefore){
       if(u.UserPermissionsKnowledgeUser==true){
            Schema.DescribeSObjectResult r = Knowledge__kav.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            for(ContentDocumentLink cdl:trigger.new){
                if((String.valueOf(cdl.LinkedEntityId)).startsWith(keyPrefix)){
                  if(!Test.isRunningTest()){
                        cdl.ShareType = 'V';
                        cdl.Visibility = 'AllUsers';
                    }
                } 
            }
        }
    }
    Schema.DescribeSObjectResult r = case.sObjectType.getDescribe();
    String keyPrefix = r.getKeyPrefix();
    system.debug(keyPrefix );
      for(ContentDocumentLink cdl:trigger.new){
        if((String.valueOf(cdl.LinkedEntityId)).startsWith(keyPrefix)){
          cdl.ShareType = 'V';
          cdl.Visibility = 'AllUsers';
          } 
   }
    
}