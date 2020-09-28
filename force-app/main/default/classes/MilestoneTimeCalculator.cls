global class MilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {   

    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        String businesshourId =system.label.COMODO_Support_Business_Hours;
        List<Case> listOfCase = [select id,status,reason,EntitlementId,Priority,Account.Enterprise_Premier__c,entitlement.servicecontractid,entitlement.servicecontract.name from case where id=:caseId];
        Integer timeToreturn = 2;
            Map<string,SLA_Setting__c> slaSettings = SLA_Setting__c.getAll();
     /*  if(listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('CCM support')){
         businesshourId = system.label.CCM_Business_Hours;
       }else{
         businesshourId = system.label.COMODO_Support_Business_Hours;      
       } */
       
       
       //Get the Case Reasons from Custom Settings
        Map<String, mileStoneCaseReason__c> vMapNameCustomSett = mileStoneCaseReason__c.getAll();
        system.debug('>>>>'+ vMapNameCustomSett.keyset());
        Set<String> setKeys = new Set<String>();
        for(mileStoneCaseReason__c ms : vMapNameCustomSett.values()){
            setKeys.add(ms.Label__C);        
        }
       
       // if(listOfCase[0].reason == 'HackerGuardian Partner Inquiry' || listOfCase[0].reason == 'Customer Feedback' || listOfCase[0].reason == 'Consumer Relations' || listOfCase[0].reason == 'Certificate Manager'){
       if(setKeys.contains(listOfCase[0].reason) ) {
         businesshourId = system.label.CCM_Business_Hours;
       }else{
         businesshourId = system.label.COMODO_Support_Business_Hours;      
       }
         
            MilestoneType mt = [SELECT Name FROM MilestoneType WHERE Id=:milestoneTypeId];
            
            if(listOfCase[0].Account.Enterprise_Premier__c == true){
              if(mt.Name.equalsIgnoreCase('Initial SLA')){
                if(listOfCase[0].priority == 'Low'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Enterprise_Premier_LP__c);               
                }else if(listOfCase[0].priority == 'Medium (L3)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Enterprise_Premier_MP__c);                    
                }else if(listOfCase[0].priority == 'High (L2)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Enterprise_Premier_HP__c);                    
                }else if(listOfCase[0].priority == 'Critical (L1)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Enterprise_Premier_CP__c);                    
                } 
              }else if(mt.Name.equalsIgnoreCase('Followup SLA')){
                if(listOfCase[0].priority == 'Low'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Enterprise_Premier_LP__c);               
                }else if(listOfCase[0].priority == 'Medium (L3)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Enterprise_Premier_MP__c);                    
                }else if(listOfCase[0].priority == 'High (L2)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Enterprise_Premier_HP__c);                    
                }else if(listOfCase[0].priority == 'Critical (L1)'){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Enterprise_Premier_CP__c);                    
                } 
              }
            }else{
              if(mt.Name.equalsIgnoreCase('Initial SLA')){
                if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('CCM support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Time_for_Enterprise_Support__c);               
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('General Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Time_for_Support__c);                    
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('Retail Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Retail_Support_Intial_SLA__c);                    
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('Partner/Reseller Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Initial_SLA_Time_for_Partner_Support__c);                    
                } 
              }else if(mt.Name.equalsIgnoreCase('Followup SLA')){
                if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('CCM support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Time_for_Enterprise_Support__c);               
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('General Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Time_for_Support__c);                    
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('Retail Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Retail_Support_Followup_SLA__c);                    
                }else if(listOfCase[0].entitlement.servicecontract.name != null  &&  listOfCase[0].entitlement.servicecontract.name.equalsIgnoreCase('Partner/Reseller Support')){
                   timeToreturn = Integer.valueOf(slaSettings.get('TIME').Followup_SLA_Time_for_Partner_Support__c);                    
                } 
              }
            }
             if(businesshourId != null){
                DateTime dt = BusinessHours.add(businesshourId, system.now(), (timeToreturn*60*1000));
                system.debug('DateTime----> '+dt);
                timeToreturn = Integer.valueOf((dt.getTime() - system.now().getTime())/1000/60);
                system.debug('After--->'+timeToreturn); 
            } 
            return timeToreturn;    
        }
        
       }