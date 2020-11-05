public class ContactOwnerRoleUpdate {
    
    public static void updatekeyconatct(List<Contact> conList, Map<Id,Contact> conOld, Map<Id,Contact> conNew,Map<Id,Account> accMap){
        Id RecordTypeIdCon = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        system.debug('Contact Enterprise Record Type:'+RecordTypeIdCon);
        Id retailRecordTypeIdCon = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        User conOwnerDefault = [SELECT ID,Name FROM User where Name='Ebrima N\'Dure' LIMIT 1];
        
        Map<String,ContactAssignment__c> caseAssignmentMapList = ContactAssignment__c.getAll();
        
        List<Id> ConID = New List<Id>(); 
        Set<String> roleset = new Set<String>();
        String role = Label.Roles;
        String[] rolees = role.split(',');
        integer roleesize =  rolees.size();
        for(integer i = 0; i < roleesize; i++){
            roleset.add(rolees[i]);
        }
        
        for(Contact con: conList){
            if(Con.AccountId != null && con.RecordTypeId == RecordTypeIdCon){
               if((conOld.get(con.Id).Owner_Role__c != conNew.get(con.Id).Owner_Role__c) && ((conOld.get(con.Id).Owner_Role__c =='BDR Sales Rep') || (conOld.get(con.Id).Owner_Role__c =='BDR Manager'))){
                    if(roleset.contains(con.Owner_Role__c)){
                        con.key_Contact__c = true;
                    }
                }    
            }  
            if(conOld.get(con.Id).MQL_Qualified__c == false &&  con.MQL_Qualified__c && caseAssignmentMapList.containsKey(con.Territory__c) && con.Territory__c != null && caseAssignmentMapList.get(con.Territory__c).OwnerId__c != null && caseAssignmentMapList.get(con.Territory__c).OwnerId__c != ''  && ( con.RecordTypeId == RecordTypeIdCon || con.RecordTypeId == retailRecordTypeIdCon ) ){
                   con.OwnerId =  caseAssignmentMapList.get(con.Territory__c).OwnerId__c ;
               }else if(conOwnerDefault.Id != null && conOld.get(con.Id).MQL_Qualified__c == false &&  con.MQL_Qualified__c ){
                   con.OwnerId =   conOwnerDefault.Id;   
               } 
        }
        
    }  
}