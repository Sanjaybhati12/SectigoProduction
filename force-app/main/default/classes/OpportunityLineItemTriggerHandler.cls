/*********************************************************
Component : Apex Class
Created By : Vinay Chaturvedi
Purpose : Handler for Trigger on Opportunity Line Item
Last Modified by : NA
Last Modified Date : NA
Last Modified Reason : NA
********************************************************/
public class OpportunityLineItemTriggerHandler
{
    //Constants declared for Quantity and Range
    static final Integer QUANTITY_RANGE_1_1=10;
    static final Integer QUANTITY_RANGE_1_2 = 49;
    static final Integer QUANTITY_RANGE_2_1 = 50;
    static final Integer QUANTITY_RANGE_2_2 = 99;
    static final Integer QUANTITY_RANGE_3_1 = 100;
    static final Integer QUANTITY_RANGE_3_2 = 299;
    static final Integer QUANTITY_RANGE_4_1 = 300;
    static final Integer QUANTITY_RANGE_4_2 = 499;
    static final Integer QUANTITY_RANGE_5_1 = 500;
    static final Integer QUANTITY_RANGE_5_2 = 999;
    static final Integer QUANTITY_RANGE_6 = 1000;
    static final Integer QUANTITY_RANGE_7 = 25;
    static final Integer QUANTITY_RANGE_8 = 249;
    static final Integer QUANTITY_RANGE_9 = 250;
    static final Integer QUANTITY_RANGE_10 = 2499;
    static final Integer QUANTITY_RANGE_11 = 2500;
    static final Integer QUANTITY_RANGE_12 = 4999;
    static final Integer QUANTITY_RANGE_13 = 5000;
    static final Integer QUANTITY_RANGE_14 = 9999;
    static final Integer QUANTITY_RANGE_15 = 10000;
    static final Integer QUANTITY_RANGE_16 = 19999;
    static final Integer QUANTITY_RANGE_17 = 20000;
    static final Integer QUANTITY_RANGE_18 = 25000;
    static final Integer QUANTITY_RANGE_19 = 50000;
    static final Integer QUANTITY_RANGE_20 = 100000;
    static final Integer QUANTITY_RANGE_21 = 250000;
    static final Integer QUANTITY_RANGE_22 = 500000;
    static final Integer QUANTITY_RANGE_23 = 1000000;
    static final Integer QUANTITY_RANGE_24 = 2000000;
    static final Integer QUANTITY_RANGE_25 = 5000000;
    static final Integer QUANTITY_RANGE_26 = 10000000;
    
    
    
