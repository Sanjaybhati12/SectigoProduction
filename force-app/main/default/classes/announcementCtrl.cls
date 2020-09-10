public class announcementCtrl { 
    public List<announcementWrapper> announceList {get;set;}
    public announcementCtrl() {
        announceList = new List<announcementWrapper>();
        for(Announcement__c announce : [SELECT Id, Name,createdDate, Title__c,Priority__c FROM Announcement__c where Priority__c = 'High' order by createdDate desc]){
            announcementWrapper aw = new announcementWrapper();
            Integer days = system.today().daysBetween(date.valueOf(announce.createdDate));
            days =  days*(-1);
            if(days <= 30){
                aw.isNew = true;
            }
            aw.announcement = announce;
            announceList.add(aw);
        }
    }
    public class announcementWrapper{
        public Announcement__c announcement {get;set;}
        public boolean isNew {get;set;}
        
    }
}