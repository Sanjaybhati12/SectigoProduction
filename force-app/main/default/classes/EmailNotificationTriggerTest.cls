/**
* Test class for the EmailNotificationTrigger trigger.
*
* @see         EmailNotificationTrigger.cls
*
* @version     2018-14-06    AgileCloud     first version
*              
*/
@isTest 
public class EmailNotificationTriggerTest {
    
    static testMethod void testcasecomments() { 
    
       SLA_Setting__c slaSettings = new SLA_Setting__c();
        slaSettings.Followup_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Enterprise_Support__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Followup_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Support__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_CP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_HP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_LP__c = 30;
        slaSettings.Initial_SLA_Enterprise_Premier_MP__c = 30;
        slaSettings.Followup_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Initial_SLA_Time_for_Partner_Support__c = 30;
        slaSettings.Retail_Support_Followup_SLA__c = 30;
        slaSettings.Retail_Support_Intial_SLA__c = 30;
        slaSettings.Name='TIME';
        insert slaSettings;
        
        mileStoneCaseReason__c mileStonCaseRea = new mileStoneCaseReason__c();
        mileStonCaseRea.Name='Brand Validation';
        insert mileStonCaseRea ;
        
         mileStoneCaseReason__c mileStonCaseRea1 = new mileStoneCaseReason__c();
        mileStonCaseRea1.Name='CCM Validation';
        insert mileStonCaseRea1 ;
        
         mileStoneCaseReason__c mileStonCaseRea2 = new mileStoneCaseReason__c();
        mileStonCaseRea2.Name='EV Validation';
        insert mileStonCaseRea2 ;
    
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        
         ServiceContract sc = new ServiceContract();  
        sc.Name = 'Partner/Reseller Support'; 
        sc.accountId = acc.Id;     
        insert sc;
        
        Entitlement ent = new Entitlement (
            Name = 'Service SLA',
            Type = 'Phone Support',
            AccountId = acc.Id,
            ServiceContractId = sc.Id
        );
        insert ent;
        
          contact ct = new contact(
        LastName = 'test contact',
        Email = 'vinay@dazeworks.com',
        Phone = '1234567890',
        LeadSource='Inbound Call',
        accountId = acc.Id
        );
        insert ct;
        
        
        //Account account = new Account(Name='Test Account');
        //insert account;
        
       // Contact cont1 = new Contact(LastName='ContTest1', Email='test1contact@duptest.com', AccountId = account.Id, LeadSource='Inbound Call');
       // insert cont1;
        
        Case cse=new Case(Subject= 'In Service Billable - A29',ContactId=ct.id); 
        insert cse; 
        
        List<Case_Comment__c > lstcasecmts= new List<Case_Comment__c >();
        Case_Comment__c onecasecmt= new Case_Comment__c();
        onecasecmt.ParentId__c=cse.id;
        oneCaseCmt.Send_Email_to_Customer__c = true;
        onecasecmt.EmailMessageId__c=cse.id;      
        lstcasecmts.add(onecasecmt);    
        
        Case_Comment__c seccasecmt= new Case_Comment__c();
        seccasecmt.ParentId__c = cse.id;
        seccasecmt.Send_Email_to_Customer__c = true;
        lstcasecmts.add(seccasecmt);
        
        insert  lstcasecmts; 
    }
    
    
}