@isTest
public class restrictUsersFromDelTest{
    
    static Case tCase;
    static Case_Comment__c tComment;
    static Profile tProfile;
    static User tUser;
    
    @isTest
    static  void  createTestData(){
        tCase = new Case();
        
        tCase.Status = 'Open';
        tCase.Description = 'Test Description';
        tCase.Origin = 'Annuity External';
        tCase.Type = 'Feature Request';
        tCase.Priority = 'Low';
        
        INSERT tCase;
        
        tComment = new Case_Comment__c();
        tComment.ParentId__c = tCase.Id;
        
        INSERT tComment;
        
        tProfile = 
            [
                SELECT Id 
                FROM   Profile 
                WHERE  Name = 'Support Management Team'
            ];
        
        tUser = new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = tProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuser@sometestorg.com'
        );
        
        System.runAs(tUser){
            system.debug('user Profile'+userinfo.getProfileId());
            system.debug('user Profile'+tUser);
            try{
                DELETE tComment;
            }catch(Exception ex){
                Boolean expectedExceptionThrown =  ex.getMessage().contains('You are not authorized to delete the record , please contact your system administrator') ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }

            
        }
    }
    
}
/*   @isTest
static void DelectCaseComment(){
test.startTest();

createTestData();

//  try{
System.runAs(tUser){
DELETE tComment;
}
//  }
// catch(Exception e){ }

test.stopTest();
}    
} */

/* @isTest
public class restrictUsersFromDelTest{

private static testmethod void testdelete(){
// Setup test data
// Create a test UserName
String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
// This code runs as the system user
Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
LocaleSidKey='en_US', ProfileId = p.Id,
TimeZoneSidKey='America/Los_Angeles',
UserName=uniqueUserName);

System.runAs(u) {
Case testcase= new Case();
testcase.Status='New';
insert testcase;
Case_Comment__c testccm= new Case_Comment__c();
testccm.Comment_Body__c='test test1';
testccm.ParentId__c=testcase.id;
insert testccm;
System.debug('Current User: ' + UserInfo.getUserName());
System.debug('Current Profile: ' + UserInfo.getProfileId());
try{
delete testccm;
}catch(Exception e){

system.assert(e.getMessage().contains('You are not authorized to delete the record'),'You are not authorized to delete the record');   
}
}
}
} */