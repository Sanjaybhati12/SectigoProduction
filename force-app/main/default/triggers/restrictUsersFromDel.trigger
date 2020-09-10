trigger restrictUsersFromDel on Case_Comment__c (before delete, after insert,after update) {


 /**
        trigger fired on:- before delete
        purpose :- restrict users not to delete Casecomments except System admin profile Users         
      **/
      
    if(trigger.isBefore && trigger.isdelete){
        system.debug('user Profile'+userinfo.getProfileId());
        Profile SystemAdminId=[select id from Profile where Name='System Administrator' limit 1];
        if(UserInfo.getProfileId() != SystemAdminId.Id){
            for(Case_Comment__c  oldcase:Trigger.old){
                    oldcase.adderror('You are not authorized to delete the record , please contact your system administrator');
            }
         }
    }
    
    if((trigger.isInsert) && (trigger.isAfter)){
        //publicCaseTriggerHelper.updateRecentCommentOnCase(trigger.new);
    }


}