public with sharing class Com_OpportunityContactHelperClass {
    public static boolean isTaskCreated = false;
    public static boolean insertCall = false;
    public static void checkProductAndContactRole(List<opportunity> newList, Map<Id,Opportunity> oldMap){
        
        OpportunityController__c control = OpportunityController__c.getInstance();
        set<Id> enterpriseOppIdSet = new set<Id>();
        set<Id> retailoppIdSet= new set<Id>();
        Map<Id,OpportunityLineItem> oppItemMap = new Map<Id,OpportunityLineItem>();
        Map<Id,SBQQ__Quote__c> QuoteMap = new Map<Id,SBQQ__Quote__c>();
        
        Id OppRetailRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        Id OppEnterpriseRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        
        for(Opportunity opp: newList){
            // This is for Retail Record Type  record type. If stage is  “Deal Approval”
            if(opp.StageName!=null && (opp.RecordTypeId == OppRetailRecId) && oldMap.get(opp.id).StageName != opp.StageName &&  opp.StageName=='Deal Approval' ){
                retailoppIdSet.add(opp.id);
            }
            // This is for Enterprise Record Type  record type. If stage is  “Deal Approval”
            if(opp.StageName!=null && (opp.RecordTypeId == OppEnterpriseRecId) && oldMap.get(opp.id).StageName != opp.StageName &&  opp.StageName=='Deal Approval' ){
                enterpriseOppIdSet .add(opp.id);
            }
            
        }
        // To check atlease one product for closed won opportunities  for Retail and Enterprise Record types
        if(retailoppIdSet.size() > 0){
            List<OpportunityLineItem> allLineItems=[SELECT Description,Discount,Id,ListPrice,Name,OpportunityId,Subtotal,TotalPrice,Total_Price_F__c,Total_Price__c,UnitPrice,Volume_Discount_F__c,Volume_Discount__c FROM OpportunityLineItem WHERE OpportunityId IN: retailoppIdSet];
            for(OpportunityLineItem eachItem : allLineItems){
                oppItemMap.put(eachItem.OpportunityId,eachItem);
            }
        }
        if(enterpriseOppIdSet.size() > 0){
            List<SBQQ__Quote__c > quotes = [SELECT Name__c, SBQQ__Account__c,SBQQ__Opportunity2__c,SBQQ__Primary__c FROM SBQQ__Quote__c  
                                            WHERE SBQQ__Primary__c = true AND SBQQ__Opportunity2__c IN :enterpriseOppIdSet ];
            
            for(SBQQ__Quote__c   qu : quotes){
                QuoteMap.put(qu.SBQQ__Opportunity2__c,qu);
            }
        }
        
        // This is for atleast one contact role
        List<OpportunityContactRole> oppconroles=[select id,OpportunityId,Opportunity.Name,Role from OpportunityContactRole where OpportunityId IN:Trigger.Newmap.keyset()];
        Map<Id,OpportunityContactRole> ocrMap = new Map<Id,OpportunityContactRole>();
        for(OpportunityContactRole ocr: oppconroles){
            ocrMap.put(ocr.OpportunityId, ocr);
        }
        
        //Now, perform our check
        for(Opportunity o: newList){
            //This is atlease one contact role
            if(Com_OpportunityContactHelperClass.insertCall == false){
                if(control.Check_Contact_Role__c){
                    if(o.IsClosed  != True){
                        if(!o.Name.startsWith(system.label.Opp_Amendment_for_contract) && !o.Name.startsWith(system.label.Opp_Renewal_Opportunity) ){  
                            if(!ocrMap.containsKey(o.Id)){
                                o.addError(System.Label.Error_Opportunity_Contact_Role_Required);
                            }
                        }
                    }
                }
            }
            //This is for atleast one product 
            if(control.Check_Product_On_Retail__c){
                if(!oppItemMap.containsKey(o.Id) && o.stageName == 'Deal Approval' && o.RecordTypeId == OppRetailRecId && oldMap.get(o.id).StageName != o.StageName)
                    o.addError(System.Label.Error_Check_Product_On_Retail_Opportunity);
                
            } 
            //This is for atleast Primary Quote
            if(control.Check_Quote_on_Enterprise__c){
                if(!QuoteMap.containsKey(o.Id) && o.stageName == 'Deal Approval' && o.RecordTypeId == OppEnterpriseRecId && oldMap.get(o.id).StageName != o.StageName)
                    o.addError(System.Label.Error_Check_Primary_Quote_On_Enterprise_Opportunity);
            }
            // Check for Product Interest and Plateform Interest for Retail and Enterprise
            if(control.Check_Product_and_Plateform_Interest__c){
                if(o.StageName !=null && (o.RecordTypeId == OppRetailRecId || o.RecordTypeId == OppEnterpriseRecId) && oldMap.get(o.id).StageName != o.StageName && o.StageName=='Presentation/Proof of Concept'  && String.isBlank(o.Original_Interest__c) && String.isBlank(o.Pltform_Interest__c)){
                    o.addError(System.Label.Error_For_Plateform_Interest_on_Opportunity);
                }  
            }
        }
        
    }
    
    public static void createTaskOnUpdate(List<Opportunity> opportunityList){
        set<Id> oppconId=new set<Id>();
        for(opportunity o:opportunityList){
            if(o.Current_Status__c != null){
                oppconId.add(o.Id);
            }
        }
        Map<Id,Id> contactRoleMap = new Map<Id,Id>();
        for(OpportunityContactRole oppconRole : [SELECT Id,OpportunityId, Opportunity.Name, Contact.Email, Contact.Name,Contactid, Role, isPrimary 
                                                 FROM OpportunityContactRole  
                                                 where OpportunityId IN:oppconId AND IsPrimary =true]){
                                                     if(!contactRoleMap.containskey(oppconRole.OpportunityId)){
                                                         contactRoleMap.put(oppconRole.OpportunityId,oppconRole.Contactid);
                                                     }
                                                 }
        if(opportunityList.size()>0){
            List<Task> taskList=new List<Task>();
            for(Opportunity opp:opportunityList){
                Task task1=new Task();
                task1.Subject=opp.Current_Status__c;
                if(contactRoleMap.containskey(opp.Id)){
                    task1.WhoId = contactRoleMap.get(opp.Id);
                }
                task1.Type='Update';
                task1.status='Completed';
                task1.OwnerId = opp.OwnerId;
                task1.ActivityDate=date.today();    
                task1.WhatId=opp.Id;
                taskList.add(task1);      
            }
            if(taskList.size()>0){
                insert taskList;
                isTaskCreated = true;
            }
        }
    }
    
    
    public static void setBDRTransfer(List<Opportunity> newOppList,Map<Id,Opportunity> oldMap,Map<Id,Opportunity> newMap){
        for(opportunity op : newOppList){
            if((oldMap.get(op.Id).Owner_Role__c != newMap.get(op.Id).Owner_Role__c) && (op.Owner_Role__c == 'BDR Sales Rep' || op.Owner_Role__c == 'BDR Manager')){
                op.BDR_Transfer_Date__c = null;
                op.BDR_Transfer__c = false;
            }
            else if((oldMap.get(op.Id).Owner_Role__c  != newMap.get(op.Id).Owner_Role__c) && (oldMap.get(op.Id).Owner_Role__c =='BDR Sales Rep' || oldMap.get(op.Id).Owner_Role__c =='BDR Manager')){
                op.BDR_Transfer_Date__c = system.today();
                op.BDR_Transfer__c = true;
                system.debug('Condition True');
            }
        }
    }
    
    
    public static void setPriceBook(List<Opportunity> newOppList){
        try{
            Id enterpriseRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
            Id retailPriceBook = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            Set<Id> OppId = new Set<Id>();
            system.debug('newOppList '+newOppList);
            if(newOppList.size() > 0){  
                List<OpportunityLineItem> oppListItems = [Select id,Opportunityid from OpportunityLineItem where Opportunityid IN:newOppList];
                For(OpportunityLineItem propp: oppListItems){
                    OppId.add(propp.Opportunityid);
                }
                system.debug('OppId '+OppId);
                for(Opportunity opp : newOppList){
                    if(!OppId.contains(opp.Id))
                        if(!opp.isClosed){
                            if(opp.RecordtypeId == enterpriseRecordType ){
                                opp.Pricebook2Id = Label.CPQ_Opportunity_EnterPrise_PriceBook;
                            }
                            if(opp.RecordTypeId == retailPriceBook ){
                                
                                opp.Pricebook2Id = Label.CPQ_Opportunity_Retail_PriceBook;
                            }
                        }
                }
            }
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    } 
    
    
    
    public static void aproveisPrimary(Set<Id> oppIdSet,Map<Id,Opportunity> oldMap){
        List<SBQQ__Quote__c > QuoteList = [SELECT Id,Name__c,SBQQ__Primary__c, SBQQ__Account__c, SBQQ__Opportunity2__c from SBQQ__Quote__c where SBQQ__Opportunity2__c =: oppIdSet];
        List<SBQQ__Quote__c> updatestatus = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quotup: QuoteList){
            if(quotup.SBQQ__Primary__c == True){
                quotup.SBQQ__Status__c = 'Approved';
                updatestatus.add(quotup);   
            }else{
                quotup.SBQQ__Status__c = 'Rejected';
                updatestatus.add(quotup); 
            }
        }
        Update updatestatus;
    }
    
    public static void PrimaryCampaignInfo(List<Opportunity> newOppList){
        for(Opportunity OppCamp: newOppList){
            String leadSource = Label.Opp_Lead_Source;
            String[] LeadSour = leadSource.split(',');
            if(OppCamp.CampaignId == Null && LeadSour.contains(OppCamp.LeadSource)){
                OppCamp.addError(System.Label.Opp_Primary_Campaign_Source);
            }else{
                system.debug('Record Inserted');
            }
        }
    }
    
    public static void PrimaryQuoteDA(Set<Id> SetOppID,Map<Id,Opportunity> oldMap){
        List<SBQQ__Quote__c > QuoteList = [SELECT Id,Name__c,SBQQ__Primary__c, SBQQ__Account__c, SBQQ__Opportunity2__c from SBQQ__Quote__c where SBQQ__Opportunity2__c =: SetOppID];
        List<SBQQ__Quote__c> updatestatus = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quotup: QuoteList){
            if(quotup.SBQQ__Primary__c == True){
                quotup.SBQQ__Status__c = 'Discount Approved';
                updatestatus.add(quotup);   
            }
        }
        Update updatestatus;
    }
    //System admin can only change owner of opportunity
    Public static void validateOpportunityTransfer(List<Opportunity> oppList , Map<Id,Opportunity> oldMap){
        List<String> profileList = label.System_Owner.split(',');
        Profile pro = [Select Id,Name From Profile WHere Id=:userInfo.getProfileId()];
        for(Opportunity opp : oppList){
            if(!profileList.contains(pro.Name) && userinfo.getUserId() != oldMap.get(opp.id).OwnerId && opp.OwnerId != oldMap.get(opp.id).OwnerId){
                opp.addError(system.label.Error_Owner_Transfer_on_Opportunity);
            }
        }
    }
    
    public static void updateTCVOnCampaign(List<Opportunity> oppList){
        List<Campaign> campListToUpdate = new List<Campaign>();
        Set<ID> oppCampList = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.CampaignId != null){
                system.debug('opp.CampaignId ' + opp.CampaignId);
                oppCampList.add(opp.CampaignId);
            }
        }
        for(Campaign cmp : [SELECT ID,Name,TCV_Value_Won_Opportunities__c,TCV_Value_Lost_Opportunities__c,TCV_Value_Opportunities_in_Campaign__c,(SELECT Id,Name,TCV__c,StageName FROM Opportunities) FROM Campaign WHERE Id IN: oppCampList]){
            Decimal totalTcv = 0 ;
            Decimal totalTcvWon = 0 ;
            Decimal totalTcvLost = 0;
            for(Opportunity op : cmp.opportunities){
                totalTcv += op.TCV__c;
                if(op.StageName == 'Closed Won'){
                    totalTcvWon += op.TCV__c;
                }else if(op.StageName == 'Closed Lost'){
                    totalTcvLost += op.TCV__c;
                }
            }
            cmp.TCV_Value_Opportunities_in_Campaign__c = totalTcv;
            cmp.TCV_Value_Lost_Opportunities__c = totalTcvLost;
            cmp.TCV_Value_Won_Opportunities__c = totalTcvWon;
            campListToUpdate.add(cmp); 
        }
        
        try{
            if(campListToUpdate.size() > 0){update campListToUpdate;}
        }catch(dmlexception e){}
    }
    
    public static void mostRecentClosedWon(Map<Id,Opportunity> newMapList, Map<Id,Opportunity> oldMapList){
         Set<Id> set_OppId = new Set<Id>();
        for(Id Key : newMapList.keySet()){
            Opportunity oppNew= newMapList.get(key);
            Opportunity oppOld= oldMapList.get(key);
            Id recordypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            if(oppNew.StageName != oppOld.StageName && oppNew.StageName == 'Closed Won' && oppNew.RecordTypeId == recordypeId){
                set_OppId.add(key);
            }
        }
        if(!set_OppId.isEmpty()){
            List<Contact> conList = new List<Contact>();
            for(OpportunityContactRole ocr : [SELECT ContactId, OpportunityId, Id  FROM OpportunityContactRole WHERE OpportunityId in : set_OppId]){
                
                Contact c=new Contact();
                c.id = ocr.ContactId;
                c.Most_Recent_Closed_Won_Retail_Opportunit__c = OCR.OpportunityId;
                conList.add(c);
            }
            if(!conList.isEmpty()){
                update conList;
            }
        }
    }
    
}