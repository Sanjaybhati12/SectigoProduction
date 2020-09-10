public class Sec_dealRegistrationCtrl{
    
    //Account and Contact Information
    public String companyName {get;set;}
    public String keyStakeholderFirstName {get;set;}
    public String keyStakeholderLastName {get;set;}
    public String titlePosition {get;set;}
    public String phoneNumber {get;set;}
    public String emailAddress {get;set;}
    public String streetAddress {get;set;}
    public String cityVal {get;set;}
    public String postalCodeVal {get;set;}
    public String countryVal {get;set;}
    public String stateVal {get;set;}
    
    //Opportunity Information
    public String oppNamePartnerCRM {get;set;}
    public String oppDescription {get;set;}
    public String sectigoClientDiscovery {get;set;}
    public Date sectigoClientDiscoveryOn {get;set;}
    public Date expectedCloseDate {get;set;}
    public Decimal expectedOppVal {get;set;}
    public String productInterest {get;set;}
    
    //Partner Information
    public String partnerCompanyName {get;set;}
    public String leadSourceVal {get;set;}
    public String partnerAccountManagerFirstName {get;set;}
    public String partnerAccountManagerLastName {get;set;}
    public String partnerEmailAddress {get;set;}
    public String partnerPhoneNumber {get;set;}
    public string areYouCurrentWorking {get;set;}
    public Id accountRecTypeId ;
    public Id contactRecTypeId ;
    public Id oppRecTypeId ;
    
    List<Account> accountList;
    List<Contact> contactList;
    List<Account> partnerAccountList;
    List<Pricebook2> Pricebookname;
    List<Contact> partnerContactList;
    list<Contact> contactToInsert;
    list<Contact> partnerContactToInsert;
    List<opportunity> oppToInsert;
    List<Contact> contactsToAddToContactRoles;
    List<OpportunityContactRole> ocrList;
    String partnerDomain;
    public String hasError {get;set;}
    
    public Sec_dealRegistrationCtrl(){
        System.debug('sectigoClientDiscovery'+sectigoClientDiscovery);
        
        partnerDomain  = '';
        accountList = new List<Account>();
        contactList = new List<Contact>();
        contactToInsert = New List<Contact>();
        oppToInsert = new List<Opportunity>();
        partnerContactToInsert = New List<Contact>();
        Pricebookname = New List<Pricebook2>([Select Id, Name from Pricebook2 where Name =: Label.Pricebook_Name]);
        partnerAccountList = new List<Account>();
        partnerContactList = new List<Contact>();
        contactsToAddToContactRoles = new List<Contact>();
        ocrList = new List<OpportunityContactRole>();
        hasError = 'Test';
    }
    public List<SelectOption> getProductInterstOptions() {
        List<SelectOption> productInterest = new List<SelectOption>();
        List<DealRegistrationProductInterest__c> interestList = DealRegistrationProductInterest__c.getall().values();
        productInterest.add(new SelectOption('','-None-'));
        for(DealRegistrationProductInterest__c dpi : interestList ){
            productInterest.add(new SelectOption(dpi.value__c,dpi.Name));
        }
        return productInterest;
    }
    //Radio button Options
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No'));  
        return options; 
    }
    
    public void checkCountry(){
        system.debug('Country >> '+countryVal);
    }
    
    //Action called on submit button
    public void SubmitAction(){
        if(!(string.valueOf(expectedOppVal)).isNumeric()){
            hasError = '';
        }else{
            System.debug('companyName'+companyName);
            Boolean isFirstContact = true;
            accountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
            System.debug('recordtype id of account: '+accountRecTypeId );
            contactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
            System.debug('recordtype id of contact: '+contactRecTypeId );
            oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Enterprise').getRecordTypeId();
            System.debug('recordtype id of opportunity: '+oppRecTypeId );
            
            List<User> userList = new List<User>([Select ID, Name From User Where Name =: 'Heather Bell' Limit 1]);
            
            User BonnieId = [SELECT Id FROM User where Name = 'Heather Bell'];
            
            if(companyName != Null && cityVal != Null){
                accountList = [Select Id, Name, Segment__c,ShippingCity,ShippingStreet,ShippingState,ShippingPostalCode,ShippingCountry,Phone From Account Where Name =: companyName AND ShippingCity =: cityVal ];
                system.debug('<<<<<accout list: '+accountList);
            }        
            system.debug('>>>>>account list size:'+accountList.size());
            if((accountList == Null || accountList.size() == 0) && companyName != Null){
                Account acc = new Account();
                acc.recordtypeId = accountRecTypeId;
                acc.name = companyName;
                if(streetAddress !=Null){
                    acc.ShippingStreet = streetAddress;
                }else if(streetAddress!=Null){
                    acc.ShippingStreet = streetAddress;
                }
                acc.ShippingCity = cityVal;
                acc.ShippingState = stateVal;
                acc.ShippingPostalCode = postalCodeVal;
                acc.ShippingCountry = countryVal;
                acc.OwnerId = BonnieId.Id;
                acc.Phone = phoneNumber ;
                Insert acc;
                accountList.add(acc);
                system.debug('accountList Step-1'+acc);
                hasError = 'success';
            }        
            if(emailAddress != NUll && accountList != Null){
                contactList = [Select Id, LastName, FirstName, Email, Phone, AccountId From Contact Where Email =: emailAddress AND AccountId IN: accountList];
            }
            
            for(Contact con : contactList){                
                if(con.Email == emailAddress){
                    system.debug('contact already exists');
                    contactsToAddToContactRoles.add(con);
                }
            }
            
            if(contactList == Null || contactList.size() == 0){
                Contact c = new Contact();
                c.LastName = keyStakeholderLastName;
                c.FirstName = keyStakeholderFirstName;
                c.Email = emailAddress;
                c.recordTypeId = contactRecTypeId;
                c.Title = titlePosition;
                c.OwnerId = BonnieId.Id;
                for(Account acc : accountList){
                    if(companyName == acc.Name){
                        c.AccountId = acc.Id;
                        c.MailingStreet = acc.ShippingStreet;
                        c.MailingCity = acc.ShippingCity ;
                        c.MailingState = acc.ShippingState ;
                        c.MailingPostalCode = acc.ShippingPostalCode ;
                        c.MailingCountry = acc.ShippingCountry ;
                        c.Phone = acc.Phone;
                    }                 
                }
                contactToInsert.add(c);
                hasError = 'success';
            }
            if(!contactToInsert.isEmpty()){
                Insert contactToInsert;
                contactsToAddToContactRoles.addAll(contactToInsert);
                hasError = 'success';
            }
            
            
            if(partnerEmailAddress != Null){
                String webDomain = '';
                if(partnerEmailAddress.split('@').size() > 0){
                    partnerDomain = partnerEmailAddress.split('@')[1];
                    webDomain = '%'+partnerDomain+'%';
                }
                partnerAccountList = new List<Account>([Select Id,Website,Name,ShippingCity,ShippingStreet,ShippingState,ShippingPostalCode,ShippingCountry,Phone From Account Where Website Like: webDomain and Segment__c ='Enterprise Partner']);
                partnerContactList = new List<Contact>([Select Id, LastName, FirstName, Email, Phone, AccountId From Contact Where Email =: partnerEmailAddress]);
            }
            if(partnerAccountList.size() == 0){
                Account acc = new Account();
                acc.RecordTypeId = accountRecTypeId ;
                acc.Name = partnerCompanyName;
                acc.email__c = partnerEmailAddress;
                acc.Phone = partnerPhoneNumber; 
                acc.Are_you_currently_working_with_a_Sectigo__c = areYouCurrentWorking ;
                acc.OwnerId = BonnieId.Id;
                acc.Manager_First_Name__c = partnerAccountManagerFirstName;
                acc.Manager_Last_Name__c = partnerAccountManagerLastName;
                acc.How_did_you_hear_about_us__c = leadSourceVal;
                acc.Segment__c ='Enterprise Partner';
                acc.ShippingStreet = '';
                acc.ShippingCity = '';
                acc.ShippingState = '';
                acc.ShippingPostalCode = '';
                acc.ShippingCountry = '';
                Insert acc; 
                partnerAccountList.add(acc);
            }
            system.debug('partnerAccountList >>'+partnerAccountList);
            system.debug('partnerDomain >>'+partnerDomain);
            if(oppNamePartnerCRM != Null){  
                Opportunity o = new Opportunity();
                o.Name = oppNamePartnerCRM;
                o.Description = oppDescription;
                o.CloseDate = expectedCloseDate;
                o.Demo_Status__c = 'Completed';
                o.Partner_Deal_Type__c = 'Deal Reg';
                o.LeadSource = 'Partner'; //leadSourceVal;
                o.POC_Presentation_Date__c = sectigoClientDiscoveryOn;
                o.Amount = expectedOppVal;
                o.RecordTypeId = oppRecTypeId;
                o.Type = 'New';
                o.Pricebook2id = Pricebookname.get(0).id;
                o.DM_Identified__c = True;
                o.StageName = 'Presentation/Proof of Concept';
                o.Forecast_CategoryCom__c = 'Pipeline';
                o.Rag_Rating__c = 'Green';
                o.Demo_Status__c = 'Not Required';
                o.CampaignId = Label.Deal_Registration_Campaign_Id;
                o.Original_Interest__c = productInterest;
                o.Pltform_Interest__c = Label.Deal_Registration_Platform_Interest;
                if(userList.size() > 0){
                    o.OwnerId = userList[0].Id;
                }
                if(leadSourceVal == 'Webform'){
                    o.WebForm_Name__c = 'Sectigo - Partner Deal Registration';
                }
                if(partnerAccountList.size() > 0){
                    o.Channel_Partner__c = partnerAccountList[0].Id;
                }
                for(Account acc : accountList){
                    if(companyName == acc.Name){
                        o.AccountId= acc.Id;
                    }
                }
                oppToInsert.add(o);
                system.debug('accountList Step-4'+o);
                hasError = 'success';
            }
            if(!oppToInsert.isEmpty()){
                Insert oppToInsert;
                system.debug('accountList Step-5'+oppToInsert);
                hasError = 'success';
            }
            
            
            for(Contact con : partnerContactList){                
                if(con.Email == partnerEmailAddress){
                    system.debug('contact already exists');
                    contactsToAddToContactRoles.add(con);
                }
            }
            
            if(partnerContactList == Null || partnerContactList.size() == 0){
                Contact c1 = new Contact();
                c1.LastName = partnerAccountManagerLastName;
                c1.FirstName = partnerAccountManagerFirstName;
                c1.Email = partnerEmailAddress;
                c1.recordTypeId = contactRecTypeId;
                c1.Title = titlePosition;
                c1.OwnerId = BonnieId.Id;
                c1.LeadSource = leadSourceVal;
                if(partnerAccountList.size() > 0){
                    c1.AccountId = partnerAccountList[0].Id;
                    c1.MailingStreet = partnerAccountList[0].ShippingStreet;
                    c1.MailingCity = partnerAccountList[0].ShippingCity ;
                    c1.MailingState = partnerAccountList[0].ShippingState ;
                    c1.MailingPostalCode = partnerAccountList[0].ShippingPostalCode ;
                    c1.MailingCountry = partnerAccountList[0].ShippingCountry ;
                    c1.Phone = partnerAccountList[0].Phone;
                }
                partnerContactToInsert.add(c1);
                hasError = 'success';
            }
            if(!partnerContactToInsert.isEmpty()){
                Insert partnerContactToInsert;
                contactsToAddToContactRoles.addAll(partnerContactToInsert);
                hasError = 'success';
            }
            system.debug('contactsToAddToContactRoles >>'+contactsToAddToContactRoles);
            if(!contactsToAddToContactRoles.isEmpty()){    
                List<Contact> conList = [Select Id,Name,AccountId From Contact Where Id In:contactsToAddToContactRoles];       
                for(Contact con : conList){
                    OpportunityContactRole ocr = new OpportunityContactRole(ContactId = con.Id, OpportunityId = oppToInsert[0].id);
                    if(oppToInsert.size() > 0) {
                        system.debug('Channer Parntner Account >>'+oppToInsert[0].Channel_Partner__c+'  '+con.AccountId);
                        if(oppToInsert[0].Channel_Partner__c == con.AccountId){
                            ocr.IsPrimary = true;
                            isFirstContact = false;
                        }
                    }
                    ocrList.add(ocr);
                    hasError = 'success';
                }            
                if(!ocrList.isEmpty()){
                    Upsert ocrList;
                    system.debug('ocrList list'+ocrList);
                    if(oppToInsert.size() > 0 && ocrList.size() > 0){
                        system.debug('inside ocr method');
                        setCampaignMember(ocrList,oppToInsert[0]);
                    }
                    sendemailnotification();
                    
                    hasError = 'success';
                    
                    
                }
                
            }
            
        }
        //return null;
    }
    public void setCampaignMember(List<OpportunityContactRole> ocrList,Opportunity opp){
        system.debug('ocrList >>'+ocrList);
        Campaign Dealregcamp = [SELECT Id, Name, Status FROM Campaign where Name = 'Deal Reg Web Form'];
        List<OpportunityContactRole> conRoleList = [Select Id,ContactId,Contact.AccountId,Contact.Email From OpportunityContactRole Where Id IN:ocrList ];
        
        Set<Id> conIdSet = new Set<Id>();
        for(OpportunityContactRole ocr : conRoleList){
            conIdSet.add(ocr.ContactId);
        }
        Map<Id,CampaignMember> cmapaignMap = new Map<Id,CampaignMember>();
        for(CampaignMember cmpMem : [Select Id,ContactId,Email,Name From CampaignMember WHere ContactId IN:conIdSet]){
            cmapaignMap.put(cmpMem.ContactId,cmpMem);
        }
        list<CampaignMember> campmembesList = new list<CampaignMember>();
        system.debug('conRoleList >>'+conRoleList);
        system.debug('cmapaignMap >>'+cmapaignMap);
        for(OpportunityContactRole ocr : conRoleList){
            CampaignMember newcampmembers = new CampaignMember();
            newcampmembers.CampaignId = Dealregcamp.Id;
            system.debug('c >>'+partnerEmailAddress);
            newcampmembers.ContactId = ocr.contactId;
            if(cmapaignMap.containskey(ocr.ContactId)){
                newcampmembers.Id = cmapaignMap.get(ocr.ContactId).Id;
                if(partnerEmailAddress == cmapaignMap.get(ocr.ContactId).Email){
                    newcampmembers.Status = 'Enterprise Partner';
                }else{
                    newcampmembers.Status = 'End Customer';
                }
            }else{
                if(partnerEmailAddress == ocr.Contact.Email){
                    newcampmembers.Status = 'Enterprise Partner';
                }else{
                    newcampmembers.Status = 'End Customer';
                }
            }
            campmembesList.add(newcampmembers);
        }
        if(campmembesList.size() > 0){
            upsert campmembesList;
        }
    }
    public void sendemailnotification(){
        system.debug('Email Notification');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        String emailTestString = Label.Heather_and_Bonnie_Email;
        List<String> emailaddre = new List<String>();
        for (String email : emailTestString.split(',')) {
            String trimmed = email.trim();
            emailaddre.add(trimmed);
        }
        system.debug('emailaddre---->'+emailaddre);
        EmailTemplate  emailtem = [SELECT id,Name,HtmlValue,Body FROM EmailTemplate where Name = 'Deal Registration Notification'];
        
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName=: label.DealReistrationFromAddress];
        system.debug('owea---->'+owea);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddressesEmail = emailaddre;
        mail.toAddresses= (toAddressesEmail);
        
        //String htmlBody = emailtem.HtmlValue;
        //String plainBody = emailtem.Body;
        String htmlval = emailtem.HtmlValue;
        system.debug('###---->'+htmlval);
        
        htmlval = htmlval.replace('{!PartnerName}',partnerCompanyName); 
        htmlval = htmlval.replace('{!Account.Manager_First_Name__c}',partnerAccountManagerFirstName); 
        htmlval = htmlval.replace('{!Account.Manager_Last_Name__c}', partnerAccountManagerLastName);
        htmlval = htmlval.replace('{!Account.Email__c}',partnerEmailAddress);
        htmlval = htmlval.replace('{!Account.Are_you_currently_working_with_a_Sectigo__c}',areYouCurrentWorking); 
        
        htmlval = htmlval.replace('{!CompanyName}',companyName); 
        htmlval = htmlval.replace('{!Contact.FirstName}', keyStakeholderFirstName);
        htmlval = htmlval.replace('{!Contact.LastName}',keyStakeholderLastName); 
        htmlval = htmlval.replace('{!Contact.Email}',emailAddress); 
        
        htmlval = htmlval.replace('{!Opportunity.Name}', oppNamePartnerCRM);
        htmlval = htmlval.replace('{!Opportunity.Description}',oppDescription);
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl = label.Deal_Register_Link+ '/' + oppToInsert.get(0).id;
        htmlval = htmlval.replace('{!OppLink}',baseUrl);
        
        Double myDouble = expectedOppVal;
        String Oppvalue = String.valueOf(myDouble);
        htmlval = htmlval.replace('{!Opportunity.Amount}',Oppvalue); 
        
        mail.setSubject('Deal Registration Form');
        mail.setHtmlBody(htmlval);
       // mail.setSenderDisplayName('Deal Registration Submited Admin');
        mail.setTemplateId(emailtem.Id);
        mail.setSaveAsActivity(true); 
        mail.setTreatTargetObjectAsRecipient(false);
                
        if(String.isNotBlank(owea[0].Id)){
            mail.setOrgWideEmailAddressId(owea[0].Id);
        }
        
        messages.add(mail);
        system.debug('Email Notification Sent------>'+messages);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
    }
}