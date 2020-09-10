@isTest
public class QuoteLineTrigger_Test {
    private static testMethod void testOverview(){
        Account AccountBusiness = new Account( Name = 'Business Account', 
                                               Subscriber_Entity_Type__c = 'Non-Commercial');
        Insert AccountBusiness;
        
        Account AccountLabs = new Account( Name = 'Labs Account', 
                                           Subscriber_Entity_Type__c = 'Non-Commercial',
                                          ParentId = AccountBusiness.ID);
        Insert AccountLabs; 
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 ProductStandAlone = new Product2(Name = 'Sample Product', 
                                                  Description = 'Price Book Products',
                                                  IsActive = true);
        Insert ProductStandAlone;
        
        Opportunity opportunity = new Opportunity(name = 'Sample Opportunity',
                                                  AccountId = AccountLabs.id,
                                                  stageName = 'New',
                                                  closeDate = Date.today() );
        insert opportunity;
        
        SBQQ__Quote__c qut = new SBQQ__Quote__c();
        qut.SBQQ__Opportunity2__c = opportunity.id;
        qut.SBQQ__Account__c = AccountLabs.id; 
        qut.Entity_type_Discount__c = 25;
        Insert qut;
        
        SBQQ__QuoteLine__c  sbq = new SBQQ__QuoteLine__c();
        sbq.SBQQ__Quote__c = qut.id;
        sbq.SBQQ__Product__c = ProductStandAlone.id;
        sbq.SBQQ__ListPrice__c = 100;
        Insert sbq;
        
        Test.startTest();
    	Update sbq;
    	Test.stopTest(); 
        
        
    }
}