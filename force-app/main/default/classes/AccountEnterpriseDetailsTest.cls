@isTest
public class AccountEnterpriseDetailsTest {
    @isTest
    public static void testScenario1(){
        
        Account ac = new Account(name ='Grazitti',Enterprise_Premier__c=true) ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,email ='test@gmail.com' , Phone = '43656',Role__c ='Premier 1');
        insert con;  
        Product2 prod = new Product2(Name='Test Prod',Family='Partner');
        insert Prod;
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c(SBQQ__Quantity__c=2,SBQQ__ListPrice__c=1200.00,SBQQ__Account__c=ac.Id,SBQQ__Product__c=prod.Id);
        insert sub;
        
        Test.startTest();
       
        AccountEnterpriseDetails.getTotalListAmount(ac.Id);
        String fileId = AccountEnterpriseDetails.saveTheFile(ac.Id, 'fileName', 'base64Data', '.PNG');
        AccountEnterpriseDetails.saveTheChunk(ac.Id, 'fileName1', 'base64Data', '.PNG',fileId);
        AccountEnterpriseDetails.saveTheChunk(ac.Id, 'fileName2', 'base64Data', '.PNG','');
        AccountEnterpriseDetails.getContentversion(fileId, ac.Id);
        AccountEnterpriseDetails.getAccountContacts(ac.Id);
        Test.stopTest();
    }
}