/** Class Name  :  OpportunityLineItemTriggerHandlerTest 
*  Description  :  This is test class for OpportunityLineItemTriggerHandler
*  Created By   : 
*  Created On   :  26th April 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest(seeAllData=true)
public class OpportunityLineItemTriggerHandlerTest{


//Public Trusted
static testmethod  void createOppLineItm(){

        Date closeDt = Date.Today();            
        date myDate = date.today();        
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;   
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();     
        opportunity opp = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Prospecting', 
        CloseDate = closeDt,Recordtypeid=RecordTypeIdOpp, Forecast_CategoryCom__c='Committed');
        insert opp;
        //Id pricebookId = Test.getStandardPricebookId();
        
        pricebook2 myRE = [select id,name from pricebook2 where name='Enterprise CPQ'];
        Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

        //Create your product
        Product2 prod = new Product2(
        Name = 'Product X',
        ProductCode = 'Pro-X',
        family='Public Trusted',
        isActive = true
        );
        insert prod;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdpb.Id, Product2Id = prod.Id, UnitPrice = 1);
insert pbe;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = myRE.id,
        Product2Id = prod.Id,
        UnitPrice = 100.00,
        IsActive = true,
        useStandardPrice=false
        );
        insert pbEntry;
        
        
         //Create your pricebook entry
        PricebookEntry pbEntry1= new PricebookEntry(
        Pricebook2Id = stdpb.id,
        Product2Id = prod.Id,
        UnitPrice = 10.00,
        IsActive = true
        );
       // insert pbEntry1;
        
        //Create Discount
        Discount__c newDis= new Discount__c();
        //newDis.name='Dis#0001';
        newDis.Product__c=prod.Id;
        newDis.Range_1__c=5;
        newDis.Range_2__c=10;
        newDis.Range_3__c=15;
        newDis.Range_4__c=20;
        newDis.Range_5__c=25;
        newDis.Range_6__c=30;
        newDis.Type__c='Volume';
        newDis.Product_Code_SKU__c='EV-flex-2yr';
        insert newDis;
        
        
           //create your opportunity line item.  
        OpportunityLineItem oli = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli;
        
        //create your opportunity line item.  
        OpportunityLineItem oli1 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 23,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli1;
        
          //create your opportunity line item.  
        OpportunityLineItem oli2 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 73,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli2;
        
          //create your opportunity line item.  
        OpportunityLineItem oli3 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 150,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli3;
        
          //create your opportunity line item.  
        OpportunityLineItem oli4 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 350,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli4;
        
          //create your opportunity line item.  
        OpportunityLineItem oli5 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 550,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli5;
        
           //create your opportunity line item.  
        OpportunityLineItem oli6 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 1020,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli6;

    }
    
     //Private Trusted
    static testmethod  void createOppLineItmPrivate(){

        Date closeDt = Date.Today();            
        date myDate = date.today();        
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;        
        opportunity opp = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Prospecting', 
        CloseDate = closeDt);
        insert opp;
       // Id pricebookId = Test.getStandardPricebookId();
         pricebook2 myRE = [select id,name from pricebook2 where name='Enterprise CPQ'];
        Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

        
        //Create your product
        Product2 prod = new Product2(
        Name = 'Product X',
        ProductCode = 'Pro-X',
        family='Private Trusted',
        isActive = true
        );
        insert prod;
        
         PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdpb.Id, Product2Id = prod.Id, UnitPrice = 1);
insert pbe;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = myRE.id,
        Product2Id = prod.Id,
        UnitPrice = 100.00,
        IsActive = true
        );
        insert pbEntry;
        
        //Create Discount
        Discount__c newDis= new Discount__c();
        //newDis.name='Dis#0001';
        newDis.Product__c=prod.Id;
        newDis.Range_1__c=5;
        newDis.Range_2__c=10;
        newDis.Range_3__c=15;
        newDis.Range_4__c=20;
        newDis.Range_5__c=25;
        newDis.Range_6__c=30;
        newDis.Range_7__c=40;
        newDis.Range_8__c=50;
        newDis.Range_9__c=50;
        newDis.Range_10__c=50;
        newDis.Range_11__c=50;
        newDis.Range_12__c=50;
        newDis.Range_13__c=50;
        newDis.Range_14__c=50;        
        newDis.Type__c='Volume';
        newDis.Product_Code_SKU__c='EV-flex-2yr';
        insert newDis;
        
        
           //create your opportunity line item.  
        OpportunityLineItem oli = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli;
        
        //create your opportunity line item.  
        OpportunityLineItem oli1 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 23,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli1;
        
          //create your opportunity line item.  
        OpportunityLineItem oli2 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 73,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli2;
        
          //create your opportunity line item.  
        OpportunityLineItem oli3 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 150,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli3;
        
          //create your opportunity line item.  
        OpportunityLineItem oli4 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 350,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli4;
        
          //create your opportunity line item.  
        OpportunityLineItem oli5 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 550,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli5;
        
           //create your opportunity line item.  
        OpportunityLineItem oli6 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 1020,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli6;
        
        //create your opportunity line item.  
        OpportunityLineItem oli7 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 27,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli7;
        
        
        
        //create your opportunity line item.  
        OpportunityLineItem oli8 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 2550,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli8;
        
        
        
        //create your opportunity line item.  
        OpportunityLineItem oli9 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5050,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli9;
        
         
        //create your opportunity line item.  
        OpportunityLineItem oli10 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 10050,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli10;
        
        
         //create your opportunity line item.  
        OpportunityLineItem oli11 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 20050,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli11;


    }
   //IoT PKI Manager
static testmethod  void createOppItmIoTK(){

        Date closeDt = Date.Today();            
        date myDate = date.today();        
        Account a2 = new Account(Name ='icrm testing acc');
        insert a2;        
        opportunity opp = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Prospecting', 
        CloseDate = closeDt);
        insert opp;
       // Id pricebookId = Test.getStandardPricebookId();
          pricebook2 myRE = [select id,name from pricebook2 where name='Enterprise CPQ'];
        Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

        
        //Create your product
        Product2 prod = new Product2(
        Name = 'Product X',
        ProductCode = 'Pro-X',
        family='IoT PKI Manager',
        isActive = true
        );
        insert prod;
         
         PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdpb.Id, Product2Id = prod.Id, UnitPrice = 1);
insert pbe;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = myRE.id,
        Product2Id = prod.Id,
        UnitPrice = 100.00,
        IsActive = true
        );
        insert pbEntry;
        
        //Create Discount
        Discount__c newDis= new Discount__c();
        //newDis.name='Dis#0001';
        newDis.Product__c=prod.Id;
        newDis.Range_1__c=5;
        newDis.Range_2__c=10;
        newDis.Range_3__c=15;
        newDis.Range_4__c=20;
        newDis.Range_5__c=25;
        newDis.Range_6__c=30;
        newDis.Quantity_10000__c=40;
        newDis.Quantity_25000__c=40;
        newDis.Quantity_50000__c=40;
        newDis.Quantity_100000__c=40;
        newDis.Quantity_250000__c=40;
        newDis.Quantity_500000__c=40;
        newDis.Quantity_1000000__c=40;
        newDis.Quantity_2000000__c=40;
        newDis.Quantity_5000000__c=40;
        newDis.Quantity_10000000__c=40;
        newDis.Quantity_5000000__c=40;
        newDis.Type__c='Volume';
        newDis.Product_Code_SKU__c='EV-flex-2yr';
        insert newDis;
        
          //create your opportunity line item.  
        OpportunityLineItem oli = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli;
        
        //create your opportunity line item.  
        OpportunityLineItem oli1 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 23,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli1;
        
          //create your opportunity line item.  
        OpportunityLineItem oli2 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 73,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli2;
        
          //create your opportunity line item.  
        OpportunityLineItem oli3 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 150,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli3;
        
          //create your opportunity line item.  
        OpportunityLineItem oli4 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 350,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli4;
        
          //create your opportunity line item.  
        OpportunityLineItem oli5 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 550,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli5;
        
           //create your opportunity line item.  
        OpportunityLineItem oli6 = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 1020,
        UnitPrice=100.00,
        
        PricebookEntryId = pbEntry.Id
       
        );
        insert oli6;




    }            
    
    

                          
}