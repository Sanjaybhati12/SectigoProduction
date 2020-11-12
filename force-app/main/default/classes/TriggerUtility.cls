/*
* Purpose: Case Object Trigger    
* Created By: Agile Cloud 03/08/2018
* Last Modified By: 
* Current Version:  v1.0 
* Revision Log:  
*              v1.1 - 
*              v1.0 -           
*/
public class TriggerUtility{
    
    public static void addCaseComments(List<Case> caseList){
        List<Case_Comment__c> caseCommentList = new List<Case_Comment__c>();
        for(Case c : caseList){
            if(String.isNotBlank(c.Internal_Comments__c)){
                caseCommentList.add(new Case_Comment__c(Comment_Body__c=c.Internal_Comments__c, parentId__c=c.Id));
            }
        }
        if(caseCommentList.size()>0){
            insert caseCommentList;
        }
    }
    
    /* Method to set service contract and entitlement for account based on value of account's customer segment */
    public static void setServiceContract(List<Account> accountList, Map<Id,Account> oldAccMap){
        List<Entitlement> eList = new List<Entitlement>();
        List<ServiceContract> updateList = new List<ServiceContract>();
        List<String> accountIDs = new List<String>();
        for(Account a : accountList){
            //if((acc.Closed_Won_Opportunities__c == acc.Total_Number_Of_Opportunities__c) && acc.Total_Number_Of_Opportunities__c > 0)
            accountIDs.add(a.Id);
        }
        
        if(accountIDs != null && accountIDs.size() > 0){
            List<ServiceContract> existingSCList = [Select Id, Name, AccountId, StartDate, EndDate From ServiceContract where AccountId IN: accountIDs];
            Map<String, ServiceContract> extMap = new Map<String, ServiceContract>();
            if(existingSCList != null && existingSCList.size() > 0){
                for(ServiceContract s : existingSCList){
                    extMap.put(s.AccountId, s);
                }
            }
            system.debug('extMap ---->> ' + extMap);
            List<SlaProcess> eprocess = [Select Id, Name From SlaProcess where IsActive=true];
            List<ServiceContract> lst = new List<ServiceContract>();
            for(Account a : accountList){
                ServiceContract sc;
                Map<ID,Schema.RecordTypeInfo> rt_Map = new Map<ID,Schema.RecordTypeInfo>();
                rt_Map  = Account.sObjectType.getDescribe().getRecordTypeInfosById();
                string recordtypeName = rt_map.get(a.RecordTypeId).getName();
                
                if(extMap != null && extMap.get(a.Id) != null){
                    sc = extMap.get(a.Id);
                    if(a.Segment__c == 'Enterprise-Large' || a.Segment__c == 'Enterprise-MidMarket'){
                        sc.Name = 'CCM support';
                    }else if(a.Segment__c == 'Retail'){
                        sc.Name = 'Retail Support';
                    }else if(a.Segment__c == 'Partner/Reseller'){
                        sc.Name = 'Partner/Reseller Support';
                    }else{
                        sc.Name = 'General Support';
                    }
                    if(recordtypeName =='Customer of Reseller/Partner' || recordtypeName =='Retail'){
                        sc.Name = 'General Support';
                    }
                    if(a.Enterprise_Premier__c== true){
                        sc.Name = 'Enterprise Premier Support';
                    }
                    updateList.add(sc);                    
                    
                }else{
                    //create new if no service contract exist
                    sc = new ServiceContract();
                    sc.Name = 'General Support';
                    sc.AccountId = a.Id;
                    sc.StartDate = system.today();
                    sc.EndDate = system.today().addYears(2);
                    
                    
                    if(a.Segment__c == 'Enterprise-Large' || a.Segment__c == 'Enterprise-MidMarket'){
                        sc.Name = 'CCM support';
                    }else if(a.Segment__c == 'Retail'){
                        sc.Name = 'Retail Support';
                    }else if(a.Segment__c == 'Partner/Reseller'){
                        sc.Name = 'Partner/Reseller Support';
                    }else{
                        sc.Name = 'General Support';
                    }
                    if(recordtypeName =='Customer of Reseller/Partner' || recordtypeName =='Retail'){
                        sc.Name = 'General Support';
                    }
                    if(a.Enterprise_Premier__c== true){
                        sc.Name = 'Enterprise Premier Support';
                    }
                    lst.add(sc);
                    
                }
            }
            system.debug('lst ------>> ' + lst);
            if(lst!=null && lst.size()>0) {
                insert lst;
            }
            for(ServiceContract sc : lst){
                Entitlement e = new Entitlement();
                e.AccountId = sc.AccountId;
                e.StartDate = system.today();
                e.EndDate = system.today().addYears(2);
                e.Name = 'Service SLA';
                e.ServiceContractId = sc.Id;
                e.SlaProcessId = eprocess[0].Id;
                eList.add(e);
            }
        }
        system.debug('eList ------>> ' + eList);
        if(eList != null && eList.size() > 0){
            insert eList;   
        }
        system.debug('updateList ---->> ' + updateList);
        
        if(updateList != null && updateList.size() > 0){
            update updateList;
        }
    }
    
