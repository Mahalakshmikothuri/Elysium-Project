/*
Trigger Name: updateAccountPhone_test
Purpose/Overview: Test Class for 'updateAccountPhone' trigger
Author: SANDEEP KUMAR K
Created Date: 26/02/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
@isTest
public class  updateAccountPhone_test{

    public static testMethod void testcontact(){
        Account acnt= new Account(Name='Sandeep Kumar');
        insert acnt;
        
        Contact cnt = new Contact(LastName='KUMAR',npe01__PreferredPhone__c='Home',HomePhone='9988776677',AccountID=acnt.id);
        insert cnt;
        
        acnt.npe01__One2OneContact__c=cnt.id;
        update acnt;
        cnt.HomePhone='9988779988';
        cnt.Phone='1234567890';
        update cnt;
    }
}