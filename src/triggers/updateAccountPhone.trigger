/*
Trigger Name: updateAccountPhone
Purpose/Overview: To Update Phone field on Account when the contacts primaru phne is chamned and it's aprimary contact of that Account
Author: SANDEEP KUMAR K
Created Date: 04/02/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
trigger updateAccountPhone on contact(after insert,after update){
list<Id> acntIds = new list<Id>();
list<Account> lstAccounts = new list<Account>();
list<Account> acntsTobeUpdated = new list<Account>();
        for(contact cnt : trigger.new){
            if(trigger.isUpdate){
                if(cnt.npsp__Primary_Contact__c || (trigger.oldmap.get(cnt.id).Phone!=cnt.Phone))
                    acntIds.add(cnt.AccountId);
            }
            if(trigger.isInsert){
                if(cnt.npsp__Primary_Contact__c && cnt.AccountId!=null)
                   acntIds.add(cnt.AccountId); 
            } 
        }
        lstAccounts = [select id,name,phone from account where id in:acntIds];
        for(contact c : trigger.new){
            for(Account acont: lstAccounts)
            {
                if((c.AccountId==acont.id && trigger.oldmap.get(c.id).Phone!=c.Phone && c.npsp__Primary_Contact__c) || (c.AccountId==acont.id && acont.phone==null && c.npsp__Primary_Contact__c)){  
                    acont.Phone = c.Phone; 
                    acntsTobeUpdated.add(acont);
                }
            }
        }
if(!acntsTobeUpdated.isEmpty())
update acntsTobeUpdated;

}