/** Class Name   : Com_NoActivityCaseTest 
*  Description  : Test class for Com_NoActivityCase Batch Class to update no activivty Cases 
*                     
*  Created By   : Veera
*  Created On   : 08-06-2018

*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
*                                                                                    
**/

@isTest
    private class Com_NoActivityCaseTest {
    
    static testmethod void test() {   
    
        String businessHourId =system.label.NoActivityBusinesshours;           
        Integer noActivityTime=Integer.ValueOf(system.label.NoActivityBusinesshours1);           
        noActivityTime= noActivityTime*60*1000*-1;
        system.debug('###in test class##'+noActivityTime);
        DateTime dt = BusinessHours.add(businesshourId, system.now(), noActivityTime);
        System.debug('#$#$#in test class$#$#$'+dt);
        
        List<noActivityCase__c >  eachACtivty = new List<noActivityCase__c >();
        noActivityCase__c eachObj = new noActivityCase__c();
        eachObj.Name='Account Changes';
        eachObj.Label__c  ='Account Changes';
        eachACtivty.add(eachObj) ;
          noActivityCase__c eachObj1 = new noActivityCase__c();
        eachObj1.Name='Partner Validation';
        eachObj1.Label__c ='Partner Validation';
        eachACtivty.add(eachObj1) ;
        insert eachACtivty;
        
        Account account = new Account(Name='Test Account');
        insert account;
        
        Contact cont1 = new Contact(LastName='ContTest1', Email='test1contact@duptest.com', AccountId = account.Id, LeadSource='Inbound Call');
        insert cont1;
        
       
    
    
       Com_NoActivityCase.dateField = Case.Duetime__c;      
       List<Case> Cases= new List<Case>();       
       
        Case c = new Case();        
        C.Status = 'Awaiting Customer Reply';
       //c.ResolutionDateline__c='';
       c.accountid=account.id;
       c.contactid=cont1.id;
        System.debug('$$$$$'+System.now());
        c.Duetime__c= dt.addHours(-55);
        c.Reason ='Account Changes';
        System.debug('#$#$#in test class%%$#$#$'+dt);
        System.debug('@@@@in test@@@@@'+c.Duetime__c);
      //  c.Duetime__c=c.Duetime__c.addHours(-23);
       // c.Duetime__c=c.Duetime__c.addMinutes(-58);
        System.debug('#######'+c.Duetime__c);
        Cases.add(c);        
         Case c1 = new Case();        
        C1.Status = 'Awaiting Customer Reply';
        c1.Duetime__c= dt.addHours(-30);
        c1.accountid=account.id;
       c1.contactid=cont1.id;
        c1.Reason ='Account Changes';
        Cases.add(c1);        
         Case c2 = new Case();        
        C2.Status = 'Awaiting Customer Reply';
        c2.Duetime__c= dt ;
        c2.accountid=account.id;
       c2.contactid=cont1.id;
        c2.Reason ='Account Changes';
        Cases.add(c2);        
         Case c3 = new Case();        
        C3.Status = 'Awaiting Customer Reply';
        c3.Duetime__c= dt ;
        c3.accountid=account.id;
       c3.contactid=cont1.id;
         c3.Reason ='Account Changes';
        Cases.add(c3);        
        insert Cases;
        
        Test.startTest();
        Com_NoActivityCase uca = new Com_NoActivityCase();
        Id batchId = Database.executeBatch(uca,5);
        Test.stopTest();        
       // System.assertEquals(2, [select count() from case where status= 'closed']);
        //System.assertEquals(2, [select count() from case where status= 'Awaiting Customer Reply']);
        
    
    }
    
    }