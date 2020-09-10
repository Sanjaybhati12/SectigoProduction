public without sharing class EmailNotification{
    /**
    * Method to notify enterprise account owners if new case creates. Only Case Creation . For certain role account owners  
    * @param triggerNew 
    * @return none
    **/
    public Static Void NotifyAccountOwner(List<Case> caseList){
        
        Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
        Set<Id> myAccID= new Set<Id>();
        //Check the Case Account is Enterprise Record Type or not. 
        //Get the Role names from custom settings
        Map<String, EnterpriseAccountNotification__c> allRoles = EnterpriseAccountNotification__c.getAll();
        List<case> enterCase= new List<Case>(); 
        for(Case eachCse : caseList){
            if(eachCse.Accountid!=null ){
                myAccID.add(eachCse.Accountid);
            }
        }
        if(myAccID.size()>0){
            List<Account> myallAcc=[select id,name,recordtypeid,Owner.id,Owner.UserRole.Name from Account where id IN:myAccID];
            Set<Id> useId = new Set<Id>(); //User id set
            //Query from Users
            for(Account oneMyAcc : myallAcc){
                useId.add(oneMyAcc.Owner.id);
            }  
            List<User> allMyusers=[Select id,Alias,UserRoleId,UserRole.Id,UserRole.Name,UserRole.DeveloperName,Email from User where id IN:useId];
            Map<id,String> allUserMa= new Map<Id,String>(); //User id,role developer name
            Map<id,User> allUserMa2= new Map<Id,User>(); //User id, USer Record
            for(User eachUS :allMyusers){
                if(eachUS.UserRole.Name!=null){
                    allUserMa.put(eachUS.id,eachUS.UserRole.DeveloperName);
                    allUserMa2.put(eachUS.id,eachUS);
                }
            }
            //Filter only Enterprise Record Types 
            Map<Id,Id> myTemp= new Map<Id,Id>();
            Set<Id> userRoleInfo = new Set<Id>();
            for(Account filterAcc : myallAcc){
                String userrle='';
                if(allUserMa.containskey(filterAcc.Owner.id))
                    userrle= allUserMa.get(filterAcc.Owner.id);
                if(userrle!=null){
                    //Check the enterprise Record Type and account owner from roles
                    if(filterAcc.recordtypeid==AccRecordTypeId && allRoles.containsKey(userrle)){
                        userRoleInfo.add(filterAcc.Owner.id);
                        myTemp.put(filterAcc.id,filterAcc.Ownerid);
                    }
                }
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();  
            //Query Email Template
            String myTemplt=Label.Enterprise_Account_Noti;
            EmailTemplate tpl = [select Id,Name,subject,DeveloperName,HtmlValue,Body FROM EmailTemplate WHERE DeveloperName=:myTemplt limit 1];
            //Set Org email from custom label
            String myOrg=Label.OrgWideEmail;
            OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where Address =: myOrg];
            
            for(Case myfinalCase: caseList){
                if(myfinalCase.Accountid!=null){
                    if(myTemp.containsKey(myfinalCase.Accountid)){
                        String userid2='';
                        //Send an email id to the user
                        if(allUserMa2.containskey(myTemp.get(myfinalCase.Accountid))){
                            userid2=allUserMa2.get(myTemp.get(myfinalCase.Accountid)).id;
                            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tpl.Id, userid2,myfinalCase.id);
                            String emailSubject = email.getSubject();
                            String emailHtmlBody = email.getHtmlBody();
                            email.setTargetObjectId(userid2);
                            email.setSubject(emailSubject);
                            email.setHtmlBody(emailHtmlBody);
                            email.saveAsActivity = false;
                            if(owea.size()>0){
                                email.setOrgWideEmailAddressId(owea.get(0).Id);
                            }
                            mails.add(email); 
                        }
                    }
                }
            }
            
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
        }
    }
}