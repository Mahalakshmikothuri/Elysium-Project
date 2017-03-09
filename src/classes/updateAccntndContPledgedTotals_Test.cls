/*
Trigger Name: updateAccntndContPledgedTotals_Test
Purpose/Overview: Test Class for 'updateAccountndContactsPledgedTotals' trigger
Author: SANDEEP KUMAR K
Created Date: 25/02/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
@isTest
public class  updateAccntndContPledgedTotals_Test{

    public static testMethod void testTrigger(){
    
        Map <String,Schema.RecordTypeInfo> rectypeAccount = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id accOrgRecTypeId = rectypeAccount.get('Organization').getRecordTypeId();
        Id accHHRecTypeId = rectypeAccount.get('Household Account').getRecordTypeId();
        System.debug('@@@@@@@@@@@@@:'+accHHRecTypeId);
        System.debug('@@@@@@@@@@@@@:'+accOrgRecTypeId);
        Map <String,Schema.RecordTypeInfo> rectypeOppty = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id oppDonRecTypeId = rectypeOppty.get('Donation').getRecordTypeId();
        Account act =  new Account();
        Account actHH = new Account();
            
        Campaign cmp = new Campaign(Name='Test Campaign');
        insert cmp;
        
        if(accOrgRecTypeId!=null){
            act = new Account(Name='Org Account',recordTypeId=accOrgRecTypeId);
            insert act;
        }
        if(accHHRecTypeId!=null)
        {
            //actHH = TestUtilityController.fetchAccount('HouseHold Account', accHHRecTypeId);
            actHH = new Account(Name='HouseHold Account', recordTypeId=accHHRecTypeId);
            insert actHH;
        }
        
        System.debug('@@@@@@@@@@@@@:'+actHH.recordTypeID);
        Contact cnt = new Contact(LastName='Sandeep');
        insert cnt;
        
        Contact cnt1 = new Contact(LastName='Kumar');
        insert cnt1;
        
        campaignMember cmemb = new campaignMember(contactId=cnt.id,campaignId=cmp.id,Number_Sent__c=1);
        insert cmemb;
        campaignMember cmemb1 = new campaignMember(contactId=cnt1.id,campaignId=cmp.id,Number_Sent__c=1);
        insert cmemb1;
        
        Opportunity opty = new Opportunity(Name='Test Sandeep',campaignId=cmp.id,Amount=25000,AccountId=act.id,npsp__Primary_Contact__c=cnt.id,recordTypeId=oppDonRecTypeId,stageName='Asked',closeDate=date.today()+10);
        insert opty;
        Test.startTest();
        opty.stageName='Pledged';
        update opty;
        
        opty.stageName='Posted';
        update opty;
        
        opty.AccountId=actHH.id;
        opty.npsp__Primary_Contact__c=cnt1.id;
        update  opty;
        
        
        delete opty;
        test.stopTest();
    }
}