    //Updating case reasons for email cases    
    public static void setCaseReason(List<Case> caseList){      
        // Getting Custom Setting Values
        Map<String, caseReason_EmailCase__c>  allVal = caseReason_EmailCase__c.getAll(); 
        List<String> caseReasonCheckList = system.label.Set_Reason_Case_Checker.split(',');  // check list filter
        for(Case eachCase :caseList ){
            if( caseReasonCheckList.contains(eachCase.Origin) ){   //eachCase.Origin == 'Email'){     
                if(allVal.containsKey(eachCase.OwnerId)){
                    eachCase.Reason= allVal.get(eachCase.OwnerId).Case_Reason__c;                             
                }
            }
        }    
    }
    
    
    /*setting Entitlement process for case based on account service contract*/
    public static void SetEntitlementprocess(List<Case> caseList){ 
        system.debug('---->'+caseList); 
        list<Id> accountList = new List<Id>();
        for(case cc:caseList){
            accountList.add(cc.accountid);
        } 
        if(accountList.size()>0){
            
            Map<Id,Account> accmap = New Map<Id,Account>([Select id,(Select Id, Name from Entitlements where ServiceContractId != null AND Status='Active') from Account where id in: accountList]);
            
            for(case cc:caseList){
                if(accmap.containskey(cc.accountid)){
                    account ac = accmap.get(cc.accountid);
                    if(ac.entitlements.size()>0){
                        cc.entitlementid = ac.entitlements[0].Id;
                        cc.entitlement = ac.entitlements[0];     
                    }
                }
                
            }
        }
        
    }
    
