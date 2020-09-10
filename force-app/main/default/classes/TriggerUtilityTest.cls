@isTest(SeeAllData=true)
public class TriggerUtilityTest {
    
    
    //code changed by me
    Private static testMethod void positivescenario(){
        List<Case> caselist=[select id,Internal_Comments__c,Contact.email,SuppliedEmail,Subject,ContactId,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case limit 10];
        Map<Id,Case> caseMap= new Map<Id,Case>();
        caseMap.putAll(caselist);
        TriggerUtility.addCaseComments(caselist);
        
        List<Account> acclist=[select id,Name,Segment__c,Enterprise_Premier__c,RecordTypeId from Account limit 100];
        Map<id,Account> accmap= new Map<id,Account>();
        accmap.putAll(acclist);
        TriggerUtility.setServiceContract(acclist,accmap);
        TriggerUtility.setCaseReason(caselist);
        TriggerUtility.SetEntitlementprocess(caselist);
        TriggerUtility.casemilestonetobeclosed(casemap,casemap);
        TriggerUtility.setRAGField(caselist);
        try{TriggerUtility.checkSpamEmails(caselist);
            TriggerUtility.CompleteMilestone(casemap);
           }catch(dmlexception e){}
        if(caseList!=null && caselist[0].Ticketid__c==null){
            //TriggerUtility.sendAutoWorkflowEmail(caselist,caseMap,caseMap);
        }
        List<Case> caselist2=[select id,Internal_Comments__c,Contact.email,SuppliedEmail,Subject,ContactId,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case limit 1];
   		triggerUtility.CaseEmailAlert(caselist2);
    }
    
    
    //code changed by me
    Private static testMethod void positivescenario2(){
        List<Case> caselist=[select id,Internal_Comments__c,SuppliedEmail,Subject,contactId,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case limit 10];
        Map<Id,Case> caseMap= new Map<Id,Case>();
        caseMap.putAll(caselist);
        TriggerUtility.addCaseComments(caselist);
        
        List<Account> acclist=[select id,Name,Segment__c,Enterprise_Premier__c,RecordTypeId from Account where Enterprise_Premier__c=true AND (Segment__c='Partner/Reseller' OR Segment__c='Enterprise-Large' OR Segment__c='Retail')  ];
        Map<id,Account> accmap= new Map<id,Account>();
        accmap.putAll(acclist);
        TriggerUtility.setServiceContract(acclist,accmap);
        TriggerUtility.setCaseReason(caselist);
        TriggerUtility.SetEntitlementprocess(caselist);
        TriggerUtility.casemilestonetobeclosed(casemap,casemap);
        TriggerUtility.setRAGField(caselist);
        TriggerUtility.checkSpamEmails(caselist);
        TriggerUtility.CompleteMilestone(casemap);
        
        if(caseList!=null && caselist[0].Ticketid__c==null){
            //TriggerUtility.sendAutoWorkflowEmail(caselist,caseMap,caseMap);
        }
    }
    Private static testMethod void positivescenario3(){
        List<Case> caselist=[select id,Internal_Comments__c,Priority,Subject,SuppliedEmail,ContactId,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case limit 100];
        Map<Id,Case> caseMap= new Map<Id,Case>();
        Map<Id,Case> caseMapnew= new Map<Id,Case>();
        caseMap.putAll(caselist);
        TriggerUtility.addCaseComments(caselist);
        
        List<Account> acclist=[select id,Name,Segment__c,Enterprise_Premier__c,RecordTypeId from Account where Enterprise_Premier__c=true AND (Segment__c='Partner/Reseller' OR Segment__c='Enterprise-Large' OR Segment__c='Retail')  ];
        List<ServiceContract> existingSCList = [Select Id, Name, AccountId, StartDate, EndDate From ServiceContract where AccountId=null];
        Map<id,Account> accmap= new Map<id,Account>();
        accmap.putAll(acclist);
        TriggerUtility.setServiceContract(acclist,accmap);
        TriggerUtility.setCaseReason(caselist);
        TriggerUtility.SetEntitlementprocess(caselist);
        TriggerUtility.casemilestonetobeclosed(casemap,casemap);
        TriggerUtility.setRAGField(caselist);
        TriggerUtility.checkSpamEmails(caselist);
        try{
            TriggerUtility.CompleteMilestone(casemap);
        }
        catch(exception e){}
        ServiceContract sc1 = new ServiceContract();  
        sc1.Name = 'Enterprise Premier Support'; 
        //sc1.accountId = myLst[1].Id;     
        insert sc1;
        
        
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        caseMapnew.putAll(caselist2);
        /* Case c= new case();
c.Status='New';
c.Origin='web';
c.reason='Billing';
c.Ticketid__c=null;
clist.add(c);*/
        
        Account acc= new Account();
        acc.name='testggggg';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqq';
        con.FirstName='test2qqqqqqqq';
        con.email='testqqqqqq@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='New';
        c2.Origin='Web';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].Subject = 'testing';
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
        
        
        
        
    }
    private static testmethod void Positivescenario4(){
        
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        
        
        Account acc= new Account();
        acc.name='testgggggqq';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqwe';
        con.FirstName='test2qqqqqqqqqwr';
        con.email='testqqqqqq1234@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='On Hold';
        c2.On_Hold_Reason__c='AVS';
        c2.Origin='Web';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].Subject = 'testing';
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
        
        
    }
    private static testmethod void positivescenario5(){
        
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        
        
        Account acc= new Account();
        acc.name='testgggggqq';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqweas';
        con.FirstName='test2qqqqqqqqqwrawer';
        con.email='testqqqqqq123124@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='New';
        //c2.On_Hold_Reason__c='AVS';
        c2.Origin='Web';
        c2.reason='Account Changes';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].Subject = 'testing';
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
        
        
    }
    private static testmethod void positivescenario6(){
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        
        Account acc= new Account();
        acc.name='testgggggqq';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqweas';
        con.FirstName='test2qqqqqqqqqwrawer';
        con.email='testqqqqqq123124@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='New';
        //c2.On_Hold_Reason__c='AVS';
        c2.Origin='Phone';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        c2.Send_case_confirmation_email__c=false;
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].Send_case_confirmation_email__c = true;
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
        
    }
    private static testmethod void Closedcasescenario(){
        
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        
        
        Account acc= new Account();
        acc.name='testgggggqq';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqweqwas';
        con.FirstName='test2qqqqqqqqqyywrawer';
        con.email='testqqqqqq12312484@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='Closed';
        //c2.On_Hold_Reason__c='AVS';
        c2.Origin='Phone';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        c2.Do_Not_Send_Close_Case_Email__c=false;
        c2.ResolutionDateline__c=null;
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].subject = 'test subject';
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
        
        
    }
    
    private static testmethod void Closedcasescenario2(){
        
        List<case> caselist2=[select id,Internal_Comments__c,Origin,OwnerId,Ticketid__c,SuppliedPhone,Order_Number__c,Web_Company_Name__c,ContactId,SuppliedCompany,Status,CaseNumber,Owner.Name,AccountId from case where Ticketid__c=null and Status = 'New'  and Origin='Web' and Reason != 'Account Changes'  limit 100];
        List<case> clist = new List<case>();
        
        
        Account acc= new Account();
        acc.name='testgggggqq';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqweqwas';
        con.FirstName='test2qqqqqqqqqyywrawer';
        con.email='testqqqqqq12312484@gmail.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='Closed';
        //c2.On_Hold_Reason__c='AVS';
        c2.Origin='Phone';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        c2.Ticketid__c=null;
        c2.Do_Not_Send_Close_Case_Email__c=false;
        c2.ResolutionDateline__c=Date.Today();
        clist.add(c2);
        insert clist; 
        
        Map<Id,Case> caseOldMap = New Map<Id,Case>();                   
        caseOldMap.putAll(clist); 
        
        clist[0].subject = 'test subject';
        update clist;
        
        system.debug('####'+clist);
        Map<id,Case> casenewMap2 = new Map<Id,Case>();
        casenewMap2.putAll(clist);
        
    }
    private static testmethod void caseEmailalertTest(){
        Account acc= new Account();
        acc.name='testgggggqqw';
        insert acc;
        
        Contact con= new contact();
        con.lastname='testqqqqqweqwasw';
        con.FirstName='test2qqqqqqqqqyywrawerw';
        con.email='nick.anderson@sectigo.com';
        con.accountid=acc.id;
        insert con;
        
        Case c2= new case();
        c2.Status='Closed';
        //c2.On_Hold_Reason__c='AVS';
        c2.Origin='Phone';
        c2.reason='Billing';
        c2.Subject='TESTFFFFFF';
        c2.ContactId=con.id;
        c2.AccountId=acc.id;
        
        
        insert c2;
        c2.Status='closed';
        c2.Reason ='Certificate Manager';
        //c2.Issue_Sub_Type__c = 'Integrations';
        try{update c2;}
        catch(dmlException e){system.debug('error ' + e);}
        
        try{delete c2;}
        catch(dmlException e){system.debug('error ' + e);}
        
    }
    
}