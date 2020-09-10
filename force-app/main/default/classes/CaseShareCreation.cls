public without sharing class CaseShareCreation{

 /*
    Method to give sharing permission to the community plus users 
    if user's contact account and case account are same.
    This functionality implemented for Incommon users
    Get incommon users , incommon users are able to see there own cases and channel partner cases.
    */
    public static void CommunityPlusCaseSharing(List<Case> newCaseList){
            //Case share to insert
            List<CaseShare> CaseShareListToInsert = new List<CaseShare>();
            Map<Id,Id> conUserInfo = new Map<Id,Id>(); // Map to hold contact,user
            Map<Id,Id> myconAcc = new Map<Id,Id>(); // Map to hold Accountid,contactid
            Map<Id,Id> myNewUser= new Map<Id,Id>(); // Map user,accountid
            Set<Id> myCaseAccountIds = new Set<Id>(); // set to hold case's accountid
            Map<Id,Account> myChannelPartnerAccounts; // Map to hold channelpartner account related to case account
            String loginUserId = userinfo.getUserId();
            String cpProfile = System.label.Chanel_Partner_CP;
            Id profileIdVar = [Select Id From Profile Where Name=:cpProfile].id;
            
            for(case eachCase : newCaseList){
                if(eachCase.Accountid != Null){
                    myCaseAccountIds.add(eachCase.Accountid);
                }
            }
            
            myChannelPartnerAccounts = new Map<Id,Account>([Select Id, Name, Channel_partner__c From Account Where Id In: myCaseAccountIds ]);
            system.debug('myChannelPartnerAccounts = '+myChannelPartnerAccounts );
            
            List<Contact> conList = new List<Contact>();
            
            //Query users
            List<User> lstUser = [Select id, name,AccountId, ContactId,Contact.Accountid,IsActive from User where profileId = : profileIdVar and IsActive =: true ];
            system.debug('userList= '+lstUser);
            Map<Id,List<User>> conUserMap = new Map<Id,List<User>>();
            if(!lstUser.isEmpty()){
                for(User eachUser : lstUser){
                    if(eachUser.contactId!=null){               
                        conUserInfo.put(eachUser.contactId,eachUser.Id);
                    }
                    
                    if(eachUser.Contact.Accountid!=null){                
                        myNewUser.put(eachUser.id,eachUser.Contact.Accountid);
                        myconAcc.put(eachUser.Contact.Accountid,eachUser.id); 
                    }
                    List<User> tempList = new List<User>();
                    if(conUserMap.containskey(eachUser.AccountId)){
                        tempList = conUserMap.get(eachUser.AccountId);
                    }
                    tempList.add(eachUser);
                    conUserMap.put(eachUser.AccountId,tempList);
                
                }
                system.debug('conUserMap >>'+conUserMap);
                system.debug('myNewUser >>'+myNewUser);
                system.debug('conUserInfo >>'+conUserInfo);
                for(Case eachCase : newCaseList){
                    system.debug('eachCase  >>'+eachCase); 
                    /*if(!conUserInfo.IsEmpty()|| conUserInfo != null){
                        System.debug('########Inside>>> foreach: '+conUserInfo );
                        if(eachCase.AccountId != null && eachCase.ContactId != Null ){
                            if(myconAcc.containsKey(myChannelPartnerAccounts.get(eachCase.Accountid).Channel_partner__c)){
                                for(Id singleUser : myNewUser.keySet()){
                                    system.debug('CHannel AccountId >>'+myChannelPartnerAccounts.get(eachCase.Accountid).Channel_partner__c);
                                    system.debug('myNewUser accountId >> '+myNewUser.get(singleUser));
                                    system.debug('loginUserId  >>'+loginUserId );
                                    system.debug('singleUser >>'+singleUser);
                                    if(loginUserId != singleUser){
                                        if(myChannelPartnerAccounts.get(eachCase.Accountid).Channel_partner__c==myNewUser.get(singleUser)){
                                            CaseShare newCaseShareRecord = new CaseShare();
                                            newCaseShareRecord.CaseAccessLevel = 'Edit';
                                            newCaseShareRecord.CaseId = eachCase.Id;
                                            newCaseShareRecord.UserOrGroupId = singleUser;
                                            newCaseShareRecord.RowCause = Schema.CaseShare.RowCause.Manual;
                                            CaseShareListToInsert.add(newCaseShareRecord);
                                        }
                                    }
                                }
                            }        
                        }
                    }*/
                    system.debug('eachCase.AccountId >>'+eachCase.AccountId);
                    if(conUserMap.containskey(eachCase.AccountId)){
                        for(User usr : conUserMap.get(eachCase.AccountId)){
                            system.debug('loginUserId  >>'+loginUserId );
                            system.debug('usr.Id >>'+usr.Id);
                            if(loginUserId != usr.Id){
                                CaseShare newCaseShareRecord = new CaseShare();
                                newCaseShareRecord.CaseAccessLevel = 'Edit';
                                newCaseShareRecord.CaseId = eachCase.Id;
                                newCaseShareRecord.UserOrGroupId = usr.Id;
                                newCaseShareRecord.RowCause = Schema.CaseShare.RowCause.Manual;
                                CaseShareListToInsert.add(newCaseShareRecord);
                            }
                        }
                    }
                }
            }
            system.debug('CaseShareListToInsert >>'+CaseShareListToInsert);
            if(!CaseShareListToInsert.isEmpty()){
                insert CaseShareListToInsert;
            }
    }
}