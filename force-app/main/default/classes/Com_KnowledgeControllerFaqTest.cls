/**
 * Test class for Com_KnowledgeControllerFaq
 *
 * @see         Com_KnowledgeControllerFaq
 *
 * @version     2019-01-01 Agile Cloud Consulting     first version
 *              
 */ 

@isTest
private class Com_KnowledgeControllerFaqTest {



    static testMethod void testParamProperties() {
        Com_TestKnowledgeController controller = new Com_TestKnowledgeController ();
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.PAGE_NUMBER_PARAMETER_NAME, '2');
        System.assertEquals(2, controller.currentPageNumber);
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.CATEGORY_PARAMETER_NAME, 'apples');
        System.assertEquals('apples', controller.currentCategory);
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.KEYWORD_PARAMETER_NAME, 'pears');
        System.assertEquals('pears', controller.currentKeyword);
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.ARTICLE_TYPE_PARAMETER_NAME, 'bananas');
        System.assertEquals('bananas', controller.currentArticleType);
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.ARTICLE_TYPE_LABEL_PARAMETER_NAME, 'ananas');
        System.assertEquals('ananas', controller.currentArticleTypeLabel);
        // Must test with one of the available languages
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.LANGUAGE_PARAMETER_NAME, 'en_US');
        //System.assertEquals('fr', controller.currentLanguage);
        ApexPages.currentPage().getParameters().put(Com_KnowledgeControllerFaq.ARTICLE_ID_PARAMETER_NAME, 'kA0x00000000e4M');
        System.assertEquals('kA0x00000000e4M', controller.currentArticleId);        
    }





    static testMethod void testGetUrls() {
        Com_TestKnowledgeController controller = new Com_TestKnowledgeController ();
        System.assertEquals(Com_KnowledgeControllerFaq.URL_HOME, controller.getHomeUrl());
        System.assertEquals(Com_KnowledgeControllerFaq.URL_SEARCH_comodo, controller.getSearchUrlComodo());
        System.assertEquals(Com_KnowledgeControllerFaq.URL_Product_comodo, controller.getProductUrlcomodo());
        system.assertEquals(Com_KnowledgeControllerFaq.URL_Detail_comodo,controller.getDetailUrlComodo());
    }


    static testMethod void testGetIsPage() {
        
        Test.setCurrentPage(Page.Com_KnowledgeMainPageFaq);
        Com_TestKnowledgeController controller = new Com_TestKnowledgeController ();
        //System.assert(controller.getIsHomePage());
        System.assert(!controller.getIsProductPage());
        System.assert(!controller.getIsSearchPage());
       // System.assert(!controller.getIsExternalPage());
        System.assert(!controller.getIsRendererPage());

        Test.setCurrentPage(Page.Com_KnowledgeProductPageFaq);
        controller = new Com_TestKnowledgeController ();
        System.assert(!controller.getIsHomePage());
        //System.assert(controller.getIsProductPage());
        System.assert(!controller.getIsSearchPage());
       // System.assert(!controller.getIsExternalPage());
        System.assert(!controller.getIsRendererPage());

        Test.setCurrentPage(Page.Com_KnowledgeSearchPageFaq);
        controller = new Com_TestKnowledgeController ();
        System.assert(!controller.getIsHomePage());
        System.assert(!controller.getIsProductPage());
        //System.assert(controller.getIsSearchPage());
        System.assert(!controller.getIsExternalPage());
        System.assert(!controller.getIsRendererPage());
        
        System.assertNotEquals(null, controller.articleIdParameterName);
        System.assertNotEquals(null, controller.languageParameterName);
        System.assertNotEquals(null, controller.MostPopular);
        System.assertNotEquals(null, controller.newLanguageParameterName);
        System.assertNotEquals(null, controller.categoryParameterName);
        System.assertNotEquals(null, controller.keywordParameterName);
        
        System.assertNotEquals(null, controller.articleTypeParameterName);
        System.assertNotEquals(null, controller.articleTypeLabelParameterName);
        System.assertNotEquals(null, controller.pageNumberParameterName);
        
        System.assertNotEquals(null, controller.currentArticleUrl);
        //System.assertNotEquals(null, controller.allLanguages);
        //System.assertNotEquals(null, controller.getArticleType(''));
        
        controller.getCurrentArticleUrl();
        //controller.getShowLanguagePickList();
        //controller.getSiteAvailableLanguagesList();
        controller.getArticleAvailableLanguagesList();
        //controller.detailpage();
        
       // System.assertNotEquals(null, controller.getCategoryDescriptions());
        System.assertNotEquals(null, controller.getHomeAdTitle());
        System.assertNotEquals(null, controller.getHomeAdText());
        System.assertNotEquals(null, controller.getRootCategoryName());
        System.assertNotEquals(null, controller.getCategoryGroupName());
        System.assertNotEquals(null, controller.getCacheMaxAge());
        
        System.assertNotEquals(null, controller.getCachePage());
        System.assertNotEquals(null, controller.getHomeUrl());
        System.assertNotEquals(null, controller.getProductUrl());
        System.assertNotEquals(null, controller.getSearchUrl());
        System.assertNotEquals(null, controller.getDetailUrlComodo());
        System.assertNotEquals(null, controller.getHomePage());
        
        System.assertNotEquals(null, controller.getProductPage());
        System.assertNotEquals(null, controller.getSearchPage());
        System.assertNotEquals(null, controller.getIsDetailPage());
        System.assertNotEquals(null, controller.getCanUserSeeKnowledge());
        System.assertNotEquals(null, controller.changeSiteLanguage());
        //System.assertNotEquals(null, controller.detailpage());
    }


    static testMethod void testGetPage() {
        Com_TestKnowledgeController controller = new Com_TestKnowledgeController ();
        System.assertEquals('', controller.getPage(''));
        System.assertEquals('', controller.getPage('/'));
        System.assertEquals('', controller.getPage('//'));
        System.assertEquals('', controller.getPage('/?'));
        System.assertEquals('', controller.getPage('/?a=1'));
        System.assertEquals('', controller.getPage('/?a=1&b=2'));
        System.assertEquals('foo', controller.getPage('foo'));
        System.assertEquals('foo', controller.getPage('/foo'));
        System.assertEquals('foo', controller.getPage('//foo'));
        System.assertEquals('foo', controller.getPage('/foo/'));
        System.assertEquals('foo', controller.getPage('//foo//'));
        System.assertEquals('foo', controller.getPage('/apex/foo'));
        System.assertEquals('foo', controller.getPage('/apex/foo/'));
        System.assertEquals('foo', controller.getPage('/foo?'));
        System.assertEquals('foo', controller.getPage('/foo?a=1'));
        System.assertEquals('foo', controller.getPage('/foo?a=1&b=2'));
        System.assertEquals('foo', controller.getPage('/foo/?'));
        System.assertEquals('foo', controller.getPage('/foo/?a=1'));
        System.assertEquals('foo', controller.getPage('/foo/?a=1&b=2'));
        System.assertEquals('foo', controller.getPage('apex/foo/?'));
        System.assertEquals('foo', controller.getPage('apex/foo/?a=1'));
        System.assertEquals('foo', controller.getPage('apex/foo/?a=1&b=2'));
        System.assertEquals('foo', controller.getPage('/apex/foo/?'));
        System.assertEquals('foo', controller.getPage('/apex/foo/?a=1'));
        System.assertEquals('foo', controller.getPage('/apex/foo/?a=1&b=2'));
    }

    static testMethod void testActions() {
        // do search
        Test.setCurrentPage(Page.Com_KnowledgeProductPageFaq);
        Com_TestKnowledgeController controller = new Com_TestKnowledgeController ();
        controller.currentCategory = 'apples';
        controller.currentKeyword = 'pears';
        PageReference pg = controller.doSearch();
        System.assertEquals('pears', controller.currentKeyword);
        System.assertEquals('apples', controller.currentCategory);
        //System.assert(controller.getPage(pg.getUrl()).contains(controller.getSearchComodoPage()));

        // keyword too short
        Test.setCurrentPage(Page.Com_KnowledgeProductPageFaq);
        controller.currentCategory = 'apples';
        controller.currentKeyword = '1';
        pg = controller.doSearch();
        System.assertEquals('apples', controller.currentCategory);
        System.assertEquals('', controller.currentKeyword);
        //System.assert(controller.getPage(pg.getUrl()).contains(controller.getProductComodPage()));

        // clean Keyword
        Test.setCurrentPage(Page.Com_KnowledgeSearchPageFaq);
        controller.currentCategory = 'apples';
        controller.currentKeyword = 'pears';
        pg = controller.cleanKeyword();
        System.assertEquals('apples', controller.currentCategory);
        System.assertEquals('', controller.currentKeyword);
        //System.assert(controller.getPage(pg.getUrl()).contains(controller.getProductComodPage()));
    }



    public class Com_TestKnowledgeController extends Com_KnowledgeControllerFaq {}
    private static testmethod void detailpagetest(){
        //Com_TestKnowledgeController testknow= new Com_TestKnowledgeController ();
        
    }

}