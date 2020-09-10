public class CaseFromLeadController {
    public static boolean flag;
    @AuraEnabled
    public static leadWrap createCaserec(String leadId){
        String caseId = '';
        flag= true;
        leadWrap response = new leadWrap();
        List<Lead> ledList = new List<Lead>();
        ledList = [Select Id,OwnerId,Description,(Select Id, Subject FROM Tasks where subject like 'Submitted Form%') from Lead Where Id=:leadId];
        Task tsk = new Task();
        if(ledlist[0].tasks.size() > 0){
            tsk = ledlist[0].tasks[0].clone();
            tsk.whoId = null;
        }
        try{
            if(String.isNotBlank(leadId)){
                Id casRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadId);
                
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true AND MasterLabel =:Label.CovertedLeadStatus LIMIT 1];
                system.debug('>>>>>>>>>>>convertStatus'+convertStatus);
                //lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(true);
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                
                String AccountId = lcr.getAccountId();
                String ContactId = lcr.getContactId();
                
                if(ledList.size() > 0){
                    case cas=new case();
                    cas.Status = 'New';
                    cas.ContactId = ContactId;
                    cas.AccountId = AccountId;
                    cas.Reason = 'Certificate Technical Support';
                    cas.Origin = 'Web';
                    cas.OwnerId = ledList[0].OwnerId;
                    cas.Description = ledList[0].Description;
                    cas.RecordTypeId = casRecordTypeId;
                    if(ledlist[0].tasks.size() > 0){
                        cas.Subject = ledlist[0].tasks[0].subject;
                        system.debug('>>>>>>>>>cas.Subject'+cas.Subject);
                    }
                    insert cas;
                    system.debug('>>>>>>>>caastest'+cas);
                    Contact con = new Contact();
                    con.Id = ContactId;
                    con.Contact_Status__c = 'Converted';
                    update con;
                    
                    caseId = cas.id;
                    system.debug('+++++++caseId'+caseId);
                    if(tsk != null && String.isNotBlank(tsk.Subject) ){
                        tsk.WhatId = cas.Id;
                        insert tsk;
                    }
                    response.isError = false;
                    response.caseId = cas.Id;
                    response.message = 'success';
                    system.debug('+++++++caseId'+tsk);
                    
                }
            }
            
        }catch(exception e){
            response.isError = true;
            response.caseId = '';
            response.message = 'Error : '+e.getMessage();
        }
        
        system.debug('>>>>>>>>>>>>>>>>>tskabc'+tsk);
        return response;
    }
    public class leadWrap{
        @AuraEnabled public String caseId;
        @AuraEnabled public String message;
        @AuraEnabled public Boolean isError;
    }
}