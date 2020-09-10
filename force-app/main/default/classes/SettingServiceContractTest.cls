@isTest
public class SettingServiceContractTest {
    
    @TestSetup static void setupData() {
        Account_Territory_based_on_Countries__c settingData = new Account_Territory_based_on_Countries__c(Name = 'Barbados', Territory__c = 'S America');
        insert settingData;
        Account_Territory_based_on_Countries__c settingData1 = new Account_Territory_based_on_Countries__c(Name = 'US', Territory__c = 'North Central');
        insert settingData1;
        Account_Territory_based_on_Countries__c settingData2 = new Account_Territory_based_on_Countries__c(Name = 'UK', Territory__c = 'Western Europe');
        insert settingData2;
        Account_Territory_based_on_US_States__c settingData3 = new Account_Territory_based_on_US_States__c(Name = 'Ohio', Territory__c = 'Michigan/Ohio');
        insert settingData3;
    }
    
    @isTest
    public static void test1(){
        
        User user2 = new User();
        user2.ProfileID = [Select Id From Profile Where Name='Partner Management'].id;
        user2.UserRoleID = [Select Id From UserRole Where Name='CEO'].id;
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
                Account acc = new Account(
                    Name = 'Test Acc',
                    ShippingCountry = 'US'
                );
                insert acc;  
                
                delete acc;
            }catch(Exception ex){
                Boolean expectedExceptionThrown =  ex.getMessage().contains('You are not authorized to delete this record') ? true : false;
                //System.assertEquals(expectedExceptionThrown, true);
            }
            
        }
        
    }
    
    @isTest
    public static void test2(){
        Account acc = new Account(
                    Name = 'Test Acc',
                    ShippingCountry = 'United States',
                    ShippingState = 'Ohio'
                );
        Account acc1 = new Account(
            Name = 'Test Acc1',
            ShippingCountry = 'United Kingdom'
        );
        Account acc2 = new Account(
            Name = 'Test Acc2',
            ShippingCountry = 'US',
            ShippingState = 'Ohio'
        );
        Account acc3 = new Account(
            Name = 'Test Acc3',
            ShippingCountry = 'US',
            ShippingState = ''
        );
        Account acc4 = new Account(
            Name = 'Test Acc4',
            ShippingState = 'United Kingdom'
        );
        Account acc5 = new Account(
            Name = 'Test Acc5',
            ShippingState = 'Ohio'
        );
        Account acc6 = new Account(
            Name = 'Test Acc6',
            ShippingState = 'Ohio'
        );
        insert acc6;

       
                
           test.startTest();
               insert acc;
               insert acc1;
               insert acc2;
               insert acc3;
               insert acc4;
        // insert acc7;
           test.StopTest();
    }
    
}