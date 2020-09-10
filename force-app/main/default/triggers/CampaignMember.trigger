trigger CampaignMember on CampaignMember (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        List<CampaignMember> campMemList = new List<CampaignMember>();
        List<CampaignMember> channelPartnerMember = new List<CampaignMember>();
        List<CampaignMember> contactNotificationList = new List<CampaignMember>();
        List<CampaignMember> campaignMemList = [Select Id,type__c,Lead.Segment__c,contact.recordType.Name,Lead.Id,Contact.Account.Owner.email,Account_Owner_Email__c,ContactId From CampaignMember Where Id IN:trigger.new];
        for(CampaignMember cm : campaignMemList){
            if(cm.Type__c == 'WebForm'){
                campMemList.add(cm);
                if(cm.ContactId != null){
                    contactNotificationList.add(cm);
                }
            }
            
        }
        system.debug('Campaign Member Call');
        if(campMemList.size() > 0){
             campaignMemberHelper.sendTaskNotification(campMemList);   
        }
        if(contactNotificationList.size() > 0){
            system.debug('contactNotificationList >> '+contactNotificationList);
            campaignMemberHelper.sendContactNotification(contactNotificationList);
        }
    }
    
    if(trigger.isInsert && trigger.isAfter){
        campaignMemberHelper.updateLeadOwner(trigger.new);
    }
     
}