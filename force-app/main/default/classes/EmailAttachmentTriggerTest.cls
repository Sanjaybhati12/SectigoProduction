/**
 * Test class for the EmailAttachmentTrigger trigger.
 *
 * @see         EmailAttachmentTrigger .cls
 *
 * @version     2018-14-06    Veera     first version
 *              
 */
@isTest 
public class EmailAttachmentTriggerTest {

static testMethod void testAttachments() { 
        Case cse=new Case(Subject= 'In Service Billable - A29'); 
        insert cse; 
        Case_Comment__c onecasecmt= new Case_Comment__c();
        onecasecmt.ParentId__c=cse.id;
        onecasecmt.EmailMessageId__c=cse.id;
        insert onecasecmt;        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=cse.id;
        insert attach;

}

}