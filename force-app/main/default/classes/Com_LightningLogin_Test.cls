@isTest(SeeAllData = true)
public class Com_LightningLogin_Test{

@isTest
static void testwithinvalidCredentials(){
    system.assertEquals('Argument 1 cannot be null',Com_LightningLogin.Login('testuser','invalidpassword',null));
}

@isTest
static void LoginFormControllerInstallation(){
 Com_LightningLogin controller = new Com_LightningLogin();
   System.assertNotEquals(controller, null);
}

@isTest
static void testwithcorrectusernamendPassword(){
   System.assertEquals(true, Com_LightningLogin.getIsUsernamePasswordEnabled());

}

@isTest
 static void testwithIsSelfRegistrationEnabled() {
  System.assertEquals(false,Com_LightningLogin.getIsSelfRegistrationEnabled());
 }
 
 @isTest
 static void testwithGetSelfRegistrationURL() {
  System.assertEquals(null, Com_LightningLogin.getSelfRegistrationUrl());
 }
 
 @isTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = Com_LightningLogin.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
 
 @isTest
 static void testforgotpassword(){
   Com_LightningLogin.getForgotPasswordUrl();
 }
  

}