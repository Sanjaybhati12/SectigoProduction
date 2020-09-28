global class caseReasonUpdateBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> reasonList = new List<String>{'SSL Certificate Support','Certificate Technical Support','Certificate Manager','SCM Support','Technical Certificate Manager',
            'HG/HP/WI','HackerGuardian Partner Inquiry','SCM Private CA','Partner Inquiry','SCM Validation','EV Validation','Validation','SSL/TLS Certificate Technical Support',
            'Sectigo Certificate Manager (SCM)','SSL/TLS Certificate Validation (OV, DV, S/MIME, Code & Doc Signing)'};
                String query = 'SELECT Id, Type, CaseNumber, Reason, Status FROM Case WHERE Reason IN : reasonList';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Case> records){
        List<Case> caseListforUpdate = new List<Case>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        system.debug('Batch Records >>'+records);
        for(Case csRec : records){
            if(csRec.Reason == 'SSL Certificate Support' || csRec.Reason == 'SSL/TLS Certificate Technical Support'){
                csRec.Reason = 'Certificate Technical Support';
            }else if(csRec.Reason == 'Certificate Manager' || csRec.Reason == 'SCM Support' || csRec.Reason == 'Technical Certificate Manager' || csRec.Reason == 'Sectigo Certificate Manager (SCM)'){
                csRec.Reason = 'Sectigo Certificate Manager (SCM) Support';
            }else if(csRec.Reason == 'HG/HP/WI' || csRec.Reason == 'HackerGuardian Partner Inquiry'){
                csRec.Reason = 'HackerGuardian';
            }else if(csRec.Reason == 'SCM Private CA'){
                csRec.Reason = 'Sectigo Certificate Manager (SCM) Private CA';
            }else if(csRec.Reason == 'Partner Inquiry'){
                csRec.Reason = 'Partner Validation';
            }else if(csRec.Reason == 'SCM Validation'){
                csRec.Reason = 'Sectigo Certificate Manager (SCM) Validation';
            }else if(csRec.Reason == 'EV Validation'){
                csRec.Reason = 'Extended Validation (EV) Certificates';
            }else if(csRec.Reason == 'Validation' || csRec.Reason =='SSL/TLS Certificate Validation (OV, DV, S/MIME, Code & Doc Signing)'){
                csRec.Reason = 'Certificate Validation (OV, S/MIME, Code & Doc Signing)';
            }
            caseListforUpdate.add(csRec);
            caseMap.put(csRec.Id,csRec);
        }
        system.debug('caseListforUpdate Records >>'+caseListforUpdate);
        if(caseListforUpdate.size() > 0 ){
            try{
                Database.SaveResult[] SRList =  Database.update(caseListforUpdate);
                system.debug('SRList  >>'+SRList );
                for(Database.SaveResult sr : SRList){
                    String rowStr = sr.id + ',' + sr.isSuccess()+','+caseMap.get(sr.id).reason;
                    csvRowValues.add(rowStr);
                }
                // update caseListforUpdate;
            }catch(dmlException e){}
        }
        
    }    
    global void finish(Database.BatchableContext bc){
        
        Account acc = [SELECT ID,Name FROM Account WHERE Name = 'Sectigo' LIMIT 1];
        if(acc.Id != null){
            String documentName = 'CaseReasonUpdatedRecords-'+ Datetime.now().format('MMM') + Datetime.now().year()+'.csv';
            csvColumnHeader = 'CaseId, isSuccess,Case Reason\n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            
            // Insert the generated CSV file in Document object under "Setup Audit Trail Logs".
            Attachment doc = new Attachment (Name = documentName, Body = Blob.valueOf(csvFile), ParentId = acc.Id, ContentType='text/csv');//'application/vnd.ms-excel');
            insert doc;
        }
    }    
}