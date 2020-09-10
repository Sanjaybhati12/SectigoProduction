public class sobjectwrapperclass {
    @AuraEnabled
    public List<SObject> cases{get;set;}
    @AuraEnabled
    public List<SObject> knowArtles {get;set;}
    @AuraEnabled
    public Integer caseCount {get;set;}
     @AuraEnabled
    public Integer knowCount {get;set;}
    public sobjectwrapperclass(){
        cases = new List<SObject>();
        knowArtles = new List<SObject>();
    }  
}