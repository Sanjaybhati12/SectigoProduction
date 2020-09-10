public class CaseFromContactController{
    public static boolean flag;
    @AuraEnabled
    public static contactWrap getContactList(Id ContactId){
        String caseId = '';
        flag= true;
        contactWrap response = new contactWrap();
        List<Contact> conList = new List<Contact>();        
        conList = [Select Id,Name,Survey_Date__c,Do_NotSurvey__c,Company__c,Description,OwnerId,(Select Id, Subject,CreatedDate,Case_Created__c,Description FROM Tasks where subject like 'Submitted Form%' order by CreatedDate DESC limit 1 ) From Contact Where Id=:ContactId];
        
        Task tsk = new Task();
        if(conList[0].tasks.size() > 0){
            tsk = conList[0].tasks[0].clone();
            tsk.whoId = null;
        }
        
        try{
            if(String.isNotBlank(ContactId)){
                //Id casRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
                case cas = new case();
                cas.Status = 'New';
                cas.Reason = 'Certificate Technical Support';
                cas.Origin = 'Web';
                cas.Survey_Date__c = conList[0].Survey_Date__c;
                cas.Do_Not_Survey__c = conList[0].Do_NotSurvey__c;
                cas.Web_Company_Name__c = conList[0].Company__c;
                cas.ContactId = ContactId;
                cas.OwnerId = conList[0].OwnerId;
                cas.Description = conList[0].Description;
                if(conList[0].tasks.size() > 0 && conList[0].tasks.get(0).Case_Created__c != True){
                    cas.Subject = conList[0].tasks[0].subject;
                    cas.Description = conList[0].tasks[0].Description; 
                    Insert cas;
                    //Contact task is updated to check case created
                    Task tsk2 = new Task();
                    tsk2.Id = conList[0].tasks[0].Id;
                    tsk2.Case_Created__c = True;
                    update tsk2;
                    
                    caseId = cas.id;
                    // New task is created for new case
                    if(tsk != null && String.isNotBlank(tsk.Subject) ){
                        tsk.WhatId = cas.Id;
                        insert tsk;
                    }
                    
                    //Contact Status updated
                    conList[0].Contact_Status__c  = 'Unqualified';
                    update conList;
                    
                    response.isError = false;
                    response.caseId = cas.Id;
                    response.message = 'success';
                }else{
                    response.isError = false;
                    response.caseId = cas.Id;
                    response.message = 'Case Already Created';
                }
                 
                
                system.debug('+++++++caseId'+tsk);
            }
        }catch(exception e){
            response.isError = true;
            response.caseId = '';
            response.message = 'Error : '+e.getMessage();
        }
        system.debug('>>>>>>>>>>>>>>>>>tskabc'+tsk);
        return response;  
    }
    
    public class contactWrap{
        @AuraEnabled public String caseId;
        @AuraEnabled public String message;
        @AuraEnabled public Boolean isError;
    } 
}