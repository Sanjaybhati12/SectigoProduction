public class spamlistButton{
    
    private ApexPages.StandardSetController standardController;
    public integer succRec{set;get;}
    public String Message {set;get;}
    public String DisplayErrorMessage {set;get;}
    
    public spamlistButton(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
    }
    
    public PageReference doSubmit(){
        //System.debug('$$$$$$filtername$$$'+ApexPages.currentPage().getParameters().get('retURL'));
        
        List<Case> casetoUpdate= new List<Case>();
        try{
            List<Case> selectedCases = (List<Case>) standardController.getSelected();
            
            if(selectedCases.isEmpty()){
                Message ='error1';
            }else{
                for(Case eachcase: selectedcases){
                    eachcase.Reason='Not a Support Request';
                    eachcase.Status='Closed';
                    eachcase.AccountId=Label.Unknown_Account;
                    eachcase.ContactId=Label.Unknown_Contact;
                    eachcase.Closing_Note1__c='Spam';
                    casetoUpdate.add(eachcase);
                }
                
                if(!casetoUpdate.isEmpty()){
                    Update casetoUpdate;
                }
                succRec=selectedcases.size();
                Message ='Success';
            }
        }catch(DmlException ex){
            Message ='error2';
            DisplayErrorMessage = String.valueof(ex.getDmlMessage(0));
        }
        return null;
    }
}