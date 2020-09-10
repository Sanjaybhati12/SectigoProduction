public class ArticleData {
    @AuraEnabled
    public static List<Integer> getDataMonth(){
        Integer currentMonth = Date.Today().Month();
        List<Integer> monthList = new List<Integer>();
        List<Community_NewsLetter__c>  ArticleData = [select id, Name,Link__c,Type__c,Date__c from Community_NewsLetter__c order by createddate desc];
        for(Community_NewsLetter__c cn : ArticleData){
            if(cn.Date__c != null){
                if(!monthList.contains(cn.Date__c.Month())){
                    monthList.add(cn.Date__c.Month());
                }
            }
        }
        return monthList;
    }
}