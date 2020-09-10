/**
 * Common apex class for all positive SSL FAQ Articles 
 *
 * @see         Com_KnowledgeControllerFaq1
 *
 * @version     2019-01-01 Agile Cloud Consulting     first version
 *              
 */ 
public abstract class HG_KnowledgeControllerFaq {

 public String cpt { get; set; }
     public String PKB_Tab_Home{get;set;}
    public String PKB_Search_NoFilter{get;set;}
    public String PKB_Search_Result{get;set;}
    public String PKB_Search_No_Result{get;set;}
    public String PKB_Last_Updated{get;set;}
    public String PKB_No_Result{get;set;}
    public String PKB_All_Article_Types{get;set;}
    public String PKB_Previous10 {get;set;}
    public String PKB_Next10{get;set;}
    public String PKB_Tab_Product{get;set;}
    public String PKB_Language{get;set;}
   
   //Added on 12 Nov
      public List<myAttachements> attchList {get; set;}


    public String securityOK { get; set; }
    private static final String PAGE_PREFIX = '/apex';

    //public static final String PAGE_HOME = 'knowledgeHome';
    public static final String PAGE_HOME = 'SvComodoLayout';
    public static final String PAGE_PRODUCT = 'knowledgeProduct';
    public static final String PAGE_SEARCH = 'knowledgeSearch';
    public static final String PAGE_RENDERER = 'ArticleRendererPkb';
    //added by me
    //public static final String PAGE_SEARCH_Comodo='knowledgeSearchComodo';
      public static final String PAGE_SEARCH_Comodo='HG_KnowledgeSearchPageFaq';
    //public static final String PAGE_PRODUCT_comodo = 'KnowledgeProductComodo';
     public static final String PAGE_PRODUCT_comodo ='HG_KnowledgeProductPageFaq';
    //public static final String Page_Detail_comodo='KnowledgeArticleDetailpage';
    public static final String Page_Detail_comodo='HG_KnowledgeDetailPageFaq';
    public id Articleid{get;set;}
    public Knowledge__kav knowledgedetails{get;set;}
    public static final String KnowledgeMainPage='HG_KnowledgeMainPageFaq';
    public Static boolean ShowHomepage{get;set;}
    public Static boolean ShowProductpage{get;set;}
    public Static boolean ShowSearchpage{get;set;}
    public Static boolean ShowDetailpage{get;set;}
    public List<ContentDocumentLink> lstContentLinks{get;set;}
    public List<ContentDistribution> lstContentDistro{get;set;}
    public boolean hasAttachment{get;set;}
    public boolean isVideo{get;set;}
    public String videoLink{get;set;}
    

    private static final String LANGUAGE_COOKIE_NAME = 'PKBLanguage';

    public static final String URL_HOME = PAGE_PREFIX + '/' + PAGE_HOME;
    public static final String URL_PRODUCT = PAGE_PREFIX + '/' + PAGE_PRODUCT;
    public static final String URL_SEARCH = PAGE_PREFIX + '/' + PAGE_SEARCH;
    //added by me
    public static final String URL_Product_comodo = PAGE_PREFIX + '/' + PAGE_PRODUCT_comodo;
    public static final String URL_SEARCH_comodo = PAGE_PREFIX + '/' + PAGE_SEARCH_Comodo;
    public static final String URL_Detail_comodo = PAGE_PREFIX + '/' + Page_Detail_comodo;
    

    public static final String ARTICLE_TYPE_PARAMETER_NAME = 't';
    public static final String CATEGORY_PARAMETER_NAME = 'c';
    public static final String KEYWORD_PARAMETER_NAME = 'k';
    public static final String PAGE_NUMBER_PARAMETER_NAME = 'p';
    public static final String ARTICLE_TYPE_LABEL_PARAMETER_NAME = 'l';
    public static final String LANGUAGE_PARAMETER_NAME = 'lang';
    public static final String NEW_LANGUAGE_PARAMETER_NAME = 'n';
    public static final String ARTICLE_ID_PARAMETER_NAME = 'id';
    
    public static final String HOME_TITLE = '';
    public static final String HOME_TEXT = '';
    public static final String ROOT_CATEGORY_NAME = 'All';
    public static final String CATEGORY_GROUP_NAME = 'FAQ';
    public static final Long CACHE_MAX_AGE = 0;
    public static final String PKB_MostPopular = 'Most Viewed';
    public static String VF_Apex{get;set;}

