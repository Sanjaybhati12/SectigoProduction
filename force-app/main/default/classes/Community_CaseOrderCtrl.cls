public class Community_CaseOrderCtrl{
  public String OrderNumber{get;set;}
public List<Case> ExistingOrderCases{get;set;}
  public Community_CaseOrderCtrl(){
      OrderNumber= apexpages.currentpage().getparameters().get('OrderNumber');
      system.debug('%%%%%%%'+OrderNumber);
      String AccountID = [Select Id,Contact.AccountId from User where ID=: UserInfo.getUserId()].Contact.AccountId;

      ExistingOrderCases= new List<Case>();
     ExistingOrderCases=[select id,CaseNumber,Order_Number__c,status,subject,CreatedDate,LastModifiedDate from case where Order_Number__c=:OrderNumber
                            and AccountId =:AccountID  ORDER BY CreatedDate DESC];
     
       
  }

  
      
}