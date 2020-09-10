public without sharing class Sec_ChannelPartnerCtrl{
    
    public String firstName {get;set;}    
    public String lastName {get;set;}    
    public String email {get; set;} 
    public String phoneNumber {get; set;}    
    public String companyName {get; set;}     
    public String country {get; set;}    
    public String state {get; set;}  
    public String subjec {get; set;}  
    public String hasError {get;set;} 
    public Boolean emailOptIn{get;set;}
    public string campaignIdVal;
    public string productInterestVal {get;set;}
    public string browserUrl {get;set;}
    public String pathNameOfBrowserUrl {get;set;}
    public string hasRedirect {get;set;}
    public String redirectUrlVal {get;set;}
    public String urlValue {get;set;}
    public String mainSiteUrl {get;set;}
    public Boolean isHubspotSync {get;set;}
    public String USState {get;set;}
    public String todayDateVal;
    public String postmessageValue {get;set;}
    public String productInterestApiVal;
    public String allStringHubProdInterest;
    public Boolean sslcheck {get;set;}
    public Boolean cgcheck {get;set;}
    public Boolean hgcheck {get;set;}
    public Boolean certificateCheck {get;set;}
    public Boolean documentCheck {get;set;}
    public Boolean WebSecurityPlatformcheck {get;set;}
    public Sec_ChannelPartnerCtrl(){
        sslcheck = false;cgcheck  = false;hgcheck  = false; isHubspotSync = false;documentCheck = false;certificateCheck = false;WebSecurityPlatformcheck=false;
        firstName = ''; lastName = ''; email = ''; phoneNumber = ''; companyName = '';urlValue = '';
        state= ''; campaignIdVal = ''; productInterestVal= ''; USState = '';
        postmessageValue = ''; allStringHubProdInterest = ''; todayDateVal = ''; mainSiteUrl = '';
        redirectUrlVal = ''; state  = '';
    }
    public void  captureExternalData(){
        system.debug('!!!<<<postmessageValue : '+postmessageValue );
        // Parse entire JSON .
        JSONParser parser = JSON.createParser(postmessageValue);
        while (parser.nextToken() != null) {   
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getCurrentName() == 'name')) {
                parser.nextToken();
                system.debug('currentName value before if: '+parser.getCurrentName());
                if(parser.getCurrentName() == 'name'){
                    system.debug('name value: '+parser.getText());
                }
                parser.nextToken();
                parser.nextToken();
                system.debug('currentName value before if: '+parser.getCurrentName());
                if(parser.getCurrentName() == 'webForm'){
                    system.debug('webform value: '+parser.getText());
                    mainSiteUrl = parser.getText();
                    system.debug('mainSiteUrl  >>> '+mainSiteUrl );
                }
                parser.nextToken();
                parser.nextToken();
                system.debug('currentName value before if: '+parser.getCurrentName());
                if(parser.getCurrentName() == 'campaignName'){
                    system.debug('campaignName value: '+parser.getText());
                    campaignIdVal = parser.getText();
                }
            }           
        }
        
    }
    
    public PageReference saveData(){
        setFirstPreference();
        allStringHubProdInterest  = setSelectedCheckBox();
        todayDateVal = System.Today().format();
        
        
        Id accounChannelPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        Id contactChannelPartnerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Channel Partners').getRecordTypeId();
        
        List < Campaign > campignList = [select id, name from Campaign where Id =: campaignIdVal limit 1];
        Map<Id,Id> campaignMemberMap = new Map<Id,Id>();
        for(CampaignMember cmp : [Select Id,ContactId,LeadId From CampaignMember Where campaignid =: campaignIdVal  ]){
            if(cmp.LeadId != null){
                campaignMemberMap.put(cmp.LeadId,cmp.Id);
            }
            if(cmp.ContactId != null){
                campaignMemberMap.put(cmp.ContactId,cmp.Id);
            }
        }
        if(hasRedirect == 'yes'){
            urlValue = redirectUrlVal ;
        }
        if (String.isNotEmpty(email)) {
            
            List < Lead > leads = [select id,State,Segment__c,HubSpot_Sync__c,HubSpot_Product_Interest__c,Webform_Name__c,Country,Phone, email,Product_Interest__c,Marketing_Email_Subscription__c,Territory__c,MobilePhone,LeadSource,Status,Company,FirstName, HubSpot_Employee_Count__c,Lastname from Lead where email =: email ORDER BY LastModifiedDate DESC];
            List < Contact > contacts = [select id, email,MobilePhone,isPrivateCA__c,Webform_Name__c,LeadSource,Product_Interest__c,HubSpot_sync__c,Account.Segment__c,Accountid,firstname,Marketing_Email_Subscription__c,lastname,Email_Opt_In__c from Contact where email =: email ORDER BY LastModifiedDate DESC];
            if (leads.size() == 0 && contacts.size() == 0) {
                Lead mySampleLead = new Lead();
                if( !String.isBlank(mainSiteUrl)){
                    mySampleLead = new Lead(Company = companyName,Marketing_Email_Subscription__c=emailOptIn, Country =country,Phone=phoneNumber, Product_Interest__c = productInterestApiVal , Webform_Name__c = mainSiteUrl, LeadSource = 'Webform', Status = 'New',HubSpot_Sync__c= true, FirstName = firstName, LastName = lastName, Email = email,HubSpot_Product_Interest__c = allStringHubProdInterest,Segment__c = 'Partner/Reseller');
                    if(USState != Null){
                        mySampleLead.State = USState;
                    }
                    System.debug('$$$$$: '+mySampleLead);
                }
                insert mySampleLead;
                String lSource = mySampleLead.LeadSource;
                String campaignName = '';
                if(campignList.size() > 0){
                    campaignName  = campignList[0].Name;
                }
                createTask(mainSiteUrl,firstName,lastName,phoneNumber,companyName,USState,email,allStringHubProdInterest,productInterestApiVal,
                            todayDateVal,country,mySampleLead.Id,campaignName );
                
                
                //Add them to campaign member
                List < CampaignMember > cm = new list < CampaignMember > ();
                if (campignList.size()>0 && !campaignMemberMap.containskey(mySampleLead.id)) {
                    insertCampaign(campignList[0].id,mySampleLead.id,'');
                }
                hasError = 'success';
            } else if (leads.size() == 1 || leads.size()>1) {
                leads[0].HubSpot_Sync__c= true;
                leads[0] = updateLead(leads[0]);   
                update leads;
                String campaignName = '';
                if(campignList.size() > 0){
                    campaignName  = campignList[0].Name;
                }
                createTask(mainSiteUrl,firstName,lastName,phoneNumber,companyName,USState,email,allStringHubProdInterest,productInterestApiVal,
                            todayDateVal,country,leads[0].Id,campaignName );
                
                
                //Add them to campaign member
                List < CampaignMember > cm = new list < CampaignMember > ();
                if (campignList.size()>0 && !campaignMemberMap.containskey(leads[0].id)) {
                    insertCampaign(campignList[0].id,leads[0].id,'');
                }
                hasError = 'success';
                
            } else if (contacts.size() == 1 || contacts.size()>1) {
                contacts[0] = updateContact(contacts[0]);
                contacts[0].HubSpot_Sync__c= true;
                
                update contacts;
                String campaignName = '';
                if(campignList.size() > 0){
                    campaignName  = campignList[0].Name;
                }
                createTask(mainSiteUrl,firstName,lastName,phoneNumber,companyName,USState,email,allStringHubProdInterest,productInterestApiVal,
                            todayDateVal,country,contacts[0].Id,campaignName );
                
                
                //Add them to campaign member
                List < CampaignMember > cm = new list < CampaignMember > ();
                if (campignList.size() > 0 && !campaignMemberMap.containskey(contacts[0].id)) {
                    insertCampaign(campignList[0].id,'',contacts[0].Id);
                }
                
                //Notify Account Owner thorugh workflow
                
                hasError = 'success';
                
            } else{
                // Must be more than 1 contact or lead
                //update most recently changed
                System.debug('\nMore than 1 contact or lead.');
                hasError = 'morecontacts';
                //  hasError = 'success';
                
            }
        }
        return null;
    }
    public void setFirstPreference(){
        system.debug(' productInterestVal >>'+productInterestVal);
        if(productInterestVal == 'SSL'){productInterestApiVal = 'SSL';}
        if(productInterestVal == 'HG'){productInterestApiVal  = 'HackerGuardian';}
        if(productInterestVal == 'CG'){productInterestApiVal  = 'CodeGuard';}
        if(productInterestVal == 'CertificateManager'){productInterestApiVal  = 'Channel SCM';}
        if(productInterestVal == 'DocumentSigning'){productInterestApiVal = 'Document Signing';}
        if(productInterestVal == 'WebSecurityPlatform'){productInterestApiVal = 'Web Security Platform';}
        system.debug(' productInterestVal >>'+productInterestApiVal );
        
    }
    public String setSelectedCheckBox(){
        List<String> checkList = new List<String>();
        String returnString = '';
        if(sslcheck){checkList.add('SSL');}   
        if(documentCheck){checkList.add('Document Signing');} 
        if(cgcheck){checkList.add('CG');}   
        if(hgcheck){checkList.add('HG');}
        if(certificateCheck){checkList.add('Channel SCM');}
        if(WebSecurityPlatformcheck){checkList.add('Web Security Platform');}
        if(!checkList.isEmpty()){
            returnString = string.join(checkList,',');
        }  
        return returnString;
    }
    @Future
    public static void insertCampaign(String campaignId,String leadId,String conId){
        system.debug('campaignId << '+campaignId);
        try{
            CampaignMember cml = new CampaignMember();
            cml.campaignid = campaignId;
            cml.type__c = 'WebForm';
            if(leadId == '' && conId != ''){
                cml.contactId = conId;    
            }
            if(leadId != '' && conId == ''){
                cml.LeadId = leadId;  
            }
            insert cml;
        }catch(exception e){
        
        }
    }
    public List<SelectOption> getEmployeeCountOptions() {
        List<SelectOption> countOptions = new List<SelectOption>();
        countOptions.add(new SelectOption('','Company Size'));
        countOptions.add(new SelectOption('1-250','1-250'));
        countOptions.add(new SelectOption('251-500','251-500'));
        countOptions.add(new SelectOption('501-1000','501-1000'));
        countOptions.add(new SelectOption('1001-3000','1001-3000'));
        countOptions.add(new SelectOption('3000+','3000+'));
        
        return countOptions;
    }
    
    public List<SelectOption> getSmimeOptions() {
        List<SelectOption> smOptions = new List<SelectOption>();
        smOptions.add(new SelectOption('','S/MIME Count'));
        smOptions.add(new SelectOption('1-10','1-10'));
        smOptions.add(new SelectOption('11-50','11-50'));
        smOptions.add(new SelectOption('50+','50+'));
        
        return smOptions ;
    }
    public Lead updateLead(Lead mySampleLead ){
        if(mySampleLead.Company == null){ mySampleLead.Company = companyName; }
        if(mySampleLead.Marketing_Email_Subscription__c == null){ mySampleLead.Marketing_Email_Subscription__c = emailOptIn;}
        if(mySampleLead.Country == null){ mySampleLead.Country = country; }
        if(mySampleLead.State == null){ mySampleLead.State = USState;}
        if(mySampleLead.Phone == null){ mySampleLead.Phone = phoneNumber;}
        if(mySampleLead.Product_Interest__c == null){ mySampleLead.Product_Interest__c = productInterestApiVal; }
        if(mySampleLead.Webform_Name__c == null){ mySampleLead.Webform_Name__c = mainSiteUrl;}
        if(mySampleLead.LeadSource == null){ mySampleLead.LeadSource = 'Webform';}
        if(mySampleLead.Status == null){ mySampleLead.Status = 'New';}
        if(mySampleLead.HubSpot_Sync__c != true){ mySampleLead.HubSpot_Sync__c = true;} 
        if(mySampleLead.FirstName == null){ mySampleLead.FirstName = FirstName; }
        if(mySampleLead.LastName == null){ mySampleLead.LastName = lastName; }
        if(mySampleLead.Email == null){ mySampleLead.Email = email;}
        if(mySampleLead.HubSpot_Product_Interest__c == null){ mySampleLead.HubSpot_Product_Interest__c = allStringHubProdInterest; }
        return mySampleLead;
    }
    
    public Contact updateContact(Contact contacts){
        if(contacts.FirstName == null){ contacts.FirstName = firstName; }
        if(contacts.Lastname == null){ contacts.Lastname = lastName;}
        if(contacts.MobilePhone == null){contacts.MobilePhone =  phoneNumber;}
        if(contacts.isPrivateCA__c != true){ contacts.isPrivateCA__c = true;}
        if(contacts.Webform_Name__c == null){contacts.Webform_Name__c =  mainSiteUrl;}
        if(contacts.LeadSource == null){ contacts.LeadSource = 'Webform';}
        if(contacts.Product_Interest__c == null){ contacts.Product_Interest__c = productInterestApiVal ;}
        if(contacts.HubSpot_sync__c != true){ contacts.HubSpot_sync__c = true;}
        if(emailOptIn==true)
            contacts.Marketing_Email_Subscription__c=emailOptIn;
        return contacts;
    }
    
    @future
    public static void createTask(String mainSiteUrl,String firstName,String lastName,String phoneNumber,String companyName,
                                   String USState,string email,
                                  String allStringHubProdInterest,String productInterestApiVal,String todayDateVal,String country,
                                  string parentId,String campaignName){
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Task newTask = new Task(Priority = 'Normal',
                                Status = 'Completed',
                                WebForm_Name__c = 'Channel Partner',
                                WebSite_Source__c = mainSiteUrl,
                                Customer_Name__c = firstName+' '+lastName,
                                ActivityDate = system.today(),
                                Task_Phone__c = phoneNumber,
                                Company_Name__c = companyName,
                                State__c = USState,
                                Task_Email__c = email,
                                recordTypeId = taskRecordTypeId,
                                HubSpot_Product_Interest__c = allStringHubProdInterest,
                                Subject = 'Submitted Form: '+ mainSiteUrl + ' - ' + productInterestApiVal +' ( '+ todayDateVal+' )' ,
                                IsReminderSet = true,
                                Type = 'Channel Partner',
                                ReminderDateTime = System.now() + 1,
                                Customer_Segment__c = 'Channel Partner/Reseller',
                                Country__c = country,
                                WhoId = parentId);
        newTask.Campaign_Name__c = campaignName;
        insert newTask;
    }
}