@isTest
public class CampaignMemberTest {
    @isTest
    public static void test1(){
        campaign mycamp= new campaign();
        mycamp.name='Private CA Campaign1';
        mycamp.IsActive=true;
        mycamp.Status='Planned';
        mycamp.Type='Event';
        mycamp.Source_Category__c ='Inbound';
        insert mycamp;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        campaign mycamp2 = new campaign();
        mycamp2.name='Enterprise Web Form Submission';
        mycamp2.IsActive=true;
        mycamp2.Status='Planned';
        mycamp2.Type='Event';
        mycamp2.Source_Category__c ='Inbound';
        insert mycamp2;
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.email='veera@dazeworks.com';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        // insert lstLead;  
        Database.insert(lstLead, dml);
        
        
        Lead lstLead1 =   new Lead();
        lstLead1.Company = 'JohnMiller1';
        lstLead1.email='veera1234@gmail.com';
        lstLead1.LastName = 'Mike1';
        lstLead1.Status = 'Open';               
        //insert lstLead1; 
        Database.insert(lstLead1, dml);
        Account acc = new Account(
            Name = 'TestAccount',
            Segment__c = 'Partner/Reseller'    
        );
        insert acc; 
        Account acc1 = new Account(
            Name = 'TestAccount1',
            Segment__c = 'Retail',
            Enterprise_Premier__c = true    
        );
        insert acc1; 
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        contact ct = new contact(
            LastName = 'test contact',
            Email = 'vinay@dazeworks.com',
            Phone = '1234567890',
            accountId = acc.Id,
            recordTypeId = contactRecordTypeId
        );
        insert ct;
        contact ct1 = new contact(
            LastName = 'test contact1',
            Email = 'vinay@dazework.com',
            Phone = '123456789',
            accountId = acc1.Id
        );
        insert ct1;
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        
        Task ts1 = new Task();
        ts1.Subject = 'testcon';
        ts1.WhoId = ct.Id;
        ts1.RecordTypeId = taskRecordTypeId;
        ts1.Type = 'Webform';
        insert ts1;
        
        Task ts2 = new Task();
        ts2.Subject = 'testcon';
        ts2.WhoId = lstLead1.Id;
        ts2.RecordTypeId = taskRecordTypeId;
        ts2.Type = 'Webform';
        insert ts2;
        
        test.startTest();
        List<CampaignMember> cmpLst = new List<CampaignMember>();
        CampaignMember cmp = new CampaignMember();
        cmp.ContactId = ct.Id;
        cmp.Type__c = 'WebForm';
        cmp.Account_Owner_Email__c = 'test@gmail.com';
        cmp.CampaignId = mycamp.Id;
        cmpLst.add(cmp);
        
        CampaignMember cmp1 = new CampaignMember();
        cmp1.LeadId = lstLead1.Id;
        cmp1.Type__c = 'WebForm';
        cmp1.CampaignId = mycamp.Id;
        cmp1.Account_Owner_Email__c = 'test@gmail.com';
        cmpLst.add(cmp1);
        
        CampaignMember cmp12 = new CampaignMember();
        cmp12.LeadId = lstLead1.Id;
        cmp12.Type__c = 'WebForm';
        cmp12.CampaignId = mycamp2.Id;
        cmp12.Account_Owner_Email__c = 'test@gmail.com';
        cmpLst.add(cmp12);
        
        insert cmpLst;
        test.stopTest();
    }
    @isTest
    public static void test(){
        
    }
}