    private Map<String, String> describeMap = new Map<String, String>();
    //Default Constructor
    public HG_KnowledgeControllerFaq () {
        createDescribeMap();
        PKB_Tab_Home='Home';
        PKB_Search_NoFilter='-- No filter --';
        PKB_Search_Result='Search Results for';
        PKB_Search_No_Result='No articles found containing';
        PKB_Last_Updated='Recently Updated';
        PKB_No_Result='No articles';
        PKB_All_Article_Types='Article Types:';
        PKB_Previous10 ='Previous 10';
        PKB_Next10='Next 10';
       PKB_Tab_Product='product';
       PKB_Language='Language';
       ShowHomepage=false;
       ShowProductpage = false;
       ShowSearchpage = false;
       ShowDetailpage = false;
        attchList = new List<myAttachements>();
       
       String strURL = ApexPages.currentPage().getURL();
       if(strURL != null && strURL != '' && strURL.contains('/apex/')){
          VF_Apex = '/apex';
       }else{
           VF_Apex = '';
       }
       
       if(strURL != null && strURL != '' && strURL.contains('HG_KnowledgeDetailPageFaq')){
           detailpagecom();
       }
    }

    public String articleIdParameterName {
        get {
            return ARTICLE_ID_PARAMETER_NAME;
        }
    }

    public String languageParameterName {
        get {
            return LANGUAGE_PARAMETER_NAME;
        }
    }
    
    public String MostPopular {
        get {
            return PKB_MostPopular;
        }
    }

    public String newLanguageParameterName {
        get {
            return NEW_LANGUAGE_PARAMETER_NAME;
        }
    }

    public String categoryParameterName {
        get {
            return CATEGORY_PARAMETER_NAME;
        }
    }

    public String keywordParameterName {
        get {
            return KEYWORD_PARAMETER_NAME;
        }
    }

    public String articleTypeParameterName {
        get {
            return ARTICLE_TYPE_PARAMETER_NAME;
        }
    }

    public String articleTypeLabelParameterName {
        get {
            return ARTICLE_TYPE_LABEL_PARAMETER_NAME;
        }
    }

    public String pageNumberParameterName {
        get {
            return PAGE_NUMBER_PARAMETER_NAME;
        }
    }

