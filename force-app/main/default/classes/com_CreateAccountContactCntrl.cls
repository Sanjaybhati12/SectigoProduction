/** Class Name   : com_CreateAccountContactCntrl 
*  Description  : Convenience class that can be called from com_CreateAccountContact lightning component to get the current Case Info
*  Created By   : Agile Cloud Consulting 
*  Created On   : 30th January 2019
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class com_CreateAccountContactCntrl {
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
    public static String createAccCon(String accN,String accS,String accB,String accW,String conF,String conL,String conE,String conP,Case ce){
        try{
            Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
            Boolean isAccExist=false;
            Boolean isConExist=false;
            String accName;
            if(conE!=null){
              accName = conE.split('@').get(1);
            }
            System.debug('>>>accName>>'+accName);
            Case myCse1=[select id,casenumber,contactid,accountid, SuppliedName, Web_Company_Name__c ,SuppliedCompany, SuppliedEmail, SuppliedPhone    from case where id=:ce.id limit 1];

            //Create an account
            Account a = new Account();
            if(myCse1.AccountId==null){
                List<Account> seaAcc = new List<Account>();
                if(accName!=null)
                    seaAcc= [select id,name from Account where name=:accName AND name!=null limit 1];
                if(seaAcc.size()>0){
                    a=seaAcc[0];
                }else{
                    a.Name=accN;
                    if(accS!=null)
                        a.AccountSource=accS;
                    if(accB!=null)
                        a.BillingCountry=accB;
                    a.RecordTypeId=recTypeId;
                    insert a;
                }
                
            }else{
                a.id=myCse1.AccountId;
                isAccExist=true;
            }
            //a.accountwebform
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
                    if(conF!=null)
                        c.firstname=conF;
                    if(conL!=null)
                        c.LastName=conL;
                    if(conE!=null)
                        c.Email=conE;
                    if(conP!=null)
                        c.Phone=conP;
                    c.RecordTypeId=conTypeId;
                    c.AccountId=a.id;
                    insert c;
                }
                
            }else{
                c.id=myCse1.ContactId;
                isConExist=true;
            }
            //Update the case
            Case myCse= new Case();
            myCse=myCse1;
            if(isConExist==true && isAccExist==true){
                return 'alreadyExists';
            }else if(isConExist==false && isAccExist==true){
                myCse.ContactId=c.Id;
            }else if(isConExist==true && isAccExist==false){
                myCse.AccountId=a.id;
            }else if(isConExist==false && isAccExist==false){
                myCse.AccountId=a.id;
                myCse.ContactId=c.Id;
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