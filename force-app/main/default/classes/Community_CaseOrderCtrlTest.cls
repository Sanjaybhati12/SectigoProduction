@isTest
public class Community_CaseOrderCtrlTest {
    public static testMethod void Community_CaseOrderCtrl(){
           Case c= new Case();
  // c.id=currentRecordId;
        c.status = 'Awaiting Customer Reply' ;
    //c.casenumber = 00195083;
    c.Reason = 'Billing';
    c.origin = 'Web';
    c.Priority = 'Medium';
    c.subject = 'test valli';
    insert c;
        String cId = c.id;
ApexPages.CurrentPage().getParameters().put('id',cId );
        Community_CaseOrderCtrl cc = new Community_CaseOrderCtrl();
    }

}