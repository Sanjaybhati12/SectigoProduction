trigger OpportuityLineItemTrigger on OpportunityLineItem (Before Insert,Before Update) {
   if(trigger.isinsert || trigger.isUpdate){
     OpportunityLineItemTriggerHandler.calculateDiscount(trigger.new);
   }
   
}