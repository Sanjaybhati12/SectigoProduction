public class OpportunityContactRoleHelperClass {
    
    public static void contactcampmember(Map<ID, OpportunityContactRole> mapopportunity){
        Map<ID,id> SetConIds = new Map<ID,id>();
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> conIdSet = new Set<Id>();
        Map<ID, OpportunityContactRole> opprolemap = new Map<ID, OpportunityContactRole>();
        for(OpportunityContactRole oppconlist:[Select id,OpportunityId,IsPrimary,ContactId from OpportunityContactRole where OpportunityId=:mapopportunity.keyset() order by isprimary desc,createddate] ){
            //oppIdSet.add(oppconList.OpportunityId);
            //if(oppconlist.IsPrimary)
            SetConIds.put(oppconlist.Opportunityid,oppconlist.ContactId);
            // else if(!SetConIds.containskey(oppconlist.Opportunityid))
            //SetConIds.put(oppconlist.Opportunityid,oppconlist.ContactId);  
            opprolemap.put(oppconlist.id,oppconlist);
            conIdSet.add(oppconlist.ContactId);
        }
        system.debug('SetConIds'+SetConIds);
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id,CampaignId From Opportunity WHere Id In: SetConIds.keyset()]);
        Map<id,Id>camapignidmap = new Map<id,Id>();
        for(CampaignMember campgn: [SELECT Id, CampaignId, ContactId,CreatedDate , Status, Name, FirstName FROM CampaignMember where ContactId =:conIdSet ORDER BY CreatedDate asc ]){
            camapignidmap.put(campgn.ContactId,campgn.CampaignId);
            system.debug('camapignidmap'+camapignidmap);
        }
        
        Map<id,Opportunity> oppList = new Map<id,Opportunity>();
        for(OpportunityContactRole oppcon: opprolemap.values()){
            if(camapignidmap.containsKey(oppcon.ContactId)){
                
                if(oppMap.containsKey(oppcon.OpportunityId) && !oppList.containsKey(oppcon.OpportunityId)){
                    if(oppMap.get(oppcon.OpportunityId).CampaignId ==null){
                        Opportunity o = new Opportunity();
                        o.id = oppcon.OpportunityId;
                        o.CampaignId = camapignidmap.get(oppcon.ContactId);
                        oppList.put(oppcon.OpportunityId,o);
                    } 
                }
            }
            
        }
        
        update oppList.values();
    }
    public static void DMCheckboxupdate(List<OpportunityContactRole> newOppConList){
        
        List<Id> OppList = new List<Id>();
        for(OpportunityContactRole oppcon : newOppConList){
            if(oppcon.OpportunityId != Null){
                OppList.add(oppcon.OpportunityId);
            }
        }
        system.debug('Opp Id'+OppList);
        List<Opportunity> oppdata = [Select Id,DM_Identified__c	from Opportunity where Id =:OppList ];
        system.debug('Opp List'+oppdata);
        
        List<Opportunity> oList = New List<Opportunity>(); 
        if(oppdata.size()>0){
            for(Opportunity o : oppdata){
                system.debug('Opp List'+o);
                if(o.DM_Identified__c != True){
                    system.debug('DM Checker is false');
                    o.DM_Identified__c = True;
                    oList.add(o);
                }
            }
            system.debug('DM Checker is false'+oList);
            try{
                update oList;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    } 
    
}