@isTest
public class Community_ChatCntrlTest{

    static testMethod void testMethod1()  {
    
        Account acc1 = new Account(
        Name = 'TestAccount1'
        
        );
        insert acc1; 
        PageReference pgRef = Page.Community_Chatter; //Create Page Reference - 'Appt_New' is the name of Page

        Test.setCurrentPage(pgRef); //Set the page for Test Method

ApexPages.currentPage().getParameters().put('id', acc1.id);//Pass Id to page
Community_ChatCntrl hh= new Community_ChatCntrl();
    
    }

}