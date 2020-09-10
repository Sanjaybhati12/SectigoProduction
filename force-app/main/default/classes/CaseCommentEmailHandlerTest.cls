/**
* Test class for the CaseCommentEmailHandler trigger.
*
* @see         CaseCommentEmailHandler .cls
*
* @version     2018-18-06    Omita first version
*              
*/
@isTest 
public class CaseCommentEmailHandlerTest{
    
    static testMethod void testCaseCommentEmailHandler(){
    test.startTest();
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
       // insert account;
        
       // Contact cont1 = new Contact(LastName='ContTest1', Email='test1contact@duptest.com', AccountId = account.Id, LeadSource='Inbound Call');
       // insert cont1;
        
        Case cse=new Case(Subject= 'In Service Billable - A29',ContactId=ct.id); 
        insert cse;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = cse.Subject+' - ['+Service.getThreadId(cse.Id)+']';
        email.HtmlBody = 'FromEmail';
        email.messageId = 'FIMXx000000000000000000000000000000000000000000000PAIJHR00ofwbxXtRQBmjCdQHRqaZLg@sfdc.net';
        
        email.ToAddresses=new String[]{'abc@123.com'};
        email.ccAddresses=new String[]{'abce@123.com'};
        env.fromAddress = 'test1contact@duptest.com';
        env.ToAddress='test@gmail.com';
        
        
        Messaging.InboundEmail.TextAttachment attachmentText = new Messaging.InboundEmail.TextAttachment();
        attachmentText.body = 'my attachment text';
        attachmentText.fileName = 'textfiletwo.txt';
        attachmentText.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] {attachmentText};
            
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        EmailMessage em= new EmailMessage();
        
        CaseCommentEmailHandler creatC = new CaseCommentEmailHandler();
        creatC.handleInboundEmail(email, env);
        test.stopTest();
    }
    
}