    /*****Method to calculate Volume Discount on Opportunity Line Item Start **********/
    public static void calculateDiscount(List<OpportunityLineItem> opportunityProductList)
    {
        //Map of Product Ids to Discount Record
        //Purpose: To get related Discount record for that particular product
        Map<Id,Discount__c>mapProductIdToDiscounts =new Map<Id,Discount__c>();
        
        //TO get set of Product IDs from list of opporunity item
        //Purpose : To query them to get related discounts in map
        Set<Id>setProductIds = new set<Id>();
        
        Decimal volumeDiscount = 0;
        Decimal partnerDiscount= 0;
        Decimal DiscretionaryDiscount =0;
        
        list<OpportunityLineItem> oliList = new list<OpportunityLineItem>();
        
        for(OpportunityLineItem objOppLineItem : opportunityProductList)
        {
            setProductIds.add (objOppLineItem.Product2Id); 
        } 
        Map<Id,Product2> mapproductdiscount = New Map<Id,Product2>([Select id,family,(select id,type__c,Quantity_10000__c,Quantity_25000__c,Quantity_50000__c,Quantity_100000__c,Quantity_250000__c,Quantity_500000__c,Quantity_1000000__c,Quantity_2000000__c,Quantity_10000000__c,Range_1__c,Range_2__c,Range_3__c,Range_4__c,Range_5__c,Range_6__c,Range_7__c,Range_8__c,Range_9__c,Range_10__c,Range_11__c,Range_12__c,Range_13__c,Range_14__c from Discounts__r) from product2 where id in:setProductIds]);
        
        Map<string,Discountpercentage__c> allDiscounts = Discountpercentage__c.getAll();
        for(OpportunityLineItem oli:opportunityProductList)
        {
            if(mapproductdiscount.containskey(oli.product2Id)){
                if(mapproductdiscount.get(oli.product2Id).Discounts__r.size() > 0){
                    List<Discount__c> DList = mapproductdiscount.get(oli.product2Id).Discounts__r;
                    String family = mapproductdiscount.get(oli.product2Id).family;
                    If(!DList.isEmpty()){
                        for(Discount__c d:DList){
                            if(d.type__c=='Volume' && family=='Public Trusted'){ 
                                if(oli.quantity >= QUANTITY_RANGE_1_1 & oli.quantity <= QUANTITY_RANGE_1_2){
                                    oli.Volume_Discount__c = d.Range_1__c;
                                    volumeDiscount = d.Range_1__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_2_1 & oli.quantity <= QUANTITY_RANGE_2_2){
                                    oli.Volume_Discount__c = d.Range_2__c;
                                    volumeDiscount = d.Range_2__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_3_1 & oli.quantity <= QUANTITY_RANGE_3_2){
                                    oli.Volume_Discount__c = d.Range_3__c;
                                    volumeDiscount = d.Range_3__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_4_1 & oli.quantity <= QUANTITY_RANGE_4_2){
                                    oli.Volume_Discount__c = d.Range_4__c;
                                    volumeDiscount= d.Range_4__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_5_1 & oli.quantity <= QUANTITY_RANGE_5_2){
                                    oli.Volume_Discount__c = d.Range_5__c;
                                    volumeDiscount = d.Range_5__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_6){
                                    oli.Volume_Discount__c = d.Range_6__c;
                                    volumeDiscount = d.Range_6__c;
                                }else{
                                    oli.Volume_Discount__c = 0.00;
                                    volumeDiscount = 0.00;
                                }
                            }else if(d.type__c=='Volume' && (family=='Private Trusted' || family =='CCM 3rd party certs')){ 
                                if(oli.quantity >= QUANTITY_RANGE_7 & oli.quantity <= QUANTITY_RANGE_1_2){
                                    oli.Volume_Discount__c = d.Range_7__c;
                                    volumeDiscount = d.Range_7__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_2_1 & oli.quantity <= QUANTITY_RANGE_2_2){
                                    oli.Volume_Discount__c = d.Range_2__c;
                                    volumeDiscount = d.Range_2__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_3_1 & oli.quantity <= QUANTITY_RANGE_8){
                                    oli.Volume_Discount__c = d.Range_8__c;
                                    volumeDiscount = d.Range_8__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_9 & oli.quantity <= QUANTITY_RANGE_4_2){
                                    oli.Volume_Discount__c = d.Range_9__c;
                                    volumeDiscount= d.Range_9__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_5_1 & oli.quantity <= QUANTITY_RANGE_10){
                                    oli.Volume_Discount__c = d.Range_10__c;
                                    volumeDiscount = d.Range_10__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_11 & oli.quantity <= QUANTITY_RANGE_12){
                                    oli.Volume_Discount__c = d.Range_11__c;
                                    volumeDiscount = d.Range_11__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_13 & oli.quantity <= QUANTITY_RANGE_14){
                                    oli.Volume_Discount__c = d.Range_12__c;
                                    volumeDiscount = d.Range_12__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_15 & oli.quantity <= QUANTITY_RANGE_16){
                                    oli.Volume_Discount__c = d.Range_13__c;
                                    volumeDiscount = d.Range_13__c;
                                }else if(oli.quantity >= QUANTITY_RANGE_17){
                                    oli.Volume_Discount__c = d.Range_14__c;
                                    volumeDiscount = d.Range_14__c;
                                }else{
                                    oli.Volume_Discount__c = 0.00;
                                    volumeDiscount = 0.00;
                                }           
                            }else if(d.type__c=='Volume' && family=='IoT PKI Manager'){
                                if(oli.quantity == QUANTITY_RANGE_15){
                                    oli.Volume_Discount__c = d.Quantity_10000__c;
                                    volumeDiscount = d.Quantity_10000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_18){
                                    oli.Volume_Discount__c = d.Quantity_25000__c;
                                    volumeDiscount = d.Quantity_25000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_19){
                                    oli.Volume_Discount__c = d.Quantity_50000__c;
                                    volumeDiscount = d.Quantity_50000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_20){
                                    oli.Volume_Discount__c = d.Quantity_100000__c;
                                    volumeDiscount = d.Quantity_100000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_21){
                                    oli.Volume_Discount__c = d.Quantity_250000__c;
                                    volumeDiscount = d.Quantity_250000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_22){
                                    oli.Volume_Discount__c = d.Quantity_500000__c;
                                    volumeDiscount = d.Quantity_500000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_23){
                                    oli.Volume_Discount__c = d.Quantity_1000000__c;
                                    volumeDiscount = d.Quantity_1000000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_24){
                                    oli.Volume_Discount__c = d.Quantity_2000000__c;
                                    volumeDiscount = d.Quantity_2000000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_25){
                                    oli.Volume_Discount__c = d.Quantity_5000000__c;
                                    volumeDiscount = d.Quantity_5000000__c;
                                }else if(oli.quantity == QUANTITY_RANGE_26){
                                    oli.Volume_Discount__c = d.Quantity_10000000__c;
                                    volumeDiscount = d.Quantity_10000000__c;
                                }else{
                                    oli.Volume_Discount__c = 0.00;
                                    volumeDiscount = 0.00;
                                }
                            }
                        }
                        if(oli.Opportunity_Record_Type__c == 'Channel_partners'){
                            partnerDiscount = allDiscounts.get('Partner Discount').Partner_Discount__c;
                            oli.Partner_Discount__c = partnerDiscount;
                            partnerDiscount = partnerDiscount;
                        }else{
                            partnerDiscount = 0.00;
                            oli.Partner_Discount__c = 0.00;
                            partnerDiscount = 0.00;
                        }
                        
                        if(oli.Discount !=null){
                            DiscretionaryDiscount = oli.Discount;
                        }else{
                            DiscretionaryDiscount = 0.00;
                        }
                        if(oli.quantity != null && oli.UnitPrice != null && volumeDiscount != null && partnerDiscount != null && DiscretionaryDiscount != null ){
                            oli.Total_Price__c = ((oli.quantity * oli.UnitPrice) - ((oli.quantity * oli.UnitPrice) * 
                                                                                    ((volumeDiscount + partnerDiscount + DiscretionaryDiscount)/100)));
                        }
                    }
                }
            } 
        }     
        
    } 
}