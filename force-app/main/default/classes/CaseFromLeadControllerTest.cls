@isTest
    public class CaseFromLeadControllerTest {
        static testMethod void caseFromLead(){
            Lead newlead=new Lead(LastName='Doe',FirstName='John',
                                  Company='Test',email='abc@daze.com',
                                  Segment__c='Retail', Product_Interest__c='Code Signing On Demand');
            
            insert newlead;  
           
            Task t = new task();
            t.OwnerId = UserInfo.getUserId();
            t.Subject='Submitted Form';
            t.Status='Not Started';
            t.Priority='Normal';
            t.whoid = newLead.id;
            insert t;
                  
            Case cs = new case();
            cs.status ='new';
            cs.Reason = 'Technical Certificate Manager';
            cs.Origin = 'Web';
            insert cs;
            CaseFromLeadController.createCaserec(newlead.id);
            
        }
        
    }