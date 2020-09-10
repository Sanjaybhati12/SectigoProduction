public without sharing class Sec_TopNavigationCntrl{
    
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
    public string productInterestVal {get;set;}
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
    public String USState {get;set;}
    public String todayDateVal;
    public String postmessageValue {get;set;}
    public Boolean SSLCertificatesCheckVal {get;set;}
    public Boolean CodeSigningCertificatesCheckVal {get;set;}
    public Boolean EmailCertificatesSMIMECheckVal {get;set;}
    public Boolean DocumentSigningCheckVal {get;set;}
    public Boolean PrivatePKICheckVal {get;set;}
    public Boolean EmbeddedSecurityCheckVal {get;set;}
    public Boolean DevOpsCheckVal {get;set;}
    public Boolean CertificateManagementPlatformCheckVal {get;set;}
    public Boolean IoTManagementPlatformCheckVal {get;set;}
    public Boolean EnterpriseSSLCheckVal {get;set;}
    public Boolean EnterpriseSMIMECheckVal {get;set;}
    public Boolean EnterpriseCodeSigningCheckVal {get;set;}
    public Boolean WebsiteBackupandRecoveryCheckVal {get;set;}
    public Boolean OtherCheckVal {get;set;}
    public String productInterestApiVal;
    public String allStringHubProdInterest;
    
    
    public Sec_TopNavigationCntrl(){
        redirectUrlVal = '';
        postmessageValue = '';
        mess = '';
    }
    
    public void captureExternalData(){
        //postmessageValue = Apexpages.currentPage().getParameters().get('postmessageExData');
       system.debug('!!!<<<postmessageValue : '+postmessageValue);
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
        // to get the API name of picklist value of product interest, it is the first value that is selected
        map<String,String> optionsMap = new map<String,String>();
        Schema.DescribeFieldResult fieldResult = Lead.Product_Interest__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            optionsMap.put(f.getValue(),f.getLabel());
        } 
               system.debug('>>>>>>optionsMap<<<= '+optionsMap);
        system.debug('>>>>>>productinteval from page= '+productInterestVal );
        
        if(productInterestVal == 'CertificateManagementPlatform'){
            productInterestVal = 'Certificate Manager';
        }
        if(productInterestVal == 'EnterpriseSMIME'){
            productInterestVal = 'Enterprise S/MIME';
        }
        if(productInterestVal == 'CodeSigningCertificates'){
            productInterestVal = 'Code Signing Certificates';
        }
        if(productInterestVal == 'EnterpriseSSL'){
            productInterestVal = 'SSL';
        }
        if(productInterestVal == 'DevOps'){
            productInterestVal = 'DevOps';
        }
        if(productInterestVal == 'IoTManagementPlatform'){
            productInterestVal = 'IoT';
        }
        if(productInterestVal == 'DocumentSigning'){
            productInterestVal = 'Document Signing';
        }
        if(productInterestVal == 'PrivatePKI'){
            productInterestVal = 'Private CA';
        }
        if(productInterestVal == 'EmailCertificatesSMIME'){
            productInterestVal = 'SMIME';
        }
        if(productInterestVal == 'SSLCertificates'){
            productInterestVal = 'SSL';
        }
        if(productInterestVal == 'EmbeddedSecurity'){
            productInterestVal = 'IconLabs';
        }
        if(productInterestVal == 'WebsiteBackupandRecovery'){
            productInterestVal = 'CodeGuard';
        }
        if(productInterestVal == 'EnterpriseCodeSigning'){
            productInterestVal = 'Code Signing On Demand';
        }
        if(productInterestVal == 'Other'){
            productInterestVal = 'Other';
        }
        
        system.debug('>>>>>>productinteval after process= '+productInterestVal );
        
        
        
        if(productInterestVal != '' || productInterestVal != Null){
            if(optionsMap.containskey(productInterestVal)){
                productInterestApiVal = optionsMap.get(productInterestVal);
                system.debug('#$#$#$ '+productInterestApiVal);
            }
        }  
    
    
        // adding values to the list for hubspot/webform product interest field
        List<String> checkedValueList = new List<String>(); 
         system.debug('checkedbefore CertificateManagementPlatformCheckVal: '+CertificateManagementPlatformCheckVal);
            if(CertificateManagementPlatformCheckVal == true){
                checkedValueList.add('Certificate Management Platform');
                system.debug('checked CertificateManagementPlatformCheckVal: '+CertificateManagementPlatformCheckVal);
            }
        
        
            if(CodeSigningCertificatesCheckVal == true){
                checkedValueList.add('Code Signing Certificates');
                system.debug('checked CodeSigningCertificatesCheckVal: '+CodeSigningCertificatesCheckVal);
            }  
         
        
            if(DevOpsCheckVal == true){
                checkedValueList.add('DevOps');
                system.debug('checked DevOpsCheckVal: '+DevOpsCheckVal);
            }
        
            if(DocumentSigningCheckVal  == true){
                checkedValueList.add('Document Signing');
                system.debug('checked DocumentSigningCheckVal: '+DocumentSigningCheckVal);
            }
        
        if(EmailCertificatesSMIMECheckVal!= Null){
            if(EmailCertificatesSMIMECheckVal){
                checkedValueList.add('Email Certificates (S/MIME)');
                system.debug('checked EmailCertificatesSMIMECheckVal: '+EmailCertificatesSMIMECheckVal);
            }
        }
        
            if(EmbeddedSecurityCheckVal  == true){
                checkedValueList.add('Embedded Security');
                system.debug('checked EmbeddedSecurityCheckVal: '+EmbeddedSecurityCheckVal);
            }
        
        
            if(EnterpriseCodeSigningCheckVal  == true){
                checkedValueList.add('Enterprise Code Signing');
                system.debug('checked EnterpriseCodeSigningCheckVal: '+EnterpriseCodeSigningCheckVal);
            }
        
        
            if(EnterpriseSMIMECheckVal  == true){
                checkedValueList.add('Enterprise S/MIME');
                system.debug('checked EnterpriseSMIMECheckVal: '+EnterpriseSMIMECheckVal);
            }
        
        
            if(EnterpriseSSLCheckVal == true){
                checkedValueList.add('Enterprise SSL');
                system.debug('checked EnterpriseSSLCheckVal: '+EnterpriseSSLCheckVal);
            }
        
        
            if(IoTManagementPlatformCheckVal == true){
                checkedValueList.add('IoT Management Platform');
                system.debug('checked IoTManagementPlatformCheckVal: '+IoTManagementPlatformCheckVal);
            }
        
       
            if(PrivatePKICheckVal == true){
                checkedValueList.add('Private PKI');
                system.debug('checked PrivatePKICheckVal: '+PrivatePKICheckVal);
            }
        
        
            if(SSLCertificatesCheckVal == true){
                checkedValueList.add('SSL Certificates');
                system.debug('checked SSLCertificatesCheckVal: '+SSLCertificatesCheckVal);
            }
        
            if(WebsiteBackupandRecoveryCheckVal  == true){
                checkedValueList.add('Website Backup and Recovery');
                system.debug('checked WebsiteBackupandRecoveryCheckVal: '+WebsiteBackupandRecoveryCheckVal);
            }
        
     
            if(OtherCheckVal  == true){
                checkedValueList.add('Other');
                system.debug('checked OtherCheckVal: '+OtherCheckVal);
            }       
        
        if(!checkedValueList.isEmpty()){
        system.debug('checkbox list= '+checkedValueList);
            
            allStringHubProdInterest = '';
            for(String str : checkedValueList){
                if(str.length() > 18){
                    allStringHubProdInterest += str.substring(0,17)+',';
                }else{
                    allStringHubProdInterest += str+',';
                }
            }
            allStringHubProdInterest = allStringHubProdInterest.removeEnd(',');
            system.debug('hubspotprod interest= '+allStringHubProdInterest);
        }  
        //SelectedProductList();    
    
        todayDateVal = System.Today().format();
        // call this method to check the dynamic values of lead source and product interest based on URL
       // checkUrlForLeadValues();
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
        system.debug('allstringinterest= '+allStringHubProdInterest);
        system.debug('#$#$#$ '+productInterestApiVal);
        System.debug('@@@@@'+firstName+'@@@@@@'+lastName+'@@@@@@@'+email+'@@@@@@@'+phoneNumber+'@@@@@@@'+companyName);
        System.debug('@@@@@'+employeeCount+'@@@@@@'+country+'@@@@@@@'+state+'@@@@@@@'+smimeQ+'@@@@@@@'+subjec+'@@@@@@'+mess+'@@@@@@@'+USState );
        List < Campaign > c = [select id, name  from Campaign where Id =: campaignIdVal limit 1];
        Map<Id,Id> campaignMemberMap = new Map<Id,Id>();
        for(CampaignMember cmp : [Select Id,ContactId,LeadId From CampaignMember Where campaignid =: campaignIdVal  ]){
            if(cmp.LeadId != null){
                campaignMemberMap.put(cmp.LeadId,cmp.Id);
            }
            if(cmp.ContactId != null){
                campaignMemberMap.put(cmp.ContactId,cmp.Id);
            }
        }
        
        Id leadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        system.debug('Campaign In Maain Class'+c);
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
                //if(!String.isBlank(productInterestVal) && !String.isBlank(mainSiteUrl)){
                if( !String.isBlank(mainSiteUrl)){
                    if(USState != Null){
                        mySampleLead = new Lead(Company = companyName, HubSpot_Employee_Count__c = employeeCount,Marketing_Email_Subscription__c=emailOptIn, Country =country,State = USState ,Phone=phoneNumber, Product_Interest__c = productInterestApiVal , Webform_Name__c = mainSiteUrl, LeadSource = 'Webform', Status = 'New',HubSpot_Sync__c= true, FirstName = firstName, LastName = lastName, Email = email,HubSpot_Product_Interest__c = allStringHubProdInterest);
                    }else{
                        mySampleLead = new Lead(Company = companyName, HubSpot_Employee_Count__c = employeeCount,Marketing_Email_Subscription__c=emailOptIn, Country =country,Phone=phoneNumber, Product_Interest__c = productInterestApiVal , Webform_Name__c = mainSiteUrl, LeadSource = 'Webform', Status = 'New',HubSpot_Sync__c= true, FirstName = firstName, LastName = lastName, Email = email,HubSpot_Product_Interest__c = allStringHubProdInterest);
                    }
                    System.debug('$$$$$: '+mySampleLead);
                }
                mySampleLead.Description = mess;
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                mySampleLead.setOptions(dmo);
                insert mySampleLead;
                mySampleLead = [Select Id,Segment__c,LeadSource From Lead WHERE Id=:mySampleLead.Id Limit 1];
                String lSource = mySampleLead.LeadSource;
                Task newTask = createTask(mySampleLead.id);
                newTask.Campaign_Name__c = c[0].Name;
                newTask.Customer_Segment__c = mySampleLead.Segment__c;
                toInsert.add(newTask);
                
                //Add them to campaign member
                
                if (!c.isEmpty() && !campaignMemberMap.containskey(mySampleLead.id)) {
                    insertCampaign(c[0].id,mySampleLead.id,'');
                }
                hasError = 'success';
                
            } else if (leads.size() == 1 || leads.size()>1) {
                leads[0].Description = mess;
                leads[0] = updateLead(leads[0]);   
                update leads;
                Task newTask = createTask(leads[0].id);
                newTask.Campaign_Name__c = c[0].Name;
                newTask.Customer_Segment__c = leads[0].Segment__c;
                toInsert.add(newTask);
                
                //Add them to campaign member
                if (!c.isEmpty() && !campaignMemberMap.containskey(leads[0].id)) {
                    insertCampaign(c[0].id,leads[0].id,'');
                }
                hasError = 'success';
                
            } else if (contacts.size() == 1 || contacts.size()>1) {
                contacts[0] = updateContact(contacts[0]);
                
                Task newTask = createTask(contacts[0].id);
                newTask.Campaign_Name__c = c[0].Name;
                newTask.Customer_Segment__c = contacts[0].Account.Segment__c;
                toInsert.add(newTask);
                 
                //Add them to campaign member
                
                if (!c.isEmpty() && !campaignMemberMap.containskey(contacts[0].id)) {
                    insertCampaign(c[0].id,'',contacts[0].id);
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
    public Task createTask(String parentId){
        Id leadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Task newTask = new Task(Description = mess,
                                        Priority = 'Normal',
                                        Status = 'Completed',
                                        ActivityDate = system.today(),
                                        WebForm_Name__c = 'Top Navigation',
                                        Task_Phone__c = phoneNumber,
                                        Smime_Count__c = smimeQ,
                                        Product_Interest__c = productInterestApiVal,
                                        Company_Name__c = companyName,
                                        State__c = USState,
                                        Country__c = country,
                                        Task_Email__c = email,
                                        Customer_Name__c = firstName+' '+lastName,
                                        Subject = 'Submitted Form: '+ mainSiteUrl + ' - ' + productInterestApiVal +' ( '+ todayDateVal+' )' ,
                                        Type = 'WebForm',
                                        recordTypeId = leadRecordTypeId,
                                        IsReminderSet = true,
                                        ReminderDateTime = System.now() + 1,
                                        Website_Source__c = mainSiteUrl,
                                        HubSpot_Product_Interest__c = allStringHubProdInterest,
                                        WhoId = parentId);
        if(employeeCount.contains('-')){
            if(employeeCount.split('-').size() > 0){
                newTask.Employee_Count__c = String.valueOf(employeeCount.split('-')[1]);
            }
        }else if(employeeCount.contains('+')){
            newTask.Employee_Count__c = employeeCount.substring(0,employeeCount.length()-1);
        }else{
            newTask.Employee_Count__c  = employeeCount; 
        }
        return newTask;
    }
    public Lead updateLead(Lead mySampleLead ){
        if(mySampleLead.Company == null){ mySampleLead.Company = companyName; }
        if(mySampleLead.HubSpot_Employee_Count__c == null){ mySampleLead.HubSpot_Employee_Count__c = employeeCount;}
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
}