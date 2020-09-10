@isTest
public class LockOpportunityRecordTest {
  
    static testMethod void insertNewOpportunity(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User usr = new User(LastName = 'TEST123',
                           FirstName='opp',
                           Alias = 'opTest',
                           Email = 'Test@sfdc.com',
                           Username = 'test.liveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                          LocaleSidKey = 'en_US'
                           );
        insert usr;
        Account acc = new Account(Name = 'Test');
        insert acc;
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp = new Opportunity();
        opp.name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.CloseDate = date.today();
        opp.OwnerId = usr.id;
        insert opp;
        opp.StageName = 'Closed Won';
        //update opp;
        oppList =[SELECT Id  FROM Opportunity WHERE Id =:opp.Id limit 1];
       //Approval.LockResult[] lockResult = Approval.lock(oppList, false);
        LockOpportunityRecord.LockOpportunity(oppList.get(0).id);
        LockOpportunityRecord.checkUser(oppList.get(0).id);
        
    }
       
    }