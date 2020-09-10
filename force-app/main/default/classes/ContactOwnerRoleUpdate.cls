public class ContactOwnerRoleUpdate {
    
    public static void updatekeyconatct(List<Contact> conList, Map<Id,Contact> conOld, Map<Id,Contact> conNew,Map<Id,Account> accMap){
        Id RecordTypeIdCon = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        system.debug('Contact Enterprise Record Type:'+RecordTypeIdCon);
        
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
        }
        
    }  
}