    //Creation of case comments from Workflow Email templates. To avoid duplicate records in email message and public case comments.  
     public static void sendAutoWorkflowEmail(List<Case> caseList,Map<Id,Case> caseOld,Map<Id,Case> caseNew){       
        
        List<EmailTemplate>  myNewLst = new List<EmailTemplate>([SELECT DeveloperName, Id,subject,body,HtmlValue FROM EmailTemplate Where DeveloperName in ('New_Support_Case_Created_NotificationS',
                                                                                                                                                            'Support_Case_onHold_Escalated_Notification_EmailTemplateS',
                                                                                                                                                           'Support_Case_Closed_Auto_ResponseS','Support_Account_Changes_Auto_Response1',
                                                                                                                                                           'Support_Closed_After_120_hrs_in_Awaiting_Customer_ReplySectigo')]);
        Map<String,EmailTemplate> myEmailMap= new Map<String,EmailTemplate> ();        
        for(EmailTemplate singelEmTemp: myNewLst ){
            myEmailMap.put(singelEmTemp.DeveloperName,singelEmTemp);
        } 
        
        system.debug('$$$$$'+myEmailMap.keyset());       
        EmailTemplate etemp ;
        Set<Id> conId = new Set<Id>();        
        for(case eachCse : caseList){
            if(eachCse.contactid!=null)
                conId.add(eachCse.contactid);
        }        
        Map<Id,Contact> mycons = new Map<Id,Contact>([select id,Email,name from contact where Id IN:(conId)]);  
        //System.debug('>>>mycons>>'+mycons);
        Map<Id,Contact> conwithCaseId = new Map<Id,Contact>();
        
        for(case eachCse : caseList){
            if(eachCse.contactid!=null){
                if(mycons.containsKey(eachCse.contactid))
                    conwithCaseId.put(eachCse.id,mycons.get(eachCse.contactid));
            }
        }
        
        String letterHeadBody= Label.Trigger_Image;
        
        List<Case_Comment__c >  lstCaseComment = new List<Case_Comment__c >();
        system.debug('conwithCaseId###'+conwithCaseId);
        for(Case eachCse: caseList){
            //This is for Auto Response Email for web and Email    create 
            if(Trigger.isInsert && Trigger.isAfter && eachCse.Status == 'New' && ( eachCse.Origin=='Web' || eachCse.Origin=='Email' || eachCse.Origin=='Community' ) && eachCse.Reason != 'Account Changes' && eachCse.Ticketid__c == null){
                
                // System.debug('$$$conwithCaseId.get(eachCse.Id).Name $$$'+conwithCaseId.get(eachCse.Id).Name );
                System.debug('%%%New Case for Web and Email %%%');                
                etemp = myEmailMap.get('New_Support_Case_Created_NotificationS'); 
                
                String emailBody = etemp.HtmlValue;       
                // Contact myTemp=conwithCaseId.get(eachCse.Id);
                if(conwithCaseId.containsKey(eachCse.Id) && emailBody.contains('{!Contact.FirstName}'))                     
                    emailBody = emailBody.replace('{!Contact.FirstName}', conwithCaseId.get(eachCse.Id).Name);
                else
                    emailBody = emailBody.replace('{!Contact.FirstName}','');
                
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber);   
                if(eachCse.Case_Owner_Name__c !=null) 
                    emailBody = emailBody.replace('{!Case.OwnerFullName}', eachCse.Case_Owner_Name__c);  
                else
                    emailBody = emailBody.replace('{!Case.OwnerFullName}','');  
                
                
                emailBody = emailBody.replace('{!Case.Status}', eachCse.Status); 
                
                if(eachCse.SuppliedEmail!=null)                        
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', eachCse.SuppliedEmail); 
                else
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', ''); 
                
                if(eachCse.SuppliedCompany!=null)
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', eachCse.SuppliedCompany);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', '');
                
                
                if(eachCse.Web_Company_Name__c!=null)
                    emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', eachCse.Web_Company_Name__c);
                else
                    emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', '');
                
                
                
                
                
                if(eachCse.SuppliedPhone!=null)                            
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', eachCse.SuppliedPhone);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', '');
                
                
                if(eachCse.Order_Number__c!=null)                            
                    emailBody = emailBody.replace('{!Case.Order_Number__c}', eachCse.Order_Number__c);
                else
                    emailBody = emailBody.replace('{!Case.Order_Number__c}','');
                
