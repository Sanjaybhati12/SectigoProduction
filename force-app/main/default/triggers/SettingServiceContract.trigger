trigger SettingServiceContract on Account (Before Insert, Before Update, after insert, after update,before delete) {

   //logic to set service contract and entitlment process based on value of Customer Segment
   if((trigger.isAfter) && trigger.isInsert){
       TriggerUtility.setServiceContract(Trigger.new, Trigger.oldMap);
   }
   if(trigger.isbefore && trigger.isdelete){
       if(UserInfo.getProfileId() != Label.system_admin_profile_id){
            for (Account acc : Trigger.old) {
                acc.addError(Label.Error_Message_On_Account_Delete);
            }
        }
   }
   
  
   if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
     /* List<Territory_Assignment_based_on_Countries__c> setting = Territory_Assignment_based_on_Countries__c.getall().values();
          system.debug('territory settings: '+setting);      
          for(Account accRec : Trigger.New){             
              if(accRec.ShippingCountry == 'United States'){
                  accRec.ShippingCountry = 'US';
              }          
              if(accRec.ShippingCountry == 'United Kingdom'){
                  accRec.ShippingCountry = 'UK';
              }               
              for(Territory_Assignment_based_on_Countries__c tABC : setting){
                  if(accRec.ShippingCountry == 'US' || accRec.ShippingCountry == 'United States'){
                      if(tABC.Name == accRec.ShippingState){
                          accRec.Territory__c = tABC.Territory__c;
                          system.debug('@@@@: '+accRec.ShippingCountry+'#####: '+accRec.Territory__c+'&&&&&&: '+tABC.Territory__c +'^^^^^^: '+accRec.ShippingState);
                      }
                  }
                  if(tABC.Name == accRec.ShippingCountry){
                      accRec.Territory__c = tABC.Territory__c;
                      system.debug('@@@@'+accRec.ShippingCountry+'#####'+accRec.Territory__c+'&&&&&&'+tABC.Territory__c);
                  }
              }
          }
          */
          
      List<Account_Territory_based_on_Countries__c> setting = Account_Territory_based_on_Countries__c.getall().values();
      List<Account_Territory_based_on_US_States__c> USsetting = Account_Territory_based_on_US_States__c.getall().values();
      system.debug('territory settings: '+setting);      
      
      for(Account accRec : Trigger.new){
          
          //United States,US,United States of America,USA,U.S.A
          if(accRec.ShippingCountry == 'United States' || accRec.ShippingCountry == 'United States of America' || accRec.ShippingCountry == 'USA'|| accRec.ShippingCountry == 'U.S.A'){
              accRec.ShippingCountry = 'US';             
          }else if(accRec.ShippingCountry == 'United Kingdom'){
              accRec.ShippingCountry = 'UK';
          }
          
          system.debug('country coming: '+accRec.ShippingCountry);
          
          for(Account_Territory_based_on_US_States__c usSates : USsetting ){
          
                if(accRec.ShippingCountry == 'US' || accRec.ShippingCountry == 'United States' || accRec.ShippingCountry == 'United States of America' || accRec.ShippingCountry == 'USA'|| accRec.ShippingCountry == 'U.S.A'){
                  
                  if(accRec.ShippingState == usSates.Name){
                      
                      accRec.Territory__c = usSates.Territory__c;
                      break;
                  }else if(usSates.Name != accRec.ShippingState || String.isBlank(accRec.ShippingState)){
                      
                      accRec.Territory__c = 'N America';
                  }
              }else if(String.isBlank(accRec.ShippingCountry) && String.isNotBlank(accRec.ShippingState)){
                  if(usSates.Name == accRec.ShippingState){
                      accRec.Territory__c = usSates.Territory__c;
                      break;                      
                  }else if(usSates.Name != accRec.ShippingState){
                      accRec.Territory__c = 'N America';                      
                  }
              }
              
          }
          
          for(Account_Territory_based_on_Countries__c tABC : setting){
          
          
              if(String.isNotBlank(accRec.ShippingCountry) && (accRec.ShippingCountry != 'US' || accRec.ShippingCountry != 'United States' || accRec.ShippingCountry != 'United States of America' || accRec.ShippingCountry != 'USA'|| accRec.ShippingCountry != 'U.S.A')){              
                  if(tABC.Name == accRec.ShippingCountry){
                      accRec.Territory__c = tABC.Territory__c;
                  }
              }else if(String.isBlank(accRec.ShippingCountry) && String.isNotBlank(accRec.ShippingState)){
                  if(tABC.Name == accRec.ShippingState){
                      accRec.Territory__c = tABC.Territory__c;                      
                  }
              } 
              
          }
        }
          
    }
    
    if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter){
        List<Account> newAccList = new List<Account>();
        for(Account acc : trigger.new){
            if(acc.Channel_partner__c != null){
                newAccList.add(acc);
            }
        }
        if(newAccList.size() > 0){
            AccountTriggerHandler.createAccountShare(newAccList);
        }
    }
    
}