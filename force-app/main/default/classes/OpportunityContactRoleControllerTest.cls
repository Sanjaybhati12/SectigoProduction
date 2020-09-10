@isTest
public class OpportunityContactRoleControllerTest {
	@TestSetup
    public static void setupMethod(){
         Date closeDt = Date.Today().adddays(10);
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;  
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test2';
        con.Accountid=a2.id;
        con.Email='test@abc.com';
        insert con;
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId(); 
       	opportunity opp=new opportunity();
        opp.Name='testing DIE 4/6/2015';
        opp.AccountId=a2.Id;
        opp.StageName='Presentation';
        opp.CloseDate=closeDt;
        opp.RecordTypeId=RecordTypeIdOpp;
        opp.Forecast_CategoryCom__c='Committed';
        opp.OMS_Account_Manager__c = 'test';
        opp.Order_Number__c = 'test';
        opp.Contract_Start_Date__c = system.today();
        opp.Contract_Term_Months__c = 12;
        opp.PO_Required__c = true;
        opp.PO_Amount__c = 100;
        opp.PO_Type__c = 'One-Year';
        opp.Email_Contact_for_PO__c = 'test@gmail.com';
        opp.PO_Number__c = 'demo';
        opp.DM_Identified__c = true;
        
		insert opp;
        OpportunityContactRole occ= new OpportunityContactRole ();
        occ.Contactid=con.id;
        occ.Opportunityid=opp.id;
        occ.Role = 'Decision Maker';
        occ.IsPrimary =true;
        insert occ;
    }
    @isTest
    public static void test1(){
        Opportunity opp = [Select Id,Name From Opportunity Limit 1];
        OpportunityContactRoleController.getOptyContactRole(opp.Id);
    }
}