    protected String paramByParamId(String paramId, String defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : value;
        }
    }

    protected Integer paramByParamId(String paramId, Integer defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {

            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : Integer.valueOf(value);
        }
    }

    public Integer currentPageNumber {
        get {
            if (currentPageNumber == null) {
                currentPageNumber = paramByParamId(PAGE_NUMBER_PARAMETER_NAME, 1);
            }
            return currentPageNumber;
        }
        set;
    }

    public String currentCategory {
        get {
            if (currentCategory == null) {
                currentCategory = paramByParamId(CATEGORY_PARAMETER_NAME, getRootCategoryName());
            }
            return currentCategory;
        }
        set;
    }

     public String currentLanguage {
        get {/*
            if (currentLanguage == null) {
                //if (siteSetup.MainLanguage__c!=null && siteSetup.MainLanguage__c.length()>0) {
                    Boolean OK = false;
                    currentLanguage = paramByParamId(LANGUAGE_PARAMETER_NAME, '');

                    if (currentLanguage.length()==0) {
                        Cookie languageCookie = ApexPages.currentPage().getCookies().get(LANGUAGE_COOKIE_NAME);
                        if (languageCookie == null) {
                            // no language specified and no cookie : use main language
                            currentLanguage = siteAvailableLanguages[0].getIsoCode();
                        } else {
                            // no language specified but a cookie : use cookie language
                            currentLanguage = languageCookie.getValue();
                        }
                    }

                    for (Language lang : siteAvailableLanguages) {
                        if (lang.getIsoCode().equals(currentLanguage)) {
                            OK = true;
                        }
                    }
                    if (!OK) {
                        currentLanguage = siteAvailableLanguages[0].getIsoCode();
                    }

                    // User changed the language we must store that in a cookie
                    if (paramByParamId(NEW_LANGUAGE_PARAMETER_NAME, '0').equals('1')) {
                        Cookie languageCookie = new Cookie(LANGUAGE_COOKIE_NAME, currentLanguage, null, -1, false);
                        ApexPages.currentPage().setCookies(new Cookie[]{ languageCookie });
                    }
                //}
            }*/
            return currentLanguage;
        }
        set;
    }

    public String currentArticleType {
        get {
            if (currentArticleType == null) {
                currentArticleType = paramByParamId(ARTICLE_TYPE_PARAMETER_NAME, '');
            }
            return currentArticleType;
        }
        set;
    }

    public String currentArticleTypeLabel {
        get {
            if (currentArticleTypeLabel == null) {
                currentArticleTypeLabel = paramByParamId(ARTICLE_TYPE_LABEL_PARAMETER_NAME, '');
            }
            return currentArticleTypeLabel;
        }
        set;
    }

    public String currentKeyword {
        get {
            if (currentKeyword == null) {
                currentKeyword = paramByParamId(KEYWORD_PARAMETER_NAME, '');
            }
            return currentKeyword;
        }
        set;
    }

    public String currentArticleId {
        get {
            if (currentArticleId == null) {
                currentArticleId = paramByParamId(ARTICLE_ID_PARAMETER_NAME, '');
            }
            return currentArticleId;
        }
        set;
    }

     public String currentArticleUrl {
      get {
         if (currentArticleUrl == null) {
            currentArticleUrl = getCurrentArticleUrl();
         }
         return currentArticleUrl;
      }
      set;
     }

   /* public static Map<String, String> allLanguages {
        get {
            if (allLanguages == null) {
                allLanguages = new Map<String, String>();
                // List of Salesforce supported languages
                 // http://www.salesforce.com/us/developer/docs/api_meta/Content/meta_translations.htm
                allLanguages.put('da', 'Danish');
                allLanguages.put('de', 'German');
                allLanguages.put('en_US', 'English');
                allLanguages.put('es', 'Spanish');
                allLanguages.put('fi', 'Finnish');
                allLanguages.put('fr', 'French');
                allLanguages.put('it', 'Italian');
                allLanguages.put('ja', 'Japanese');
                allLanguages.put('ko', 'Korean');
                allLanguages.put('nl_NL', 'Dutch');
                allLanguages.put('pt_BR', 'Portuguese (Brazil)');
                allLanguages.put('ru', 'Russian');
                allLanguages.put('sv', 'Swedish');
                allLanguages.put('th', 'Thai');
                allLanguages.put('zh_CN', 'Chinese (Simplified)');
                allLanguages.put('zh_TW', 'Chinese (Traditional)');
            }
            return allLanguages;
        }
        set;
    }*/

    public class Language {
        String isoCode;
        String label;
        Language(String isoCode, String label) {
            this.isoCode = isoCode;
            this.label = label;
        }
        public String getIsoCode() {
            return isoCode;
        }
        public String getLabel() {
            return label;
        }
    }

    private void createDescribeMap() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('ka') || key.endsWith('kb')) {
                this.describeMap.put(objectType.getDescribe().getKeyPrefix(), objectType.getDescribe().getLabel());
            }
        }
    }

    public String getArticleType(String articleId) {
        String articlePrefix = articleId.substring(0,3);
        Set<String> keySet = describeMap.keySet();
        String articleType = null;
        for(String key: keySet) {
            if(articlePrefix.equalsIgnoreCase(key)) {
                articleType = describeMap.get(key);
                return articleType;
            }
        }
        return articleType;
    }

    public String getCurrentArticleUrl() {
        String articleUrl = '';
        if (currentArticleId != null && currentArticleId.length()>0 && currentLanguage != null && currentLanguage.length()>0) {
            String query = 'select Id, UrlName, Language from Knowledge__kav where KnowledgeArticleId = \'' + currentArticleId + '\' and PublishStatus = \'Online\' and Language = \'' + currentLanguage + '\'';
            List<Knowledge__kav> articles = Database.query(query);
            Knowledge__kav article = articles.get(0);
            articleUrl =  '/articles/' + article.language + '/' + getArticleType(article.Id) + '/' + article.UrlName  + '?lang=' + article.language;
        }
        return articleUrl;
    }

    public Boolean getShowLanguagePickList() {
        return siteAvailableLanguages.size()>1;
    }

    public static Language[] siteAvailableLanguages {
        get {
            /*if (siteAvailableLanguages == null) {
                siteAvailableLanguages = new List<Language>();
                if (siteSetup.MainLanguage__c!=null && siteSetup.MainLanguage__c.length()>0) {
                    String isoCode = siteSetup.MainLanguage__c.trim();
                    siteAvailableLanguages.add(new Language(isoCode, allLanguages.get(isoCode)));
                }
                if (siteSetup.SecondaryLanguages__c!=null && siteSetup.SecondaryLanguages__c.length()>0) {
                    String [] isoCodes = siteSetup.SecondaryLanguages__c.split(';', -1);
                    for (String isoCode : isoCodes) {
                        isoCode = isoCode.trim();
                        if (!isoCode.equals(siteAvailableLanguages[0].getIsoCode())) {
                            siteAvailableLanguages.add(new Language(isoCode, allLanguages.get(isoCode)));
                        }
                    }
                }
            }*/
            return siteAvailableLanguages;
        }
        set;
    }

    public List<SelectOption> getSiteAvailableLanguagesList() {
        List<SelectOption> options = new List<SelectOption>();
        for (Language lang : siteAvailableLanguages) {
            options.add(new SelectOption(lang.isoCode, lang.label));
        }
        return options;
    }

    public List<SelectOption> getArticleAvailableLanguagesList() {
        List<SelectOption> options = new List<SelectOption>();
        if (this.currentArticleId != null &&  this.currentArticleId.length()>0) {
            String query = 'select Id, UrlName, Language from Knowledge__kav where KnowledgeArticleId = \'' + currentArticleId + '\' and PublishStatus = \'Online\'';
            List<Knowledge__kav> articles = Database.query(query);  
            Map<String, String> articleUrlsByLanguage = new Map<String, String>();                                
            for (Knowledge__kav article : articles) {              
                String isoCode = article.language;
                String articleUrl =  '/articles/' + isoCode + '/' + getArticleType(article.Id) + '/' + article.UrlName  + '?lang=' + isoCode;
                articleUrlsByLanguage.put(isoCode, articleUrl);
            }
            for (Language lang : siteAvailableLanguages) {
                if (articleUrlsByLanguage.containsKey(lang.isoCode)) {
                    //options.add(new SelectOption(articleUrlsByLanguage.get(lang.isoCode), allLanguages.get(lang.isoCode)));
                }
            }
        }
        return options;
    }

    /*public static PKBSiteSetup__c siteSetup {
        get {
            if (siteSetup == null) {
                try {
                    String siteName = Site.getName();
                    if (siteName == null || siteName.length()==0) {
                        siteName = 'Comodo';
                    }
                    siteSetup = [
                       SELECT id, PKBSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
                       Category1Description__c, Category2Description__c, Category3Description__c,
                       Category4Description__c, Category5Description__c, Category6Description__c,
                       HomeAdText__c, HomeAdTitle__c, MainLanguage__c, SecondaryLanguages__c
                       FROM PKBSiteSetup__c
                       WHERE PKBSiteName__c = :siteName ];
                } catch (QueryException  e) {
                    // can't throw an exception here in order to prevent tests from failing before creating an PKB Site Setup
                    siteSetup = new PKBSiteSetup__c();
                }
            }
            return siteSetup;
        }
        set;
    }*/

    /*public PKBTranslation__c siteTranslation {
        get {
            if (siteTranslation == null) {
                try {
                    siteTranslation = [
                           SELECT
                               Category1Description__c, Category2Description__c, Category3Description__c,
                               Category4Description__c, Category5Description__c, Category6Description__c,
                               HomeAdText__c, HomeAdTitle__c
                           FROM PKBTranslation__c
                           WHERE language__c = :currentLanguage
                           AND PKB_Site_Setup__r.id = :siteSetup.id
                    ];
                } catch (QueryException  e) {
                    // can't throw an exception here in order to prevent tests from failing before creating an PKB Site Setup
                    siteTranslation = new PKBTranslation__c();
                }
            }
            return siteTranslation;
        }
        set;
    }*/


    /*public PKBSiteSetup__c getSiteSetup() {
        return siteSetup;
    }*/

    private String[] categoryDescriptions;

    public String[] getCategoryDescriptions() {/*
        if (categoryDescriptions == null) {
            categoryDescriptions = new String[]{};
            categoryDescriptions.add(siteTranslation.category1Description__c != null ? siteTranslation.category1Description__c : ( siteSetup.category1Description__c == null ? '' : siteSetup.category1Description__c));
            categoryDescriptions.add(siteTranslation.category2Description__c != null ? siteTranslation.category2Description__c : ( siteSetup.category2Description__c == null ? '' : siteSetup.category2Description__c));
            categoryDescriptions.add(siteTranslation.category3Description__c != null ? siteTranslation.category3Description__c : ( siteSetup.category3Description__c == null ? '' : siteSetup.category3Description__c));

            categoryDescriptions.add(siteTranslation.category4Description__c != null ? siteTranslation.category4Description__c : ( siteSetup.category4Description__c == null ? '' : siteSetup.category4Description__c));
            categoryDescriptions.add(siteTranslation.category5Description__c != null ? siteTranslation.category5Description__c : ( siteSetup.category5Description__c == null ? '' : siteSetup.category5Description__c));
            categoryDescriptions.add(siteTranslation.category6Description__c != null ? siteTranslation.category6Description__c : ( siteSetup.category6Description__c == null ? '' : siteSetup.category6Description__c));
        }*/
        return categoryDescriptions;
    }

    public String getHomeAdTitle() {
        return HOME_TITLE; //siteTranslation.HomeAdTitle__c!=null ? siteTranslation.HomeAdTitle__c :  (siteSetup.HomeAdTitle__c == null ? '' : siteSetup.HomeAdTitle__c);
    }

    public String getHomeAdText() {
        return HOME_TEXT;//siteTranslation.HomeAdText__c!=null ? siteTranslation.HomeAdText__c :  (siteSetup.HomeAdText__c == null ? '' : siteSetup.HomeAdText__c);
    }

    public String getRootCategoryName() {
        return ROOT_CATEGORY_NAME;//siteSetup.RootCategoryName__c == null ? '' : siteSetup.RootCategoryName__c;
    }

    public String getCategoryGroupName() {
        return CATEGORY_GROUP_NAME;//siteSetup.CategoryGroupName__c == null ? '' : siteSetup.CategoryGroupName__c;
    }

    public Long getCacheMaxAge() {
        return CACHE_MAX_AGE;//siteSetup.CacheMaxAge__c == null ? 0 : siteSetup.CacheMaxAge__c.longValue();
    }

    public Boolean getCachePage() {
        return paramByParamId(LANGUAGE_PARAMETER_NAME, '').length()>0;
    }

    public String getHomeUrl() {
        return URL_HOME;
    }

    public String getProductUrl() {
        return URL_PRODUCT;
    }
   //added by me
     public String getProductUrlcomodo(){
       return URL_Product_comodo;
     }
    public String getSearchUrl() {
        return URL_SEARCH;
    }
    //added by me
    public String getSearchUrlComodo(){
    return URL_SEARCH_comodo;
    }
    
    //added by me 
    public String getDetailUrlComodo(){
       return URL_Detail_comodo;
    }
    

    public String getHomePage() {
        return PAGE_HOME;
    }

    public String getProductPage() {
        return PAGE_PRODUCT;
    }

    public String getSearchPage() {
        return PAGE_SEARCH;
    }

    public String getPage(String url) {
        if (url.contains('?')) {
            Integer i = url.indexOf('?');
            url = url.substring(0, i);
        }
        while (url.endsWith('/')) {
            url = url.substring(0, url.length()-1);
        }
        if (url.contains('/')) {
            Integer i = url.lastIndexOf('/');
            url = url.substring(i+1);
        }
        return url;
    }


    public PageReference currentPageReference {
        get {
            if (currentPageReference == null) {
                currentPageReference = ApexPages.currentPage();
            }
            return currentPageReference;
        }
        set;
    }

    public String currentPage {
        get {
                if (currentPage == null) {
                    currentPage = getPage(currentPageReference.getUrl());
                }
                return currentPage;
            }
            set;
    }

    public Boolean isPage(String pageName) {
        return currentPage.toLowerCase().contains(pageName.toLowerCase());
    }

    public Boolean getIsHomePage() {
        return isPage(PAGE_HOME);
    }

    public Boolean getIsProductPage() {
       // return isPage(PAGE_PRODUCT);
       return isPage(PAGE_PRODUCT_comodo);
    }

    public Boolean getIsSearchPage() {
       // return isPage(PAGE_SEARCH);
       return isPage(PAGE_SEARCH_Comodo);
    }
    
    //added by me
    public Boolean getIsDetailPage(){
       return isPage(Page_Detail_comodo);
    }

    public Boolean getIsExternalPage() {
        return !(getIsHomePage() || getIsProductPage() || getIsSearchPage() ||getIsDetailPage());
    }

    public Boolean getIsRendererPage() {
        return isPage(PAGE_RENDERER);
    }

   public PageReference doSearch() {
        if (currentKeyword.length()<2) {
            return cleanKeyword();
        }
        
        //PageReference pg = new PageReference(getSearchUrl());
       // modified by me
         PageReference pg = new PageReference(getSearchUrlComodo());
        system.debug('KKKKK');
        pg.getParameters().put(KEYWORD_PARAMETER_NAME, currentKeyword);
        system.debug('KKKKK&&&');
        pg.getParameters().put(CATEGORY_PARAMETER_NAME, currentCategory);
        pg.getParameters().put(LANGUAGE_PARAMETER_NAME, currentLanguage);
        system.debug('current category$$$'+currentCategory);
        
        if (getIsExternalPage()) {
            pg.setRedirect(true);
        }
        return pg;
        
        
   }

    public PageReference cleanKeyword() {
        // PageReference pg = new PageReference(getProductUrl());
        //modified by me
        
        PageReference pg = new PageReference(getProductUrlcomodo());
        
         pg.getParameters().put(CATEGORY_PARAMETER_NAME, currentCategory);
         pg.getParameters().put(KEYWORD_PARAMETER_NAME, '');
         currentKeyword = '';
         if (getIsExternalPage()) {
             pg.setRedirect(true);
         }
         return pg;
    }

    public Boolean getCanUserSeeKnowledge() {
        // Not possible anymore to have better than this:
        return true;
    }

    public PageReference changeSiteLanguage() {
        PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
        pr.getParameters().put(CATEGORY_PARAMETER_NAME, currentCategory);
        pr.getParameters().put(LANGUAGE_PARAMETER_NAME, currentLanguage);
        pr.getParameters().put(KEYWORD_PARAMETER_NAME, currentKeyword);
        pr.getParameters().put(ARTICLE_TYPE_PARAMETER_NAME, currentArticleType);
        pr.getParameters().put(ARTICLE_TYPE_LABEL_PARAMETER_NAME, currentArticleTypeLabel);
        pr.setRedirect(true);
        return pr;
    }
    
    //added by me
        public void detailpagecom(){
           Articleid=ApexPages.currentPage().getParameters().get('id');
           lstContentDistro = new List<ContentDistribution>();
                   attchList = new List<myAttachements>();

           system.debug('article id is####'+Articleid); 
                  knowledgedetails=new Knowledge__kav();

           knowledgedetails=[ select id,Title,Summary,Summary__c,Summary_Data__c,UrlName,knowledgeArticleId, (SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.FileExtension,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLinks) from Knowledge__kav where PublishStatus='Online' and Language='en_US' and knowledgeArticleId =:Articleid];
           system.debug('content link details are####'+knowledgedetails.ContentDocumentLinks);
             if(knowledgedetails.ContentDocumentLinks.size() > 0)
                hasAttachment = true;
             else
                hasAttachment = false;
                
            if(knowledgedetails.Summary.startsWith('https://')){
                isVideo = true;
                videoLink = knowledgedetails.summary.replace('watch?v=','embed/');
            }else{
                isVideo = false;
                videoLink = '';
            }
           //Map<Id, List<ContentDocumentLink>> mapKnowledgeIdDocLink = new Map<Id, List<ContentDocumentLink>>();
           lstContentLinks = new List<ContentDocumentLink>();
           Set<Id> setContentDocIds = new Set<Id>();
           system.debug('@@@@before lstContentLinks@@@'+lstContentLinks);
           if(knowledgedetails != null ){
                      system.debug('@@@@after lstContentLinks@@@'+lstContentLinks);
               lstContentLinks.addAll(knowledgedetails.ContentDocumentLinks);
               if(lstContentLinks != null && lstContentLinks.size() > 0){
                   for(ContentDocumentLink clink : lstContentLinks){
                       setContentDocIds.add(clink.ContentDocumentId);
                   }
                   lstContentDistro = [Select id,ContentDownloadUrl,DistributionPublicUrl,PdfDownloadUrl, Name from ContentDistribution where ContentDocumentId IN: setContentDocIds];
                   system.debug('$$$$$$lstContentDistro$$$$$'+lstContentDistro);
                   //Added on 12 Nov
                   for(ContentDistribution eachCD : lstContentDistro){
                     myAttachements oneAttch = new myAttachements();
                     oneAttch.attchName=eachCD.Name;
                     oneAttch.attchUrl=eachCD.ContentDownloadUrl;
                     attchList.add(oneAttch);
                   }
                   
                  system.debug('####attchList####'+attchList); 
               }
           }
           system.debug('lstContentLinks : '+lstContentLinks);
           system.debug('lstContentDistro : '+lstContentDistro);
        }
        
        public class myAttachements{
           
           public String attchName{get;set;}
           public String attchUrl{get;set;}
         
        }
        

           


}