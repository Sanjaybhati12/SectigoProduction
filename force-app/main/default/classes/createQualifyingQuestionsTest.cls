@isTest
private class createQualifyingQuestionsTest {
    
    @TestSetup static void setupData() {
        
        Account_Territory_based_on_US_States__c accUsStates = new Account_Territory_based_on_US_States__c();
        accUsStates.Name = 'us';
        accUsStates.Territory__c = 'Michigan/Ohio';
        insert accUsStates;
        Account_Territory_based_on_Countries__c  accCountry = new Account_Territory_based_on_Countries__c();
        accCountry.Name = 'UK';
        accCountry.Territory__c= 'Western Europe';
        insert accCountry;
    } 
    
    static testMethod void testleadconvert() {
        
        Lead testLead = new Lead();
        testLead.FirstName = 'Test First';
        testLead.LastName = 'Test Last';
        testLead.Company = 'Test Co';
        testLead.email='testlead4@gmail.com';
        testLead.Account_Creation_Approval__c='Approved';
        testLead.Segment__c='Retail';
        testLead.Product_Interest__c='SMIME';
        testLead.RR_Number__c=1;
        testLead.HubSpot_Employee_Count__c = '1-250';
        testLead.Country = 'Barbados';
        try{insert testLead;}catch(dmlException e){system.debug('error ' + e);}
        
        Qualifying_Questions__c qc= new Qualifying_Questions__c();
        qc.Lead__c=testLead.id;
        try{insert qc;}catch(dmlException e){system.debug('error ' + e);}
        test.StartTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(testLead.id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());        
        test.StopTest();
        
        User user2 = new User();
        user2.ProfileID = [Select Id From Profile Where Name='Partner Management'].id;
        user2.EmailEncodingKey = 'ISO-8859-1';
        user2.LanguageLocaleKey = 'en_US';
        user2.TimeZoneSidKey = 'America/New_York';
        user2.LocaleSidKey = 'en_US';
        user2.FirstName = 'firsfght';
        user2.LastName = 'lasrtyt';
        user2.username = 'testerer@apdfghpertirio.com';   
        user2.CommunityNickname = 'tewersdfghtstuser2123';
        user2.Alias = 't1';
        user2.Email = 'no@emertail.com';
        user2.IsActive = true;
        insert user2;
        
        system.runAs(user2){
            try{
                Lead led = new Lead(
                    LastName = 'test led',
                    company = 'testCompany',
                    Email = 'vinay@dazeworks.com',
                    Phone = '1234567890',
                    Country = 'Barbados'
                );
                insert led;  
                
            }catch(Exception ex){
                Boolean expectedExceptionThrown =  ex.getMessage().contains('You are not authorized to delete this record') ? true : false;
                //System.assertEquals(expectedExceptionThrown, true);
            }
            
        }
        
        
    }
    
