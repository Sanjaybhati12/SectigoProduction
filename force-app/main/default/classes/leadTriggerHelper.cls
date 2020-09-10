public class leadTriggerHelper{
    public static Boolean isChannelAssignment = false;
    public static Boolean isLeadAssignment = false;
    public static void setNoOfEmployee(List<Lead> leadList){
        for(Lead led : leadList){
            system.debug('led.HubSpot_Employee_Count__c >>'+led.HubSpot_Employee_Count__c);
            if(led.HubSpot_Employee_Count__c != null && led.NumberOfEmployees == null){
                if(led.HubSpot_Employee_Count__c.split('-').size() > 1){
                    if(Integer.valueOf(led.HubSpot_Employee_Count__c.split('-')[1]) <= 3000){
                        led.NumberOfEmployees = Integer.valueOf(led.HubSpot_Employee_Count__c.split('-')[1])-1;
                    }else{
                        led.NumberOfEmployees = Integer.valueOf(led.HubSpot_Employee_Count__c.split('-')[1]);
                    }
                }else{
                    led.NumberOfEmployees = Integer.valueOf(String.valueOf(led.HubSpot_Employee_Count__c).removeEnd('+'));
                }
            }
        }
    }
    
    
    public static void TerritoryAssignment(List<Lead> leadList){
        
        List<Account_Territory_based_on_Countries__c> setting = Account_Territory_based_on_Countries__c.getall().values();
        List<Account_Territory_based_on_US_States__c> USsetting = Account_Territory_based_on_US_States__c.getall().values();
        system.debug('territory settings: '+setting);      
        
        for(Lead leadRec : leadList){
            //United States,US,United States of America,USA,U.S.A
            if(leadRec.Country == 'United States' || leadRec.Country == 'United States of America' || leadRec.Country == 'USA'|| leadRec.Country == 'U.S.A'){
                leadRec.Country = 'US';
                system.debug(leadrec.Country);
            }else if(leadRec.Country == 'United Kingdom'){
                leadRec.Country = 'UK';
                //system.debug(leadrec.Country);
            }
            
            system.debug(leadrec.Country);
            
            for(Account_Territory_based_on_US_States__c usSates : USsetting ){
                //system.debug(leadrec.Country);
                if(leadRec.Country == 'US' || leadRec.Country == 'United States' || leadRec.Country == 'United States of America' || leadRec.Country == 'USA'|| leadRec.Country == 'U.S.A'){
                    if(usSates.Name == leadRec.State){
                        leadRec.Territory__c = usSates.Territory__c;
                        break;
                    }else if(usSates.Name != leadRec.State || String.isBlank(leadRec.State)){
                        leadRec.Territory__c = 'North America';
                    }
                }else if(String.isBlank(leadRec.Country) && String.isNotBlank(leadRec.State)){
                    if(usSates.Name == leadRec.State){
                        leadRec.Territory__c = usSates.Territory__c;  
                        break;                    
                    }else if(usSates.Name != leadRec.State){
                        leadRec.Territory__c = 'North America';                      
                    }
                }
            }
            
            for(Account_Territory_based_on_Countries__c tABC : setting){
                //system.debug(leadrec.Country);
                if(String.isNotBlank(leadRec.Country) && (leadRec.Country != 'US' || leadRec.Country != 'United States' || leadRec.Country != 'United States of America' || leadRec.Country != 'USA'|| leadRec.Country != 'U.S.A')){              
                    if(tABC.Name == leadRec.Country){
                        leadRec.Territory__c = tABC.Territory__c;
                    }
                }else if(String.isBlank(leadRec.Country) && String.isNotBlank(leadRec.State)){
                    if(tABC.Name == leadRec.State){
                        leadRec.Territory__c = tABC.Territory__c;                      
                    }
                }
            }
        }
    }
    public static void RoundRobinFunctionality(list<Lead> leadList){
        Integer myNumber;
        if(!Test.isRunningTest()){
            Lead myLeadCnt = [select id,RR_Number__c from lead WHERE RR_Number__c != null ORDER BY CreatedDate DESC limit 1];
            
            myNumber =Integer.ValueOf(myLeadCnt.RR_Number__c);
            
        }else{
            myNumber=2;
        }    
        
        for(Lead eachLead : leadList){
            system.debug('Trigger Lead Segment>>'+eachLead.Segment__c);
            if(eachLead.Segment__c != 'Partner/Reseller'){
                system.debug('eachLead.S_MIMEs__c  >>'+eachLead.S_MIMEs__c );
                // according to lead assignment rules, when smime is not null hubspot_employee_Count: 1-10,11-100,101-250,1-250,251-500
                if((eachLead.S_MIMEs__c == '1-10' || eachLead.S_MIMEs__c == '11-50' || eachLead.S_MIMEs__c == Null) && (((eachLead.HubSpot_Employee_Count__c == '1-10') || (eachLead.HubSpot_Employee_Count__c == '11-100') || (eachLead.HubSpot_Employee_Count__c == '101-250') || (eachLead.HubSpot_Employee_Count__c == '1-250') || (eachLead.HubSpot_Employee_Count__c == '251-500')) || (eachLead.NumberOfEmployees <= 500))){
                    system.debug('Inside condition');
                    myNumber = myNumber+1;
                    
                    eachLead.RR_Number__c = myNumber;
                    
                }   
            }
        }
    }  
    public static void fireLeadAssignment(List<Lead> leadList){
        List<Lead> leadToUpdate = new List<Lead>();
        for(Lead led : [Select l.LastModifiedBy.Alias, l.Id From Lead l WHERE Id IN:leadList]){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true; 
            dmo.EmailHeader.triggerUserEmail = true;
            led.setOptions(dmo);
            leadToUpdate.add(led);
        }
        
        if(leadToUpdate.size() > 0){
            update leadToUpdate; 
            leadTriggerHelper.isLeadAssignment = true;
        }
    }
    
    public static void roundRobinQueue(List<Lead> LeadList, String queueName){
        
        List<Lead> leadToUpdate = new List<Lead>();
        Set<Id> userIdSet = new Set<Id>();
        Map<Id,Integer> userCountMap = new Map<Id,Integer>();
        List<leadWrapper> userCountList = new List<leadWrapper>();
        Group ExpQueue = [Select Id ,Group.Name from Group where Type = 'Queue' AND Name =: queueName LIMIT 1];
        system.debug('ExpQueue >>'+ExpQueue);
        for(Lead le :LeadList){
            if(le.OwnerId == ExpQueue.Id){
                leadToUpdate.add(le);
            }
        }
        system.debug('leadToUpdate >>'+leadToUpdate);
        if(leadToUpdate.size() > 0){
            leadToUpdate = [Select Id,OwnerId,Owner.Email From Lead Where Id IN:leadToUpdate];
            for(GroupMember gm : [Select UserOrGroupId From GroupMember where GroupId =:ExpQueue.Id]){
                userCountMap.put(gm.UserOrGroupId,0);
                userIdSet.add(gm.UserOrGroupId);
            } 
            system.debug('135 - ExpQueue.Name ' + ExpQueue.Name);
            if( ExpQueue.Name != System.Label.Retail_Queue_Round_Robin_Queue_Name){
                for(AggregateResult ar : [Select count(Id) usrCnt,ownerId From Lead Where OwnerId IN:userIdSet Group by OwnerId ]){
                    userCountMap.put(String.valueOf(ar.get('ownerId')),Integer.valueOf(ar.get('usrCnt')));
                    system.debug('User >>'+String.valueOf(ar.get('ownerId'))+' Count > '+Integer.valueOf(ar.get('usrCnt')));
                } 
            }else{
                Map<String, Retail_Round_Robin__c> userwithleadsCount = Retail_Round_Robin__c.getAll();
                for(Retail_Round_Robin__c rr : userwithleadsCount.values() ){
                    userCountMap.put(String.valueOf(rr.UserId__c),Integer.valueOf(rr.Count__c));
                    system.debug('User >>'+String.valueOf(rr.UserId__c)+' Count > '+Integer.valueOf(rr.Count__c));
                }
            }
            system.debug('userCountMap.keyset() ' + userCountMap.keyset());
            for(id key : userCountMap.keyset()){
                leadWrapper lw = new leadWrapper(key,userCountMap.get(key));
                userCountList.add(lw);
            }
           
            for(Lead le : leadToUpdate){
                userCountList.sort();
                if(userCountList.size() > 0){
                    le.ownerId = userCountList[0].userId;
                    userCountList[0].count += 1;
                } 
            }
            
            if(leadToUpdate.size() > 0){
                system.debug('leadToUpdate ' + leadToUpdate);
                if(trigger.isAfter){
                    update leadToUpdate;
                    leadToUpdate = [Select Id,OwnerId,Owner.Email From Lead Where Id IN:leadToUpdate];
                    if( ExpQueue.Name == System.Label.Retail_Queue_Round_Robin_Queue_Name){
                        channelPartnerOwnerNotification(leadToUpdate,System.Label.Media_to_Retail_Notification_Email_Template);
                        updateRoundRobinCustomRecords(userCountList);  // update custom settings - userCountList                  
                    }else{
                        channelPartnerOwnerNotification(leadToUpdate,System.Label.Channel_Partner_Round_Robin_Email_Template);
                    }
                 //   channelPartnerOwnerNotification(leadToUpdate);
                }
                isChannelAssignment = true;
            }
        }
    }
    
    public static void channelPartnerOwnerNotification(List<Lead> leadList, String templatename){
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress Where DisplayName=:System.Label.Channel_Partner_Round_Robin_Email_From_Address limit 1];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName=:templatename ORDER BY LastModifiedDate];
        String emailTemplateId = '';
        if(lstEmailTemplates.size() > 0){
            emailTemplateId  = lstEmailTemplates[0].Id;
        }
        for(Lead led : leadList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateID(emailTemplateId); 
            mail.setTargetObjectId(led.Id);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(false);
            mail.setToAddresses(new List<String>{led.Owner.Email});
            mail.setOrgWideEmailAddressId(owa.id);
            allmsg.add(mail);
            
        }
        if(allmsg.size() > 0){
            Messaging.sendEmail(allmsg,false);
        }
    }
    public static void updateRoundRobinCustomRecords(List<leadWrapper> leadsCountList){
        Map<String, Retail_Round_Robin__c> userwithleads = Retail_Round_Robin__c.getAll();
        List<Retail_Round_Robin__c> roundRobinList = new List<Retail_Round_Robin__c>();
        system.debug('userwithleads ' + userwithleads);
        for(leadWrapper lw :leadsCountList){
            system.debug('200 ' + lw);
            system.debug(userwithleads.get(lw.userId));
            try{Retail_Round_Robin__c r = userwithleads.get(lw.userId);
                if(r.UserId__c == lw.userId){
                    r.count__c = lw.count;
                    roundRobinList.add(r); 
                }
               }catch(exception e){}
            
        }
        if(roundRobinList.size() > 0){
            update roundRobinList;
        }
        
    }
    public class leadWrapper implements Comparable {
        public string userId;
        public Integer count;
        
        public leadWrapper(String userId,Integer count){
            this.userId = userId;
            this.count = count;
        }
        public Integer compareTo(Object objToCompare) {
            return Integer.valueOf(count- (((leadWrapper)objToCompare).count));
        }
    }
}