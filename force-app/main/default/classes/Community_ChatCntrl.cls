public class Community_ChatCntrl {
    public String currentchatId {get;set;}
    public Community_ChatCntrl(){
       currentchatId  = ApexPages.CurrentPage().getparameters().get('id');
    }
}