    static testMethod void testleadTerritory() {
        
        Lead testLead = new Lead();
        testLead.FirstName = 'Test First';
        testLead.LastName = 'Test Last';
        testLead.Company = 'Test Co';
        testLead.email='testlead6@gmail.com';
        testLead.Account_Creation_Approval__c='Approved';
        testLead.Segment__c='Retail';
        testLead.Product_Interest__c='SMIME';
        testLead.RR_Number__c=1;
        testLead.HubSpot_Employee_Count__c = '1-250';
        testLead.Country = 'US';
        testLead.State = 'Ohio';
        
        Lead testLead1 = new Lead();
        testLead1.FirstName = 'Test First';
        testLead1.LastName = 'Test Last';
        testLead1.Company = 'Test Co';
        testLead1.email='testlead2@gmail.com';
        testLead1.Account_Creation_Approval__c='Approved';
        testLead1.Segment__c='Retail';
        testLead1.Product_Interest__c='SMIME';
        testLead1.RR_Number__c=1;
        testLead1.HubSpot_Employee_Count__c = '3000+';
        testLead1.Country = 'United States';
        testLead1.State = 'Ohio';
        
        Lead testLead2 = new Lead();
        testLead2.FirstName = 'Test First';
        testLead2.LastName = 'Test Last';
        testLead2.Company = 'Test Co';
        testLead2.email='testlead1@gmail.com';
        testLead2.Account_Creation_Approval__c='Approved';
        testLead2.Segment__c='Retail';
        testLead2.Product_Interest__c='SMIME';
        testLead2.RR_Number__c=1;
        testLead2.HubSpot_Employee_Count__c = '1-250';
        testLead2.Country = 'United Kingdom';
        
        Lead testLead3 = new Lead();
        testLead3.FirstName = 'Test First';
        testLead3.LastName = 'Test Last';
        testLead3.Company = 'Test Co';
        testLead3.email='testleadrty1@gmail.com';
        testLead3.Account_Creation_Approval__c='Approved';
        testLead3.Segment__c='Retail';
        testLead3.Product_Interest__c='SMIME';
        testLead3.RR_Number__c=1;
        testLead3.HubSpot_Employee_Count__c = '1-250';
        testLead3.Country = 'US';
        testLead3.State= 'Ohio';
        
        Lead testLead4 = new Lead();
        testLead4.FirstName = 'Test First';
        testLead4.LastName = 'Test Last';
        testLead4.Company = 'Test Co';
        testLead4.email='testleartyud1@gmail.com';
        testLead4.Account_Creation_Approval__c='Approved';
        testLead4.Segment__c='Retail';
        testLead4.Product_Interest__c='SMIME';
        testLead4.RR_Number__c=1;
        testLead4.HubSpot_Employee_Count__c = '1-250';
        testLead4.State= 'Ohio';
        
        test.StartTest();
        try
        {insert testLead;
         insert testLead1;
         insert testLead2;
         insert testLead3;
         insert testLead4;
        }catch(dmlException e){system.debug('error ' + e);}
        
        Test.StopTest();
    } 
    @isTest
    public static void channelTest(){
        Group testGroup = new Group(Name='Channel Partner', Type='Queue');
        insert testGroup;
        QueuesObject q1 = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Lead');
        insert q1;
        GroupMember gm = new GroupMember();
        gm.GroupId = testGroup.Id;
        gm.UserOrGroupId = userInfo.getUserId();
        insert gm;
        User usr = [Select Id From User Where Id=:userInfo.getUserId()];
        system.runAs(usr){
            Lead led2 = new Lead(
                LastName = 'test led',
                company = 'testCompany',
                Email = 'vinay@dazeworks.com',
                Segment__c = 'Partner/Reseller',
                Phone = '1234567890',
                Country = 'Barbados'
            );
            try
            {insert led2;
             led2 = [Select Id,OwnerId,Owner.Name From Lead Where Id=:led2.Id];
             system.debug('led2 '+led2.OwnerId);
             update led2;
            }catch(dmlException e){
                system.debug('exception ' + e);
            }
            
        }
    }
    @isTest
    public static void channelTest1(){
        Group testGroup = new Group(Name='Retail Queue', Type='Queue');
        insert testGroup;
        QueuesObject q1 = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Lead');
        insert q1;
        GroupMember gm = new GroupMember();
        gm.GroupId = testGroup.Id;
        gm.UserOrGroupId = userInfo.getUserId();
        insert gm;
        
        User usr = [Select Id From User Where Id=:userInfo.getUserId()];
        
        
        system.runAs(usr){
            Retail_Round_Robin__c r = new Retail_Round_Robin__c();
            r.Name=userInfo.getUserId();r.userId__c = userInfo.getUserId();r.Count__c = 1;
            try{insert r;}catch(exception e){system.debug('error ' + e);}
            
            Lead led2 = new Lead(
                LastName = 'test led2',
                company = 'testCompany 1',
                Email = 'vinay@dazeworks1.com',
                Segment__c = 'Retail',
                Phone = '1234567810'
                
            );
            try
            {
                Group ExpQueue = [Select Id ,Group.Name from Group where Type = 'Queue' AND Name =: 'Retail Queue' LIMIT 1];
                led2.OwnerId = ExpQueue.Id;
                insert led2;
                led2 = [Select Id,OwnerId,Owner.Name From Lead Where Id=:led2.Id];
                system.debug('led2 '+led2.OwnerId);
                update led2;
                
            }catch(dmlException e){
                system.debug('exception ' + e);
            }
            
        }
    }
}