                if(eachCse.Subject!=null)                            
                    emailBody = emailBody.replace('{!Case.Subject}', eachCse.Subject);
                else
                    emailBody = emailBody.replace('{!Case.Subject}','');
                
                
                if(eachCse.Description!=null)                            
                    emailBody = emailBody.replace('{!Case.Description}', eachCse.Description);
                else
                    emailBody = emailBody.replace('{!Case.Description}','');
                
                
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;  //emailBody
                autoCaseComment.From_Address__c =Label.Email_Automation;
                autoCaseComment.Customer_Email__c = eachCse.SuppliedEmail;
                if(conwithCaseId.containsKey(eachCse.Id) )
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);
            }
            //This is onhold notification  create and update
            if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate ) && eachCse.Status == 'On Hold' && eachCse.Ticketid__c == null){
                system.debug('&&on hold >>>&&');
                
                etemp = myEmailMap.get('Support_Case_onHold_Escalated_Notification_EmailTemplateS');  
                String emailBody = etemp.HtmlValue;  
                
                if(conwithCaseId.containsKey(eachCse.Id)) 
                    emailBody = emailBody.replace('{!Case.Contact}', conwithCaseId.get(eachCse.Id).Name);  
                else
                    emailBody = emailBody.replace('{!Case.Contact}','');  
                
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber); 
                
                
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;
                autoCaseComment.From_Address__c =Label.Email_Automation;
                if(conwithCaseId.containsKey(eachCse.Id) )
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);
                
                
            }
            //This is for closed cases  create and update
            if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate ) && eachCse.Status == 'Closed' && eachCse.Ticketid__c == null && eachCse.Do_Not_Send_Close_Case_Email__c== false && eachCse.ResolutionDateline__c == null){
                
                system.debug('###Closed#'+ eachCse.Status);
                
                
                // AutoCloseEmailTemplate update
                etemp = myEmailMap.get('Support_Case_Closed_Auto_ResponseS');  
                String emailBody = etemp.HtmlValue; 
                
                if(conwithCaseId.containsKey(eachCse.Id)) 
                    emailBody = emailBody.replace('{!Case.Contact}', conwithCaseId.get(eachCse.Id).Name);  
                else
                    emailBody = emailBody.replace('{!Case.Contact}','');  
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber); 
                
                
                if(eachCse.Description!=null)                            
                    emailBody = emailBody.replace('{!Case.Description}', eachCse.Description);
                else
                    emailBody = emailBody.replace('{!Case.Description}','');
                
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;
                autoCaseComment.From_Address__c =Label.Email_Automation;
                if(conwithCaseId.containsKey(eachCse.Id))
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);
                
                
            }
            //This is for Auto Response Email for chat and Phone  created and update    Web Email
            if(Trigger.isAfter && ((Trigger.isInsert && eachCse.Status == 'New' && (eachCse.Origin=='Phone' || eachCse.Origin=='Chat') && eachCse.Reason != 'Account Changes' && eachCse.Ticketid__c == null && caseNew.get(eachCse.Id).Send_case_confirmation_email__c == true )|| (Trigger.isUpdate && eachCse.Status == 'New' && (eachCse.Origin=='Phone' || eachCse.Origin=='Chat') && eachCse.Reason != 'Account Changes' && eachCse.Ticketid__c == null && caseOld.get(eachCse.Id).Send_case_confirmation_email__c == false && caseNew.get(eachCse.Id).Send_case_confirmation_email__c == true ))  ){
                
                
                
                etemp = myEmailMap.get('New_Support_Case_Created_NotificationS');                            
                String emailBody = etemp.HtmlValue;       
                if(conwithCaseId.containsKey(eachCse.Id))                     
                    emailBody = emailBody.replace('{!Contact.FirstName}', conwithCaseId.get(eachCse.Id).Name);
                else
                    emailBody = emailBody.replace('{!Contact.FirstName}','');
                
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber);   
                
                if(eachCse.Case_Owner_Name__c !=null) 
                    emailBody = emailBody.replace('{!Case.OwnerFullName}', eachCse.Case_Owner_Name__c); 
                else
                    emailBody = emailBody.replace('{!Case.OwnerFullName}','');  
                
                
                emailBody = emailBody.replace('{!Case.Status}', eachCse.Status); 
                
                if(eachCse.SuppliedEmail!=null)                        
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', eachCse.SuppliedEmail); 
                else
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', ''); 
                
                if(eachCse.SuppliedCompany!=null)
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', eachCse.SuppliedCompany);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', '');
                
                if(eachCse.Web_Company_Name__c!=null)
                    emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', eachCse.Web_Company_Name__c);
                else
                    emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', '');
                
                
                if(eachCse.SuppliedPhone!=null)                            
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', eachCse.SuppliedPhone);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', '');
                
                
                if(eachCse.Order_Number__c!=null)                            
                    emailBody = emailBody.replace('{!Case.Order_Number__c}', eachCse.Order_Number__c);
                else
                    emailBody = emailBody.replace('{!Case.Order_Number__c}','');
                
                if(eachCse.Subject!=null)                            
                    emailBody = emailBody.replace('{!Case.Subject}', eachCse.Subject);
                else
                    emailBody = emailBody.replace('{!Case.Subject}','');
                
                
                if(eachCse.Description!=null)                            
                    emailBody = emailBody.replace('{!Case.Description}', eachCse.Description);
                else
                    emailBody = emailBody.replace('{!Case.Description}','');
                
                
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;
                autoCaseComment.From_Address__c =Label.Email_Automation;
                if(conwithCaseId.containsKey(eachCse.Id))
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);     
                
            }
            
            //This is for Account changes Auto Response  created        web Email         
            if(Trigger.isAfter && Trigger.isInsert  && eachCse.Status == 'New' && eachCse.Reason == 'Account Changes' && eachCse.Ticketid__c == null){
                
                
                
                
                etemp = myEmailMap.get('Support_Account_Changes_Auto_Response1');  
                String emailBody = etemp.HtmlValue; 
                
                if(conwithCaseId.containsKey(eachCse.Id))                     
                    emailBody = emailBody.replace('{!Contact.FirstName}', conwithCaseId.get(eachCse.Id).Name);
                else
                    emailBody = emailBody.replace('{!Contact.FirstName}','');
                
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber);   
                if(eachCse.Case_Owner_Name__c !=null) 
                    emailBody = emailBody.replace('{!Case.OwnerFullName}', eachCse.Case_Owner_Name__c);  
                else
                    emailBody = emailBody.replace('{!Case.OwnerFullName}','');  
                
                
                emailBody = emailBody.replace('{!Case.Status}', eachCse.Status); 
                
                if(eachCse.SuppliedEmail!=null)                        
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', eachCse.SuppliedEmail); 
                else
                    emailBody = emailBody.replace('{!Case.SuppliedEmail}', ''); 
                
                if(eachCse.SuppliedCompany!=null)
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', eachCse.SuppliedCompany);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedCompany}', '');
                
                
                if(eachCse.SuppliedPhone!=null)                            
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', eachCse.SuppliedPhone);
                else
                    emailBody = emailBody.replace('{!Case.SuppliedPhone}', '');
                
                
                if(eachCse.Order_Number__c!=null)                            
                    emailBody = emailBody.replace('{!Case.Order_Number__c}', eachCse.Order_Number__c);
                else
                    emailBody = emailBody.replace('{!Case.Order_Number__c}','');
                
                if(eachCse.Subject!=null)                            
                    emailBody = emailBody.replace('{!Case.Subject}', eachCse.Subject);
                else
                    emailBody = emailBody.replace('{!Case.Subject}','');
                
                /*  if(eachCse.Web_Company_Name__c!=null)
emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', eachCse.Web_Company_Name__c);
else
emailBody = emailBody.replace('{!Case.Web_Company_Name__c}', '');
*/
                
                if(eachCse.Description!=null)                            
                    emailBody = emailBody.replace('{!Case.Description}', eachCse.Description);
                else
                    emailBody = emailBody.replace('{!Case.Description}','');
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;
                autoCaseComment.From_Address__c =Label.Email_Automation;
                if(conwithCaseId.containsKey(eachCse.Id))
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);     
                
                
                
            }
            
            // This is Clsoed case 5 days Awaiting customer reply   created and updated 
            if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate ) && eachCse.Status == 'Closed' && eachCse.ResolutionDateline__c  != null && eachCse.Do_Not_Send_Close_Case_Email__c == false && eachCse.Ticketid__c == null ){
                
                //Support_Closed_After_120_hrs_in_Awaiting_Customer_Reply
                
                etemp = myEmailMap.get('Support_Closed_After_120_hrs_in_Awaiting_Customer_ReplySectigo');  
                String emailBody = etemp.HtmlValue; 
                
                if(conwithCaseId.containsKey(eachCse.Id)) 
                    emailBody = emailBody.replace('{!Case.Contact}', conwithCaseId.get(eachCse.Id).Name);  
                else
                    emailBody = emailBody.replace('{!Case.Contact}','');  
                
                emailBody = emailBody.replace('{!Case.CaseNumber}', eachCse.CaseNumber); 
                
                
                if(eachCse.Description!=null)                            
                    emailBody = emailBody.replace('{!Case.Description}', eachCse.Description);
                else
                    emailBody = emailBody.replace('{!Case.Description}','');
                
                
                
                Case_Comment__c autoCaseComment = new Case_Comment__c();
                autoCaseComment.ParentId__c=eachCse.id;
                autoCaseComment.Contact__c=eachCse.ContactId;
                autoCaseComment.Comment_Body__c= letterHeadBody + emailBody.stripHtmlTags() ;
                autoCaseComment.From_Address__c =Label.Email_Automation;
                if(conwithCaseId.containsKey(eachCse.Id))
                    autoCaseComment.To_Address__c = conwithCaseId.get(eachCse.Id).Email;
                lstCaseComment.add(autoCaseComment);
                
                
                
            }
        }
        
        try{
            if(!lstCaseComment.isEmpty())
                insert lstCaseComment;
            
        }catch(Exception e){
            
        }
        
        
    } 
    
    /*Method to get all cases for which we need to close milestone*/
    Public static map<Id,case> casemilestonetobeclosed(Map<Id,Case> casemap,Map<Id,case> oldmap){
        Map<Id,case> casemaptoreturn = new Map<Id,case>();
        List<case> caselist = [select id,status,priority,reason,Account.Enterprise_Premier__c from case where id in:casemap.keyset()];
        for(case cc:caseList){
            if((cc.status != oldmap.get(cc.id).status) && cc.Account.Enterprise_Premier__c != true){ 
                casemaptoreturn.put(cc.Id,cc);
            }
            if(((cc.account.Enterprise_Premier__c == true) && (cc.priority != oldmap.get(cc.id).priority)) || ((cc.account.Enterprise_Premier__c == true) && (cc.status != oldmap.get(cc.id).status) && (oldmap.get(cc.id).status == 'New'))){
                casemaptoreturn.put(cc.Id,cc);
            }
        }
        return casemaptoreturn;
    }
    
    /*Method to close existing milestone before creating new via entitlement process*/
    public static void CompleteMilestone(Map<Id,Case> caseMap){ 
        system.debug('---->'+caseMap); 
        List<casemilestone> MilestonetobeUpdate = new List<casemilestone>(); 
        List<Casemilestone> ml = [select id,CompletionDate from casemilestone where CompletionDate=null and caseid in: caseMap.keyset()];
        for(casemilestone miles : ml){
            miles.completionDate = system.now();
            MilestonetobeUpdate.add(miles);
        }
        if(MilestonetobeUpdate.size()>0){
            update MilestonetobeUpdate;
        }
    }
    /* 20th Sep 2018:-  Set the RAG Field on case */
    public static void setRAGField(List<Case> caseList){
        
        /* Custom Meta Data Code comment 
List<RAG_Configurations__mdt> myDomains=[select id, DeveloperName,Domain_Names__c  from RAG_Configurations__mdt];

// Domain name , color name
Map<String,String> myDmStr = new Map<String,String>();
for(RAG_Configurations__mdt eachRAGCon : myDomains){
List<String> eachStr = eachRAGCon.Domain_Names__c.split(',');
for(String eachSubStr : eachStr){
if(! myDmStr.containsKey(eachSubStr))
myDmStr.put(eachSubStr,eachRAGCon.DeveloperName);
}
}
*/
        // Domain name , color name
        Map<String,String> myDmStr = new Map<String,String>();
        //Get red custom setting values
        Map<String ,RAG_Red_Config__c> mcs = RAG_Red_Config__c.getAll();
        for(RAG_Red_Config__c eachRedRAG : mcs.Values()){
            myDmStr.put(eachRedRAG.Name,'Red');
        }
        
        //Get Green custom setting values
        Map<String , RAG_Green_Config__c > mcs1 = RAG_Green_Config__c.getAll();
        for(RAG_Green_Config__c eachGreenRAG : mcs1.Values()){
            myDmStr.put(eachGreenRAG.Name,'Green');
        }
        
        //Get Amber custom setting values
        Map<String , RAG_Amber_Config__c > mcs2 = RAG_Amber_Config__c.getAll();
        for(RAG_Amber_Config__c eachAmberRAG : mcs2.Values()){
            myDmStr.put(eachAmberRAG.Name,'Amber');
        }
        
        //Get Spanish custom setting values
        Map<String , RAG_Spanish_Config__c > mcs3 = RAG_Spanish_Config__c.getAll();
        for(RAG_Spanish_Config__c eachSpanishRAG : mcs3.Values()){
            myDmStr.put(eachSpanishRAG.Name,'Spanish');
        }
        
        //Get Chinese custom setting values
        Map<String , RAG_Chinese_Config__c > mcs4 = RAG_Chinese_Config__c.getAll();
        for(RAG_Chinese_Config__c eachChineseRAG : mcs4.values()){
            myDmStr.put(eachChineseRAG.Name, 'Chinese');
        }
        
        Set<Id> mycontIds=new Set<Id>();
        for(Case eachCseLst : caseList){
            mycontIds.add(eachCseLst.ContactId);
        }
        
        Map<Id,Contact> myConMap;
        if(! mycontIds.isEmpty())
            myConMap = new Map<Id,Contact>([select id,email from contact where id IN:(mycontIds) AND email!=null]);
        
        
        system.debug('$$myConMap$$'+myConMap);
        
        //Capture the Supplied email and contact email to check
        for(Case eachCseLs : caseList){
            
            //First checking for contact email.
            if(myConMap.containsKey(eachCseLs.ContactId)){
                String MyConEmaname = myConMap.get(eachCseLs.ContactId).Email;
                if(MyConEmaname != null){         //SuppliedEmail
                    
                    String myPickValue = MyConEmaname.split('@').get(1);
                    if(myDmStr.ContainsKey(myPickValue))   
                        eachCseLs.RAG_Picklist__c= myDmStr.get(myPickValue);
                    
                }
            }else{ //If contact email is not found , then looking for Supplied Email from case
                
                if(eachCseLs.SuppliedEmail !=null){
                    String myCasEmaname= eachCseLs.SuppliedEmail;
                    String myPickValue = myCasEmaname.split('@').get(1);
                    
                    System.debug('$$$$myPickValue$$$'+myPickValue);
                    System.debug('###myDmStr###'+myDmStr);
                    if(myDmStr.ContainsKey(myPickValue))   
                        eachCseLs.RAG_Picklist__c= myDmStr.get(myPickValue);
                    
                }
            }
        }
    } 
    
    
    
    
    /**
* Method to check all the cases that are created from emailtocases have spam keyword or not. If it is there don't insert the case.
* @param triggerNew  
* @return none
**/
    public static void checkSpamEmails(List<Case> caseList){
        
        //Map<String ,EmailtoCase_Spam_Words__c> allKeyWords = EmailtoCase_Spam_Words__c.getAll();
        List<EmailtoCase_Spam_Words__c> allKeyWords = EmailtoCase_Spam_Words__c.getall().values();
        system.debug('allKeyWords>>>>>'+allKeyWords);
        List<EmailtoCase_Spam_EmailWords__c> allSpamEmails = EmailtoCase_Spam_EmailWords__c.getall().values();
        
        
        for(Case eachCseLs : caseList){
            if(eachCseLs.Origin=='Email'){
                
                string mysub;
                string myemail;
                if(eachCseLs.Subject!=null)
                    mysub= eachCseLs.Subject;
                if(eachCseLs.SuppliedEmail!=null)
                    myemail = eachCseLs.SuppliedEmail;
                
                
                if(mysub!=null) {
                    for(EmailtoCase_Spam_Words__c eachemailcaseSpam : allKeyWords){
                        
                        String myTemp= eachemailcaseSpam.Keyword__c;
                        if(mysub.containsIgnorecase(myTemp)){
                            eachCseLs.addError('Spam Cases');
                            system.debug('Spam Cases >>>>>>');
                            break;
                        }
                        
                    }
                }
                
                if(myemail!=null){
                    for(EmailtoCase_Spam_EmailWords__c eachemailSpam : allSpamEmails){
                        String myTemp1 = eachemailSpam.Email_Address__c;
                        if(myemail.containsIgnorecase(myTemp1)){
                            eachCseLs.addError('Spam Cases');
                            system.debug('Spam Cases >>>>>>');
                            break;
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //@
    
    
    public static void CaseEmailAlert(List<Case> caseList){
        String emailTemplateName =  label.SurveyEmailTemplate;
        String orgWideDisplayName = label.SurveyOrgWideAddress;
        List<EmailTemplate> templateList = [SELECT Id, Body,DeveloperName, Subject from EmailTemplate where DeveloperName =:emailTemplateName Limit 1];
        String emailTemplateId  = '';
        if(templateList.size() > 0 ){
            emailTemplateId = templateList[0].Id;
        }
        system.debug('@@@et'+emailTemplateId);
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName=:orgWideDisplayName ];
        String owdId = '',FromAddress = '';
        if(owea.size() > 0){
            owdId = owea[0].Id;
            FromAddress = owea[0].Address;
        }
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        List<Case_Comment__c> caseCommentList = new List<Case_Comment__c>();
        List<Contact> conList = new List<Contact>();
        Set<Id> conDupSet = new Set<Id>();
        if(string.isNotBlank(emailTemplateId)){
            for(Case cas : caseList){
                if(String.isNotBlank(cas.contact.email)){
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplateId  ,cas.ContactId,cas.Id);
                    String  subject = email.getSubject();
                    String body = email.gethtmlBody();
                    email.setSaveAsActivity(false);
                    email.setSubject(subject);
                    email.setTreatTargetObjectAsRecipient(false);
                    email.sethtmlBody(body);
                    String[] emailids = new String[]{cas.contact.email};
                    email.setToAddresses(emailids);
                    if(String.isNotBlank(owdId)){
                        email.setOrgWideEmailAddressId(owdId);
                    }
                    
                    Case_Comment__c cc = new Case_Comment__c();
                    cc.ParentId__c = cas.Id;
                    cc.Comment_Body__c = body;
                    cc.Email_Subject__c = subject;
                    if(String.isNotBlank(FromAddress)){
                        cc.From_Address__c = FromAddress ;
                    }
                    cc.To_Address__c = cas.contact.email;
                    caseCommentList.add(cc);
                    emailMessageList.add(email);
                    
                    if(!conDupSet.contains(cas.ContactId)){
                        Contact con = new Contact();
                        con.Id = cas.ContactId;
                        con.Survey_Date__c = system.today();
                        conList.add(con);
                        conDupSet.add(cas.ContactId);
                    }
                }
            }
        }
        if(emailMessageList.size() > 0){
            Messaging.sendEmail(emailMessageList);
        }
        if(caseCommentList.size() > 0){
            insert caseCommentList;
        }
        if(conList.size() > 0){
            update conList;
        }
    }
    
    
              /**
         * Method to check all the cases Status when Case Status will be Clinet Info Completed then then Task Due Date will be reduce 7 days from previous Due Date.
         * @param triggerNew  
         * Created By: Agile Cloud 13/08/2019
         * Last Modified By: Hari Mittapalli
         * @return none
        **/
        
    
    /*public static void taskduedateupdate(list<case> caselist){
       // List<Task> tasksToUpdate = new List<Task>();
      
        Set<id> caseid = new Set<id>();
        //list<case> caselist = [select id from case];
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GDPR Case').getRecordTypeId();
        System.debug('qwerty'+RecordTypeIdCase);
        for(Case ids: caselist){
            if(ids.RecordTypeId == RecordTypeIdCase && ids.Status == 'Client Info Completed'){
                caseid.add(ids.id);
            }
        }
        if(caseid.size()>0){
      List<Task> tasklst = new List<Task>([SELECT WhoId,who.name, WhatId, Id, Subject, Status, OwnerId,GDPR_Contact_Email__c, RecordTypeId, ActivityDate FROM Task where Whatid=:caseid and Status != 'Completed']);  
        for(task updatetask:tasklst){
            
            system.debug('updatetask.ActivityDatebefore'+updatetask.ActivityDate);
            updatetask.ActivityDate = date.today()+ Integer.valueOf(System.Label.Task_Due_Date);
            system.debug('updatetask.ActivityDateafter'+updatetask.ActivityDate);
            
        }
           update tasklst; 
        }
        
    } */
    
    /* Crateing Case Comments when Case comments old and new value not equal */
    
    public static void casecomments(list<case> caselist,Map<Id,case> oldcasemap){
        
        List<CaseComment> casecommentToInsert= new List<CaseComment>();
        for(case c : caselist){
            if(c.Closing_Note1__c!=null && oldcasemap.get(c.Id).Closing_Note1__c != c.Closing_Note1__c){
                system.debug('test');
                CaseComment cc= new caseComment();
                cc.ParentId=c.id;
                cc.CommentBody=c.Closing_Note1__c;          
                casecommentToInsert.add(cc);
            }
        }
        insert casecommentToInsert;
    }
    
    /*public static void emailtocasecontact(list<case> caselist){
        
    List<String> emailAddresses = new List<String>();
    //First exclude any cases where the contact is set
            for (Case caseObj:caselist){
            if (caseObj.ContactId==null && caseObj.SuppliedEmail!=''){
                
                emailAddresses.add(caseObj.SuppliedEmail);
            }
        }
        
        List<Contact> listContacts = [Select Id,Email From Contact Where Email in :emailAddresses];
        Map<String,Id> emailToContactMap = new Map<String,Id>();
        if(listContacts !=null){
        for (Contact Conlist: listContacts) {            
            emailToContactMap.put(Conlist.email,Conlist.id);
        }
        }
         if(emailToContactMap !=null){
        for (Case caseObj:caselist){
            if (emailToContactMap.containskey(caseObj.SuppliedEmail)){
                caseObj.ContactId = emailToContactMap.get(caseObj.SuppliedEmail);
            }
        }
         }
    } */
    
    
    public static void desktopsupportfieldupda(list<case> caselist){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Desktop Support').getRecordTypeId();
        List<Case> Casedatalist = New List<Case>();
        for(Case caselistdata: caselist){
            if(caselistdata.RecordTypeId == RecordTypeIdCase){
                caselistdata.Reason='Desktop Support';
                caselistdata.Platform_Type__c ='Desktop Support';
                caselistdata.Do_Not_Survey__c = True;
            }
        }

    }
    
  
    
}