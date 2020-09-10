public without Sharing class Sec_GatedContentCntrl{
    
    public String firstName {get;set;}    
    public String lastName {get;set;}    
    public String email {get; set;} 
    public String phoneNumber {get; set;}    
    public String companyName {get; set;}    
    public String employeeCount {get; set;}    
    public String country {get; set;}    
    public String state {get; set;}    
    public String smimeQ {get; set;}  
    public String subjec {get; set;}    
    public String mess {get; set;} 
    public String hasError {get;set;} 
    public Boolean emailOptIn{get;set;}  
    public String region {get; set;}  
    public string campaignIdVal;
    public string productInterestVal;
    public string browserUrl {get;set;}
    public String pathNameOfBrowserUrl {get;set;}
    public string hasRedirect {get;set;}
    public String redirectUrlVal {get;set;}
    public String urlValue {get;set;}
    public String mainSiteUrl {get;set;}
    public String mainUrl {get;set;}
    public String pathVal {get;set;}
    public String prodName {get;set;}
    public Boolean isHubspotSync {get;set;}
    public String todayDateVal;
    
    public PageReference saveData(){
        todayDateVal = System.Today().format();
        // call this method to check the dynamic values of lead source and product interest based on URL
        checkUrlForLeadValues();
        system.debug('&&&&'+hasRedirect);
        if(hasRedirect == 'yes'){
            urlValue = redirectUrlVal ;
        }
        
        system.debug('^^^^^^'+redirectUrlVal);
        system.debug('****'+urlValue);
        system.debug('!!!!!: '+campaignIdVal);
        system.debug('#####: '+productInterestVal);
        system.debug('$$$$$$: '+mainSiteUrl);
        system.debug('^^^^^^^: '+prodName);
        System.debug('@@@@@'+firstName+'@@@@@@'+lastName+'@@@@@@@'+email+'@@@@@@@'+phoneNumber+'@@@@@@@'+companyName);
        System.debug('@@@@@'+employeeCount+'@@@@@@'+country+'@@@@@@@'+state+'@@@@@@@'+smimeQ+'@@@@@@@'+subjec+'@@@@@@'+mess);
        List < Campaign > campaignList = [select id, name  from Campaign where Id =: campaignIdVal limit 1];
        Map<Id,Id> campaignMemberMap = new Map<Id,Id>();
        for(CampaignMember cmp : [Select Id,ContactId,LeadId From CampaignMember Where campaignid =: campaignIdVal  ]){
            if(cmp.LeadId != null){
                campaignMemberMap.put(cmp.LeadId,cmp.Id);
            }
            if(cmp.ContactId != null){
                campaignMemberMap.put(cmp.ContactId,cmp.Id);
            }
        }
        
        //email match with leads
        List < Task > toInsert = new List < Task > ();
        // List<Task> toInsertLead= new List<Task>();
        if (String.isNotEmpty(email)) {
            
            List < Lead > leads = [select id,State,Segment__c,HubSpot_Sync__c,HubSpot_Product_Interest__c,Webform_Name__c,Country,Phone, email,Product_Interest__c,Marketing_Email_Subscription__c,Territory__c,MobilePhone,LeadSource,Status,Company,FirstName, HubSpot_Employee_Count__c,Lastname from Lead where email =: email ORDER BY LastModifiedDate DESC];
            List < Contact > contacts = [select id, email,MobilePhone,isPrivateCA__c,Webform_Name__c,LeadSource,Product_Interest__c,HubSpot_sync__c,Account.Segment__c,Accountid,firstname,Marketing_Email_Subscription__c,lastname,Email_Opt_In__c from Contact where email =: email ORDER BY LastModifiedDate DESC];
            if (leads.size() == 0 && contacts.size() == 0) {
                //Create new lead
                //S_MIME_Quantity__c=smimeQ,
                Lead mySampleLead = new Lead();
                if(!String.isBlank(productInterestVal) && !String.isBlank(mainSiteUrl))
                    mySampleLead = new Lead(Company = companyName,Marketing_Email_Subscription__c=emailOptIn, Country =country,Phone=phoneNumber, Product_Interest__c = productInterestVal, Webform_Name__c = mainSiteUrl, LeadSource = 'Gated Form', Status = 'New',HubSpot_Sync__c= true, FirstName = firstName, LastName = lastName, Email = email);
                System.debug('$$$$$: '+mySampleLead);
                
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                mySampleLead.setOptions(dmo);
                insert mySampleLead;
                mySampleLead = [Select Id,Segment__c,LeadSource From Lead WHERE Id=:mySampleLead.Id Limit 1];
                Task newTask = createTask(mySampleLead.id);
                if(campaignList.size() > 0){
                    newTask.Campaign_Name__c = campaignList[0].Name;
                }
                newTask.Customer_Segment__c = mySampleLead.Segment__c;
                toInsert.add(newTask);
                
                //Add them to campaign member
                if (campaignList.size() > 0 && !campaignMemberMap.containskey(mySampleLead.id)) {
                    insertCampaign(campaignList[0].id,mySampleLead.Id,'');
                }
                hasError = 'success';
                
            } else if (leads.size() == 1 || leads.size()>1) {
                leads[0].Description = mess;
                leads[0] = updateLead(leads[0]);
                
                Task newTask = createTask(leads[0].id);
                if(campaignList.size() > 0){
                    newTask.Campaign_Name__c = campaignList[0].Name;
                }
                newTask.Customer_Segment__c = leads[0].Segment__c;
                toInsert.add(newTask);
                
                //Add them to campaign member
                if (campaignList.size() > 0  && !campaignMemberMap.containskey(leads[0].id)) {
                    insertCampaign(campaignList[0].id,leads[0].Id,'');
                }
                
                hasError = 'success';
                
            } else if (contacts.size() == 1 || contacts.size()>1) {
                contacts[0] = updateContact(contacts[0]);
                update contacts;
                Task newTask = createTask(contacts[0].id);
                if(campaignList.size() > 0){
                    newTask.Campaign_Name__c = campaignList[0].Name;
                }
                newTask.Customer_Segment__c = contacts[0].Account.Segment__c;
                toInsert.add(newTask);
                
                //Add them to campaign member
                if (campaignList.Size() > 0 && !campaignMemberMap.containskey(contacts[0].id)) {
                    insertCampaign(campaignList[0].id,'',contacts[0].id);
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
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
        //not matched create   lead and 
        //create a task with webform name, subject and message under lead or contact
        return null;
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
    public void checkUrlForLeadValues(){
        
        
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('baseUrl = '+baseUrl);
        System.debug('browserurl = '+browserUrl);  
        system.debug('PathName from page: = '+pathNameOfBrowserUrl);      
        
        if(!String.isBlank(browserUrl)){
            mainUrl = browserUrl.substringBetween('//','.com');  
            prodName = browserUrl.substringAfterLast('/');
            system.debug('*****: '+prodName);          
        }else if(String.isBlank(browserUrl)){
            mainUrl = baseUrl.substringBetween('//','.com'); 
            prodName = browserUrl.substringAfterLast('/');
            system.debug('*****: '+prodName);          
        }
               
        
        
      /*  if(!String.isBlank(pathNameOfBrowserUrl)){
            system.debug('&&&&&&: '+pathNameOfBrowserUrl);
            
        }*/
        
        
        system.debug('@@@@@@@@: '+mainUrl);
        Map<string,Campaign_Assignment_Settings__c> urlInstancesMap = Campaign_Assignment_Settings__c.getAll();
        
        for(Campaign_Assignment_Settings__c cAS : urlInstancesMap.values()){
            if(prodName == cAS.Name && mainUrl == cAS.Main_Site_Url__c.removeEnd('.com')){
                //String prodName =  pathVal.substringAfterLast('/');
                system.debug('test productname in the path: '+prodName);
                campaignIdVal= cAS.CampaignName__c;
                productInterestVal = cAS.Product__c;
                redirectUrlVal  = cAS.RedirectURL__c;
                mainSiteUrl = cAS.Main_Site_Url__c;
            }
        }
        
    }
    
    public Task createTask(String parentId){
        Id leadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Task newTask = new Task(Description = mess,
                                        Priority = 'Normal',
                                        WebForm_Name__c = 'Gated Form',
                                        country__c = country,
                                        ActivityDate = system.today(),
                                        Task_Phone__c = phoneNumber,
                                        Company_Name__c = companyName,
                                        Task_Email__c = email,
                                        Status = 'Completed',
                                        recordTypeId = leadRecordTypeId,
                                        Customer_Name__c = firstName+' '+lastName,
                                        Subject = 'Submitted Form: '+ mainSiteUrl + ' - ' + productInterestVal +' ( '+ todayDateVal+' )' ,
                                        IsReminderSet = true,
                                        type = 'WebForm',
                                        ReminderDateTime = System.now() + 1,
                                        Website_Source__c = mainSiteUrl,
                                        WhoId = parentId);
        return newTask;
    }
    public Lead updateLead(Lead mySampleLead ){
        if(mySampleLead.Company == null){ mySampleLead.Company = companyName; }
        if(mySampleLead.HubSpot_Employee_Count__c == null){ mySampleLead.HubSpot_Employee_Count__c = employeeCount;}
        if(mySampleLead.Marketing_Email_Subscription__c == null){ mySampleLead.Marketing_Email_Subscription__c = emailOptIn;}
        if(mySampleLead.Country == null){ mySampleLead.Country = country; }
        if(mySampleLead.Phone == null){ mySampleLead.Phone = phoneNumber;}
        if(mySampleLead.Webform_Name__c == null){ mySampleLead.Webform_Name__c = mainSiteUrl;}
        if(mySampleLead.LeadSource == null){ mySampleLead.LeadSource = 'Webform';}
        if(mySampleLead.Status == null){ mySampleLead.Status = 'New';}
        if(mySampleLead.HubSpot_Sync__c != true){ mySampleLead.HubSpot_Sync__c = true;} 
        if(mySampleLead.FirstName == null){ mySampleLead.FirstName = FirstName; }
        if(mySampleLead.LastName == null){ mySampleLead.LastName = lastName; }
        if(mySampleLead.Email == null){ mySampleLead.Email = email;}
        return mySampleLead;
    }
    
    public Contact updateContact(Contact contacts){
        if(contacts.FirstName == null){ contacts.FirstName = firstName; }
        if(contacts.Lastname == null){ contacts.Lastname = lastName;}
        if(contacts.MobilePhone == null){contacts.MobilePhone =  phoneNumber;}
        if(contacts.isPrivateCA__c != true){ contacts.isPrivateCA__c = true;}
        if(contacts.Webform_Name__c == null){contacts.Webform_Name__c =  mainSiteUrl;}
        if(contacts.LeadSource == null){ contacts.LeadSource = 'Webform';}
        if(contacts.HubSpot_sync__c != true){ contacts.HubSpot_sync__c = true;}
        if(emailOptIn==true)
            contacts.Marketing_Email_Subscription__c=emailOptIn;
        return contacts;
    }
}