@istest
public class Com_OpportunityTeamMemberTriggerTest{
    
    private static testmethod void positiveScenario(){
        
        User testuser= [Select Id,Name from User where Profile.Name='System Administrator' AND isActive = true LIMIT 1];
        User testuser2= [Select Id,Name from User where Profile.Name='System Administrator' AND id != : testuser.id AND isActive = true  LIMIT 1];
        
        Account acc= new Account();
        acc.Name='test';
        insert acc;
        
        Opportunity opp= new Opportunity();
        opp.Name='test opp';
        opp.AccountId=acc.id;
        opp.CloseDate=Date.Today();
        opp.StageName='In Progress';
        opp.Sales_Engineer_Added__c =false;
        Insert Opp;
        
        Id oppOwnerid=[select OwnerId from Opportunity where id=:opp.id].OwnerId ;
        
        OpportunityTeamMember otm1 = new OpportunityTeamMember();
        otm1.TeamMemberRole = 'Sales Engineer';
        otm1.OpportunityId =opp.Id;
        otm1.UserId=testuser.id;
        insert otm1;
        
        opp = [select Sales_Engineer_Added__c from Opportunity where id=:opp.id];
        System.assertEquals(opp.Sales_Engineer_Added__c, true);
        
        otm1.TeamMemberRole = 'Sales Rep';
        update otm1;
        opp = [select Sales_Engineer_Added__c from Opportunity where id=:opp.id];
        System.assertEquals(opp.Sales_Engineer_Added__c, false);
        
        OpportunityTeamMember otm2 = new OpportunityTeamMember();
        otm2.TeamMemberRole = 'Sales Engineer';
        otm2.OpportunityId =opp.Id;
        otm2.UserId=testuser2.id;
        insert otm2;
        opp = [select Sales_Engineer_Added__c from Opportunity where id=:opp.id];
        System.assertEquals(opp.Sales_Engineer_Added__c, true);
        
        List<OpportunityTeamMember> OTM=[select id,UserId,OpportunityId,TeamMemberRole from OpportunityTeamMember where OpportunityId =:opp.id];
        
        Com_OpportunityTeamMemberTriggerHelper help= new Com_OpportunityTeamMemberTriggerHelper();
        Com_OpportunityTeamMemberTriggerHelper.updateSalesEngineerAddedCheckbox(OTM);
        
        delete otm2;
        opp = [select Sales_Engineer_Added__c from Opportunity where id=:opp.id];
        System.assertEquals(opp.Sales_Engineer_Added__c, false);
    }
}