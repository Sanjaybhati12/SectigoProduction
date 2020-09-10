/** Class Name   : com_CreateContactCntrl 
*  Description  : Convenience class that can be called from com_CreateContact lightning component to get the current Case Info
*  Created By   : Agile Cloud Consulting 
*  Created On   : 02 May 2019
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class com_CreateContactCntrl {
    /**
* @description : To get Case Information  
* @param : 
* @return : string
**/
    @AuraEnabled
    public static com_CreateAccContWrapper getOpenCases(String caseId){
        system.debug('$$$$$caseId$$$'+caseId);
        com_CreateAccContWrapper mywrap= new com_CreateAccContWrapper();
        Case myCse=[select id,casenumber,contactid,accountid, SuppliedName, Web_Company_Name__c ,SuppliedCompany, SuppliedEmail, SuppliedPhone    from case where id=:caseId limit 1];
        if(myCse.accountid!=null && myCse.ContactId!=null)
         mywrap.isPopup=false;
        
        if(myCse.accountid!=null)
            mywrap.Accountid=myCse.accountid;
        if(myCse.ContactId!=null)
            mywrap.ContactId=myCse.ContactId;
        if(myCse.SuppliedName!=null){
            if(myCse.SuppliedName.containsWhitespace()){
                String[] temp= myCse.SuppliedName.split(' ', 2);
                mywrap.ConFirst=temp[0];
                mywrap.ConSecond=temp[1]; //mywrap.ConFirst=
            }else{
                mywrap.ConSecond=myCse.SuppliedName; //mywrap.ConFirst=
            }
        }
        if(myCse.SuppliedEmail!=null)
            mywrap.ConEmail= myCse.SuppliedEmail;// myCse.SuppliedCompany;      
        if(myCse.SuppliedPhone !=null)
            mywrap.ConPhone=myCse.SuppliedPhone;
        if(myCse.Web_Company_Name__c!=null)
            mywrap.AccName=myCse.Web_Company_Name__c;
        
        mywrap.AccSource='Webform';
        mywrap.AccWebForm='Support Ticket Page';
        mywrap.myCase=myCse;
        
        System.debug('####mywrap###'+mywrap);
        return mywrap;
    }
    /**
* @description : Create Account, Contact and update the case.  
* @param : 
* @return : string
**/
    @AuraEnabled
    public static String createAccCon(String accN,String accS,String accB,String accW,String conF,String conL,String conE,String conP,Case ce,String selecteAccId){
        try{
           
            Boolean isConExist=false;
           
            Case myCse1=[select id,casenumber,contactid,accountid, SuppliedName, Web_Company_Name__c ,SuppliedCompany, SuppliedEmail, SuppliedPhone    from case where id=:ce.id limit 1];

            
            Id conTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            
            //Create a Contact
            Contact c= new Contact();
            if(myCse1.ContactId==null){
                //Check contact exists in sfdc with email
                List<Contact> con= new List<Contact>();
                if(conE!=null)
                    con=[select id,email from contact where email=:conE AND email!=null limit 1];
                if(con.size()>0){
                    c=con[0];
                }else{
                    //create a new contact
                    if(conF!=null)
                        c.firstname=conF;
                    if(conL!=null)
                        c.LastName=conL;
                    if(conE!=null)
                        c.Email=conE;
                    if(conP!=null)
                        c.Phone=conP;
                    c.RecordTypeId=conTypeId;
                    c.AccountId=selecteAccId;
                    insert c;
                }
                
            }else{
                c.id=myCse1.ContactId;
               // c.AccountId=selecteAccId;
                //update c;
                isConExist=true;
            }
            //Update the case
            Case myCse= new Case();
            myCse=myCse1;
            if(isConExist==true)
                myCse.AccountId=selecteAccId;
            else if(isConExist==false){
                myCse.ContactId=c.Id;
                myCse.AccountId=selecteAccId;
            }
            update myCse;
            system.debug('$$myCse$$After update$'+myCse);
            return 'Created';
        }   catch(DmlException ex){
            // throw new AuraHandledException('User-defined error');
            // Database.rollback(sp3);
            
            throw new AuraHandledException(ex.getMessage());
        }
        
        
    }
}