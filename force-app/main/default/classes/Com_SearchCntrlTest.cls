/**
* Test class for the Com_SearchCntrl 
*
* @see         Com_SearchCntrl.cls
*
* @version     2018-14-06    AgileCloud     first version
*              
*/
@isTest 
public class Com_SearchCntrlTest{

 static testMethod void testcasecomments() { 
 
 
     sobjectwrapperclass mytest= new sobjectwrapperclass();
     mytest= Com_SearchCntrl.fetchSobjectInfo('Test');
 
 }
 
 
 

}