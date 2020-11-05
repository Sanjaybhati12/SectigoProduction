@isTest
public class ContactTriggerTest {
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
                contact con = new contact(
                    LastName = 'test contact',
                    Email = 'vinay@dazeworks.com',
                    Phone = '1234567890'                    
                    
                );
                insert con;  
                
                delete con;
            }catch(Exception ex){
                Boolean expectedExceptionThrown =  ex.getMessage().contains('You are not authorized to delete this record') ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }
            
        }
        
        
        
    }
    
    @testSetup static void methodName() {
		User user1 = new User();
        user1.ProfileID = [Select Id From Profile Where Name='Retail Sales Rep Ottawa' limit 1].id;
        user1.UserRoleID = [Select Id From UserRole Where Name='Retail Ottawa'].id;
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.LanguageLocaleKey = 'en_US';
        user1.TimeZoneSidKey = 'America/New_York';
        user1.LocaleSidKey = 'en_US';
        user1.FirstName = 'anmar';
        user1.LastName = 'alkhafaji';
        user1.username = 'anmar.alkhafaji@sectigo.com.full1';   
        user1.CommunityNickname = 'anmar.alkhafaji@sectigo';
        user1.Alias = 't1';
        user1.Email = 'anmar.alkhafaji@sectigo.com.full';
        user1.IsActive = true;
        insert user1;
        
        User user2 = new User();
        user2.ProfileID = [Select Id From Profile Where Name='BDR Sales Reps' limit 1].id;
        user2.UserRoleID = [Select Id From UserRole Where Name='BDR Sales Rep'].id;
        user2.EmailEncodingKey = 'ISO-8859-1';
        user2.LanguageLocaleKey = 'en_US';
        user2.TimeZoneSidKey = 'America/New_York';
        user2.LocaleSidKey = 'en_US';
        user2.FirstName = 'firsfght';
        user2.LastName = 'lasrtyt';
        user2.username = 'testerer@apdfghpertirio.com1';   
        user2.CommunityNickname = 'testerer@apdfghpertirio';
        user2.Alias = 't2';
        user2.Email = 'testerer@apdfghpertirio.com';
        user2.IsActive = true;
        insert user2;
        
	}
	@isTest
    public static void test2(){
		
		user u1=[select id,name from user where username='testerer@apdfghpertirio.com1'];
        
        user u2=[select id,name from user where username='anmar.alkhafaji@sectigo.com.full1'];
                
        system.runAs(u1){
            ContactAssignment__c conAssignment = new ContactAssignment__c(Name='Canada',Territory__c='Canada',OwnerId__c=u2.Id);
            Insert conAssignment;
        Id retailRecordTypeIdCon = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            List<Contact> conList = new List<Contact>();
                contact con = new contact(
                    LastName = 'test contact',
                    Email = 'vinay@dazeworks.com',
                    Phone = '1234567890',
                    Territory__c = 'Canada'
                    
                );
             contact con2 = new contact(
                    LastName = 'test contact',
                    Email = 'vinay@dazeworks.com',
                    Phone = '1234567890',
                    Territory__c = 'Canada',
                    MQL_Qualified__c = true,
                 RecordTypeId  = retailRecordTypeIdCon
                );
                conlist.add(con);conlist.add(con2); 
                insert conList;  
                
                
            
            
        }
        contact con = new contact();
        con.LastName='Testing';
        con.Email='testing@dazeworks.com';
        con.Phone='999999';
        con.OwnerId=u1.id;
        con.BDR_Transfer_Date__c = system.today();
        con.BDR_Transfer__c = True;
        
        insert con;
         system.debug('>>>>>>>>>>>>>'+con);
         system.debug('>>>>>>>>>>>>>'+con.Owner_Role__c);
        con.OwnerId=u2.Id;
        con.BDR_Transfer_Date__c = system.today();
        con.BDR_Transfer__c = false;
        con.MQL_Qualified__c = true;
        update con;
        system.debug('>>>>>>>>>>>>>'+con);
        system.debug('>>>>>>>>>>>>>'+con.Owner_Role__c);
    }
}